function ext = new_extension_dialog(type, par)

% new_extension_dialog - dialog to assist creation of new extension
% -----------------------------------------------------------------
%
% ext = new_extension_dialog(type, par)
%
% Input:
% ------
%  type - type of extension to generate (def: '')
%  par - parent browser (def: [])
%
% Output:
% -------
%  ext - generated extension

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

%----------------------
% HANDLE INPUT
%----------------------

%--
% set no parent default and generic new extension
%--

if nargin < 2
	par = [];
end

if (nargin < 1) || isempty(type)
	type = '';
end

%--
% check input to set new extension state
%--

% NOTE: we handle extension and extension type input

new = ~isstruct(type);

if ~new
	ext = type; type = ext.subtype;
end

%--
% set and check extension type
%--

generic = (nargin < 1) || isempty(type);

types = get_extension_types;

if generic
	type = types{1};
end

if ~ismember(type, types)
	error('Unrecognized extension type input.');
end

%--
% create empty extension in the new case
%--

% NOTE: create needs a type, type specific fields are not used here

if new 
	ext = extension_create(types{1});
end

%----------------------
% CREATE CONTROLS
%----------------------

%--
% create type header or extension header and type selector
%--

control = empty(control_create);

if generic
	
	control(end + 1) = control_create( ...
		'style', 'separator', ...
		'type', 'header', ...
		'min', 1, ...
		'string', 'Extension' ...
	);
	
	control(end).space = 0.5;
	
	ix = find(strcmp(type, types));

	control(end + 1) = control_create( ...
		'name', 'type', ...
		'style', 'popup', ...
		'string', title_caps(types), ... 
		'space', 1.5, ...
		'value', ix ...
	);

	control(end + 1) = control_create( ... 
		'style', 'separator' ...
	);

else
	
	if new
		str = title_caps(type);
	else
		str = [title_caps(type), '  (', ext.name, ')'];
	end
	
	control(end + 1) = control_create( ...
		'style', 'separator', ...
		'type', 'header', ...
		'min', 1, ...
		'string', str ...
	);

end

%--
% basic, author, and advanced tabs
%--

control(end).space = 0.11;

tabs = {'Basic', 'Author', 'Advanced'};

control(end + 1) = control_create( ...
	'name', 'new_extension_tabs', ...
	'style', 'tabs', ...
	'tab', tabs ... 
); 

%--
% name and short description
%--

% NOTE: these are the contents of the basic tab

control(end + 1) = control_create( ...
	'name', 'name', ...
	'tab', tabs{1}, ...
	'style', 'edit', ...
	'type', 'filename', ...
	'string', ext.name, ...
	'space', 0.75, ...
	'onload', 1 ...
);

if ~new
	control(end).initialstate = '__DISABLE__';
end

control(end + 1) = control_create( ...
	'name', 'short_description', ...
	'tab', tabs{1}, ...
	'style', 'edit', ...
	'string', ext.short_description, ...
	'space', 0.75 ...
);

control(end + 1) = control_create( ...
	'name', 'version', ...
	'tab', tabs{1}, ...
	'style', 'edit', ...
	'string', ext.version, ...
	'width', 1/3, ...
	'space', 1.5 ...
);

%--
% author fields
%--

% NOTE: for existing extensions we duck the user with extension

if new
	user = get_active_user;
else
	user = ext; user.name = user.author;
end

% NOTE: these are the contents of the basic tab

control(end + 1) = control_create( ...
	'name', 'author', ...
	'alias', 'name', ...
	'tab', tabs{2}, ...
	'style', 'edit', ... 
	'string', user.name, ...
	'space', 0.75 ...
);

control(end + 1) = control_create( ...
	'name', 'email', ...
	'tab', tabs{2}, ...
	'style', 'edit', ... 
	'string', user.email, ...
	'space', 0.75 ...
);

control(end + 1) = control_create( ...
	'name', 'url', ...
	'alias', 'URL', ...
	'tab', tabs{2}, ...
	'style', 'edit', ... 
	'string', user.url, ...
	'space', 1.5 ...
);

%--
% categories and parent controls
%--

[categories, initialstate] = get_known_categories(type);

control(end + 1) = control_create( ...
	'name', 'known_categories', ...
	'tab', tabs{3}, ...
	'style', 'popup', ...
	'initialstate', initialstate, ...
	'string', categories, ...
	'value', 1, ...
	'color', get(0, 'defaultuicontrolbackgroundcolor'), ...
	'label', 0, ...
	'width', 0.5, ... 
	'align', 'right', ...
	'space', -0.5 ...
);

control(end + 1) = control_create( ...
	'name', 'categories', ...
	'tab', tabs{3}, ...
	'style', 'edit', ...
	'string', cellstr_to_str(ext.category), ...
	'lines', 2, ...
	'space', 0.75 ...
);

exts = get_extensions(type); 

if isempty(exts)
	names = {'None'}; state = '__DISABLE__';
else
	names = {'None', exts.name}; state = '__ENABLE__';
end

control(end + 1) = control_create( ...
	'name', 'parent', ...
	'tab', tabs{3}, ...
	'style', 'popup', ...
	'initialstate', state, ...
	'string', names, ... 
	'value', 1 ...
);

if ~new
	control(end).initialstate = '__DISABLE__';
end

control(end).space = 2;

%----------------------
% CREATE DIALOG
%----------------------

%--
% configure dialog
%--

