function out = what_ext(source, varargin)

% what_ext - directory content with specified extensions
% ------------------------------------------------------
%
% out = what_ext(source, ext, ... , 'insensitive')
%
% Input:
% ------
%  source - source directory 
%  ext - file extensions
%
% Output:
% -------
%  out - structure with path, file extensions, and dir
%
% NOTE: 'insensitive' as the last input allows case-insensitive extension match
%
% See also: what

%-----------------
% HANDLE INPUT
%-----------------

%--
% set directory
%--

if (nargin < 1) || isempty(source)
	source = pwd;
end

%--
% set extensions to search
%--

if length(varargin) < 1
	ext = [];
else
	% NOTE: why do we have to free ourselves here?
	
	ext = cellfree(varargin);
	
	if ischar(ext)
		ext = {ext};
	end
end

%--
% check for insensitive comparison
%--

% NOTE: the last argument may ask us to be insensitive

if iscell(ext) && strcmpi(ext{end}, 'insensitive')
	
	compare = @strcmpi; ext(end) = [];
else
	compare = @strcmp;
end

%-----------------
% GET CONTENTS
%-----------------

out.path = source;

%--
% get directory contents
%--

% NOTE: the second statement removes self and parent directory references

content = dir(source); content = content(3:end); 

%--
% get child directory content
%--

dirs = {};

for k = length(content):-1:1
	
	if content(k).isdir
		dirs{end + 1} = content(k).name; content(k) = []; %#ok<*AGROW>
	end
end

out.dir = flipud(dirs(:));

if isempty(ext)
	return;
end

%--
% get files with specified extensions
%--

for i = 1:length(ext)

	files = {};
	
	for k = length(content):-1:1	
		%--
		% get extension from name
		%--
		
		ix = findstr(content(k).name, '.');

		if isempty(ix) % NOTE: file has no extension in name
			continue;
		end
		
		current = content(k).name(ix(end) + 1:end);
				
		%--
		% select file based on extension
		%--
		
		if compare(current, ext{i})
			files{end + 1} = content(k).name; content(k) = [];
		end		
	end
	
	%--
	% align file list and pack into extension field
	%--
	
	% NOTE: that fields for extensions with no files will not exist
	
	files = flipud(files(:));

	out.(ext{i}) = files;
end
