function ext = generate_extension(type, name, parent, description)

% generate_extension - generate extension skeleton
% ------------------------------------------------
%
% ext = generate_extension(type, name, parent, description)
%
% Input:
% ------
%  type - extension type
%  name - extension name
%  parent - parent name
%  description - short description of extension
%
% Output:
% -------
%  ext - extension

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

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% set default description and parent
%--

if (nargin < 4) || isempty(description)
	description = '';
end

if (nargin < 3) || isempty(parent)
	parent = '';
end

%--
% check and normalize type
%--

% NOTE: this function should not throw an error! this part is ugly

type = type_norm(type);

if isempty(type)
	
	disp(' ');
	disp('No extension created. Unrecognized extension type.');
	disp(' ');
	
	if nargout
		ext = [];
	end
	
	return;

end

%--
% check extension name
%--

if ~proper_filename(name)
	
	disp(' ');
	disp('No extension created. Name must be proper filename.');
	disp(' ');
	
	if nargout
		ext = [];
	end
	
	return;

end

%--
% get parent using name and type
%--

if ~isempty(parent)
	
	ext0 = get_extensions(type, 'name', parent);

	if isempty(ext0)
		
		disp(' ');
		disp('No extension created. Parent is not available.');
		disp(' ');

		if nargout
			ext = [];
		end
		
		return;

	end 
	
	parent = func2str(ext0.fun.main);
	
end

%----------------------------------------------------------
% GENERATE DIRECTORIES
%----------------------------------------------------------

%--
% get extension root from type and name
%--

root = [extensions_root, filesep, type_to_dir(type), filesep, name];

% NOTE: if root directory exists, assume extension exists and return

% TODO: try to create extension instead

if exist(root, 'dir')
	
	disp(' ');
	disp('No extension created. Extension seems to exist.');
	disp(' ');
		
	if nargout
		ext = [];
	end
	
	return;
	
end

%--
% create extension directory tree 
%--

disp(' ');

% NOTE: add extension root to path immediately so we can create extension

mkdir(root); path(path, root);

child = get_extension_directories;

% TODO: consider adding these to path

for k = 1:length(child)
	
	mkdir(root, child{k}); rel_path([root, filesep, child{k}]);
	
end

%----------------------------------------------------------
% GENERATE MAIN
%----------------------------------------------------------

%--
% get name from extension name
%--

main_name = get_main_name(name);

%--
% create main
%--

% NOTE: we create this simple main to bootstrap extension creation

temp = [root, filesep, main_name, '.m']; rel_path(temp);

fid = fopen(temp, 'w');

if isempty(parent)
		
	fprintf(fid,'%s\n\n%s\n', ...
		['function ext = ', main_name], ...
		'ext = extension_create;' ...
	);

else
	
	fprintf(fid,'%s\n\n%s\n', ...
		['function ext = ', main_name], ...
		['ext = extension_inherit(', parent, ');'] ...
	);
	
end

fclose(fid);

%----------------------------------------------------------
% CREATE EXTENSION
%----------------------------------------------------------

%--
% create extension
%--

% NOTE: move to extension root in case name is not unique, this should be avoided

curr = pwd; cd(root);

ext = eval(main_name);

cd(curr);

%--
% regenerate fuller main 
%--

ext.short_description = description;

user = get_active_user;

ext.author = user.name; ext.email = user.email; ext.url = user.url;

regenerate_main(ext);

% NOTE: for some reason we have to clear the function for the edits to show

clear(main_name); ext = eval(main_name);

%--
% generate compute, most extensions have a compute
%--

% TODO: extend to create the basic 'compute' for other extensions

% NOTE: default compute is lazy, an identity filter is lazy, a null detector is lazy

generate_function(ext, 'compute');

%--
% update extensions cache and menus, then get extension
%--

update_extensions;

% NOTE: we test that get extensions works on the generated extension

ext = get_extensions(ext.subtype, 'name', ext.name);

%--
% peek into extension
%--

disp(' ');
disp('Extension succesfully created.');
disp(' ');

% NOTE: we supress the command-line display of the extension

if ~nargout
	clear ext;
end

%--
% add extensions directories to path, carefully!
%--

store = path;

try
	path(path, get_path_str(root, 'rec'));
catch
	path(store);
end

%--
% update cache
%--

disp('Updating extensions cache ...');
disp(' ');

get_extensions('!');

disp('Done.'); 
disp(' ');

%----------------------------------------------------------
% GET_MAIN_NAME
%----------------------------------------------------------

function main_name = get_main_name(name)

% get_main_name - compute main function name from extension name
% --------------------------------------------------------------
%
% main_name = get_main_name(name)
%
% Input:
% ------
%  name - extension name
%
% Output:
% -------
%  main_name - main function name

%--
% lower and strip punctuation
%--

main_name = lower(strip_punctuation(name));

%--
% check for name clashes and possibly add suffix
%--

% NOTE: this could clearly fail, if it does we probably have larger problems

if ~isempty(which(main_name))
	main_name = [main_name, '_ext'];
end

prefix = main_name; k = 2;

while ~isempty(which(main_name))
	main_name = [prefix, int2str(k)];
end
