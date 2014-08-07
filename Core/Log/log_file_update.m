function log = log_file_update(par, oldlog)

% log_file_update - create new version of deprecated log file
% -----------------------------------------------------------
%
% [flag, g] = log_file_update(par, oldlog)
%
% Input:
% ------
%  par - parent browser handle
%  oldlog - old log structure
%
% Output:
% -------
%  log - new log structure

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
% setup
%--

data = get_browser(par);

file = oldlog.file;  

lib = get_active_library;

user = get_active_user;

%--
% test for existance of log
%--

str = [lib.path, sound_name(data.browser.sound), filesep, 'Logs', filesep, file];

if exist(str, 'file')
	log = []; return;
end

%--
% create new log
%--

log = log_create(str, ...
	'sound', data.browser.sound, ...
	'author',get_field(user,'name') ...
);

%--
% update log events
%--

log = log_append(log, update_event(oldlog.event));

%--
% update log ID numbers and index and save
%--

log.length = length(log.event); log.curr_id = max([log.event.id]) + 1;

log_save(log);



	
	
	
	
