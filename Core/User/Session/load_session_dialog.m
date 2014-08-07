function session = load_session_dialog(user)

% load_session_dialog - allow user to select from available session to load
% -------------------------------------------------------------------------
%
% session = load_session_dialog(user)
%
% Input:
% ------
%  user - user (def: active user)
%
% Output:
% -------
%  session - loaded session

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

%------------------------
% HANDLE INPUT
%------------------------

%--
% set default user
%--

if nargin < 1
	user = get_active_user;
end

%--
% get sessions
%--

names = get_sessions('', user);

% NOTE: there is nothing to load return

if isempty(names)
	session = []; return; 
end

%------------------------
% CREATE DIALOG
%------------------------

%--
% create controls
%--

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', ['Session  (', user.name, ')'] ...
);

control(end + 1) = control_create( ...
	'name', 'name', ... 
	'style', 'popup', ...
	'onload', 1, ...
	'string', names, ...
	'value', 1 ...
);

control(end + 1) = control_create( ...
	'name', 'info', ...
	'style', 'listbox', ...
	'max', 2, ...
	'lines', 3 ...
);

%--
% configure dialog
%--

opt = dialog_group; 

opt.width = 12;

opt.text_menu = 1;

% TODO: consider a helper that gets the parent color and add parent input

opt.header_color = get_extension_color('root');

%--
% present dialog
%--

out = dialog_group('Load ...', control, opt, {@load_session_callback, user});

% NOTE: if dialog was cancelled or aborted return

values = out.values;

if isempty(values)
	session = []; return;
end

%--
% return session
%--

% NOTE: the name value is packed in a cell

session = values.name{1};


%------------------------------------
% LOAD_SESSION_CALLBACK
%------------------------------------

function load_session_callback(obj, eventdata, user)

%--
% get callback context
%--

[control, pal] = get_callback_context(obj);

%--
% handle control by name
%--

switch control.name
	
	case 'name'
		
		%--
		% get session name and info handles
		%--
		
		name = get_control(pal.handle, 'name', 'value');
		
		handles = get_control(pal.handle, 'info', 'handles');

		%--
		% load session and update info control
		%--
		
		session = load_session(name{1}, user);

		% TODO: we really want a session info string function

		set(handles.obj, ...
			'string', session_info_str(session), ...
			'value', [] ...
		);
		
	case 'info'

end



function S = session_info_str(session)

S = cell(0); current = '';

for k = 1:length(session.content)

	element = parse_browser_tag(session.content{k});
	
	if isempty(current) || ~strcmp(current, element.library)
		
		current = element.library; S{end + 1} = current; S{end + 1} = ['    ', element.sound];
	
	else
		
		S{end + 1} = ['    ', element.sound];
		
	end
	
end
