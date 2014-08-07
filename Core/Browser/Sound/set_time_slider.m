function slider = set_time_slider(par, field, value)

% set_time_slider - set browser time slider property
% --------------------------------------------------
%
% slider = set_time_slider(par, field, value)
%
% Input:
% ------
%  par - parent browser handle
%  field - field to set
%  value - value to set
%
% Output:
% -------
%  slider - browser time slider

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2005-08-25 10:08:40 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1658 $
%--------------------------------

%-----------------------------
% HANDLE INPUT
%-----------------------------

%--
% get parent time slider
%--

slider = get_time_slider(par);

if isempty(slider)
	error('Input parent does not contain time slider.');
end

%--
% remove stale handles
%--

stale = find(~ishandle(slider.handle));

if ~isempty(stale)
	handle.slider(stale) = [];
end

if isempty(slider.handle)
	error('There are no valid slider handles to work with.');
end

%--
% check set field value
%--

% NOTE: there are slider builtin fields and special time slider fields

field = lower(field); builtin = {'min', 'value', 'max'}; special = get_time_slider_fields;

if ~ismember(field, builtin) && ~ismember(field, special)
	error(['Unrecognized time slider field ''', field, '''.']);
end

%-----------------------------
% SET SLIDER PROPERTY
%-----------------------------

%--
% set modified time stamp
%--

% NOTE: for get operations we use a single handle, we for set all

data = get(slider.handle(1), 'userdata'); data.modified = clock;

% NOTE: add slider type to slider userdata this solves a problem with control sliders

data.type = 'time';

%--
% enforce value consistency
%--

% NOTE: indicate when time needs set and slider needs hide

time = []; hide = 0;

switch field
	
	%--
	% BUILTIN
	%--
	
	case 'min'
		
		if (value > slider.value)
			time = value;
		end
		
	case 'value'

		if (value < slider.min)
			value = slider.min;
		elseif (value > slider.max)
			value = slider.max;
		end
		
	case 'max'
		
		if (value <= 0)
			value = 0; hide = 1;
		end
		
		if (value < slider.value)
			time = value;
		else
			time = slider.value;
		end
		
		if hide
			set(slider.handle,'visible','off','max',0,'userdata',data);
		else
			set(slider.handle,'visible','on','max',value,'value',time);
		end
		
		try
			browser_resizefcn(par);
		catch
			% TODO: consider what to do here, silently log
		end
		
		if hide
			return;
		end
	
	%--
	% SPECIAL
	%--
	
	% NOTE: these updates do not affect visible slider properties
	
	case 'modified' % NOTE: this is a get only field
	
	case special, data.(field) = value; 
		
end

%--
% store slider userdata
%--

set(slider.handle, 'userdata', data);

%--
% update slider step if needed to satisfy slider increment
%--

% NOTE: make sure we have the right slider increment value

slider = get_time_slider(par);

if ~isempty(slider.slider_inc)
	
	change = {'min','max','slider_inc'};
	
	if ismember(field, change)
		
		range = slider.max - slider.min;
		
		if range
			set(slider.handle, ...
				'sliderstep', inc_to_step(range, slider.slider_inc) ...
			);
		end
		
	end
	
end

% NOTE: there are no further special field updates

if ismember(field, special)
	return;
end

%--
% set slider field, possibly update time first to avoid problem states
%--

if ~isempty(time)
	set(slider.handle, 'value', time);
end

set(slider.handle, field, value);
