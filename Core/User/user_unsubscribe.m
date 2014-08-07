function user = user_unsubscribe(lib,user)

% user_unsubscribe - unsubscribe user to library
% ------------------------------------------
%
% user = user_unsubscribe(lib,user)
%
% Input:
% ------
%  lib - library to unsubscribe
%  user - user to unsubscribe (def: active user)
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

% NOTE: there is significant common code in 'subscribe' and 'unsubscribe'

% TODO: consider refactoring using a 'user_subscription' with 'start' and 'end'

%-------------------------------
% HANDLE INPUT
%-------------------------------

% TODO: allow using name of library

%--
% get active user as default
%--

% NOTE: also compute active user flag to determine whether to update active user

if (nargin < 2)
	user = get_active_user; active = 1;
else
	active = isequal(user, get_active_user);
end

%-------------------------------
% UNSUBSCRIBE FROM LIBRARY
%-------------------------------

% NOTE: return if there is nothing to unsubscribe

if strcmp(get_library_name(lib, user), 'Default')
	warn_dialog({'You can''t unsubscribe from', 'your own Default library!'}, 'Unsubscribe Warning'); 
	return;
end

if isempty(user.library)
	return;
end

%--
% unsubscribe user to library if needed
%--

% NOTE: return if we are already unsubscribed to this library

% if (isempty(get_libraries(user,'path',lib.path)))
% 	return;
% end

%--
% remove library from subscribed libraries
%--

ix = find(strcmp(lib.path, user.library));

if ~isempty(ix)
	user.library(ix) = [];
end

%--
% save user and possibly update active user
%--

user_save(user);

if active
	set_active_user(user);
end

%--
% subtract user name from library
%--

if isfield(lib, 'user')
	
	ix = find(strcmp(user.name, lib.user));

	if ~isempty(ix)
		lib.user(ix) = [];
	end

	library_save(lib);
	
end

%--
% delete shortcut to if needed
%--

% NOTE: this only works on windows

link_file = [user_root(user), filesep, 'Libraries', filesep, lib.name, '.lnk'];

if exist(link_file, 'file')
	delete(link_file);
end
	
	
	
