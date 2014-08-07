function [lib, cancel] = migrate_library(source, user)

% migrate_library - migrate library to current version
% ----------------------------------------------------
%
% lib = migrate_library(source, user)
%
% Input:
% ------
%  source - source library directory
%  user - the user that will get the library
%
% Output:
% -------
%  lib - library

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

cancel = 0;

%--
% get user if needed
%--

% NOTE: the user helps locate the library, also someone should subscribe

if nargin < 2 || isempty(user)
	user = get_active_user;
end

%--
% get source library file
%--

lib = [];

if source(end) == filesep
	source(end) = '';
end

[root, name] = fileparts(source); file = get_library_file(root, name);

%--
% update waitbar
%--

[ignore, result] = migrate_wait('Libraries', [], name);

if ~isempty(result)
	cancel = strcmp(result, 'cancel'); return;
end

% NOTE: the library source is bogus, we can't find the library file

if ~exist(file, 'file')
	disp(['non-existant library file "', file, '"']); return;
end

%--
% load library file and check for 'lib' variable
%--

load(file);

if ~exist('lib', 'var')
	lib = []; 'bad library file', return;
end

%--
% update data structure
%--

lib = struct_update(library_create, lib);

%--
% deal with library patrons past, present, and future
%--

user_names = user_name_list;

% NOTE: library author no longer exists, give 'Default' authorship

if ~ismember(lib.author, user_names)
	lib.author = 'Default';
end

for k = length(lib.user):-1:1
	
	% NOTE: library user no longer exists, remove from record
	
	if ~ismember(lib.user{k}, user_names)
		lib.user(k) = [];
	end
	
end

%--
% update path
%--

lib.path = [user_root(lib.author, 'lib'), filesep, lib.name, filesep];

%--
% subscribe user to library
%--

[root, created] = create_dir(lib.path);

if isempty(root)
	error('Unable to create library root directory.');
end

author = get_users('name', lib.author); user = get_users('name', user.name);

% NOTE: this saves library file

user_subscribe(lib, author);

user_subscribe(lib, user);

%--
% migrate sounds to the created library
%--

% NOTE: this is not the best test

if ~created && ~strcmp(dir_name(root), 'Default')
	return;
end

count = numel(library_folder_contents(source));

set_migrate_wait_ticks(count);

migrate_sounds(source, lib);
