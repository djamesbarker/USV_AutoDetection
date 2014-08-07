function library_menu(par, user)

% library_menu - create menu for user librarys
% --------------------------------------------
%
% library_menu(par, user)
%
% Input:
% ------
%  par - menu parent
%  user - user (def: active user)

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

if nargin < 2
	user = get_active_user; 
end

%----------------------
% SETUP
%----------------------

%--
% clear former menu if needed
%--

top = findobj(par, 'type', 'uimenu', 'tag', 'TOP_LIBRARY_MENU');

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
	top = uimenu(par, 'label', 'Session', 'tag', 'TOP_LIBRARY_MENU');
end 

%--
% create command menus
%--

uimenu(top, ...
	'label', 'New ...', ...
	'callback', {@new_library_callback, par, user} ...
);

uimenu(top, ...
	'label', 'Add ...', ...
	'callback', {@add_library_callback, user} ...
);

uimenu(top, ...
	'label', 'Edit ...', ...
	'callback', {@edit_library_callback, user} ...
);

%--
% create library menus
%--

names = library_name_list(user); 

if isempty(names)
	
	% NOTE: this should not happen
	
	uimenu(top, ...
		'label', '(No Libraries Found)', ... 
		'enable', 'off', ...
		'separator', 'on' ...
	);

else

	named = [];

	for k = 1:length(names)
		named(end + 1) = uimenu(top, ...
			'label', names{k}, ...
			'callback', {@set_active_library_callback, user} ...
		);
	end

	set(named(1), 'separator', 'on');
	
	uimenu(top, ...
		'label', 'Show Files ...', ...
		'separator', 'on', ...
		'callback', {@show_files_callback, user} ...
	);

end


%--------------------------------------
% NEW_LIBRARY_CALLBACK
%--------------------------------------

function new_library_callback(obj, eventdata)

new_library_dialog;


%--------------------------------------
% ADD_LIBRARY_CALLBACK
%--------------------------------------

function new_library_callback(obj, eventdata)

user_subscribe_dialog;


%--------------------------------------
% EDIT_LIBRARY_CALLBACK
%--------------------------------------

function new_library_callback(obj, eventdata)

edit_library_dialog;


%--------------------------------------
% SAVE_LIBRARY_CALLBACK
%--------------------------------------

function save_library_callback(obj, eventdata, par, user)

%--
% present dialog to save library
%--

info = save_library_dialog(user);

% NOTE: return if no library was saved

if isempty(info)
	return;
end 

%--
% rebuild library menu
%--

library_menu(par, user);


%--------------------------------------
% SET_ACTIVE_LIBRARY_CALLBACK
%--------------------------------------

function set_active_library_callback(obj, eventdata, user)

% TODO: this is not implemented, it is hidden in 'xbat_palette'

% lib = get_libraries(user, 'name', get(obj, 'label'));
% 
% if isempty(lib)
% 	return;
% end 
% 
% set_active_library(lib, user);


%--------------------------------------
% SHOW_FILES_CALLBACK
%--------------------------------------

function show_files_callback(obj, eventdata, user)

lib = get_active_library;

show_file(lib.path);




