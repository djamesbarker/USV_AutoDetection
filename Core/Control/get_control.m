function out = get_control(pal, name, opt)

% get_control - get control from palette
% --------------------------------------
%
%     out = get_control(pal, name)
%
%         = get_control(pal, name, 'all')
%
% control = get_control(pal, name, 'control')
%
% handles = get_control(pal, name, 'handles')
%
%   value = get_control(pal, name, 'value')
%
%   label = get_control(pal, name, 'label')
%
% Input:
% ------
%   pal - parent palette handle
%  name - control name
%
% Output:
% -------
%      out - output container
%  control - control
%  handles - handles
%    value -  value
%    label - label

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

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% set default output option
%--

if (nargin < 3) || isempty(opt)
	opt = 'all';
end

%--
% check output option
%--

opts = {'all', 'control', 'handles', 'value', 'label', 'string', 'index'};

if ~ismember(opt, opts)
	error(['Unknown output option ''', opt, '''.']);
end

%--
% check palette handle
%--

if ~is_palette(pal)
	error('Input handle is not a palette.');
end

%--------------------------------
% GET CONTROL
%--------------------------------

%--
% get control
%--

control = get_control_by_name(pal, name);

% NOTE: return simple empty when control is not found , consider some kind of message here

if isempty(control)
	out = []; return;
end

%--
% get further cotnrol info and pack output
%--

% NOTE: the lower level functions return simple empty on empty

switch opt
	
	case 'control'
		
		out = control;
		
	case {'handles', 'label', 'string', 'index'}
		
		% NOTE: this does not get all header handles
		
		%--
		% handles code
		%--
		
		handles = get_control_handles(pal, name, control);
		
		if isempty(handles.all)
			out = []; return;
		end
		
		if strcmp(opt, 'handles')
			out = handles; return;
        end
        
        if strcmp(opt, 'string')
            out = get(handles.obj, 'string'); return;
		end
		
		if strcmp(opt, 'index')
			
			out = get(handles.obj, 'value');
			
			if ~isnumeric(out)
				out = []; 
			end
			
			return;
		
		end
			
		%--
		% label code
		%--
		
		out = get_control_label(handles);
	
	case {'value', 'all'}
		
		%--
		% required for value and hence for all
		%--
		
		out.control = control;
		
		out.handles = get_control_handles(pal, name, control);
		
		% NOTE: discard control and handles from output if 'value'
		
		if strcmp(opt, 'value')
			out = get_value(out); return;
		end
		
		out.value = get_value(out);
		
		out.label = get_control_label(out.handles);
		
end


%----------------------------------------------
% GET_CONTROL_LABEL
%----------------------------------------------

function label = get_control_label(handles)

% TODO: consider the case of multiple text handles, mark label in some way

if ~isfield(handles.uicontrol, 'text') || isempty(handles.uicontrol.text)
	label = []; return;
end

label = get(handles.uicontrol.text, 'string');


%----------------------------------------------
% GET_VALUE
%----------------------------------------------

function value = get_value(control)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3621 $
% $Date: 2006-02-15 17:24:23 -0500 (Wed, 15 Feb 2006) $
%--------------------------------

%--
% return quickly if there are no handles
%--

% TODO: implement hidden control here, the value is stored in the palette

if isempty(control.handles)
	value = []; return;
end

% TODO: make use of control struct for efficiency and robustness

%--
% get control handles
%--

% TODO: use the handle struct and be smarter

handles = control.handles.all;

%--
% get control value
%--

%------------------------------
% AXES
%------------------------------

% NOTE: this also gets the value from a rating control

ix = find(strcmp(get(handles, 'type'), 'axes'));

if ~isempty(ix)
	value = get(handles(ix), 'userdata'); return;
end

%------------------------------
% SLIDER
%------------------------------

% NOTE: slider first yields the correct result for controls composed of a slider and edit box

ix = find(strcmp(get(handles, 'style'), 'slider'));

if ~isempty(ix)
	value = get(handles(ix), 'value'); return;
end

%------------------------------
% EDIT
%------------------------------

% NOTE: we convert multiple row character arrays to string cell arrays

ix = find(strcmp(get(handles, 'style'), 'edit'));

if ~isempty(ix)

	value = get(handles(ix), 'String');

	if size(value, 1) > 1
		value = cellstr(value);
	end

	return;

end

%------------------------------
% POPUPMENU
%------------------------------

% TODO: the output value of popup menus should be a string, change with care

ix = find(strcmp(get(handles, 'style'), 'popupmenu'));

if ~isempty(ix)

	% NOTE: we get value by dereferencing string with value

	strings = get(handles(ix), 'string');
	
	value = strings(get(handles(ix), 'value')); % results in cell

	return;

end

%------------------------------
% LISTBOX
%------------------------------

ix = find(strcmp(get(handles, 'style'), 'listbox'));

if ~isempty(ix)
	
	% NOTE: we get value by dereferencing string with value

	strings = get(handles(ix), 'string');
	
	if isempty(strings)
		value = {}; return;
	end
	
	ix = get(handles(ix), 'value');
	
	if isempty(ix)
		value = {}; return;
	end
	
	value = strings(ix); return;
	
end

%------------------------------
% CHECKBOX
%------------------------------

ix = find(strcmp(get(handles, 'style'), 'checkbox'));

if ~isempty(ix)
	value = get(handles(ix), 'value'); return;
end

%------------------------------
% PUSHBUTTON
%------------------------------

ix = find(strcmp(get(handles, 'style'), 'pushbutton'));

if ~isempty(ix)
	value = get(handles(ix), 'userdata'); return;
end