% NOTE: consider using color based on type value and possibly changing label

opt = dialog_group; 

opt.width = 12;

opt.text_menu = 1;

if generic
	opt.header_color = get_extension_color('root'); 
else
	opt.header_color = get_extension_color(type);
end

%--
% present dialog
%--

if new
	name = 'New ...';
else
	name = 'Edit ...';
end

out = dialog_group(name, control, opt, {@new_extension_callback, type});

% NOTE: return on cancel or abort

values = out.values;

if isempty(values)
	
	% NOTE: no extension created in this case
	
	if new
		ext = [];
	end 
	
	return;
	
end

%----------------------
% GENERATE
%----------------------

if new
	
	%--
	% update extension type
	%--

	if has_control(control, 'type')
		type = values.type{1};
	end
	
	%--
	% generate extension
	%--

	if strcmpi(values.parent{1}, 'none')
		ext = generate_extension(type , values.name);
	else
		ext = generate_extension(type, values.name, values.parent{1}, values.short_description);
	end
	
	%--
	% regenerate extension main
	%--
	
	values.category = str_to_tags(strrep(values.categories, ',', ''));

	values = rmfield(values, {'name', 'parent', 'known_categories', 'categories'});
	
	ext = struct_update(ext, values);
	
	regenerate_main(ext);
	
	%--
	% open extension palette if we have a parent
	%--
	
	if (nargin > 1) && ~isempty(par)
		extension_palettes(par, ext.name);
	end

%----------------------
% EDIT
%----------------------

else
	
	%--
	% update values for extension update
	%--
	
	values.category = str_to_cellstr(values.categories);

	% NOTE: we do not allow updates on these fields
	
	values = rmfield(values, {'name', 'parent', 'known_categories', 'categories'});
	
	%--
	% update extensions
	%--
	
	ext = struct_update(ext, values);
	
end 


%-------------------------------------
% NEW_EXTENSION_CALLBACK
%-------------------------------------

function new_extension_callback(obj, eventdata, type);

%--
% get callback context
%--

[control, pal] = get_callback_context(obj);

%--
% handle controls by name
%--

switch control.name
	
	case 'type'
		
		%--
		% get potential parent extension names
		%--
		
		type = get_control(pal.handle, 'type', 'value');
		
		% TODO: consider that inheritance may jump types, this is not yet defined
		
		exts = get_extensions(type{1}); 
		
		if ~isempty(exts)
			names = {'None', exts.name};
		else
			names = {'None'};
		end
		
		%--
		% update parent control menu
		%--
		
		% NOTE: the fact that it is a menu implies single inheritance
		
		handles = get_control(pal.handle, 'parent', 'handles');
		
		set(handles.obj, 'string', names, 'value', 1);
		
		set_control(pal.handle, 'parent', 'enable', ~isempty(exts));
		
		%--
		% update known categories
		%--
		
		[categories, state] = get_known_categories(type{1});
		
		handles = get_control(pal.handle, 'known_categories', 'handles');
		
		set(handles.obj, 'string', categories);
		
		set_control(pal.handle, 'known_categories', 'command', state);
		
	case 'name'
		
		set_control(pal.handle, 'OK', 'enable', proper_filename(get(obj, 'string')));
		
	case 'short_description'
		
	case 'known_categories'
		
		%--
		% add known category to set of categories
		%--
		
		categories = get_control(pal.handle, 'categories', 'value');
		
		known_category = get_control(pal.handle, 'known_categories', 'value');
		
		% NOTE: union is the same as adding a tag
		
		categories = union(str_to_cellstr(categories), known_category{1});
		
		%--
		% update categories control
		%--
		
		set_control(pal.handle, 'categories', 'value', cellstr_to_str(categories));
		
	case 'categories'
		
	case 'parent'
		
		%--
		% get parent extension
		%--
		
		% NOTE: the type may be fixed or be a control, this code handles this
		
		if has_control(pal.handle, 'type')
			type = get_control(pal.handle, 'type', 'value'); type = type{1};
		end
		
		name = get_control(pal.handle, 'parent', 'value'); name = name{1};
		
		ext = get_extensions(type, 'name', name);
		
		if isempty(ext)
			return;
		end 
		
		%--
		% set parent categories as ours
		%--
		
		set_control(pal.handle, 'categories', 'value', cellstr_to_str(ext.category));
			
end


%-------------------------------------
% CELLSTR_TO_STR
%-------------------------------------

function str = cellstr_to_str(in)

%--
% consider trivial cases
%--

if isempty(in)
	str = ''; return;
end

% NOTE: we are flexible in accepting string input

if ischar(in)
	str = in; return;
else
	if ~iscellstr(in)
		error('Input must be a string or cell array of strings.');
	end
end

str = in{1};

for k = 2:numel(in)
	str = [str, ', ', in{k}];
end


%-------------------------------------
% STR_TO_CELLSTR
%-------------------------------------

function out = str_to_cellstr(str)

out = strread(str, '%s', -1, 'delimiter', ',');

out = strtrim(out);


%-------------------------------------
% GET_KNOWN_CATEGORIES
%-------------------------------------

function [categories, state] = get_known_categories(type)

category = get_extension_categories(type, 0); 

if isempty(category)
	categories = {'None'}; state = '__DISABLE__';
else
	categories = {category.name}'; state = '__ENABLE__';
end

%-------------------------------------
% GET_POTENTIAL_PARENTS
%-------------------------------------

function get_potential_parents


