function browser_kpfun(par, key)

% browser_kpfun - key press function for browser figure
% -----------------------------------------------------
%
% browser_kpfun(par, key)
%
% Input:
% ------
%  par - browser
%  key - keypress information

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

% NOTE: we could use the 'shift', 'return', and 'tab' keys for modal or focal changes

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% check handle input
%--

if ~is_browser(par)
	return;
end

%--
% get keypress struct
%--

if nargin < 2
	key = get_keypress(par);
end

% NOTE: build keypress struct from character input

if ischar(key)
	key.char = key; key.code = double(key.char); key.key = [];
end

%--------------------------------------------
% KEYPRESS CALLBACK
%--------------------------------------------

if strcmp(key.key, 'space')
	
	if isempty(get_player_buffer)
		
		sel = get_browser_selection(par);
		
		if isempty(sel.event)
			browser_sound_menu(par, 'Page');
		else 
			browser_sound_menu(par, 'Selection');
		end
		
	end
	
end

%--
% handle function keys
%--

% NOTE: at the moment we use these for various visibility commands

if ~isempty(key.key) && (key.key(1) == 'f')
    
    data = get(par, 'userdata');
	
	switch key.key

		%--
		% toggle palette display
		%--
		
		case 'f1'
			browser_window_menu(par, 'Hide Palettes');
		
		%--
		% toggle other sounds display
		%--
		
		case 'f2'
			browser_window_menu(par, 'TOGGLE_OTHERS');
		
		%--
		% toggle desktop display
		%--
		
		case 'f3'
			browser_window_menu(par, 'TOGGLE_DESKTOP');
		
		%--
		% cycle through open sounds, previous and next sound
		%--
		
		% NOTE: this is particularly useful when hiding other sounds
		
		% NOTE: 'f6' is back because forward is more intuitive and 'f5' more accesible
		
		case 'f5'
			show_browser(par, 'next'); 
		
		case 'f6'
			show_browser(par, 'previous');
            
        % 'f7' is Previous Time-Stamp
        case 'f7'
            sessions = get_sound_sessions(data.browser.sound, 0);
            ix = get_current_session(data.browser.sound);
            if ix > 1
                time = map_time( ...
                    data.browser.sound, 'slider', 'real', sessions(ix - 1).start);
                set_time_slider(par, 'value', time);
            end

        % 'f8' is Next Time-Stamp
        case 'f8'
            sessions = get_sound_sessions(data.browser.sound, 0);
            ix = get_current_session(data.browser.sound);
            if ix < length(sessions)
                time = map_time( ...
                    data.browser.sound, 'slider', 'real', sessions(ix + 1).start);
                set_time_slider(par, 'value', time);
            end
	end
	
	return;
	
end 
	
%--
% return on empty characters
%--

if isempty(key.code)
	return;
end

%--
% handle keystroke commands
%--

