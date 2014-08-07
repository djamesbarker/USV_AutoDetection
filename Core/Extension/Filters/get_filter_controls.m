function control = get_filter_controls(ext, context, state, mode)

% get_filter_controls - get control structure array for a filter extension
% ------------------------------------------------------------------------
%
% control = get_filter_controls(ext, context, state, mode)
%
% Input:
% ------
%  ext - the filter extension
%  context - the extension context
%  state - whether extension is active
%  mode - 'palette' or 'dialog'
%
% Output:
% -------
%  control - the control array

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


if nargin < 4 || isempty(mode)
	mode = 'palette';
end

%--------------------------------------------------
% CREATE PALETTE
%--------------------------------------------------

control = empty(control_create);

%---------------------
% FILTER
%---------------------

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'string', 'Filter' ...
);

%--
% opacity
%--

control(end + 1) = control_create( ...
	'name', 'opacity', ...
	'alias', 'Fade', ...
	'tooltip', 'Fade result of filtering', ...
	'style', 'slider', ...
	'min', 0, ...
	'max', 1, ...
	'value', 1, ...
	'callback', {@filter_dispatch, ext} ...
);

%--
% active filter
%--

if strcmp(mode, 'palette')
	
	control(end + 1) = control_create( ...
		'name', 'active', ...
		'alias', 'On', ...
		'style', 'checkbox', ...
		'value', state, ...
		'callback', {@filter_dispatch, ext}, ...
		'tooltip', ['Make filter active'] ...
	);
	
end

%--
% developer controls
%--

if xbat_developer

	offset = 0.5 * 0.75;

	control(end + 1) = control_create( ...
		'style', 'separator', ...
		'space', 1 + offset ...
	);

	control(end + 1) = control_create( ...
		'name', 'debug', ...
		'alias', 'DEBUG', ...
		'style', 'checkbox' ...
	);

	control(end).space = -(1 + offset);

	control(end + 1) = control_create( ...
		'name', 'refresh', ...
		'alias', 'REFRESH', ...
		'style', 'buttongroup', ...
		'align', 'right', ...
		'lines', 1.75, ...
		'width', 0.5, ...
		'callback', {@filter_dispatch, ext} ...
	);

end

%---------------------
% PARAMETERS
%---------------------

%--
% get filter controls
%--

ext_controls = empty(control_create);

if ~isempty(ext.fun.parameter.control.create)

	try
		ext_controls = ext.fun.parameter.control.create(ext.parameter, context);
	catch
		extension_warning(ext, 'Parameter control creation failed.', lasterror);
	end

end

%--
% append filter specific controls to controls array
%--

if ~isempty(ext_controls)

	control(end + 1) = control_create( ...
		'style', 'separator', ...
		'type', 'header', ...
		'string', 'Parameters' ...
	);

	control(end) = adjust_control_space(control(end), ext_controls(1));

	%--
	% set filter control callbacks
	%--

	% NOTE: this routes the filter-specific callbacks through our own

	for k = 1:length(ext_controls)

		if ~iscell(ext_controls(k).name)

			ext_controls(k).callback = {@filter_dispatch, ext, ext_controls(k).callback};

		else

			% NOTE: this pattern may have to be repeated, hence factored

			% NOTE: this handles cell-packed controls, at the moment only 'buttongroup'

			callback = ext_controls(k).callback;

			for j = 1:length(ext_controls(k).name)

				if isempty(callback)

					ext_controls(k).callback{j} = {@filter_dispatch, ext, []};

				else

					if iscell(callback) && ~is_callback(callback)
						ext_controls(k).callback{j} = {@filter_dispatch, ext, callback{j}};
					else
						ext_controls(k).callback{j} = {@filter_dispatch, ext, callback};
					end

				end

			end

		end

	end

	%--
	% concatenate common controls and specific controls
	%--

	control = [control, ext_controls];

end
