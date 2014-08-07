function [lib,out] = update_library(lib,tasks)

% update_library - perform library maintenance tasks
% --------------------------------------------------
%
% [lib,out] = update_library(lib,tasks)
%
% Input:
% ------
%  lib - library to perform task on
%  tasks - tasks to be performed (similar to 'scan_dir' callback)
%
% Output:
% -------
%  lib - updated library
%  out - task execution related, not determined

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
% $Revision: 1161 $
% $Date: 2005-07-05 16:25:08 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

% NOTE: this code should look like and converge with the action code

%------------------------------------------------
% HANDLE INPUT
%------------------------------------------------

%--
% set default library
%--

if ((nargin < 1) || isempty(lib))
	lib = get_active_library;
end

if (isempty(lib))
	error('Library input is required.');
end

%--
% set default tasks to all
%--

if (nargin < 2)
	tasks = 'all';
end

if (isempty(tasks))
	return;
end

%--
% handle multiple libraries recursively
%--

if (numel(lib) > 1)

	for k = 1:numel(lib)
		update_library(lib(k),tasks);
	end

	return;

end 

%------------------------------------------------
% GET TASKS
%------------------------------------------------

switch (class(tasks))
	
	%--
	% get all or single task by name
	%--
	
	case ('char')
		
		if (strcmp(tasks,'all'))
			tasks = get_task;
		else
			tasks = get_task(tasks);
		end
		
	%--
	% get multiple tasks by name, check for 'all'
	%--

	case ('cell')
		
		if (iscellstr(tasks))
			
			if (ismember('all',tasks))
				tasks = get_task;
			else
				names = tasks; tasks = cell(0);
				for k = 1:length(names)
					tasks{k} = get_task(names{k});
				end
			end
			
		end
		
end
	
if (isempty(tasks))
	return;
end

%------------------------------------------------
% PERFORM TASKS
%------------------------------------------------

for task = tasks
	
	switch (class(task))
		
		case ('function_handle') 
			task(lib);
			
		case ('cell')
			param = task(2:end); task = task{1}; task(lib,param{:});
			
	end
	
end


%------------------------------------------------
% GET_TASKS
%------------------------------------------------

function task = get_task(name)

% TODO: determine how tasks are stored and retrieved






% TODO: call the log update function from here

% TODO: add library fields containing summary information

% NOTE: implement 'backup_rename','clear_backup_files' ...

%------------------------------------------------
% PERFORM TASK
%------------------------------------------------
	
% NOTE: available tasks should perhaps be more dynamic

switch (task)
	
	% NOTE: not all tasks will consist of simple calls to 'scan_dir'
	
	case ('backup_rename')

		% NOTE: renames backup directories
		
		out = scan_dir(lib.path,{@dir_rename,'Backup','__BACKUP'});

	case ('clear_backup_files')
		
		% NOTE: delete backup zip files
		
		out = scan_dir(lib.path,@clear_backup_files);
end


%------------------------------------------------
% BACKUP_RENAME
%------------------------------------------------

function out = dir_rename(p,n1,n2)

% dir_rename - rename a specifically named directory
% --------------------------------------------------
%
% out = backup_rename(p,n1,n2)
%
% Input:
% ------
%  p - directory
%  n1 - initial name
%  n2 - final name
%
% Output:
% -------
%  out - not yet determined

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1161 $
% $Date: 2005-07-05 16:25:08 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

% TODO: put some task related information here

out = [];

%--
% split directory into parent and leaf (current directory)
%--

[p1,d1] = path_parts(p);

%--
% check for directory with initial name, copy to new name, and delete
%--

% TODO: consider ways of protecting integrity, look at 'copyfile' output

if (strcmp(d1,n1))

	copyfile(p,[p1, filesep, n2]);
	
	rmdir(p,'s'); % NOTE: this is a dangerous command
	
end
	

%------------------------------------------------
% CLEAR_BACKUP_FILES
%------------------------------------------------

function out = clear_backup_files(p)

% clear_backup_files - remove files from backup directories
% ---------------------------------------------------------
%
% out = clear_backup_files(p)
%
% Input:
% ------
%  p - directory
%
% Output:
% -------
%  out - not yet determined

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1161 $
% $Date: 2005-07-05 16:25:08 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

% TODO: put some task related information here

out = [];

%--
% split directory into parent and leaf (current directory)
%--

[p1,d1] = path_parts(p);

%--
% check for directory with initial name, copy to new name, and delete
%--

% TODO: consider ways of protecting integrity, look at 'copyfile' output

if (strcmp(d1,n1))

	copyfile(p,[p1, filesep, n2]);
	
	rmdir(p,'s'); % NOTE: this is a dangerous command
	
end
