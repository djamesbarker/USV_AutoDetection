function control = control_create(varargin)

% control_create - create control structure
% -----------------------------------------
%
% control = control_create('field', value, ..., 'field', value)
%
% Input:
% ------
%  field - control field
%  value - field value
%
% Output:
% -------
%  control - control structure

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
% $Revision: 6565 $
% $Date: 2006-09-18 01:58:33 -0400 (Mon, 18 Sep 2006) $
%--------------------------------

% TODO: create 'get_control_styles' function that may be used to check style

% TODO: calling form where first input is 'style', or first two fields are 'style' and 'name'

%---------------------------------------------------------------------
% CREATE CONTROL STRUCTURE
%---------------------------------------------------------------------

persistent CONTROL_PERSISTENT;

if isempty(CONTROL_PERSISTENT)
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	control.name = '';					% name of control
	
	control.alias = '';					% alias 'name' to be used as label when available
	
	control.style = '';					% style of uicontrol object
	
	%--------------------------------
	% CONTROL FIELDS
	%--------------------------------
		
	control.value = 0;					% value of uicontrol object
		
	control.min = 0;					% slider min value
	
	control.max = 1;					% slider max value
	
	control.sliderstep = [0.01, 0.1];	% slider step variables
	
	control.slider_inc = [];			% slider increment values (absolute values)
	
	control.type = '';					% type of control ... sliders and edit
		
	control.string = '';				% string in edit box, cell array of strings in listbox or popup
	
	control.confirm = 0;				% creates buttons for listbox
	
	control.units = '';					% set units or type of units for control
	
	%--------------------------------
	% LAYOUT AND DISPLAY FIELDS
	%--------------------------------
	
	control.show = 1;					% IN DEVELOPMENT, this should really hide a control
	
	% NOTE: consider this for hidden controls as well, and integrate with
	% 'set' and 'get' to store and retrieve values from the control store
	% if the control is not showing
	
	control.label = 1;					% label indicator
	
	control.tab = '';					% tab that the control belongs to
	
	control.layout = 'normal';			% layout mode may be 'normal' or 'compact' (NOT FULLY IMPLEMENTED)
	
	control.width = 1;					% width of control in control palette as fraction of palette
	
	control.lines = [];					% number of lines for listbox or edit box in tiles
	
	control.space = [];					% spacing after control in tiles
	
	control.align = 'left';				% alignment for controls
	
	control.buttonspace = [0.05,0.05];	% spacing for buttons (NOT IMPLEMENTED)
	
	control.color = [];
	
	control.marker = [];				% marker used for rating controls
	
	control.initialstate = '';			% use to hide or disable a control on creation
	
	control.update_rate = 0.02;			% update rate for control mostly used for waitbars

	%--------------------------------
	% HELP FIELDS
	%--------------------------------
	
	control.tooltip = '';				% tooltip string
	
	control.help = '';					% url for help file
	
	%--------------------------------
	% CALLBACK FIELDS
	%--------------------------------
	
	control.callback = '';				% control callback function
	
	control.onload = 0;					% execute callback on load
	
	control.active = 0;					% active control behavior
	
	%--------------------------------
	% USERDATA FIELD
	%--------------------------------
	
	control.tag = '';					% tag string for control
	
	control.userdata = [];				% userdata field is not used by system
	
	%--
	% set persistent control
	%--
	
	CONTROL_PERSISTENT = control;
	
else
	
	%--
	% copy persistent control and update creation date
	%--
	
	control = CONTROL_PERSISTENT;
		
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

% TODO: add some validation code to this as we move towards an object

% NOTE: consider using a DDL (data description language) to represent validation

