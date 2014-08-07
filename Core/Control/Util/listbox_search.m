function listbox_search(pal, type)

% listbox_search - filter listbox strings according to search box pattern
% -----------------------------------------------------------------------
%
% listbox_search(pal, type)
%
% Input:
% ------
%  pal - figure (palette) handle
%  type - the name of the control to search

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
% Author: Matt Robbins
%--------------------------------
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------


%--
% get various function names
%--

list_control_name = title_caps(string_plural(type));

info_control_name = [type, '_info'];

find_control_name = ['find_', string_plural(type)];

%--
% get search pattern
%--

pattern = get_control(pal, find_control_name, 'value');

%---------------------------
% UPDATE LISTBOX CONTROL
%---------------------------

% NOTE: the update of the listboxtop property is required

handles = get_control(pal, list_control_name, 'handles');

if isempty(handles)
	return;
end

%--
% filter names
%--

names = get(handles.uicontrol.listbox, 'string');
	
names = filter_strings(names, pattern);

enable_state = 'on';

if ~length(names)
	names = {['(No ', list_control_name, ' Available)']}; enable_state = 'off';
end

if ~iscell(names)
	names = {names};
end

set(handles.uicontrol.listbox, ...
	'string',names, ...
	'value',[], ...
	'listboxtop',1, ...
	'enable', enable_state ...
);		

%--
% create and update control label
%--

switch type
	
	case 'sound'
		
		info = sound_info_str(get_library_sounds([], 'name', names), 'multiple');
		
	otherwise
		
		if strcmp(enable_state, 'on') 
			N = length(names);
		else
			N = 0;
		end
		
		info = integer_unit_string(N, type);

end
	
%--
% set label
%--

set(handles.uicontrol.text, ...
	'string',[list_control_name, ' (', info, ')'] ...
);

%---------------------------
% RESET INFO CONTROL
%---------------------------

handles = get_control(pal, info_control_name, 'handles');

if ~isempty(handles)

	set(handles.uicontrol.listbox, ...
		'string',[], ...
		'value',[], ...
		'listboxtop',1, ...
		'enable','off' ...
	);

end


