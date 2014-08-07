function delete_extension(in)

% delete_extension - delete_extension from system
% ------------------------------------------------
%
% delete_extension(ext)
%
% delete_extension(root)
%
% Input:
% ------
%  ext - extension
%  root - extension root

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

% TODO: add backup to this operation, it is very dangerous

% TODO: integrate with SVN

%-----------------------------
% HANDLE INPUT
%-----------------------------

%--
% get root from input
%--

if ~ischar(in)
	root = extension_root(in);
else
	root = in;
end

if ~exist_dir(root)
	error('Unable to find extension root directory.');
end

%-----------------------------
% DELETE EXTENSION
%-----------------------------

%--
% recursively remove root from path and then filesystem
%--

remove_path(scan_dir(root));

rmdir(root,'s');

%--
% update extensions cache
%--

get_extensions('!');

% TODO: update extension related menus


%----------------------------
% REMOVE PATH
%----------------------------

function remove_path(remove)

%--
% check remove elements are part of path
%--

current = path_cell;

for k = numel(remove):-1:1
	
	ix = find(strcmp(remove{k}, current));
	
	if isempty(ix)
		remove(k) = [];
	end
	
end

%--
% update path
%--

% NOTE: convert found remove list into path string and remove

rmpath(path_str(remove));


%----------------------------
% PATH_STR
%----------------------------

function out = path_cell(in)

if nargin < 1
	in = path;
end

out = strread(in, '%s', 'delimiter', pathsep);


%----------------------------
% PATH_STR
%----------------------------

% NOTE: this can fail for multiple character path separators, use 'cell_to_path'

function out = path_str(in)

% NOTE: add separators to strings, concatenate, and remove trailing separator

out = strcat(in, pathsep); out = strcat(out{:}); out(end) = [];