if length(varargin)
	
	%--
	% store field value pairs into proper fields
	%--
	
	[control, fields] = parse_inputs(control, varargin{:});

	if isempty(control.style)
		error('Control style must be set.');
	end

	%--
	% perform some validation
	%--
	
	% NOTE: this could later become a validation callback for 'parse_inputs'
	
	switch control.style

		%--
		% POPUP
		%--
		
		case 'popup'
			
			if ~iscellstr(control.string)
				error('Popup control ''string'' property must be a string cell array.');
			end
			
			if ~control.value
				control.value = 1;
			end
			
		%--
		% TABS
		%--
		
		case 'tabs'
			
			% NOTE: set prefixed random name for tabs if needed
			
			if isempty(control.name)
				control.name = ['TABS_', int2str(rand(1) * 10^12)];
			end
			
		%--
		% EDIT
		%--
		
		case 'edit'
			
			if ~isempty(control.type) ...
                    && ~ismember(control.type, get_edit_types)
				error('Unrecognized edit type.');
			end
			
		%--
		% SLIDER AND RATING
		%--
		
		% NOTE: the rating is really a type of slider
		
		case {'slider', 'rating'}

			%--
			% check for min and max and set missing value if needed
			%--
			
			if isempty(control.min) || isempty(control.max)
				error('Slider control min and max must be set.');
			end
			
			if isempty(control.value)
				control.value = control.min;
			end
			
			%--
			% check range of value and produce warning
			%--
			
			flag = 0;
			
			if (control.value > control.max)
				control.value = control.max; flag = 1;
			elseif (control.value < control.min)
				control.value = control.min; flag = 1;
			end
			
			% TODO: this kind of behavior should be reserved for developers
			
			if flag
				disp(['WARNING: declared value for control ''', ...
                    control.name, ''' is out of range.']);
			end
			
			%--
			% slider specific
			%--
			
			if strcmp(control.style, 'slider')
				
				%--
				% set slider step using desired slider increment
				%--

				if ~isempty(control.slider_inc)
					control.sliderstep = inc_to_step(control);
				end

				%--
				% check slider type
				%--

				if ~isempty(control.type)

					if ~ischar(control.type)
						error('Slider type must be a string.');
					end 

					if ~ismember(control.type, get_slider_types)
						error(['Unrecognized slider type ''', control.type, '''.']);
					end
					
					if strcmp(control.type, 'integer') ...
                            && ~any(ismember({'slider_step', 'slider_inc'}, fields))
						
						range = control.max - control.min + 1;
						
						if range < 32
							control.slider_inc = [1, 2];
						elseif (range >= 50) && (range < 75)
							control.slider_inc = [1, 5];
						else
							control.slider_inc = [1, 10];
						end
						
						control.sliderstep = inc_to_step(control);
					
					end

				end
				
			%--
			% rating specific
			%--
			
			else
				
				% NOTE: this should be the default for waitbars as well
				
				if isempty(control.lines)
					control.lines = 1.15;
				end
				
				if isempty(control.color)
					control.color = 0.5 * ones(1, 3);
				end
				
				if isempty(control.marker)
					control.marker = 'o';
				end
				
			end
			
		%--
		% WAITBAR
		%--
		
		case 'waitbar'
			
			if isempty(control.lines)
				control.lines = 1.1;
			end
			
		%--
		% SEPARATOR
		%--
		
		case 'separator'
			
			if isempty(control.lines)
				control.lines = 1.05;
			end
			
			% NOTE: set prefixed random name for separators if needed
			
			if isempty(control.name)
				control.name = ['SEP_', int2str(rand(1) * 10^12)];
			end
			
		%--
		% BUTTONGROUP
		%--
		
		case 'buttongroup'
			
			%--
			% handle actual button groups
			%--
			
			if iscell(control.name)
				
				if isempty(control.tooltip)
					
					%--
					% set empty tooltips
					%--
					
					tooltip = cell(size(control.name));
					
					for k = 1:numel(tooltip)
						tooltip{k} = '';
					end
					
					control.tooltip = tooltip;
					
				else
					
					%--
					% check for proper tooltip value
					%--
					
					if ~iscellstr(control.tooltip)
						error('Tooltip for button group must be a cell array of strings.');
					end
					
					if ~isequal(size(control.name), size(control.tooltip))
						error('Tooltip for button group must be of the same size as button group.');
					end
					
				end
				
			end
					
	end
	
	%--
	% set some defaults
	%--

	if isempty(control.lines)
		control.lines = 1;
	end
	
end
