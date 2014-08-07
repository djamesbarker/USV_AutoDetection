function user_menu(par)

% user_menu - create users menu
% -----------------------------
%
% user_menu(par)
%
% Input:
% ------
%  par - menu parent

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

% NOTE: consider using a single 'File' menu on the XBAT palette

%----------------------
% HANDLE INPUT
%----------------------

%----------------------
% SETUP
%----------------------

%--
% clear former menu if needed
%--

top = findobj(par, 'type', 'uimenu', 'tag', 'TOP_USER_MENU');

if ~isempty(top)
	delete(allchild(top));
end

%----------------------
% CREATE MENUS
%----------------------

%--
% create top menu if needed
%--

if isempty(top)
	top = uimenu(par, 'label', 'User', 'tag', 'TOP_USER_MENU');
end 

%--
% get users and active user
%--

users = get_users; names = {users.name}; active = get_active_user;

%--
% create command menus
%--

uimenu(top, ...
	'label', 'New ...', ...
	'callback', @new_user_callback ...
);

if strcmpi(active.name, 'default')
	
	uimenu(top, 'enable', 'off', 'label', 'Edit ...');

else
	uimenu(top, ...
		'label', 'Edit ...', ...
		'callback', @edit_active_user_callback ...
	);
end

%--
% create user menus
%--

if isempty(names)
	
	% NOTE: this should never happen, there is always a default user
	
	uimenu(top, ...
		'label', '(No Users Found)', ... 
		'enable', 'off', ...
		'separator', 'on' ...
	);

else

	uimenu(top, ...
		'label', '(Users)', ...
		'separator', 'on', ...
		'enable', 'off' ...
	);

	named = [];

	for k = 1:length(names)
		
		named(end + 1) = uimenu(top, ...
			'label', names{k}, ...
			'check', bin2str(strcmp(names{k}, active.name)), ...
			'callback', @set_active_user_callback ...
		);
	
	end

% 	set(named(1), 'separator', 'on');

end

uimenu(top, ...
	'label', 'Refresh', ...
	'separator', 'on', ...
	'callback', {@refresh_menu_callback, par} ...
);

uimenu(top, ...
	'label', 'Show Files ...', ...
	'separator', 'off', ...
	'callback', @show_files_callback ...
);


%--------------------------------------
% NEW_USER_CALLBACK
%--------------------------------------

function new_user_callback(obj, eventdata)

%--
% create new user
%--

user = new_user_dialog;

%--
% rebuild user menu if needed
%--

% NOTE: this may not be needed

if ~isempty(user)
	user_menu(ancestor(obj, 'figure'));
end


%--------------------------------------
% EDIT_USER_CALLBACK
%--------------------------------------

function edit_active_user_callback(obj, eventdata)

new_user_dialog(get_active_user);


%--------------------------------------
% SET_ACTIVE_USER_CALLBACK
%--------------------------------------

function set_active_user_callback(obj, eventdata)

%--
% get user by name
%--

user = get_users('name', get(obj, 'label'));

% TODO: this should refresh the user list

if isempty(user)
	return;
end

%--
% set user as active user
%---

set_active_user(user);


%--------------------------------------
% REFRESH_MENU_CALLBACK
%--------------------------------------

function refresh_menu_callback(obj, eventdata, par)

user_menu(par);


%--------------------------------------
% SHOW_FILES_CALLBACK
%--------------------------------------

function show_files_callback(obj, eventdata)

show_file(users_root);



