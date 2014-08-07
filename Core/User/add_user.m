function user = add_user(user)

% add_user - add user to system
% -----------------------------
%
% user = add_user(user)
%
% Input:
% ------
%  user - input user structure
%
% Output:
% -------
%  user - user added

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

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% return user of the same name if it exists
%--

if exist_dir(user_root(user))
	
	try
		user = get_users('name', user.name); return;
	catch
		error(['Failed to load user named ''', user.name, ''' which seems to exist.']); 
	end
	
end

%--------------------------------
% ADD USER TO FILE SYSTEM
%--------------------------------	

%--
% create user directories
%--

types = user_root_types;

for type = types
	
	root = create_dir(user_root(user, type));

	if isempty(root)
		error(['Unable to create user ''', title_caps(type), ''' directory.']);
	end
	
end

user_save(user);

%--
% create default library for user
%--

lib = add_library(library_create('Default', user));

if isempty(lib)
	error('Unable to create default user library.');
end

%--
% subscribe user to its default library
%--

% NOTE: this call updates and saves the user to file

user = user_subscribe(lib, user);

%--------------------------------
% UPDATE PALETTE
%--------------------------------

% TODO: consider how to centralize this type of code

%--
% check for palette
%--

pal = get_palette(0, 'XBAT');

if isempty(pal)
	return;
end

% TODO: update this to use 'get' and 'set' functions for controls

%--
% get user control and current user name
%--

control = get_control(pal, 'User');

menu = control.handles.uicontrol.popupmenu;

%--
% get all user names
%--

names = struct_field(get_users, 'name');

% NOTE: put default user on top if available

ix = find(strcmp('Default', names));

if ~isempty(ix)
	names(ix) = []; names = {'Default', names{:}};
end

%--
% update user control
%--

set(menu, 'string', names, 'value', ix);
		

