function [lib, user] = library_relocate(user, old_path, new_path)

% library_relocate - change library path
% --------------------------------------
%
% [lib, user] = library_relocate(user, old_path, new_path)
%
% Input:
% ------
%  user - the user
%  old_path - where the library used to be
%  new_path - where the library is
%
% Output:
% -------
%  lib - the relocated library
%  user - the updated user

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

lib = [];

active = isequal(user, get_active_user);

%--
% if new path is not provided, we need to look
%--

if nargin < 3
	
	new_path = uigetdir(pwd, 'Select location of library.');
	
	if ~new_path
		return;
	end

end

%--
% return for empty new path
%--

if isempty(new_path)
	return;
end

%--
% make sure network attached path is refreshed
%--

% NOTE: according to the mathworks, this may solve the "Could not get
% change notification handle" problem.

% path(path);

%----------------------
% UPDATE LIBRARY
%----------------------

%--
% try to load library from new location
%--

[root, name] = path_parts(new_path); file = get_library_file(root, name);

lib = load_library(file); 

if isempty(lib)
    warning('XBAT:libraryRelocateFailure','failed to load re-located library file'); return;
end

%--
% update library path and save
%--

lib.path = [new_path, filesep]; 

library_save(lib);

%-----------------------------
% UPDATE USER
%-----------------------------

ix = find(strcmp(old_path, user.library));

user.library{ix} = lib.path;

user_save(user);

if active
	set_env('xbat_user', user);
end




