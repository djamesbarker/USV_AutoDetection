function result = source_dispatch(obj, eventdata, ext, context)

if nargin < 4
	context = [];
end

if ~isfield(context, 'sound')
	[context.sound, context.lib] = get_selected_sound;
end

context.ext = ext; 

ext = source_dialog(ext, context);

sound = context.sound;

%--
% edit sound sources
%--

if ~isfield(sound.output, 'source') || isempty(sound.output.source)
	sound.output.source = ext; return;
end

names = {sound.output.source(:).name}; 

ix = find(strcmp(ext.name, names));
	
sound.output.source(ix) = ext;

%--
% save sound
%--

result = sound_save([], sound);

