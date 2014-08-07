function sound_backup(lib,name)

% sound_backup - backup sound from library
% ----------------------------------------
%
% sound_backup(lib,name)
%
% Input:
% ------
%  lib - library containing sound
%  name - name of sound to backup

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
% check for the existence of the backup directory. create if needed
%--

backup_dir = [lib.path, '__BACKUP'];

if (~exist(backup_dir,'dir'))
	mkdir(lib.path,'__BACKUP');
end

% NOTE: block on the directory creation, this may not be needed

while(~exist(backup_dir,'dir'))
	pause(0.1);
end

%--
% zip sound directory backup folder with time stamp
%--

in = [lib.path, name]; % location of sound directory

out = [lib.path, '__BACKUP', filesep, name, ' ', datestr(now,30), '.zip']; % location of backup zip file
	
zip(out,in);
