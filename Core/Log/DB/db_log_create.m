function db_log = db_log_create(name, sound, lib)

% db_create_log - create sqlite based log
% ---------------------------------------
%
% db_log = db_log_create(name, sound, lib)
%
% Input:
% ------
%  name - log name
%  sound - parent sound
%  lib - container library
%
% Output:
% -------
%  db_log - db_log struct

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
% create log struct
%--

db_log.root = '';

db_log.events = '';

db_log.measures = {};

db_log.annotations = {};

% NOTE: return if there is nothing to do

if ~nargin
	return;
end

%--
% handle input
%--

% TODO: consider which conditions should result in errors

if nargin < 3
	lib = get_active_library;
end 

if isempty(lib)
	return;
end

if nargin < 2
	sound = get_active_sound;
end

if ischar(sound)
	sound = get_library_sound(lib, 'name', sound);
end

if isempty(sound)
	return;
end

if ~proper_filename(name)
	error('Log name must be proper filename.');
end

% NOTE: the name should not have excess spaces

name = strtrim(name);

%--
% create root directory
%--

[root, created] = create_dir(fullfile(lib.path, sound_name(sound), 'Logs', name));

% NOTE: return if the log directory exists or we can't create its root

if ~created
	db_log = get_db_logs(lib, sound, name); return; 
end

if isempty(root)
	error('Failed to create log root directory.');
end

%--
% create events database
%--

events = [root, filesep, 'Events.db'];

% NOTE: this is the only call to the database layer

% TODO: create a higher level function that creates the full events database

sqlite(events, 'prepared', create_event_table);

%--
% create measure and annotation root directories
%--

if isempty(create_dir([root, filesep, 'Measures']))
	error('Failed to create measures directory.');
end

if isempty(create_dir([root, filesep, 'Annotations']))
	error('Failed to create annotations directory.');
end

%--
% get log from system
%--

% NOTE: this checks that we can get the log from using the higher level code

db_log = get_db_logs(lib, sound, name);






% db_log = db_log_create(name, sound, lib)

% db_logs = get_db_logs(lib, sound, name)


% NOTE: these should be very light, since the struct is just pointers

% db_log = open_db_log(par, db_log)

% db_log = close_db_log(par, name)


% NOTE: now we will only build events in memory as needed

% [id, events] = db_log_select_events(db_log, statement)

% events = db_log_events_in_page(db_log, page)


% NOTE: this is the basic CRUD 

% count = db_log_add_events(db_log, events)

% count = db_log_delete_events(db_log, events)

% count = db_log_update_events(db_log, events, field, value, ... )


