function user = new_user_dialog(user)

% new_user_dialog - dialog to create new users
% --------------------------------------------
%
% user = new_user_dialog(user)
%
% Input:
% ------
%  user - user to edit
%
% Output:
% -------
%  user - new user created

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
% $Revision: 1161 $
% $Date: 2005-07-05 16:25:08 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set new user state
%--

if ~nargin
	new = 1; active = 0;
else
	new = 0; active = isequal(user, get_active_user);
end

%----------------------------------
% CREATE CONTROLS
%----------------------------------

control = empty(control_create);

%-----------------
% INFO
%-----------------

if ~new
	str = ['User  (', user.name, ')'];
else
	str = 'User';
end

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'space', 0.1, ...
	'string', str ...
);


tabs = {'Info', 'Prefs', 'Libraries'};

if new
	tabs = setdiff(tabs, {'Libraries'});
end

control(end + 1) = control_create( ...
	'style','tabs', ...
	'name','Tabz', ...
	'tab',tabs ...
);

%--
% name
%--

control(end + 1) = control_create( ...
	'name', 'name', ...
	'space', 1, ...
	'onload', 1, ...
	'space', 0.75, ...
	'style', 'edit', ...
	'tab', tabs{1}, ...
	'type', 'filename' ...
);

if ~new
	control(end).string = user.name; control(end).initialstate = '__DISABLE__';
end

% %--
% % organization
% %--
% 
% control(end + 1) = control_create( ...
% 	'name', 'organization', ...
% 	'space', 1, ...
% 	'style', 'edit' ...
% );
% 
% if ~new
% 	control(end).string = user.organization;
% end

%--
% email and url
%--

control(end + 1) = control_create( ...
	'name', 'email', ...
	'space', 0.75, ...
	'tab', tabs{1}, ...
	'style', 'edit' ...
);

if ~new
	control(end).string = user.email;
end

control(end + 1) = control_create( ...
	'name', 'url', ...
	'alias', 'URL', ...
	'space', 0.75, ...
	'tab', tabs{1}, ...
	'style', 'edit' ...
);

if ~new
	control(end).string = user.url;
end

control(end).space = 1.5;

%--------------------------
% PREFERENCES
%--------------------------

control(end + 1) = control_create( ...
	'style', 'checkbox', ...
	'name', 'developer', ...
	'tab', tabs{2} ...
);

control(end + 1) = control_create( ...
	'style', 'checkbox', ...
	'name', 'palette_sounds', ...
	'tab', tabs{2} ...
);

control(end + 1) = control_create( ...
	'style', 'checkbox', ...
	'name', 'palette_tooltips', ...
	'tab', tabs{2} ...
);

%--------------------------
% LIBRARIES
%--------------------------

if ~new

	control(end + 1) = control_create( ...
		'name', 'available_libraries', ...
		'style', 'listbox', ...
		'lines', 3, ...
		'string', library_name_list(get_users, 'full'), ...
		'value', [], ...
		'onload', 1, ...
		'tab', tabs{3}, ...
		'min', 1, ...
		'max', 3 ...
	);

	control(end + 1) = control_create( ...
		'style', 'buttongroup', ...
		'name', {'add', 'rem', 'locate ...'}, ...
		'tab', tabs{3}, ...
		'lines', 1.5 ...
	);

	control(end + 1) = control_create( ...
		'name', 'user_libraries', ...
		'style', 'listbox', ...
		'string', library_name_list(user), ...
		'value', [], ...
		'tab', tabs{3}, ...
		'lines', 3, ...
		'min', 1, ...
		'max', 3 ...
	);

end

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

%--
% create dialog
%--

if new
	name = 'New ...';
else 
	name = 'Edit ...';
end

try
out = dialog_group(name, control, opt, @new_user_callback);
catch
	nice_catch(lasterror);
end


% NOTE: return empty on cancel

if isempty(out.values)
	user = []; return;
end

%----------------------------------
% CREATE AND SUBSCRIBE USER
%----------------------------------

values = out.values;

%--
% create and add user
%--

if new
	
	user = struct_update(user_create, values);
	
	% NOTE: this creates the default user library and subscribes the user to it

	user = add_user(user);
	
	return;
	
end
	
user = struct_update(get_active_user, values); 

% user_save(user);

%----------------------------------
% NEW_USER_CALLBACK
%----------------------------------

function new_user_callback(obj, eventdata)

%--
% get callback context
%--

[control, pal] = get_callback_context(obj);

%--
% disable the OK button
%--

set_control(pal.handle, 'OK', 'enable', 0);

%--
% get lists
%--

available = get_control(pal.handle, 'available_libraries', 'value');

subscribed = get_control(pal.handle, 'user_libraries', 'value');

%--
% toggle button enabled-ness
%--

set_control(pal.handle, 'add', 'enable', ~isempty(available));

set_control(pal.handle, 'rem', 'enable', ~isempty(subscribed));

%--
% process callback request
%--

switch control.name
		
	%--
	% add (subscribe to) library
	%--
	
	case 'add'
		
		for k = 1:length(available)
			user_subscribe(get_library_from_name(available{k}));
		end

		han = get_control(pal.handle, 'user_libraries', 'handles');

		set(han.obj, ...
			'string', library_name_list(get_active_user), 'value', [] ...
		);			
		
	%--
	% remove (unsubscribe from) library
	%--		
		
	case 'rem'
		
		for k = 1:length(subscribed)
			user_unsubscribe(get_library_from_name(subscribed{k}));	
		end	
	
		han = get_control(pal.handle, 'user_libraries', 'handles');

		set(han.obj, ...
			'string', library_name_list(get_active_user), 'value', [] ...
		);			
	
	%--
	% locate library
	%--
		
	case 'locate ...'
		
		%--
		% look for library starting in this user's root
		%--
		
		user = get_active_user;
		
		di = pwd; cd(user_root(user, 'lib'));
		
		[lib_file, lib_path] = uigetfile2( ...
			{'*.mat', 'MAT-files (*.mat)'}, ...
			'Please select an existing library file.' ...
		);
		
		cd(di);

		if isnumeric(lib_file) || ~is_library(lib_path, lib_file) 
			set_control(pal.handle, 'OK', 'enable', 1); return;
		end
		
		%--
		% get library
		%--
			
		lib = load_library(fullfile(lib_path, lib_file));
		
		%--
		% subscribe user to library if needed
		%--
		
		user_subscribe(lib, get_active_user);	
		
		%--
		% update available libraries control
		%--		
	
		han = get_control(pal.handle, 'available_libraries', 'handles');
		
		set(han.obj, ...
			'string', library_name_list(get_users), 'value', [] ...
		);		
	
		han = get_control(pal.handle, 'user_libraries', 'handles');

		set(han.obj, ...
			'string', library_name_list(get_active_user), 'value', [] ...
		);	
			
end

%--
% re-enable OK button
%--

set_control(pal.handle, 'OK', 'enable', 1);

%-------------------------------------------
% IS_LIBRARY
%-------------------------------------------

function out = is_library(path, file)

out = 0;

fullfile = [path, file];

contents = load(fullfile, 'lib');

if ~isfield(contents, 'lib')
	return
end

lib = contents.lib;

if ~isequal(fieldnames(library_create), fieldnames(lib));
	return
end

out = 1;

