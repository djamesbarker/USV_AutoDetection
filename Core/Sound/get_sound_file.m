function file = get_sound_file(source)

[ignore, name] = path_parts(source);

file = [source, filesep, name, '.mat'];
