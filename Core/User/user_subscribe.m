function user = user_subscribe(lib, user)

% user_subscribe - subscribe user to library
% ------------------------------------------
%
% user = user_subscribe(lib, user)
%
% Input:
% ------
%  lib - library to subscribe to
%  user - user to subscribe (def: active user)
%
% Output:
% -------
%  user - updated user

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
% $Revision: 1632 $
% $Date: 2005-08-23 13:09:06 -0400 (Tue, 23 Aug 2005) $
%--------------------------------

%-------------------------------
% HANDLE INPUT
%-------------------------------

% TODO: allow using library name

%--
% get active user as default
%--

% NOTE: also compute active user flag to determine whether to update active user

if (nargin < 2)
	user = get_active_user; active = 1;
else
	current = get_active_user; active = strcmp(current.name, user.name);
end

%--
% dialog by default
%--

if ~nargin
	user_subscribe_dialog(user); return;
end

if isempty(lib)
	return;
end

%--
% subscribe to library(ies)
%--

for k = 1:length(lib)
	user = subscribe_user(lib(k), user);
end

%--
% save user and possibly update active user
%--

user_save(user);

if active
	set_active_user(user);
end

set_active_library(lib, user);


%-----------------------------------
% SUBSCRIBE_USER
%-----------------------------------

function user = subscribe_user(lib, user)
	
%--
% subscribe user to library, this updates the user
%--

if isempty(user.library)

	user.library{end + 1} = lib.path; user.default = 1; user.active = 1;

else

	if isempty(get_libraries(user, 'path', lib.path))
		user.library{end + 1} = lib.path;
	end

end

%--
% add user to library, this updates the library
%--

if ~ismember(user.name, lib.user)
	lib.user{end + 1} = user.name;
end

library_save(lib);

%--
% create shortcut to libraries not in libraries directory
%--

libs_path = [user_root(user), filesep, 'Libraries'];

if ~strncmp(libs_path, lib.path, length(libs_path))

	create_shortcut(lib.path, libs_path, lib.name);

end
	
