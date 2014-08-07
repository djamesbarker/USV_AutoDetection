function tool = get_tool(name, scan)

% get_tool - get tool struct from name
% ------------------------------------
%
% tool = get_tool(name, scan)
%
% Input:
% ------
%  name - tool name
%  scan - scan for help indicator or hint
%
% Output:
% -------
%  tool - tool struct

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

% NOTE: This function requires the tool be in the MATLAB path.

% TODO: add license field and use help scan strategy to get license info

%-----------------
% HANDLE INPUT
%-----------------

%--
% set default help scan
%--

% NOTE: the scan input may be a hint for where to get help

hint = '';

if nargin < 2
	scan = 1;
end

if ischar(scan)
	hint = scan; scan = 1; 
end 

% NOTE: clear hint when it is not an existing directory

if ~isempty(hint) && ~exist_dir(hint)
	hint = '';
end

%-----------------
% GET TOOL
%-----------------

%--
% create tool
%--

tool = create_tool;

%--
% get tool location and type
%--

% NOTE: the file redundantly contains root for convenience

if ispc

	tool.file = which(name);

else

	[status, tool.file] = system(['which "', name, '"']);
	
	if ~isempty(tool.file)
		tool.file(end) = []; 
	end

end

% NOTE: this allows for full filenames not in MATLAB path to work

if isempty(tool.file) && exist(name, 'file')
	tool.file = name;
end

if isempty(tool.file)
	tool = []; return;
end

% NOTE: for unix scripts we could inspect the first line of the file to get type

[tool.root, tool.name, tool.type] = fileparts(tool.file);

%--
% scan for various fields
%--

if ~scan
	return;
end

tool.help = get_tool_help(tool, hint);

% NOTE: we may have to set the 'version' and 'url' fields manually

% tool.version = get_tool_version(tool);

% tool.url = get_tool_url(tool);


%--------------------------------
% CREATE_TOOL
%--------------------------------

function tool = create_tool

tool.name = '';

tool.version = '';

tool.root = '';

tool.file = '';

tool.type = '';

tool.help = {};

tool.url = '';


%--------------------------------
% GET_TOOL_HELP
%--------------------------------

function help = get_tool_help(tool, hint)

% NOTE: this function tries to infer which files in tool root are help files

%--
% setup
%--

% NOTE: we declare name cues and file types typical as help

cues = { ...
	'changes', 'changelog', ...
	'doc', 'docs', ...
	'faq', 'history', ...
	'help', ...
	'how to', 'how-to', 'howto', ...
	'install', ...
	'read me', 'read-me', 'readme', ...
	lower(tool.name) ...
};

types = {'', '.chm', '.dvi', '.htm', '.html', '.pdf', '.tex', '.txt'}; 

%--
% handle input
%--

start = tool.root;

% NOTE: if a non-empty hint was provided use it

if (nargin > 1) && ~isempty(hint)
	start = hint;
end

% TODO: consider searching in both places if available

%--
% scan near root for help files
%--

[above, current] = fileparts(start);

% NOTE: move help search root up when starting directory is 'bin'

if strcmpi(current, 'bin')
	root = above;
else
	root = start;
end

content = no_dot_dir(root);

% TODO: replace this with a proper while

for l = 1:4
	
	for k = length(content):-1:1

		if is_help_dir(content(k), tool)

			more_content = no_dot_dir([root, filesep, content(k).name]);
			
			for j = 1:length(more_content)
				more_content(j).name = [content(k).name, filesep, more_content(j).name];
			end

			content = [content; more_content]; content(k) = [];

		end

	end
	
end

%--
% check for help files among content
%--

help = {};

for k = 1:length(content)
	
	if content(k).isdir
		continue;
	end
	
	[name, type] = strtok(content(k).name, '.'); name = lower(name); type = lower(type);
	
	cue = 0;
	
	for j = 1:length(cues) 
		
		if findstr(name, cues{j})
			cue = 1; break;
		end
		
	end
	
	% TODO: make these full names for convenience and flexibility
	
	if cue && ismember(type, types)
		help{end + 1} = [root, filesep, content(k).name];
	end
	
end

help = help(:);


% TODO: these functions will depend on the type of tool

%--------------------------------
% GET_TOOL_VERSION
%--------------------------------

function version = get_tool_version(tool)

version = '';

%--------------------------------
% GET_TOOL_URL
%--------------------------------

function url = get_tool_url(tool)

url = '';


%--------------------------------
% IS_HELP_DIR
%--------------------------------

function value = is_help_dir(content, tool)

value = 0;

if ~content.isdir
	return;
end

prefix = {'doc', 'help', 'html', 'pdf', tool.name}; name = lower(content.name);

[ignore, name] = fileparts(name);

for k = 1:length(prefix)

	if ~isempty(strmatch(name, prefix{k}))
		value = 1; return;
	end

end

