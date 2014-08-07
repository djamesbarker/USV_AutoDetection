function [root, status, result] = local_repository(root)

% local_repository - create local subversion repository
% -----------------------------------------------------
%
% [root, status, result] = local_repository(root)
%
% Input:
% ------
%  root - for repository
%
% Output:
% -------
%  root - of repository
%  status - of system call
%  result - of system call

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

% TODO: add options from 'svnadmin.exe'

%---------------
% HANDLE INPUT
%---------------

%--
% get root interactively if needed
%--

if ~nargin
	
	% NOTE: start path is not valid, we start at 'base' path
	
	root = uigetdir('/\', 'Select Repository Root');
	
	if ~ischar(root)
		root = ''; status = []; result = 'Cancelled'; return;
	end 
	
end

%---------------
% SETUP
%---------------

%--
% check that we can in fact have a root for the repository
%--

root = create_dir(root);

if isempty(root)
	return;
end

%--
% get tool to create repository
%--

tool = get_tool('svnadmin.exe'); 

% NOTE: if we cannot manage our repository we have no repository

if isempty(tool)
	root = '';
end

%---------------
% CREATE REPO
%---------------

%--
% create or verify local repository
%--

% NOTE: the two elements are '.' and '..'

if length(dir(root)) == 2
	[status, result] = system(['"', tool.file, '" create "', root, '"']);	
else	
	[status, result] = system(['"', tool.file, '" verify "', root, '"']);	
end

% NOTE: if repository create or verify failed we have no local repository

if status
	root = '';
end

%--
% update local repositories file if needed
%--

if isempty(root)
	return;
end 

update_repositories(root);


%----------------------------------
% UPDATE_REPOSITORIES
%----------------------------------

function repo = update_repositories(root)

% NOTE: this is not DRY, it is repeated in 'get_repositories'

file = [fileparts(which('svn')), filesep, 'repositories.txt'];

if exist(file, 'file')
	repo = file_readlines(file); repo = union(repo, root);
else
	repo = {root};
end

file_writelines(file, repo);
