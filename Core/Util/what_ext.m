function out = what_ext(source, varargin)

% what_ext - get directory content information using extensions
% -------------------------------------------------------------
%
% out = what_ext(source, ext1, ..., extN)
%
% Input:
% ------
%  source - source directory 
%  ext - desired file extensions
%
% Output:
% -------
%  out - structure with path, file extensions, and dir

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
	ext = varargin;
end

%--
% check for insensitive comparison
%--

% NOTE: the last argument may ask us to be insensitive

if iscell(ext) && strcmpi(ext{end}, 'insensitive')
	compare = @strcmpi; ext = ext(1:end - 1);
else
	compare = @strcmp;
end

%-----------------
% GET CONTENTS
%-----------------

%--
% output path field 
%--

out.path = source;

%--
% get directory contents
%--

content = dir(source); 

% NOTE: this removes self and parent directory references

content = content(3:end); 

%--
% get children directory contents
%--

D = {};

for k = length(content):-1:1
	
	if content(k).isdir
		D{end + 1} = content(k).name; content(k) = [];
	end
	
end

out.dir = flipud(D(:));

if isempty(ext)
	return;
end

%--
% get files with specified extensions
%--

for i = 1:length(ext)
	
	%--
	% create list of selected filenames
	%--
	
	L = {};
	
	for k = length(content):-1:1
		
		%--
		% get extension from name
		%--
		
		ix = findstr(content(k).name, '.');
		
		% NOTE: file has no extension in name
		
		if isempty(ix)
			continue;
		end
		
		r = content(k).name(ix(end) + 1:end);
		
		%--
		% select file based on extension
		%--
		
		% NOTE: consider making this case insensitive, at least optional
		
		if compare(r, ext{i})
			L{end + 1} = content(k).name; content(k) = [];
		end
		
	end
	
	L = flipud(L(:));
		
	%--
	% put cell array into field
	%--
	
	out.(ext{i}) = L;

end
