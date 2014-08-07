function state = set_browser_state(par, state, opt)

% set_browser_state - set browser display state
% ---------------------------------------------
%
% state = set_browser_state(par, state, opt)
%
%   opt = set_browser_state
% 
% Input:
% ------
%  par - browser figure handle
%  state - browser display state
%  opt - state loading options
%
% Output: 
% -------
%  state - browser display state
%  opt - state loading options

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
% set default options
%--

if (nargin < 3) || isempty(opt)
	
	%--
	% create options structure
	%--
	
	opt.position = 1;
	
	opt.palettes = 1;
	
	opt.log = 1;
	
	opt.selection = 1;
	
	%--
	% output options structure
	%--
	
	if ~nargin
		state = opt; return;
	end
	
end
	
%--
% turn off sounds while we are doing this
%--

palette_sounds = get_env('palette_sounds');

% NOTE: set the default value if not available

if isempty(palette_sounds)
	palette_sounds = 'on';
end

set_env('palette_sounds', 'off');

%--
% turn off palette daemon if needed
%--

% NOTE: this can be encapsulated

timer_stop('XBAT Palette Daemon');

%--
% check screensize
%--

% NOTE: the screensize check could be problematic

screensize = get(0, 'screensize');

if ~isequal(screensize, state.screensize)
	disp('WARNING: Screensize changed between sessions, problems may arise.');
end

%----------------------------------
% UPDATE OUT OF SCREEN POSITIONS
%----------------------------------

% NOTE: this code needs to be checked and cleaned up

%--
% consider offset for figures off the screen
%--

offset = 0;

if (state.position(1) <= 0)
	
	offset = -state.position(1) + 32;
	
elseif (state.position(1) >= screensize(3))
	
	offset = -state.position(3) - 32;
	
end

%--
% update state positions based on offset
%--

if offset

	state.position(1) = state.position(1) + offset;

	for k = 1:length(state.palette)
		state.palette(k).position(1) = state.palette(k).position(1) + offset;
	end

end

%----------------------------------
% SET BROWSER POSITION
%----------------------------------

if opt.position
	
	set(par, 'position', state.position);

end

%----------------------------------
% OPEN PALETTES
%----------------------------------

if opt.palettes && ~isempty(state.palette)

	for k = 1:length(state.palette)

		try

			pal = [];
			
			%--
			% try to open palette using tag if available
			%--
			
			if isfield(state.palette(k), 'tag')
				
				info = parse_tag(state.palette(k).tag, '::', {'ignore', 'type', 'name'});
				
				info.type = lower(info.type);
				
				switch info.type
					
					case 'core'
						pal = browser_palettes(par, state.palette(k).name);
						
					otherwise
						pal = extension_palettes(par, info.name, info.type);
						
				end
				
			end
				
			%--
			% try to open palette by beating with a stick
			%--
			
			if isempty(pal)

				pal = browser_palettes(par, state.palette(k).name);

				% NOTE: in this case the function tries to infer the type

				if isempty(pal)
					pal = extension_palettes(par, state.palette(k).name);
				end
			
			end
			
			%--
			% set palette state
			%--
			
			% TODO: this step fails for detector palettes
			
			if ~isempty(pal)
				set_palette_state(pal, state.palette(k));
			end

		catch

			nice_catch(lasterror, ['WARNING: Failed to open ''', state.palette(k).name, ''' palette.']);

		end

	end

end

%----------------------------------
% RESTORE PALETTE STATES
%----------------------------------

if opt.palettes && ~isempty(state.palette_states)

	data = get(par, 'userdata');

	data.browser.palette_states = state.palette_states;

	set(par, 'userdata', data);

end
	
%----------------------------------
% SET OPEN LOGS STATE
%----------------------------------

if opt.log && isfield(state, 'log') && ~isempty(state.log)

	%--
	% get library content from figure tag
	%--
	
	info = parse_tag(get(par, 'tag')); 
	
	lib = get_libraries([], 'name', get_library_file_name(info.library));
	
	%--
	% construct library log locations
	%--
	
	logs = strcat(lib.path, info.sound, [filesep, 'Logs', filesep], state.log.names, '.mat');
	
	%--
	% separate active log from other logs in list
	%--
	
	active = logs{state.log.active};
	
	logs(state.log.active) = [];
	
	%--
	% try to open logs from state
	%--
	
	% NOTE: we open active log last, and log open is given a no warning flag

	for k = 1:length(logs)
		flag = log_open(par, logs{k}, 0);
	end
	
	flag = log_open(par, active, 0);
	
	% TODO: consider notifying user if some log failed to load
	
end

%----------------------------------
% RESTORE SELECTION STATES
%----------------------------------

if opt.selection && isfield(state, 'selection') && ~isempty(state.selection)

	%--
	% update browser selection state
	%--
	
	% TODO: browsers should become objects
	
	data = get(par, 'userdata');

	data.browser.selection = state.selection;

	set(par, 'userdata', data);

	%--
	% make sure that controls are in sync with state
	%--
	
	% NOTE: we recreate the palette so that current selection values will be loaded
	
	pal = get_palette(par, 'Selection', data);
	
	if ~isempty(pal)
		
		close(pal); browser_window_menu(par, 'Selection'); % create and set state
	
	end	
	
	%--
	% update selection display
	%--
	
	selection_update(par, data);
	
end

%--
% set palette sounds to previous state
%--

% NOTE: this is another problem related to failure to load state

set_env('palette_sounds', palette_sounds);

%--
% restart daemon if needed
%--

timer_run('XBAT Palette Daemon');

	
