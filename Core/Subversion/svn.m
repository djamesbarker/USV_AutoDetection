function [status, result] = svn(varargin)

% svn - access subversion command-line client
% -------------------------------------------
%
% [status, result] = svn(varargin)
%
% NOTE: use essentially as from any other command-line
%
% NOTE: the functional syntax above allows you to capture the output

%-------------------
% SETUP
%-------------------

%--
% get and possibly output tool
%--

tool = get_svn;

if ~nargin
    status = tool; return;
end

% NOTE: throw an error if we try to use an unavailable tool

if isempty(tool)
    error(['''', tool.name, ''' is not available.']);
end 

executable = tool.file;

editor = get_tool(ternary(ispc, 'scite.exe', 'gedit'));

if ~isempty(editor)
    editor = editor.file;
end
      
%--
% declare known commands
%--

known_commands = svn_commands;

%-------------------
% HANDLE INPUT
%-------------------

if nargin
	command = varargin{1};
else
	command = '';
end

args = [];

if nargin > 1
	args = varargin(2:end);
end
	
%--
% check command
%--

if ~string_is_member(command, known_commands)
	error(['Unrecognized command ''', command, '''.']);
end

%--
% build basic command string
%--

% NOTE: the choice of aliases for the version commands take after the MATLAB 'ver' and 'version' commands

switch command
	
	case 'ver'
		command = '--version';
		
	case 'version'
		command = '--version --quiet';

end

command_str = ['"', executable, '" ', command];

%--
% add editor command to args if necessary
%--

if ismember(command, {'ci', 'commit'}) && ~isempty(editor) && ~any(strmatch('--editor-cmd', args))
    args{end + 1} = ['--editor-cmd "', editor, '"'];
end

%--
% append arguments to command string
%--

for k = 1:length(args)
	
	% NOTE: try to quote filenames if needed, but not flag or number type arguments
	
	str = args{k};
	
	if ~ismember(str(1), '-1234567890"')
		str = ['"', str, '"'];
	end
	
	command_str = [command_str, ' ', str];

end

%--
% evaluate
%--

if ~nargout
	disp(' ');
end

switch command
	
	case {'ext', 'externals'}
		
		command_str = strrep(command_str, command, 'propget svn:externals -r HEAD');
		
		[status, result] = system(command_str);
		
		lines = file_readlines(result);
		
		for k = 1:numel(lines)
			disp(lines{k});
		end 
		
		if ~nargout
			disp(' ');
		end
		
	case {'st', 'status', 'st-?', 'st-m'} 
		
		% TODO: the filtering code is ugly and should be improved
		
		if command(end) == '?'
			command_str = strrep(command_str, 'st-?', 'st');
		end
		
		if command(end) == 'm'
			command_str = strrep(command_str, 'st-m', 'st');
		end 
			
		[status, result] = system(command_str);
		
		lines = file_readlines(result);
		
		if command(end) == '?', lines = filter_unversioned(lines); end
		
		if command(end) == 'm', lines = filter_matlab_binaries(lines); end
		
		lines = sort(lines);
		
		% NOTE: look at 'develop_extension' for code to pad and add links
		
		for k = 1:length(lines)
			
			if isempty(lines{k})
				continue;
			end
			
			switch lines{k}(1)
				
				case '?'
					
					content = parse_line(lines{k}); file = fullfile(pwd, content.file);
					
					if strcmp(content.file(end - 1:end), '.m') || strcmp(content.file(end - 1:end), '.c')
						disp(['<a href="matlab:svn(''add'', ''', file, ''');">', lines{k}, '</a>']);
					else 
						disp(lines{k});
					end
					
				% TODO: make added files editable through link
				
				case 'A'
					
					content = parse_line(lines{k}); file = fullfile(pwd, content.file);
					
					[ignore, ignore, ext] = fileparts(content.file);
					
					if ~isempty(ext)
						disp(['<a href="matlab:ted(''', file, ''');">', lines{k}, '</a>']);
					else
						disp(['<a href="matlab:show_file(''', file, ''');">', lines{k}, '</a>']);
					end
					
% 					disp(lines{k});
					
				% TODO: add 'Revert' link to modified, line itself currently shows 'diff'
				
				case 'M'

					if isempty(tsvn_root)
						disp(lines{k});
					else
						content = parse_line(lines{k}); file = fullfile(pwd, content.file);
						disp(['<a href="matlab:tsvn(''diff'', ''', file, ''');">', lines{k}, '</a>']);
					end
					
				otherwise
					
					disp(lines{k});
					
			end
			
		end
		
		if ~nargout
			disp(' ');
		end
		
	case {'up', 'update'}
		
		[status, result] = system(command_str);
		
		lines = file_readlines(result);
		
		for k = 1:length(lines)
			
			if isempty(lines{k})
				continue;
			end
			
			switch lines{k}(1)
				
				case 'U '
					
					% TODO: we must be able to call 'tsvn' with more arguments to make this 'diff' possible
					
					if isempty(tsvn_root)
						disp(lines{k});
					else
						content = parse_line(lines{k}); file = fullfile(pwd, content.file);
						disp(['<a href="matlab:tsvn(''diff'', ''', file, ''');">', lines{k}, '</a>']);
					end
					
				otherwise
					
					disp(lines{k});
					
			end
			
		end
		
	otherwise		
		
		if ~nargout
			system(command_str);
		else
			[status, result] = system(command_str); % result = pack_result(result);
		end

end

if ~nargout
	clear status;
end


%--------------------------------
% PACK_RESULT
%--------------------------------

% TODO: a similar parsing happens in 'get_svn_info' consider updating these

% NOTE: this is effective at least for the 'info' command, which is one we care about

function result = pack_result(output)

%--
% parse output to lines, skipping empty lines
%--

opt = file_readlines; opt.skip = 1; lines = file_readlines(output, [], opt);

%--
% parse and pack field value pairs
%--

result = struct; not_parsed = 0;

for k = 1:numel(lines)
	
	% TODO: make field value separator an option
	
	ix = find(lines{k} == ':', 1);

	if isempty(ix)
		not_parsed = 1; continue;
	end

	% NOTE: we remove spaces before calling general transformation
	
	field = genvarname(strrep(lines{k}(1:(ix - 1)), ' ', ''));
	
	value = lines{k}((ix + 2):end);
	
	result.(field) = value;
	
end

% NOTE: we provide the 'raw' output lines if any lines were not parsed

if not_parsed
	result.RAW = lines;
end

%--
% simplify field values if possible
%--

result = struct_simplify_values(result); 


%--------------------------------
% PARSE_LINE
%--------------------------------

function out = parse_line(line)

% NOTE: the skipped character is a space 

prefix = line(1:6); file = strtrim(line(8:end));

out.line = line; out.prefix = prefix; out.file = file;

status.file = prefix(1);

status.props = prefix(2);

status.locked = ~isspace(prefix(3));

status.history = ~isspace(prefix(4));

status.switched = ~isspace(prefix(5));

status.lock = prefix(6);

out.status = status;


%--------------------------------
% SVN_COMMANDS
%--------------------------------

function commands = svn_commands

commands = {...
	'help', ...
	'add', ...
	'blame', ...
	'praise', ...
	'annotate', ...
	'ann', ...
    'cat', ...
    'checkout', ...
	'co', ...
    'cleanup', ...
	'commit', ...
	'ci', ...
    'copy', ...
	'cp', ...
    'delete', ...
	'del', ...
	'remove', ...
	'rm', ...
    'diff', ...
	'di', ...
    'export', ...
    'help', ...
	'?', ...
	'h', ...
    'import', ...
    'info', ...
    'list', ...
	'ls', ...
    'lock', ...
    'log', ...
    'merge', ...
    'mkdir', ...
    'move', ...
	'mv', ...
	'rename', ...
	'ren', ...
    'password', ...
    'propdel', ...
	'pdel', ...
	'pd', ...
    'propedit', ...
	'pedit', ...
	'pe', ...
    'propget', ...
	'pget', ...
	'pg', ...
    'proplist', ...
	'plist', ...
	'pl', ...
    'propset', ...
	'pset', ...
	'ps', ...
    'resolved', ...
    'revert', ...
    'status', ...
	'stat', ...
	'st', ...
	'st-?', 'st-m', 'ext', 'externals' ... % NOTE: these are not actual commands
    'switch', ... 
	'sw', ...
    'unlock', ...
    'update', ...
	'up', ...
    'username', ...
	'ver', ...
	'version' ...
};


%--------------------------------
% FILTER_UNVERSIONED
%--------------------------------

function lines = filter_unversioned(lines)

for k = length(lines):-1:1

	if isempty(lines{k})
		continue;
	end

	% NOTE: this is given by the 'svn' standard output conventions
	
	if lines{k}(1) == '?'
		lines(k) = [];
	end

end


%--------------------------------
% FILTER_MATLAB_BINARIES
%--------------------------------

function lines = filter_matlab_binaries(lines)

% NOTE: we want to exclude MAT files and MEX files

ext = {['.', mexext], '.mat'}; len = iterate(@numel, ext);

for k = length(lines):-1:1

	if isempty(lines{k})
		continue;
	end

	% NOTE: we remove a line that ends with one of the binary extensions
	
	for j = 1:numel(ext)

		% NOTE: we break, since we can only exclude a line once
		
		if numel(lines{k}) > len(j) && strcmp(lines{k}(end - len(j) + 1:end), ext{j})
			lines(k) = []; break;
		end
		
	end

end
