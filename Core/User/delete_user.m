function delete_user(user)

% delete_user - completely remove user from system
% ------------------------------------------------
% delete_user(user)
%
% Input:
% ------
%  user - user

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
% return early for default user
%--

if strcmp(user.name, 'Default')
	warn_dialog({'You can''t delete the Default user!'}); return;
end

%--
% Find this user in the file system
%--

user_path = user_root(user);

%--
% confirm that we really want to do this
%--

str = {'Are you sure you want to completely', ...
	['remove user "', user.name, '" , with full path: '], ...
	['"' user_path '" ?'] ...
};

answer = quest_dialog(str, 'Confirm Delete');

if ~strcmp(answer, 'Yes')
	return;
end

%--
% unsubscribe user from all non-default libraries
%--

lib = get_libraries(user);

for j = 1:length(lib)
	
	if strcmp(get_library_name(lib(j), user), 'Default')
		continue;
	end

	user_unsubscribe(lib(j), user);
	
end

%--
% backup user
%--

user_backup(user);

%--
% delete directory
%--

rmdir(user_path, 's');

set_active_user(get_active_user);


