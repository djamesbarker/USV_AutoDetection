function file = log_backup(log)

% log_backup - create backup log
% ------------------------------
%
% file = log_backup(log)
%
% Input:
% ------
%  log - log to backup
%
% Output:
% -------
%  file - log backup file

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
% $Revision: 1421 $
% $Date: 2005-08-01 17:03:23 -0400 (Mon, 01 Aug 2005) $
%-------------------------------- 

% TODO: possibly offer the option to copy work somewhere else

%-------------------------------------
% HANDLE INPUT
%-------------------------------------

%--
% check that log to backup exists
%--

log_file = [log.path, log.file];

if ~exist(log_file,'file')
	error(['Unable to find log file ''', log.file, '''.']);
end
	
%-------------------------------------
% BACKUP
%-------------------------------------
	
%--
% get backup directory
%--

backup = create_dir([log.path, '__BACKUP']);

if isempty(backup)
	error('Unable to create backup directory.');
end

%--
% create time stamped backup copy 
%--

% NOTE: we may consider compression when the file format is not 'mat'

name = file_ext(log.file);

file = [backup, filesep, name, ' ', datestr(now,30), '.mat'];

copyfile(log_file, file);

%-------------------------------------
% CLEAN UP BACKUP
%-------------------------------------

%--
% remove older backup copies
%--

files = dir(backup);

files = files(3:end);

files = struct_field(files,'name');

% NOTE: remove stamp and extension for testing

for k = 1:length(files)
	test{k} = files{k}(1:end - 20);
end

ix = strcmp(test,name);

% NOTE: number of backup files is hard coded here

N = 12;

if (length(ix) > N);

	% NOTE: files are sorted and the time stamp format implies older logs are first

	files = files(ix); 
	
	files = files(1:(length(files) - N));

	for k = 1:length(files)
		delete([backup, filesep, files{k}]);
	end

end
