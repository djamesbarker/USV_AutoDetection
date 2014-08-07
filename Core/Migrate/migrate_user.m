function [user, library, cancel] = migrate_user(source, opt)

% migrate_user - migrate user from source by name
% -----------------------------------------------
%
% [user, library] = migrate_user(name, source)
%
% Input:
% ------
%  name - user name
%  source - user parent root
%  opt - library migrate option
%
% Output:
% -------
%  user - migrated user
%  library - user library cards, we have taken them!

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
% handle input
%--

if nargin < 2
	opt = 1;
end

%--
% update waitbar
%--

[ignore, name] = fileparts(source);

migrate_wait('Users', [], name);

%--
% load user file
%--

file = fullfile(source, [name, '.mat']);

library = [];

if ~exist(file, 'file')
	user = []; return;
end

% NOTE: this load should create the 'user' variable

load(file);

if ~exist('user', 'var')
	user = []; return;
end

%--
% update data structure
%--

user = update_user(user);

%--
% strip libraries and add user
%--

% NOTE: we take the library cards and send the user packing

library = user.library; user.library = {}; 

user = add_user(user);

%--
% optionally migrate user's libraries and subscribe
%--

if ~opt
	return;
end

%--
% set wait ticks if necessary
%--

[sounds, logs] = library_folder_contents(library);

count = numel(library) + numel(sounds) + numel(logs) + 1;

set_migrate_wait_ticks(count);

%--
% migrate user's libraries
%--

[ignore, cancel] = migrate_libraries(library, user);

