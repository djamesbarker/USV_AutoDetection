function [sound, cancel] = migrate_sound(source, lib)

%--
% set default output
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

cancel = 0;

sound = [];

%--
% update waitbar ticks if necessary
%--

content = what_ext(fullfile(source, 'Logs'), 'mat'); 

% NOTE: we add 1 to account for this sound in addition to its logs.

set_migrate_wait_ticks(length(content.mat) + 1);

%--
% increment waitbar
%--

[ignore, name] = fileparts(source); 

[ignore, result] = migrate_wait('Sounds', [], name);

if ~isempty(result)
	cancel = strcmp(result, 'cancel'); return;
end

%--
% handle input
%--

if nargin < 2 || isempty(lib)
	lib = get_active_library;
end

%--
% load old sound file
%--

file = get_sound_file(source);

if ~exist(file, 'file')
	return;
end

contents = load(file);

%--
% check contents of file
%--

if isfield(contents, 'snd')
	sound = contents.snd;
elseif isfield(contents, 'sound')
	sound = contents.sound;
else
	return;
end

if ~isempty(get_library_sounds(lib, 'name', sound_name(sound)))
	return;
end

% NOTE: state is not currently updated

if ~isfield(contents, 'state')
	state = [];
else
	state = contents.state;
end

%--
% update sound and add to library
%--

sound = update_sound(sound);

add_sounds(sound, lib);

%--
% migrate logs
%--

migrate_logs([source, filesep, 'Logs'], lib, sound);
