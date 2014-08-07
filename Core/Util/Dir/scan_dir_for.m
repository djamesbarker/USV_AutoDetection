function files = scan_dir_for(type, root)

% scan_dir_for - file types
% -------------------------
%
% files = scan_dir_for(type, root)
%
% Input:
% ------
%  type - string or cell array, file extension(s)
%  root - for scan (def: pwd)
%
% Output:
% -------
%  files - found
%
% See also: scan_dir

if nargin < 2
	root = pwd;
end

files = scan_dir(root, {@helper, type});

if ~nargout
	disp(' '); iterate(@display, files); disp(' '); clear files;
end


%----------------
% HELPER
%----------------

function file = helper(here, type)

content = what_ext(here, type);

if ischar(type)
	type = {type};
end

file = {};

for k = 1:numel(type)
	if ~isfield(content, type{k}) || isempty(content.(type{k}))
		continue;
	end
	
	file = [file; strcat(content.path, filesep, content.(type{k}))]; %#ok<AGROW>
end


%----------------
% DISPLAY
%----------------

function display(file)

disp(['<a href="matlab:show_file(''', file, ''');">', file, '</a>']);
