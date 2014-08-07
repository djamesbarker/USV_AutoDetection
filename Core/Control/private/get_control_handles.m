function handles = get_control_handles(pal, name, control)

% get_control_handles - get control handles by name
% -------------------------------------------------
%
% handles = get_control_handles(pal, name, control)
%
% Input: 
% ------
%  pal - palette handle
%  name - control name
%  control - control
%
% Output:
% -------
%  handles - palette handle structure

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

% TODO: option to shortcut object search when we find something 

%-------------------------------------------
% CREATE STRUCT OF HANDLES
%-------------------------------------------

%--
% field for main callback control and all control related handles
%--

% NOTE: these get filled at the end

handles.obj = [];

handles.all = [];

%--
% struct for uicontrol handles
%--

handles.uicontrol.all = findobj(pal, 'type', 'uicontrol', 'tag', name);

for k = 1:length(handles.uicontrol.all)
	
	%--
	% copy control handle and get style for convenience
	%--
	
	handle = handles.uicontrol.all(k); style = get(handle, 'style');
	
	%--
	% store handle in style bin, creating bin if needed
	%--
	
	if ~isfield(handles.uicontrol, style)
		handles.uicontrol.(style) = handle;
	else
		handles.uicontrol.(style)(end + 1) = handle;
	end
	
end

%--
% fields for other type of objects
%--

type = {'axes', 'text'};

for k = 1:length(type)
	handles.(type{k}) = findobj(pal, 'type', type{k}, 'tag', name);
end

%--
% handle special cases
%--

% NOTE: most of these can be solved by careful choice of control names

if ~isempty(handles.axes)
	
	%--
	% remove palette toggle axes from control axes
	%--
	
	obj = findobj(handles.axes, 'buttondownfcn', 'palette_toggle'); 

	if ~isempty(obj)
		handles.axes = setdiff(handles.axes, obj); 
	end
	
	%--
	% get rating markers
	%--
	
	% NOTE: consider a more general way to get axes children
	
	if strcmp(control.style, 'rating')
		
		markers = findobj(handles.axes, 'type', 'line'); pos = cell2mat(get(markers, 'xdata'));
		
		[ignore, ix] = sort(pos); markers = markers(ix);
		
		handles.markers = markers;
		
	end
	
end

if ~isempty(handles.text)
	
	obj = findobj(handles.text, 'backgroundcolor', 'none'); 
	
	if ~isempty(obj)
		handles.text = setdiff(handles.text, obj); 
	end
	
end

%--
% collect all handles into all field
%--

handles.all = handles.uicontrol.all;
	
for k = 1:length(type)	
	
	if ~isempty(handles.(type{k}))
		handles.all = [handles.all; handles.(type{k})];
	end
	
end

%--
% return simple empty on empty
%--

% NOTE: this is probably not a good idea 

if isempty(handles.all)
	handles = []; return;
end
		
%-------------------------------------------
% SELECT MAIN CONTROL HANDLE
%-------------------------------------------

% TODO: a function 'get_control_styles' to check the validity of styles

style = control.style;

switch style
	
	% NOTE: these controls are named as the uicontrol
	
	case {'checkbox', 'edit', 'listbox', 'slider'}, handles.obj = handles.uicontrol.(style);
	
	% NOTE: these controls store value information in axes
	
	case {'axes', 'rating'}, handles.obj = handles.axes;
	
	% NOTE: these controls have a shorthand name
	
	case 'popup', handles.obj = handles.uicontrol.popupmenu;
		
	case 'buttongroup', handles.obj = handles.uicontrol.pushbutton;
		
end
		



