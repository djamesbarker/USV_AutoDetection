function set_active_toggle_menu(pal, state)

%--
% user the state to find and set the top menu
%--

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

if state
	label = '(Off)'; update = '(On)';
else 
	label = '(On)'; update = '(Off)';
end

% NOTE: we only find the menu when we need to change it

top = findobj(pal, 'type', 'uimenu', 'tag', 'TOP_TOGGLE_MENU');

if isempty(top)
	return;
end

%--
% update menus
%--

set(top, 'label', update);

states = allchild(top);

set(states, 'check', 'off')

if state
	label = 'On';
else
	label = 'Off';
end

set(findobj(states, 'label', label), 'check', 'on');
