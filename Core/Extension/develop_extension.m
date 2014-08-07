function develop_extension(varargin)

% develop_extension - a command-line extension development tool
% -------------------------------------------------------------
%
% develop_extension(ext)
%
% develop_extension type name
%
% Input:
% ------
%  ext - extension
%  type - type
%  name - name

%---------------------
% HANDLE INPUT
%---------------------

switch length(varargin)
	
	case 0
		
		develop_types; return;
		
	case 1
		
		if isstruct(varargin{1})
			ext = varargin{1};
		else
			ext.subtype = varargin{1}; ext.name = ''; develop_type(ext.subtype); return;
		end
		
	% NOTE: this is all we need to get the actual extension from the system
	
	case 2
		
		ext.subtype = varargin{1}; ext.name = varargin{2};
		
end

%--
% get extension and check subversion status
%--

if ~isempty(ext.name)
	ext = get_extensions(ext.subtype, 'name', ext.name);
else
	ext = get_extensions(ext.subtype);
end

% TODO: this should return to the parent?

if isempty(ext)
	return;
end

% NOTE: this is a coarse test of revision control status

root = extension_root(ext); in_svn = is_working_copy(root);

%---------------------
% SETUP
%---------------------

%--
% get API function handles and names
%--

fun = flatten(ext.fun); field = fieldnames(fun); 

%--
% get helpers and maximum label length for functions
%--

n(1) = max(cellfun('prodofsize', field));

helpers = get_helpers(ext);

if ~isempty(helpers)
	n(end + 1) = max(cellfun('prodofsize', helpers));
end

helpers_private = get_helpers(ext, 'private');

if ~isempty(helpers_private)
	n(end + 1) = max(cellfun('prodofsize', helpers_private)) + length(' (private)');
end

n = max(n);

%---------------------
% DISPLAY
%---------------------

%--
% build header
%--

type = upper(strrep(ext.subtype, '_', ' '));

name = upper(ext.name);

description = get_description(ext);

header = [ ...
	' ', types_link, ' > ', type_link(ext.subtype, type), ' > ', name, ' ', ext.version ...
];

% NOTE: this is not very effective consider something a bit more sophisticated

header = strrep(header, '  ', ' ');

% TODO: display description!!@

%--
% display header
%--

m = min(84, max([n, length(header) + 4, 84])); sep = str_line(m, '_');

p = min(m, 50);

% disp(' ');
disp(sep);
disp(' ');
disp(header);
disp(' ');

len = length(sep) - length(description) - length(' edit rename');

if len
	pad = char(double(' ') * ones(1, len)); disp([' ', description, pad, ext_edit_link(ext), ' ', rename_link(ext)]);
else
	disp([' ', description]);
end

disp(sep);
disp(' ');


pad = char(double(' ') * ones(1, length(sep) - length('refresh')));

sep_ref = [pad, refresh_link(ext)];

%--
% display family
%--

lines = family_links(ext, p);

if ~isempty(lines)
	
	disp(' FAMILY:');
	disp(' ');
	
	for k = 1:length(lines)
		disp(lines{k});
	end
	
	disp(' ');
	
end

%--
% display API section
%--

disp(' API:');
disp(' ');

lines = {}; code = [];

for k = 1:length(field)
	
	if isempty(fun.(field{k}));
		continue;
	end
	
	info = functions(fun.(field{k})); file = info.file;

	% NOTE: these methods belong to an ancestor parent, we should not edit them from here
	
	if isempty(strmatch(root, file))
		continue;
	end
	
	[lines{end + 1}, code(end + 1)]  = file_line(info.function, file, n, in_svn);
	
end

for k = 1:length(lines)
	disp(lines{k});
end

if sum(code)
	disp(' ');
	disp(['   API LINES: ', int2str(sum(code))]);
end

disp(' ');

display_add_links(ext, 'override');

disp(' ');

display_add_links(ext, 'add');

disp(' ');
% 
% lines = {}; str = '   ADD: '; count = length(str);
% 
% for k = 1:length(field)
% 	
% 	% TODO: this is not a strong enough test, we must check whether this is our own implementation
% 	
% 	if ~isempty(fun.(field{k}))
% 		
% 		info = functions(fun.(field{k}));
% 		
% 		if ~string_begins(info.file, extension_root(ext))
% 			continue;
% 		end
% 		
% 	end
% 	
% 	str = [str, add_link(ext, field{k}), ', '];
% 	
% 	count = count + length(field{k}) + 2;
% 	
% 	if count > p
% 		lines{end + 1} = str; str = '   '; count = length(str);
% 	end
% 
% end
% 
% if ~isempty(strtrim(str))
% 	lines{end + 1} = str;
% end
% 
% % NOTE: remove trailing comma
% 
% lines{end}(end - 1:end) = [];
% 
% for k = 1:length(lines)
% 	disp(lines{k});
% end
% 
% disp(' ');

