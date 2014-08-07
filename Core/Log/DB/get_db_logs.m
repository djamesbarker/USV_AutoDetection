function db_logs = get_db_logs(lib, sound, name)

% get_db_logs - get db logs from library
% --------------------------------------
%
% db_logs = get_db_logs(lib, sound, name)
%
% Input:
% ------
%  lib - parent library
%  sound - parent sounds
%  name - logs name
%
% Output:
% -------
%   db_logs - matching input

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
% handle input
%--

if nargin < 3
	name = '';
end

if nargin < 2
	sound = [];
end

if nargin < 1 || isempty(lib)
	lib = get_active_library;
end

if isempty(sound) 
	sound = get_library_sounds(lib);
end

%--
% get library logs
%--

db_logs = empty(db_log_create);

for k = 1:length(sound)
	
	root = fullfile(lib.path, sound_name(sound(k)), 'Logs');
	
	names = get_folder_names(root);
	
	if isempty(names)
		continue;
	end
	
	if ~isempty(name)
		if ~ismember(name, names)
			continue;
		else
			names = name;
		end
	end
	
	logs = strcat(root, filesep, names);
	
	if ischar(logs) 
		logs = {logs};
	end
	
	for j = 1:length(logs)
		db_logs(end + 1) = get_db_log(logs{j});
	end
	
end
