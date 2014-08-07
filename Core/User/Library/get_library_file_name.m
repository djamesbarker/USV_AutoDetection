function [name author] = get_library_file_name(name)

	
author = [];
	
if any(strfind(name, filesep))
	
	[author, name] = strtok(name, filesep);
	
	name(name == filesep) = '';
	
end

	
