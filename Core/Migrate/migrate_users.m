function [users, cancel] = migrate_users(source)

% migrate_users - migrate users from previous version
% ---------------------------------------------------
% 
% users = migrate_users(source)
% 
% Input:
% ------
%  source - migration source
%
% Output:
% -------
%  users - migrated users

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
% get source users root
%--

root = users_root(source, 0);

if isempty(root)
	users = []; return;
end

%--
% migrate users
%--

users = {}; library = {};

names = get_folder_names(root);

if ~length(names)
	users = []; return;
end

migrate_wait('Users', length(names), names{1});

for k = 1:length(names)
	
	[users{end + 1}, library{end + 1}, cancel] = migrate_user(fullfile(root, names{k}), 0);
	
	if cancel
		break;
	end
	
end

%--
% update progress waitbar
%--

libs = {};

for k = 1:numel(library)
	libs = {libs, library{k}{:}};
end

libs{:}

[sounds, logs] = library_folder_contents(libs);

count = numel(users) + numel(libs) + numel(sounds) + numel(logs);

set_migrate_wait_ticks(count);

%--
% migrate libraries and re-subscribe
%--

for k = 1:length(users)
	
	library{k}
	
	[ignore, cancel] = migrate_libraries(library{k}, users{k});
	
	if cancel
		break;
	end
	
end



