function info = save_session_dialog(user)

% save_session_dialog - dialog to save session
% -------------------------------------------
%
% info = save_session_dialog(user)
%
% Input:
% ------
%  user - session user
%
% Output:
% -------
%  info - session file info

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

%----------------------------------
% CREATE CONTROLS
%----------------------------------

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', ['Session  (', user.name, ')'] ...
);

control(end + 1) = control_create( ...
	'name', 'name', ...
	'space', 1, ...
	'onload', 1, ...
	'style', 'edit' ...
);

%----------------------------------
% CREATE DIALOG
%----------------------------------

%--
% configure dialog options
%--

opt = dialog_group;

opt.width = 12;

opt.header_color = get_extension_color('root');

opt.text_menu = 1;

name = 'Save ...';

%--
% create dialog
%--

out = dialog_group(name, control, opt, @save_session_callback);

if isempty(out.values)
	info = []; return;
end

%--
% save session to file
%--

info = save_session(out.values.name, user);


%-------------------------------------
% SAVE_SESSION_CALLBACK
%-------------------------------------

function save_session_callback(obj, eventdata)

[control, pal] = get_callback_context(obj);

switch control.name
	
	case 'name'
		set_control(pal.handle, 'OK', 'enable', proper_filename(get(obj, 'string')));
		
end
