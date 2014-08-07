function edit_library_dialog(lib)

if ~nargin
	lib = get_active_library;
end

user = get_active_user;

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

control(end + 1) = control_create( ...
	'name', 'tags', ...
	'style', 'edit', ...
	'space', 0.75, ...
	'color', ones(1,3) ...
);

control(end + 1) = control_create( ...
	'name', 'notes', ...
	'style', 'edit', ...
	'color', ones(1,3), ...
	'lines', 4 ...
);

% control(end + 1) = control_create( ...
% 	'name', 'relocate ...', ...
% 	'style', 'buttongroup', ...
% 	'width', 1/2, ...
% 	'lines', 1.75, ...
% 	'align', 'right' ...
% );
	
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

out = dialog_group('Edit ...', control, opt, @edit_library_callback);

% NOTE: return empty on cancel

if isempty(out.values)
	lib = []; return;
end

%-------------------------------------
% EDIT_LIBRARY_CALLBACK
%-------------------------------------

function result = edit_library_callback(obj, eventdata)

result = [];

%--
% get callback context
%--

lib = get_active_library;

user = get_active_user;

[control, pal] = get_callback_context(obj);

switch control.name

	case 'tags'
		
	case 'notes'
	
	case 'relocate ...', library_relocate(user, lib.path);
		
	otherwise
	
end