%--
% display Helpers
%--

% disp(' HELPERS:');
% disp(' ');

disp(' HELPERS:');

lines = {}; code = []; [helper, root] = get_helpers(ext);

for k = 1:length(helper)
	
	file = [root, filesep, helper{k}, '.m'];
	
	[lines{end + 1}, code(end + 1)] = file_line(helper{k}, file, n, in_svn); 
	
end

[helper, root] = get_helpers(ext, 'private');

for k = 1:length(helper)
	
	label = [helper{k}, ' (private)']; file = [root, filesep, helper{k}, '.m'];

	lines{end + 1} = file_line(label, file, n, in_svn);
	
end

lines = sort(lines);

if ~isempty(lines)
	
	disp(' ');
	
	for k = 1:length(lines)
		disp(lines{k});
	end
	
end

if sum(code)
	disp(' ');
	disp(['   HELPER LINES: ', int2str(sum(code))]);
end

disp(' ');

str = ['   NEW: ', helper_link(ext, 0)]; disp(str);

disp(' ');

disp(sep_ref);
disp(sep);
disp(' ');


%----------------
% REFRESH_LINK
%----------------

function str = refresh_link(ext)

if length(ext) > 1
	str = ['<a href="matlab:extensions_cache(discover_extensions(''', ext.subtype , ''')); dev(''', ext.subtype , ''');">Refresh</a>'];
else
	str = ['<a href="matlab:extensions_cache(discover_extensions(''', ext.subtype , ''', ''', ext.name, ''')); dev(''', ext.subtype , ''', ''', ext.name, ''');">Refresh</a>'];
end






%-----------------------------------------------------
% DEVELOP_TYPES
%-----------------------------------------------------

function develop_types

%--
% get types
%--

types = get_extension_types;

%--
% display header
%--

header = [' ', 'EXTENSIONS'];

n = max(cellfun('prodofsize', types));

m = max([n , length(header) + 4, 84]); 

sep = str_line(m, '_');

% disp(' ');
disp(sep);
disp(' ');
disp(header)
disp(sep)
disp(' ');
disp(' TYPES:');
disp(' ');

%--
% display extension types
%--

for k = 1:length(types)
	
	try
		ext = get_extensions('extension_type', 'name', title_caps(types{k}));
	catch
		nice_catch(lasterror, ['Failed to get ''', types{k}, '''.']); continue;
	end
	
	description = get_description(ext);
	
	pad = pad_line(types{k}, n);
	
	line = ['    ', type_link(types{k}), pad, description];

	% NOTE: this is not very effective consider something a bit more sophisticated

	line = strrep(line, '  ', ' ');

	disp(line);

end

%--
% display footer
%--

pad = char(double(' ') * ones(1, length(sep) - length('refresh')));

sep_ref = [pad, refresh_types_link];

disp(' ');
disp(sep_ref);	
disp(sep);
disp(' ');


%-----------------------------------------------------
% DEVELOP_TYPE
%-----------------------------------------------------

function develop_type(type)

%--
% get type extensions
%--

exts = get_extensions(type);

% TODO: handle case when there are no extensions of type

%--
% build and display header
%--

header = [' ', types_link, ' > ', upper(strrep(type, '_', ' '))];

if ~isempty(exts)
	names = {exts.name}; n = max(cellfun('prodofsize', names));
else
	n = 1;
end

m = max([n , length(header) + 4, 84]); sep = str_line(m, '_');

% disp(' ');
disp(sep);
disp(' ');
disp(header)
disp(sep)
disp(' ');
disp(' EXTENSIONS:')
disp(' ');

%--
% display extensions
%--

for ext = list(exts)

	description = get_description(ext);

	pad = pad_line(ext.name, n);
	
	line = ['    ', dev_link(ext), pad, description];

	% NOTE: this is not very effective consider something a bit more sophisticated

	line = strrep(line, '  ', ' ');

	disp(line);

end

disp(' ');
disp(['   NEW: ', new_link(type)]);

%--
% display header
%--

pad = char(double(' ') * ones(1, length(sep) - length('refresh')));

% TODO: this is not correct, we should be able to have a refresh link

if ~isempty(exts)
	sep_ref = [pad, refresh_link(ext)]; disp(sep_ref);
end 

disp(sep);
disp(' ');


%-----------------------------------------------------
% LINK HELPERS
%-----------------------------------------------------

%------------------------------------
% TYPES
%------------------------------------


% TYPES_LINK

function str = types_link

str = '<a href="matlab:dev();">EXTENSIONS</a>';

%------------------------------------

% REFRESH_TYPES_LINK

function str = refresh_types_link

str = '<a href="matlab:clear get_extension_types; dev;">Refresh</a>';


%------------------------------------
% TYPE
%------------------------------------


% TYPE_LINK - display list of available extension for type and commands

function str = type_link(type, label)

if nargin < 2
	label = title_caps(type);
end

str = ['<a href="matlab:dev(''', type, ''');">', label, '</a>'];


%------------------------------------

% NEW_LINK - new extension of type dialog link

function str = new_link(type)

str = ['<a href="matlab:new_extension_dialog(''', type , ''');">', type, '</a>'];


%------------------------------------

% REFRESH_TYPE_LINK - refresh cache for extensions of type

function str = refresh_type_link(type)

str = ['<a href="matlab:extensions_cache(discover_extensions(''', type, ''')); dev(''', type, ''');">Refresh</a>'];


%------------------------------------
% EXTENSION
%------------------------------------


% DEV_LINK - display development page for extension

function str = dev_link(ext)

str = ['<a href="matlab:dev(''', ext.subtype , ''', ''', ext.name, ''');">', ext.name, '</a>'];


%------------------------------------

% EDIT_LINK - edit link for file, broader use

function str = edit_link(file)

str = ['<a href="matlab:ted(''', file, ''');">Edit</a>'];


%------------------------------------

% SHOW_LINK - show file link, broader use

function str = show_link(file)

str = ['<a href="matlab:show_file(''', file, ''');">Show</a>'];

%------------------------------------

% DELETE_LINK - delete file link, broader use

function str = delete_link(file)

str = ['<a href="matlab:delete_file(''', file, ''', 0);">Delete</a>'];


%------------------------------------

% DIFF_LINK - show file diffs using tortoise, broader use

function str = diff_link(file)

str = ['<a href="matlab:tsvn(''diff'', ''', file, ''');">Diff</a>'];


%------------------------------------

% ADD_LINK - add API function to extension and edit

function str = add_link(ext, name, label)

if nargin < 3
	label = name;
end

str = ['<a href="matlab:edit(generate_function(''', ext_tag(ext) , ''', ''', name, '''));">', label, '</a>'];


%------------------------------------

% HELPER_LINK - add helper to extension and edit

function str = helper_link(ext, private)

if nargin < 2
	private = 0;
end 

tag = ext_tag(ext);

if private
	str = ['<a href="matlab:new_helper_dialog(''', tag , ''', 1);">helper (private)</a>'];
else
	str = ['<a href="matlab:new_helper_dialog(''', tag , ''', 0);">helper</a>'];
end 


%------------------------------------

% FILE_LINE - display commands and info for an extension file

function [str, code] = file_line(label, file, n, in_svn)

%--
% handle input
%--

if nargin < 4
	in_svn = 0;
end

%--
% add label, edit and show links, and possibly diff link
%--

pad = pad_line(label, n);

str = ['   ', label, pad, edit_link(file), ' ', show_link(file), ' ', delete_link(file)];

if in_svn
	str = [str, ' ', diff_link(file)];
end

%--
% add lines of code
%--

[code, total, functions] = lines_of_code(file); 

% NOTE: we subtract the (typically) generated function declaration from the count

code = code - 1;
	
% NOTE: this will only align displays when code is less than a 1000 lines

str = [str, '  ', integer_unit_string(code, 'line', 100)];

switch functions
	
	case 0, str = [str, ', script'];
		
	case 1, % NOTE: we display nothing, this is the typical case
		
	otherwise, str = [str, ', ', integer_unit_string(functions - 1, 'sub-function')];
		
end



%------------------------------------

% FAMILY_LINKS - display linked extension family

function lines = family_links(ext, width)

width = 64;

%--
% get direct direct family, ancestors and children
%--

ancestor = get_extension_ancestry(ext);	

child = get_extension_children(ext);

%--
% check if we have to produce lines
%--

lines = {};

% NOTE: this test whether extension has ancestors or children

if (length(ancestor) == 1) && isempty(child)
	return;
end

%--
% produce family links lines
%--
	
count = length(ancestor(end).name);

if length(ancestor) == 1
	str = [' [ ', dev_link(ancestor(end)), ' ]'];
else
	str = dev_link(ancestor(end));
end

for k = (length(ancestor) - 1):-1:1

	if k == 1
		str = [str, ' > [ ', dev_link(ancestor(k)), ' ]'];
	else
		str = [str, ' > ', dev_link(ancestor(k))];
	end

	count = count + length(ancestor(k).name) + 1;

	if count > width
		lines{end + 1} = str; count = 0; str = '';
	end

end

if ~isempty(child)

	str = [str, ' > '];  count = count + 3;

	if count > width
		lines{end + 1} = str; count = 0; str = '';
	end
	
	for k = 1:length(child)

		[nest, grand] = has_children(child(k));
		
		if nest
			
			count = count + length(child(k).name) + 5;
			
			str = [str, ' ( ', dev_link(child(k)), ' > '];
			
			if count > width
				lines{end + 1} = str; count = 0; str = '';
			end
			
			for j = 1:length(grand)
				
				count = count + length(grand(j).name) + 3;
				
				if j == 1
					str = [str, ' ', dev_link(grand(j)), ', '];
				else
					str = [str, dev_link(grand(j)), ', '];
				end
				
				if count > width
					lines{end + 1} = str; count = 0; str = '';
				end
			
			end
			
			try
				str(end - 1:end) = ' )';
			catch
				str = [str, ' )'];
			end
			
		else
		
			str = [str, ' ', dev_link(child(k))];

		end
		
		if k < length(child)
			str(end + 1) = ',';
		end

		count = count + length(child(k).name) + 1;

		if count > width
			lines{end + 1} = str; count = 0; str = '';
		end

	end

end

lines{end + 1} = str;

for k = 1:length(lines)
	lines{k} = ['  ', strrep(lines{k}, '  ', ' ')];
end


%-----------------------------------------------------
% HELPERS
%-----------------------------------------------------


% EXT_DESCRIPTION - get string to describe extension

function str = get_description(ext)

if trivial(ext)
	str = '*** Short description is not available ***'; return; 
end

% db_disp describe; ext

str = ext.short_description;

if isempty(str)
	str = '*** Short description is not available ***';
end


%------------------------------------

% EXT_TAG - create a string to describe extensions, broader use

function tag = ext_tag(ext)

if isempty(ext.parent)
	parent_name = ''; 
else
	parent_name = ext.parent.name;
end

tag = [ext.subtype, '::', ext.name, '::', parent_name];


%------------------------------------

% PAD_LINE - create padding line

function pad = pad_line(line, total, marker)

if nargin < 3
	marker = '.';
end

if nargin < 2
	total = 48;
end

pad = [' ', char(double(marker) * ones(1, total - length(line) + 3)), ' '];


%------------------------------------

function str = ext_edit_link(ext)

% EXT_EDIT_LINK - invoke edit extension dialog

tag = ext_tag(ext);

str = ['<a href="matlab:extension_edit_dialog(''', tag , ''');">Edit</a>'];


%------------------------------------

% RENAME_LINK - invoke rename extension dialog

function str = rename_link(ext)

tag = ext_tag(ext);

str = ['<a href="matlab:extension_rename_dialog(''', tag , ''');">Rename</a>'];








function lines = display_add_links(ext, type)

%--
% handle input
%--

% NOTE: the types are 'add' and 'override'

if nargin < 2
	type = 'add'
end

%--
% setup
%--

width = 50;

fun = flatten(ext.fun); field = fieldnames(fun);

%--
% build lines
%--

lines = {}; str = ['   ', upper(type), ': ']; count = length(str); added = 0;

for k = 1:length(field)
	
	%--
	% get current handle and check simple conditions
	%--
	
	current = fun.(field{k});
	
	if isempty(current)
		if strcmp(type, 'override')
			continue;
		end
	else
		if strcmp(type, 'add')
			continue;
		end
	end

	%--
	% when a function handle is available we check where it comes from
	%--
	
	if ~isempty(current) && strcmp(type, 'override')
		
		info = functions(current);

		if string_begins(info.file, extension_root(ext))
			continue;
		end
		
	end
	
	%--
	% build line
	%--
	
	added = added + 1;
	
	str = [str, add_link(ext, field{k}), ', '];

	count = count + length(field{k}) + 2;

	if count > width
		lines{end + 1} = str; str = '   '; count = length(str);
	end

end

if ~isempty(strtrim(str))
	lines{end + 1} = str;
end

lines{end}(end - 1:end) = []; % NOTE: remove trailing comma

if ~added
	lines = {};
end

%--
% display lines if no output was requested
%--

if ~nargout
	
	for k = 1:length(lines)
		disp(lines{k});
	end

end







