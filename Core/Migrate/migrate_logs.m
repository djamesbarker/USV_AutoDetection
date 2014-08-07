function [log, cancel] = migrate_logs(source, lib, sound)

% migrate_logs - migrate library logs
% ------------------------------------------
% 
% logs = migrate_logs(source, lib, sound)
%
% Input:
% ------
%  source - source logs root
%  lib - library to which to migrate logs
%  sound - sound to which to migrate logs
%
% Output:
% -------
%  logs - migrated logs

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

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

cancel = 0;

%--
% get active library if none given
%--

if nargin < 2 || isempty(lib)
	lib = get_active_library;
end

%--
% try to get sound from library if not given
%--

if nargin < 3 || isempty(sound)
	
	[ignore, soundname] = fileparts(fileparts(source));

	sound = get_library_sounds(lib, 'name', soundname);
	
end
	
if isempty(sound)
	sound = get_active_sound;
end

if isempty(sound)
	
	str = { ...
		['Could not find a sound with the same name as'], ...
		['the selected log ''', source, '''.'], ...
		['Please select or open the appropriate sound and try again.'] ...
	};

	warn_dialog(str, 'Migration Failed');
	
	log = -1; return;

end

%--
% migrate single log
%--

if exist(source) == 2
	log = migrate_log(source, lib, sound); return;
end

%--
% migrate logs
%--

content = what_ext(source, 'mat'); log = {};

%--
% set total migrate wait ticks if needed
%--

set_migrate_wait_ticks(length(content.mat));

overwrite = 0;

for k = 1:length(content.mat)		
	
	[ignore, result] = migrate_wait('Logs', [], content.mat{k});
	
	if ~isempty(result)
		
		cancel = strcmp(result, 'cancel'); 
		
		if cancel
			break;
		else
			continue;
		end
		
	end

	[log{end + 1}, cancel, overwrite] = migrate_log( ...
		[source, filesep, content.mat{k}], lib, sound, overwrite ...
	);	
	
	if cancel
		break;
	end
	
end

log = [log{:}];


%--------------------------------
% MIGRATE_LOG
%--------------------------------

function [log, cancel, overwrite] = migrate_log(source, lib, sound, overwrite)

if nargin < 4
	overwrite = 0;
end

cancel = 0;

%--
% migrate and update the log
%--

if exist(source) ~= 2
	log = []; return;
end

%--
% update waitbar
%--

[ignore, log_name] = fileparts(source);

migrate_wait('Events', 0, ['Loading "', log_name, '" ...']);

%--
% load old log from file
%--

oldlog = log_load(source);

if isempty(oldlog)
	log = []; return;
end

%--
% prepare waitbar
%--

str = ['Migrating "', log_name, '" (', int2str(length(oldlog.event)), ' events) ...'];

migrate_wait('Events', length(oldlog.event), str);

%--
% get new log file, exit if it exists already
%--

logfile = get_library_log_file(lib, sound, log_name);

if exist(logfile, 'file')
	
	question = { ...
		['The file ', logfile, ' already exists.'], ...
		['Do you want to replace it?'] ...
	};
	
	result = quest_dialog(question,'Replace Log?', 'No', 'Yes', 'All', 'No');
	
	if ismember(result, {'No', ''})
		log = []; migrate_wait('Events', 0, 'Events'); return;
	end
	
	if strcmp(result, 'All')
		overwrite = 1;
	end
		
end

%--
% create new log
%--

log = log_create(logfile, ...
	'sound', sound, ...
	'author', lib.author ...
);

%--
% update events and append them
%--

[events, cancel] = update_event(oldlog.event);

log = log_append(log, events);

%--
% clear waitbar
%--

migrate_wait('Events', 0, 'Events');


