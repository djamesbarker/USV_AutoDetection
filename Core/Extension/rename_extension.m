function new_ext = rename_extension(ext,new_name)

% rename_extension - rename extension
% -----------------------------------
%
% new_ext = rename_extension(ext,new_name)
%
% Input:
% ------
%  ext - extension to rename
%  new_name - new extension name
%
% Output:
% -------
%  new_ext - renamed extension

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

%-----------------------------------------------------
% SETUP
%-----------------------------------------------------

%--
% try to generate extension with new name
%--

% NOTE: generate directory structure and check for name conflicts

new_ext = generate_extension(ext.subtype, new_name);

if isempty(new_ext)
	return;
end

%--
% create convenience variables
%--

name = ext.name;

main = get_extension_main(ext); new_main = get_extension_main(new_ext);

main_name = func2str(ext.fun.main); new_main_name = func2str(new_ext.fun.main); 

root = extension_root(ext); new_root = extension_root(new_ext);

%--
% configure file replace
%--

% NOTE: these are the patterns we will find and replace as part of rename

pat = {name, main_name}; rep = {new_name, new_main_name};

opt = file_replace; 

opt.verb = 1; opt.test = 0;

%-----------------------------------------------------
% COPY AND PROCESS EXTENSION CONTENTS
%-----------------------------------------------------

%--
% copy and process main file
%--

file_replace(main, pat, rep, new_main, opt);

%--
% copy and process contents of extension directories
%--

type = {'private','Helpers','Presets','Docs'};

for k = 1:length(type)
	
	%--
	% copy files from extension to new extension
	%--
	
	source = [root, filesep, type{k}]; dest = [new_root, filesep, type{k}];
		
	copyfile(source,dest);

	%--
	% process destination copies
	%--
	
	content = dir(dest);
	
	for j = 1:length(content)
		
		%--
		% handle child directories
		%--
		
		% NOTE: remove '.svn' directories and skip other directories
		
		if content(j).isdir
			
			if strcmp(content(j).name, '.svn')
				rmdir([dest, filesep, '.svn'], 's');
			else
				continue;
			end
			
		end
		
		%--
		% handle matlab source files
		%--
						
		if strcmp(content(j).name(end - 1:end), '.m')
			file_replace([dest, filesep, content(j).name], pat, rep, [], opt);
		end
		
	end
	
end

%--
% get source extension children
%--

child = get_extension_children(ext);

if isempty(child)
	return;
end

%--
% adopt children
%--

% NOTE: all children call 'extension_inherit' in main function, this is the replace target

for k = 1:length(child)
	
	file_replace(get_extension_main(child(k)), pat, rep, [], opt);
	
end
