function logs = get_library_logs(mode, lib, sounds, name)

% get_library_logs - get available logs in a library
% --------------------------------------------------
%
% logs = get_library_logs('info', lib, sounds, name)
%
%      = get_library_logs('file', lib, sounds, name)
%
%      = get_library_logs('logs', lib, sounds, name)
%
% Input:
% ------
%  lib - library (def: active library)
%  sounds - selected sounds or names from library
%  name - log name
%
% Output:
% -------
%  logs - mode dependent output

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2284 $
% $Date: 2005-12-14 18:31:07 -0500 (Wed, 14 Dec 2005) $
%--------------------------------

% TODO: add 'info_str' mode, eventually store such summary in log file

%---------------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------------

%--
% set default empty name string
%--

if nargin < 4
	name = [];
end

%--
% set default library to active library
%--

if (nargin < 2) || isempty(lib)
	lib = get_active_library; 
end

%--
% set default selected sounds to all available
%--

if (nargin < 3) || isempty(sounds)
	
	% NOTE: get names of all sounds in library
	
	sounds = sound_name(get_library_sounds(lib));
	
else
	
	% NOTE: convert sounds to names
	
	if isstruct(sounds)
		sounds = sound_name(sounds);
	end	
	
	% TODO: check that input is sounds or names and 
	
	sounds = sound_name(get_library_sounds(lib, 'name', sounds));
	
end

% NOTE: return quickly if there are no sounds

if isempty(sounds)
	logs = []; return;
end

%--
% set default mode
%--

if (nargin < 1) || isempty(mode)

	mode = 'info';

else
	
	mode = lower(mode);

	if (isempty(find(strcmp(mode,{'info','file','logs'}))))
		error('Unrecognized output mode.');
	end

end

%---------------------------------------------------------
% GET SOUND LOGS
%---------------------------------------------------------

%--
% put single string sound in cell
%--

if ischar(sounds)
	sounds = {sounds};
end

%--
% trim compound names
%--

ix = strfind(name, filesep);

if ix   
    name = name(ix + 1:end);
end

%--
% get logs from all sounds
%--

logs = {};

for k = 1:length(sounds)
	
	%--
	% get logs with this parent sound
	%--
	
	p = [lib.path, sounds{k}, filesep, 'Logs'];
	
	% NOTE: generate logs directory if needed, this includes the backup
	
	if ~exist(p, 'dir')			
		mkdir([lib.path, sounds{k}], 'Logs'); mkdir(p, '__BACKUP');	
	end
	
	f = file_ext(get_field(what(p),'mat'));
	
	%--
	% search for the requested name
	%--
	
	if ~isempty(name)
		f = intersect(f, name);
    end
    
    %--
    % Strip out uigetfile2 file
    %--
    
    f(strncmp(f, 'lastUsedDir', 11)) = [];
	
	%--
	% append sound logs to list of library logs
	%--
	
	if isempty(f)
		continue;
	end
		
	% NOTE: prefix log names with sound name (this aspect is quirky)

	f = strcat(sounds{k}, filesep, f); 

	logs = {logs{:}, f{:}};
		
end

if isempty(logs)
	logs = []; return;
end

%--
% stretch and sort log info
%--

logs = sort(logs(:));

%--
% get file names if needed
%--

if ~strcmpi(mode,'info')

	% NOTE: this step depends on the library storage convention and above code

	logs = strrep(logs,filesep,[filesep, 'Logs', filesep]);

	logs = strcat(lib.path,logs,'.mat');
	
end

%--
% get logs if needed
%--

% TODO: make robust to load log failures

if strcmpi(mode,'logs')
	
	files = logs; clear logs;
	
	for k = 1:length(files)
		logs(k) = log_load(files{k});
	end
	
end
	
	
