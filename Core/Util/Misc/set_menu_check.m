function set_menu_check(handles, state)

% set_menu_check - set check state of menus
% -----------------------------------------
%
% set_menu_check(handles, state)
%
% Input:
% ------
%  handles - menu handles
%  state - check state

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

%--
% check input handles
%--

if any(~ishandle(handles)) || isempty(find(strcmp(get(handles, 'type'), 'uimenu')))
	error('Input must be valid menu handles.');
end

%--
% set menu check state
%--

switch state
	
	case {'on', 1}, set(handles, 'check', 'on');
		
	case {'off', 0}, set(handles, 'check', 'off');
		
	otherwise, error('Unrecognized state input.');
		
end
