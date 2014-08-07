function [par, created] = open_library_sound(name, lib, create)

% open_library_sound - open library sound
% ---------------------------------------
%
% [par, created] = open_library_sound(name, lib, create)
%
% Input:
% ------
%  name - sound name
%  lib - parent library
%  create - create new browser (def: 0)
%
% Output:
% -------
%  par - browser handle
%  created - new browser created indicator

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

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set new browser option
%--

if (nargin < 3) || isempty(create)
	create = 0;
end

%--
% get library if needed
%--

if (nargin < 2) || isempty(lib)
	lib = get_active_library;
end

% NOTE: handle library name input

if ischar(lib)
	lib = get_library_from_name(lib);
end

% NOTE: return if we don't have a parent library

if isempty(lib)
	par = []; created = 0; return;
end

%----------------------------------
% SETUP
%----------------------------------

%--
% load sound file content
%--

content = sound_load(lib, name);

% NOTE: get browser state and sound from sound

field = fieldnames(content);

if (length(field) > 1) && ~isempty(find(strcmp('state', field), 1))
	state = content.state;
else
	state = [];
end

sound = content.sound;

%----------------------------------
% CHECK AND REPAIR SOUND
%----------------------------------

if ~sound_check_files(sound)
	sound = sound_repair(sound);
end

if isempty(sound)
	par = []; created = []; return;
end

sound = sound_attribute_update(sound);
	
%----------------------------------
% OPEN SOUND
%----------------------------------

%--
% check for open sound
%--

[opened, par] = sound_is_open(sound, lib);

if ~isempty(par) && ~create 
	figure(par(1)); created = 0; return;
end

%--
% open sound in browser
%--
	
% TODO: there is something minor not done here

timer_stop;

if ~opened
	par = browser(sound);
end

created = 1;

%--
% update browser display state
%--

if ~isempty(state)
	
	try
		set_browser_state(par, state);
	catch
		nice_catch(lasterror, 'WARNING: Failed to fully reset browser state.');
	end
	
end

timer_run;