switch key.code
	
	%--------------------------------------------
	% MODE COMMANDS
	%--------------------------------------------
		
	%--
	% Hand Mode
	%--
	
	case double('h')
		
		% NOTE: this command should also be put into some other place
		
		set_browser_mode(par, 'hand');
		
	%--
	% Select Mode
	%--
	
	case double('s')
		set_browser_mode(par, 'select');
				
	%--------------------------------------------
	% SOUND COMMANDS
	%--------------------------------------------
	
	%--
	% Play Page
	%--

	case double('P')
		browser_sound_menu(par, 'Page');
		
	%--
	% Play Selection
	%--
	
	case double('p')
		
		%--
		% get availability of selection from menu state
		%--
		
		data = get(par, 'userdata');
		
		% NOTE: return if current figure is not a proper browser figure
		
		if ~isfield(data, 'browser')
			return;
		end
		
		tmp = get_menu(data.browser.sound_menu.play, 'Selection');
		
		%--
		% play selection or page
		%--
				
		if strcmp(get(tmp, 'enable'), 'on')
			browser_sound_menu(par, 'Selection');
		else
			browser_sound_menu(par, 'Page');
		end
		
	%--
	% Other Rate
	%--
	
	case double('r')
		browser_sound_menu(par, 'Other Rate ...');
		
	%--
	% Volume Control
	%--
	
	case double('v')
		browser_sound_menu(par, 'Volume Control ...');
		
	%--------------------------------------------
	% NAVIGATE COMMANDS
	%--------------------------------------------
		
	% NOTE: the view navigation is currently unstable under the new
	% navigation framework
	
	%--
	% Previous Event
	%--
	
	case double('E')
		
		%--
		% try to get event palette, if not found return
		%--
		
		g = get_palette(par, 'Event');
		
		if (isempty(g))
			return;
		end
		
		%--
		% execute previous event callback
		%--
		
		control_callback([],g, 'previous_event');
		
	%--
	% Next Event
	%--
	
	case double('e')
		
		%--
		% try to get event palette, if not found return
		%--
		
		g = get_palette(par, 'Event');
		
		if isempty(g)
			return;
		end
		
		%--
		% execute previous event callback
		%--
		
		control_callback([],g, 'next_event');
		
	%--
	% Previous View
	%--
	
	case double('<')
		browser_view_menu(par, 'Previous View');
		
	%--
	% Next View
	%--
	
	case double('>')
		browser_view_menu(par, 'Next View');
		
	%--
	% Previous Page (back arrow)
	%--
	
	case {28, double('b')}
		browser_view_menu(par, 'Previous Page');
		
	%--
	% Next Page (forward arrow)
	%--
	
	case {29, double('n')}
		browser_view_menu(par, 'Next Page');
		
	%--
	% First Page (up arrow)
	%--
	
	case 30
		browser_zoom('out', par);
		
	%--
	% Last Page (down arrow)
	%--
	
	case 31
		browser_zoom('in', par);
		
	%--
	% Go To Page ...
	%--
	
	case double('g')
		browser_view_menu(par, 'Go To Page ...');
		
	%--
	% Previous File
	%--
	
	% NOTE: perhaps this should be an idempotent commmand, look through the code
	
	case double('[')
		browser_view_menu(par, 'Previous File');
		
	%--
	% Next File
	%--
	
	case double(']')
		browser_view_menu(par, 'Next File');
		
	%--
	% Go To File ...
	%--
	
	case double('f')
		browser_view_menu(par, 'Go To File ...');

	%--------------------------------------------
	% COLORMAP COMMANDS
	%--------------------------------------------
	
	%--
	% Gray 
	%--
	
	% NOTE: the trailing space in the name of the menu command
	
	case double('G')
		browser_view_menu(par, 'Gray ');
	
	%--
	% Hot 
	%--
	
	case double('H')
		browser_view_menu(par, 'Hot');
		
	%--
	% Jet
	%--
	
	case double('J')
		browser_view_menu(par, 'Jet');
		
	%--
	% Bone
	%--
	
	case double('B')
		browser_view_menu(par, 'Bone');
		
	%--
	% HSV
	%--
	
	case double('V')
		browser_view_menu(par, 'Jet');
		
	%--
	% Colorbar
	%--
	
	case double('c')
		browser_view_menu(par, 'Colorbar');
		
	%--
	% Auto Scale
	%--
	
	case double('a')
		browser_view_menu(par, 'Auto Scale');
			
	%--
	% Invert
	%--
	
	case double('i')
		browser_view_menu(par, 'Invert');
		
	%--------------------------------------------
	% SELECTION COMMANDS
	%--------------------------------------------
	
	%--
	% Delete Selection (delete), and Stop Play
	%--
	
	case 127
		
		%--
		% check for sound player
		%--
		
		% NOTE: eventually there may be multiple players, one per parent
		
		player = timerfind('name', 'PLAY_TIMER');
		
		if ~isempty(player)
			stop(player); return;
		end
		
		%--
		% delete selection from current figure
		%--
		
		delete_selection(par);
	
	%--
	% Log Selection To
	%--
	
	% NOTE: there are problems with the name of this command
	
	case double('l')
		
		handle = get_menu(par, 'Log Selection To');
		
		handles = get(handle, 'children');
		
		if strcmp(get(handles, 'enable'), 'on')
			browser_edit_menu(par, 'Log Selection To');
		end
		
	%--
	% Selection Grid
	%--
	
	case double('''')
		browser_view_menu(par, 'Grid');
				
	%--
	% Selection Labels
	%--
	
	case double('"')
		browser_view_menu(par, 'Labels');
				
	%--
	% Control Points
	%--
	
	case double('.')
		browser_view_menu(par, 'Control Points');
		
	%--
	% Selection Zoom
	%--
	
	% NOTE: this is a mode, however it sometimes behaves as an action
	
	case double('z')
		browser_view_menu(par, 'Selection Zoom');
			
	%--------------------------------------------
	% GRID COMMANDS
	%--------------------------------------------
	
	%--
	% Time Grid (used to be 'Grid')
	%--
	
	case double(';')
		browser_view_menu(par, 'Time Grid');
				
	%--
	% File Grid
	%--
	
	case double(':')
		browser_view_menu(par, 'File Grid');
			
	%--------------------------------------------
	% MISCELLANEOUS COMMANDS
	%--------------------------------------------
	
	%--
	% Actual Size
	%--
	
	case double('=')
		browser_window_menu(par, 'Actual Size');
		
	%--
	% Half Size
	%--
	
	case double('-')
		browser_window_menu(par, 'Half Size');
		
	%--------------------------------------------
	% PALETTE COMMANDS
	%--------------------------------------------
	
	case double('x')
		xbat_palette;
	
	otherwise
		
end

% NOTE: consider if we want the browser to keep focus


