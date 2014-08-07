function log = new_log(logname, user, lib, sound)

% new_log - make a new log belonging to a particular user and sound

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

log = [];

%--
% check for empty string and proper file name
%--

if isempty(logname) || ~proper_filename(logname)
	return;
end

%--
% check whether a log with this name already exists
%--

logs = get_library_logs('info', lib, sound);

if any(strcmp(logs,[sound_name(sound) filesep logname]))
	return;
end

%--
% create new log and open
%--

lib_path = lib.path;

logname = [lib_path, sound_name(sound), filesep, 'Logs', filesep, logname, '.mat'];

log = log_create(logname,'sound',sound,'author',user.name);

%---------------------------------
% UPDATE VISIBLE STATE
%---------------------------------

%--
% update XBAT palette if available
%--

xbat_palette('find_sounds');

%--
% try to open log in browser if possible
%--

par = get_active_browser;

if ~isempty(par)
	log_open(par, logname);
end
