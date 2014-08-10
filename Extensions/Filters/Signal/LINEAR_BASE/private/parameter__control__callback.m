function result = parameter__control__callback(callback, context)

% LINEAR_BASE - parameter__control__callback

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

result = [];

%--
% compile an updated extension and put it in context
%--

context.ext = get_callback_extension(callback);

%--
% consider the FV callback
%--

if strcmpi(callback.control.name, 'fvtool')
	get_fvtool(callback, context, 1);
end

%--
% update filter display and possibly fvtool
%--

% NOTE: these happen for any control

update_filter_display(callback, context);

% NOTE: the behavior of these figures is different from other figures

update_fvtool(callback, context);


%-------------------------------------------------------------------------
% UPDATE_FILTER_DISPLAY
%-------------------------------------------------------------------------

function update_filter_display(callback, context)

%-------------------------
% SETUP
%-------------------------

pal = callback.pal.handle;

ext = context.ext;

%--
% get 'filter' control parent axes handle
%--

ax = findobj(pal,'type','axes','tag','filter');

% NOTE: this should perhaps show up as an error

if isempty(ax)
	return;
end

rate = get_sound_rate(context.sound);

%------------------------------------------------
% UPDATE CONTROL VALUES
%------------------------------------------------

%--
% update filter control
%--

% NOTE: this uses new code to set the value of an axes control

set_control(pal, 'filter', 'value', ext.parameter.filter);

%------------------------------------------------
% UPDATE FILTER DISPLAY
%------------------------------------------------

%-------------------------------
% SETUP
%-------------------------------

%--
% set display colors
%--

% NOTE: eventually consider axes display here

response_color = [0 0 0];

guide_color = 0.5 * ones(1,3);

%--
% copy filter for convenience
%--

filter = ext.parameter.filter;

%--
% prepare display axes
%--

axes(ax); hold on;

delete(get(ax, 'children'));

%-------------------------------
% DISPLAY
%-------------------------------

% NOTE: update plot based on display control state

[ignore, opt] = control_update([], pal, 'display'); 

opt = lower(strtok(opt{1}, ' '));

switch opt
	
	%-------------------------------
	% FREQUENCY RESPONSE
	%-------------------------------
	
	case 'frequency'
		
		%--
		% compute and plot frequency response
		%--
		
		[h, f] = freqz(filter.b, filter.a, 512, rate);
		
		plot(f, abs(h), 'k-');
		
		%--
		% compute and set axes limits
		%--
		
		% NOTE: the vertical limits are based on the distortion specified
		
		xlim = [0, 0.5 * rate]; ylim = [-0.2, max(1.2, 1.2 * max(abs(h)))];
		
		set(ax, ...
			'ylim', ylim, 'xlim', xlim ...
		);

		%--
		% display basic guides
		%--
		
		% NOTE: display one and zero lines

		tmp = plot(xlim, [1 1], ':'); set(tmp, 'color', guide_color);
		
		tmp = plot(xlim, [0 0], ':'); set(tmp, 'color', guide_color);
		
		%--
		% display special guides
		%--
		
		% NOTE: it may not be the control we check for

		if has_control(pal, 'min_freq')

			min_freq = get_control(pal, 'min_freq', 'value');
			
			line(min_freq * [1 1], ylim, ...
				'parent', ax, 'linestyle', ':', 'color', guide_color ...
			);

			if has_control(pal, 'transition')
				
				trans = get_control(pal, 'transition', 'value');
				
				line((min_freq - trans) * [1 1], ylim, ...
					'parent', ax, 'linestyle', ':', 'color', guide_color ...
				);

			end
			
		end

		if has_control(pal, 'max_freq')

			max_freq = get_control(pal, 'max_freq', 'value');
			
			line(max_freq * [1 1], ylim, ...
				'parent', ax, 'linestyle', ':', 'color', guide_color ...
			);

			if has_control(pal, 'transition')
				
				trans = get_control(pal, 'transition', 'value');
				
				line((max_freq + trans) * [1 1], ylim, ...
					'parent', ax, 'linestyle', ':', 'color', guide_color ...
				);
			
			end

		end
		
		if has_control(pal, 'center_freq')

			center_freq = get_control(pal, 'center_freq', 'value');

			line(center_freq * [1 1], ylim, ...
				'parent', ax, 'linestyle', ':', 'color', guide_color ...
			);

		end
		
	%-------------------------------
	% IMPULSE RESPONSE
	%-------------------------------
	
	case 'impulse'
	
		%--
		% plot fir impulse response
		%--
		
		[h, t] = impz(filter.b, filter.a);
		
		plot(t, h, 'k-');
		
		%--
		% compute and set axes limits
		%--
		
		% NOTE: we update axes limits to be centered and fairly tight

		if (length(t) > 1)
			xlim = fast_min_max(t); ylim = fast_min_max(h) + 0.1 * [-1, 1];
		else
			xlim = [-0.5, 0.5]; ylim = [0, h] + 0.1 * [-1, 1];
		end
		
		set(ax, 'ylim', ylim, 'xlim', xlim);

		%--
		% display guides
		%--
		
		% NOTE: display zero line

		tmp = plot(xlim, [0 0], ':'); set(tmp, 'color', guide_color);
		
end


%--------------------------------------
% GET_FVTOOL
%--------------------------------------

function tool = get_fvtool(callback, context, force)

%--
% check if we should force creation
%--

if nargin < 3
	force = 0;
end

%--
% get extension and build tag
%--

ext = context.ext; 

tag = ['FVTOOL::', ext.name, '::', int2str(callback.par.handle)];

%--
% find tool, create if not found
%--

tool = findobj(0, 'tag', tag);

if ~isempty(tool)
	return;
end

if isempty(tool) && force
	tool = fvtool(ext.parameter.filter.b, ext.parameter.filter.a); set(tool, 'tag', tag);
end


%--------------------------------------
% UPDATE_FVTOOL
%--------------------------------------

function update_fvtool(callback, context)

%--
% get extension
%--

ext = context.ext;

%--
% get fvtool figure
%--

% NOTE: this is the parent figure handle

tool = get_fvtool(callback, context);

if isempty(tool)
	return;
end

%--
% update fvtool state and display
%--

% NOTE: this code actually works with the API

data = getappdata(tool);

% TODO: move the exceoption handler to cover the whole function

try
	tool = data.fvtool.handle;
catch
	nice_catch(lasterror, 'WARNING: Failed to get ''fvtool'' handle.'); return;
end

filt = get(get(tool, 'Filters'), 'Filter');

set(filt, 'Numerator', ext.parameter.filter.b);

set(filt, 'Denominator', ext.parameter.filter.a);

setfilter(tool, filt);



