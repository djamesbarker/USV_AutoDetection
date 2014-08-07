function files = users_root_update

% users_root_update - update users to tolerate root update
% --------------------------------------------------------
%
% files = users_root_update
%
% Output:
% -------
%  files - user files updated

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

% TODO: consider allowing for 'move' and 'rename'

%--
% get user files
%--

users = get_folder_names(users_root); files = {};

for k = 1:length(users)
	files{end + 1} = get_user_file(users{k});
end

files = files(:);

%--
% update user library references
%--

root = xbat_root;

for k = 1:length(files)
	
	load(files{k});
	
	for j = 1:length(user.library)
		user.library{j} = replace_root(user.library{j}, root);
	end
	
	save(files{k}, 'user');
	
end


function str = replace_root(str, root)

[root, name] = fileparts(root);

ix = strfind(str, [filesep, name, filesep]);

if isempty(ix)
	return;
end

ix = ix(end);

% NOTE: this is to handle the library path filesep issues

str = fullfile(root, str(ix:end));

