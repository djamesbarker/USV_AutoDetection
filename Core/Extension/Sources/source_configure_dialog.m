function result = source_configure_dialog(sound)

result = [];

if ~nargin
	sound = get_selected_sound;
end

if numel(sound) ~= 1
	return;
end

ext = [];

if isfield(sound.output, 'source')
	ext = sound.output.source;
end

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'string', 'sources' ...
);

sources = get_extensions('source');

control(end + 1) = control_create( ...
	'name', 'available_sources', ...
	'style', 'listbox', ...
	'lines', 3, ...
	'string', {sources.name}, ...
	'value', [], ...
	'onload', 1, ...
	'min', 1, ...
	'max', 3 ...
);

control(end + 1) = control_create( ...
	'style', 'buttongroup', ...
	'width', 2/3, ...
	'align', 'right', ...
	'name', {'add', 'rem'}, ...
	'lines', 1.5 ...
);

control(end + 1) = control_create( ...
	'name', 'sound_sources', ...
	'style', 'listbox', ...
	'lines', 3, ...
	'min', 1, ...
	'max', 3 ...
);

opt = dialog_group;

result = dialog_group( ...
	'configure_sources', control, opt, {@source_config_callback, sound} ...
);
	
%-----------------------------------
% SOURCE_CONFIG_CALLBACK
%-----------------------------------

function result = source_config_callback(obj, eventdata, sound)

result = [];

[control,par] = get_callback_context(obj); 

par = par.handle;

lib = get_active_library;

to_add = get_control(par, 'available_sources', 'value');

to_remove = get_control(par, 'sound_sources', 'value');

han = get_control(par, 'sound_sources', 'handles');

%--
% display source menu
%--

out = sound_load(lib,sound_name(sound));

sound = out.sound;

menu = uicontextmenu; source_menu(menu, sound);

set(han.obj, ...
	'UIContextMenu', menu ...
);

if isfield(sound.output, 'source') && ~isempty(sound.output.source)
	current_names = {sound.output.source(:).name};
else
	current_names = {};
end

if ~strcmp(control.name, 'sound_sources')
	set(han.obj, ...
		'string', current_names, ...
		'value', [] ...
	);
end

switch control.name
	
	case 'add ...'
		
		if isempty(to_add)
			return;
		end
		
		for k = 1:length(to_add)
			
			ext = get_extension('source', to_add{k});
			
			if ~isfield(sound.output, 'source') || isempty(sound.output.source)
				sound.output.source = ext; continue;
			end
			
			if ~ismember(to_add{k}, {sound.output.source(:).name})
				sound.output.source(end + 1) = ext;
			end		
			
		end	
		
		set(han.obj, ...
			'string', union(current_names, to_add), ...
			'value', [] ...
		);
		
	case 'remove ...'
		
		if isempty(to_remove)
			return;
		end
		
		set(han.obj, 'string', setdiff(current_names, to_remove), 'value', []);
		
		if ~isfield(sound.output, 'source') || isempty(sound.output.source)
			return;
		end
		
		for k = 1:length(to_remove)
			
			ix = find(strcmp({sound.output.source(:).name}, to_remove{k}));
			
			sound.output.source(ix) = [];
			
		end
		
	otherwise
		return;
end


sound_save(lib,sound,out.state);
		


