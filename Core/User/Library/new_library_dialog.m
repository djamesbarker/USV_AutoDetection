function lib = new_library_dialog(user)

if nargin < 1 || isempty(user)
	user = get_active_user;
end

%--
% dialog header
%--

control(1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', ['Library  (', user.name ')'] ...
);

%--
% user name
%--

% NOTE: the number of lines along with the dialog group options produce a square

control(end + 1) = control_create( ...
	'name', 'name', ...
	'space', 0.75, ...
	'onload', 1, ...
	'style', 'edit' ...
);

control(end + 1) = control_create( ...
	'name', 'location', ...
	'style', 'file', ...
	'type', 'dir', ...
	'lines', 5, ...
	'string', user_root(user, 'lib'), ...
	'space', 1 ...
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

%--
% create dialog
%--

out = dialog_group('New ...', control, opt, @new_library_callback);

% NOTE: return empty on cancel

if isempty(out.values)
	lib = []; return;
end

path = [out.values.location, filesep, out.values.name];

if ~create_dir(path);
	warn_dialog('Specified Library already exists or is not a valid directory.'); lib = []; return;
end

lib = library_create(out.values.name, user, out.values.location);

user_subscribe(lib, user);


%--------------------------------
% NEW_LIBRARY_CALLBACK
%--------------------------------

function new_library_callback(obj, eventdata)

%--
% get callback context
%--

[control, pal] = get_callback_context(obj);

%--
% switch callback on control name
%--

switch control.name
	
	case 'name'
		set_control(pal.handle, 'OK', 'enable', proper_filename(get(obj, 'string')));
		
	case 'location'
		
		value = get_control(pal.handle, control.name, 'value');
		
% 		set_control(pal.handle, control.name, 'value', user_root(get_active_user, 'lib'));
		
end
