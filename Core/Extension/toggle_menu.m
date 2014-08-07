function toggle_menu(pal, ext, active)

% toggle_menu - toggle active extension state menu
% ------------------------------------------------
% 
% toggle_menu(pal, ext, active)
%
% Input:
% ------
%  pal - palette handle
%  ext - palette extensio
%  active - active state for extension

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

%-----------------------------------
% CREATE MENUS
%-----------------------------------

%--
% create top menu
%--

if active
	label = '(On)';
else
	label = '(Off)';
end

top = uimenu(pal, 'label', label, 'tag', 'TOP_TOGGLE_MENU');

%--
% create state menus
%--

states = [];

states(end + 1) = uimenu(top, 'label', 'On', 'check', bin2str(active)); 

states(end + 1) = uimenu(top, 'label', 'Off', 'check', bin2str(~active));

% NOTE: at the moment 'browser_filter_menu' infers type using tag

set(states, ...
	'callback', {@toggle_menu_callback, top, states, ext.subtype}, ...
	'tag', ext.subtype ...
);


%-----------------------------------
% TOGGLE_MENU_CALLBACK
%-----------------------------------

function toggle_menu_callback(obj, eventdata, top, states, type)

%--
% get set state from menu label
%--

state = lower(get(obj, 'label'));

%--
% reflect state in menus
%--

set(top, 'label', ['(', title_caps(state), ')']);

set(states, 'check', 'off'); set(obj, 'check', 'on');

%--
% get some context for callback
%--

pal = ancestor(obj, 'figure'); par = get_palette_parent(pal);

%--
% update state through helper
%--

% NOTE: this code should be generalized and updated

switch type
	
	case {'signal_filter', 'image_filter'}
		
		switch state

			case 'off', browser_filter_menu(par, 'No Filter');

			case 'on', browser_filter_menu(par, get(pal, 'name'));

		end

	case 'detector'
		
		switch state

			case 'off', browser_detect_menu(par, 'No Detection');

			case 'on', browser_detect_menu(par, get(pal, 'name'));

		end
		
end
