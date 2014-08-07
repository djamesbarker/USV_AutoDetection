function session_menu(par, user)

% session_menu - create menu for user sessions
% --------------------------------------------
%
% session_menu(par, user)
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

top = findobj(par, 'type', 'uimenu', 'tag', 'TOP_SESSION_MENU');

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
	top = uimenu(par, 'label', 'Session', 'tag', 'TOP_SESSION_MENU');
end 

%--
% create command menus
%--

uimenu(top, ...
	'label', 'Save ...', ...
	'callback', {@save_session_callback, par, user} ...
);

uimenu(top, ...
	'label', 'Load ...', ...
	'callback', {@load_session_callback, user} ...
);

%--
% create session menus
%--

names = get_sessions('', user); 

if isempty(names)
	
	uimenu(top, ...
		'label', '(No Sessions Found)', ... 
		'enable', 'off', ...
		'separator', 'on' ...
	);

else

	uimenu(top, ...
		'label', '(Sessions)', ...
		'separator', 'on', ...
		'enable', 'off' ...
	);

	named = [];

	for k = 1:length(names)
		named(end + 1) = uimenu(top, ...
			'label', names{k}, ...
			'callback', {@open_session_callback, par, user} ...
		);
	end

% 	set(named(1), 'separator', 'on');

end

uimenu(top, ...
	'label', 'Refresh', ...
	'separator', 'on', ...
	'callback', {@refresh_menu_callback, par, user} ...
);

uimenu(top, ...
	'label', 'Show Files ...', ...
	'separator', 'off', ...
	'callback', {@show_files_callback, user} ...
);


% NOTE: consider having a single 'session_dialog' with save and load modes

%--------------------------------------
% SAVE_SESSION_CALLBACK
%--------------------------------------

function save_session_callback(obj, eventdata, par, user)

%--
% present dialog to save session
%--

info = save_session_dialog(user);

% NOTE: return if no session was saved

if isempty(info)
	return;
end 

%--
% rebuild session menu
%--

session_menu(par, user);


%--------------------------------------
% LOAD_SESSION_CALLBACK
%--------------------------------------

function load_session_callback(obj, eventdata, user)

session = load_session_dialog(user);

if ~isempty(session)
	open_session(session, user);
end


%--------------------------------------
% OPEN_SESSION_CALLBACK
%--------------------------------------

function open_session_callback(obj, eventdata, par, user)

opened = open_session(get(obj, 'label'), user);

if isempty(opened)
	session_menu(par, user);
end


%--------------------------------------
% REFRESH_MENU_CALLBACK
%--------------------------------------

function refresh_menu_callback(obj, eventdata, par, user)

session_menu(par, user);


%--------------------------------------
% SHOW_FILES_CALLBACK
%--------------------------------------

function show_files_callback(obj, eventdata, user)

show_file(sessions_root(user));



