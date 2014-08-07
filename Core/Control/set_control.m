function control = set_control(pal, name, prop, value)

% set_control - set and command controls
% --------------------------------------
%
% control = set_control(pal, name, prop, value)
%
%         = set_control([], control, prop, value)
%
% Input:
% ------
%  pal - palette
%  name - control name
%  control - control container
%  prop - property name
%  value - value or command
%
% Output:
% -------
%  control - updated control container

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
% $Revision: 3232 $
% $Date: 2006-01-20 18:00:37 -0500 (Fri, 20 Jan 2006) $
%--------------------------------

% TODO: this is in need of major refactoring

% TODO: implement setting of multiple properties

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% return settable values, not documented right now
%--

% TODO: implement 'set' behavior when missing 'value' and possibly 'prop'

if nargin < 4
	
	switch prop
		
		% NOTE: these are the allowed values for 'command'
		
		case 'command', control = get_control_commands;  return;
			
	end
	
end

%--
% get control from input
%--

if isempty(pal)
	control = name;
else	
	control = get_control(pal, name);
end

%--
% return quickly if control was not found
%--

if isempty(control)
	return;
end

%----------------------------------
% DISPATCH SET
%----------------------------------

prop = lower(prop);

switch prop
	
	%-----------------------
	% COMMAND
	%-----------------------
	
	% NOTE: control is currently not modified by commands
	
	case 'command'
		
		if ~is_control_command(value)
			error(['Unrecognized control command ''', value, '''.']);
		end

		try
			set_command(control, value);
		catch
			disp(['WARNING: Command ''', value, ''' failed on ''', control.control.name, ''' control.']);
		end
		
	%-----------------------
	% DISPLAY PROPERTY
	%-----------------------
	
	%--
	% visible
	%--
	
	case 'visible'
		
		if ~ischar(value)
			value = bin2str(value); 
		end
		
		value = lower(value);
		
		switch value
			
			case 'on', set_command(control, '__SHOW__');

			case 'off', set_command(control, '__HIDE__');

			otherwise
				error('Allowed values for ''visible'' property are ''on'' and ''off''.');

		end
		
	%--
	% enable
	%--
	
	case 'enable'
		
		if ~ischar(value)
			value = bin2str(value); 
		end
		
		value = lower(value);
		
		switch value
			
			case 'on', set_command(control, '__ENABLE__');

			case 'off', set_command(control, '__DISABLE__');

			otherwise
				error('Allowed values for ''enable'' property are ''on'' and ''off''.');

		end
		
	%--
	% hide
	%--
	
	% NOTE: this will implement a real hide, one that affects global layout
	
	case 'hide'
		
		error('Not implemented yet.');
		
		if ~ischar(value)
			value = bin2str(value); 
		end
		
		value = lower(value);
		
	%-----------------------
	% CONTROL PROPERTY
	%-----------------------
	
	case 'label'
		
		%--
		% check for label
		%--
		
		handles = control.handles;
		
		if ~isfield(handles.uicontrol, 'text') || isempty(handles.uicontrol.text)
			return;
		end
		
		%--
		% set label and update control
		%--
		
		if ~ischar(value)
			error('Control label must be string.');
		end
		
		set(handles.uicontrol.text, 'string', value);
		
		control.label = value;
		
		
	% NOTE: property updates work in a set verify way 
	
	otherwise

		control = set_property(control, prop, value);
		
end


%------------------------------------------
% SET_COMMAND
%------------------------------------------

function set_command(control, command)

% set_command - command type control update
% --------------------------------------------
%
% set_command(control, command)
%
% Input:
% ------
%  control - control and handles
%  command -  command

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3297 $
% $Date: 2006-01-29 12:34:00 -0500 (Sun, 29 Jan 2006) $
%--------------------------------

%--
% get handles from control
%--

handles = control.handles.all;

%--
% strip leading and trailing underscores
%--

command = command(3:end - 2);

%--
% perform command
%--

switch command
	
	%--
	% enable and disable
	%--
	
	case {'ENABLE', 'DISABLE'}
		
		%--
		% get property values
		%--
		
		if strcmp(command, 'ENABLE')
			value = 'on';
		else
			value = 'off';
		end
		
		%--
		% update control objects
		%--
		
		% TODO: alternative display for disabled controls with better readability
		
		for k = 1:length(handles)

			if strcmp(get(handles(k), 'style'), 'text')
				continue;
			end
			
			try
				set(handles(k), ...
					'enable', value, ...
					'hittest', value ...
				);
			catch
				set(handles(k), ...
					'visible', value, ...
					'hittest', value ...
				);
			end

		end
		
	%--
	% show and hide
	%--

	case {'SHOW', 'HIDE'}

		%--
		% get property values
		%--
		
		if strcmp(command, 'SHOW')
			value = 'on';
		else
			value = 'off';
		end
		
		%--
		% update control objects
		%--

		for k = 1:length(handles)

			set(handles(k), ...
				'visible', value, ...
				'hittest', value ...
			);

			temp = get(handles(k), 'children');

			if ~isempty(temp)
				set(temp, ...
					'visible', value, ...
					'hittest', value ...
				);
			end

		end
		
	%--
	% unimplemented
	%--
	
	% NOTE: if we make it here we have been checked through is command
	
	otherwise
		
		disp(['WARNING: Command ''', value, ''' is not implemeneted.']);

end


%------------------------------------------
% SET_PROPERTY
%------------------------------------------

function control = set_property(control, prop, value)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3408 $
% $Date: 2006-02-06 15:40:18 -0500 (Mon, 06 Feb 2006) $
%--------------------------------

% TODO: add exception handling and error reporting

%----------------------------------------
% NEW SET CODE
%----------------------------------------

%--
% set using style handler
%--

% TODO: infer name of setter and check dispatch this dynamically

switch control.control.style
	
	case 'checkbox'
		set_checkbox_property(control, prop, value); return;
		
	% TODO: implement this ...
	
% 	case 'popupmenu'
% 		set_popup_property(control, prop, value); return;
		
	case 'rating'
		set_rating_property(control, prop, value); return;
		
	case 'slider'	
		set_slider_property(control, prop, value); return;
		
end

%----------------------------------------
% OLD SET CODE
%----------------------------------------

% TODO: use the control and handle struct to be smarter

%--
% update reported control value
%--

% NOTE: we can update the following properties with this code

props = {'value', 'string', 'index'};

if ~ismember(prop, props)
	error([title_caps(control.control.style), ' ''', prop, ''' is not currently settable.']);
end

control.value = value;

%--
% get flat control handles
%--

handles = control.handles.all;

%--
% update object values
%--

for k = 1:length(handles)
	
	%--
	% compute control style
	%--
	
	type = get(handles(k), 'type');
	
	switch type
		
		case 'axes', style = 'axes';
			
		case 'uicontrol', style = get(handles(k), 'style');
			
		otherwise, error(['Unknown control type ''', type, '''.']);
			
	end
	
	% NOTE: we should probably break if we meet this condition
	
	% NOTE: this allows us to set an edit string through 'value' or 'string'
	
	if strcmp(prop, 'string') && ~ismember(style, {'popupmenu', 'listbox', 'edit'})
		continue;
	end
	
	%--
	% set control value
	%--
	
	switch style
		
		case 'edit'
			
			set(handles(k), 'string', value);
			
		case 'axes'
			
			set(handles(k), 'userdata', value);
		
		case 'pushbutton'
			
			set(handles(k), 'userdata', value);
		
		case 'popupmenu'
				
			switch prop
				
				case 'string'
					
					% NOTE: when updating the string we must also update the value
					
					if ~iscellstr(value)
						error('Popupmenu ''string'' property must be string cell array.');
					end
					
					%--
					% get updated value
					%--
					
					current = get(handles(k), 'string'); current = current{get(handles(k), 'value')};
					
					ix = find(strcmp(value, current));
					
					if isempty(ix)
						ix = 1;
					end
					
					%--
					% update control
					%--
					
					set(handles(k), ...
						'string', value, 'value', ix ...
					);
					
				case 'value'
			
					%--
					% get update index
					%--

					% NOTE: there are two ways of updating: using string or index

					if iscell(value)
						value = value{1};
					end

					if ischar(value)
						ix = find(strcmp(get(handles(k), 'string'), value));
					else
						ix = value;
					end

					%--
					% update menu value
					%--

					if isempty(ix)
						continue;
					end

					set(handles(k), 'value', ix);
					
				case 'index'
					
					set(handles(k), 'value', value);
					
			end
		
		case 'listbox'
			
			%--
			% get update indices
			%--
			
			% NOTE: there are two ways of updating: a collection of strings or indices
			
			if (iscell(value) && ischar(value{1})) || ischar(value)
				
				%--
				% string update
				%--
				
				% NOTE: put string into cell
				
				if ischar(value)
					value = {value};
				end
				
				strings = get(handles(k), 'string');
				
				% NOTE: find value strings in string array of control
				
				% TODO: consider using 'intersect' function
				
				ix = [];
				
				for j = 1:length(value)
					ix = [ix, find(strcmp(strings, value{j}))];
				end
								
			else
				
				%--
				% index update
				%--
				
				ix = value;
				
			end
						
			%--
			% update listbox value
			%--

			set(handles(k), 'value', sort(ix));
			
	end
	
end

%------------------------------------------
% SET_RATING_PROPERTY
%------------------------------------------

function control = set_rating_property(control, prop, value)

%--
% unpack control
%--

handles = control.handles; control = control.control;

%--
% check set property
%--

props = {'value'};

if ~ismember(prop, props)
	error(['Rating ''', prop, ''' is not settable.']);
end

%--
% set property
%--

switch prop
	
	case 'value'
		
		%--
		% enforce limits
		%--
		
		if value < control.min
			value = control.min;
		elseif value > control.max
			value = control.max;
		end
		
		%--
		% set control
		%--
		
		set(handles.markers, 'markerfacecolor', 'none'); 
		
		set(handles.markers(1:value), 'markerfacecolor', control.color);
		
		set(handles.axes, 'userdata', value);
		
end


%------------------------------------------
% SET_SLIDER_PROPERTY
%------------------------------------------

function control = set_slider_property(control, prop, value)

% set_slider_property - set slider property
% ----------------------------------------
%
% control = set_slider_property(control, prop ,value)
%
% Input:
% ------
%  control - control container
%  prop - property
%  value - set value
%
% Output: 
% -------
%  control - updated control

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3408 $
% $Date: 2006-02-06 15:40:18 -0500 (Mon, 06 Feb 2006) $
%--------------------------------

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% check property
%--

% TODO: implement slider increment update

props = {'value', 'min', 'max', 'slider_inc'};

if ~ismember(prop, props)
	error(['Slider ''', prop, ''' is not settable.']);
end

%--------------------------------------
% UPDATE PROPERTY
%--------------------------------------

%--
% get control handles
%--

slider = control.handles.uicontrol.slider;

edit = control.handles.uicontrol.edit;

%--
% update property
%--

switch prop
	
	%---------------------
	% MIN AND MAX
	%---------------------

	% TODO: update slider step to preserve slider increment if needed
	
	case {'min', 'max'}
		
		%--
		% enforce order and value in range
		%--
		
		update = 0;
		
		switch prop
			
			case 'min'
				
				if value >= get(slider, 'max')
					error('Min must be smaller than max.');
				end
				
				if control.value < value
					update = 1;
				end
				
			case 'max'
				
				if value <= get(slider, 'min')
					error('Max must be larger than min.');
				end
				
				if control.value > value
					update = 1;
				end
				
		end
	
		%--
		% update limit and possibly value
		%--
		
		control.control.(prop) = value;
		
		% NOTE: value is updated when it exceeds updated range
		
		if update
			control.value = value;
		end

		set(slider, ...
			prop, value, 'value', control.value ...
		);
		
		% NOTE: this update makes elements coherent, extract function
		
		control = set_slider_property(control, 'value', control.value);
		
	%---------------------
	% VALUE
	%---------------------
	
	case 'value'
		
		%--
		% enforce slider range
		%--

		low = get(slider, 'min'); high = get(slider, 'max');
		
		if value < low
			value = low;
		elseif value > high
			value = high;
		end

		%--
		% enforce slider type and compute associated edit string
		%--
		
		% NOTE: slider type can be the userdata or a userdata field
		
		type = get(slider, 'userdata');

		if isempty(type)
			type = '';
		end

		if ~ischar(type)
			if isstruct(type) && isfield(type, 'type')
				type = type.type;
			else
				type = '';
			end
		end
		
		% TODO: be flexible in setting sliders
		
		switch type

			case 'time'
				string = sec_to_clock(value);

			% NOTE: the value constraint here is part of the range enforcement

			case 'integer'
				value = round(value); string = int2str(value);

			otherwise
				string = num2str(value);

		end

		%--
		% update control value
		%--
		
		control.value = value;

		set(slider, 'value', value); 

		set(edit, 'string', string);
		
	%---------------------
	% SLIDER_INC
	%---------------------
	
	case ('slider_inc')
		
end


%------------------------------------------
% SET_CHECKBOX_PROPERTY
%------------------------------------------

function control = set_checkbox_property(control, prop, value)
 
% set_checkbox_property - set checkbox property
% ---------------------------------------------
%
% control = set_checkbox_property(control, prop, value)
%
% Input:
% ------
%  control - control container
%  value - set value
%
% Output: 
% -------
%  control - updated control

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3408 $
% $Date: 2006-02-06 15:40:18 -0500 (Mon, 06 Feb 2006) $
%--------------------------------

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% check for settable property
%--

props = {'value', 'min', 'max'};

if ~ismember(prop, props)
	error(['Checkbox ''', prop, ''' is not settable.']);
end

%--------------------------------------
% SET PROPERTY
%--------------------------------------

%--
% get control handle
%--

checkbox = control.handles.uicontrol.checkbox;

%--
% set property
%--

switch prop
	
	%---------------------
	% MIN AND MAX
	%---------------------
	
	case {'min', 'max'}
		
		%--
		% enforce order
		%--
		
		switch prop
			
			case 'min'
				
				if value >= get(checkbox, 'max')
					error('Min must be smaller than max.');
				end
				
			case 'max'
				
				if value <= get(checkbox, 'min')
					error('Max must be larger than min.');
				end
				
		end
		
		%--
		% update limit and possibly value
		%--
		
		% NOTE: consider whether this is needed
		
		control.control.(prop) = value;
		
		% NOTE: update value when the it matches limit to update
		
		if control.value == get(checkbox, prop)
			control.value = value;
		end
		
		set(checkbox, ...
			prop, value, 'value', control.value ...
		);
		
	%---------------------
	% VALUE
	%---------------------
	
	case 'value'
		
		%--
		% force value to closest of min or max
		%--
		
		low = get(checkbox, 'min'); high = get(checkbox, 'max');
		
		mid = 0.5 * (low + high);

		if value < mid
			value = low;
		else 
			value = high;
		end

		%--
		% update control value
		%--

		control.value = value;
		
		set(checkbox ,prop, value);
		
end


%------------------------------------------
% SET_POPUP_PROPERTY
%------------------------------------------

function control = set_popup_property(control, prop, value)

%--
% get main handle
%--

obj = control.handles.obj;

%--
% check property to update
%--

% NOTE: we get lowercase settable property names

props = lower(fieldnames(set(obj)));

if ~ismember(prop, props)
	error('Unrecognized settable property for ''popup''.');
end

%--
% update property
%--

% TODO: determine how errors should be handled

switch prop
	
	case 'string'
		
		if ~iscellstr(value)
			error('Popup ''string'' value must be string cell array.');
		end
		
		current = get(obj, 'string'); current = current(get(obj, 'value'));
		
		ix = find(strcmp(current, value));
		
		if isempty(ix)
			ix = 1;
		end
		
		set(obj, 'string', value, 'value', ix);
		
	case 'value'
		
		if ischar(value)		
			ix = find(strcmp(value, get(obj, 'string')));
		end
			
		if isempty(ix) || (ix < 1) || (ix > length(get(obj, 'string')))
			return;
		end
		
		set(obj, 'value', ix);
		
	otherwise
		
		% NOTE: MATLAB handles any errors here
		
		set(obj, prop, value);
		
end




