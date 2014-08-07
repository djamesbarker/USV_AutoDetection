function value = isempty_dir(in)

% empty_dir - check whether a directory is empty
% ----------------------------------------------
%
% value = isempty_dir(in)
%
% Input:
% ------
%  in - path to check (def: pwd) 
%
% Output:
% -------
%  value - empty directory indicator

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

%-------------------------------
% HANDLE INPUT
%-------------------------------

%--
% set default and check input exists
%--

if nargin < 1
	in = pwd;
end

if ~exist_dir(in)
	error('Unable to find input directory.');
end

%-------------------------------
% TEST FOR EMPTY
%-------------------------------

%--
% get directory contents and test for empty
%--

content = dir(in);

%--
% return true when there are only pointers
%--

if numel(content) < 3
	value = 1; return;
end

%--
% return false when there are any files
%--

if any(~[content.isdir])
	value = 0; return;
end

%--
% check directory names
%--

% NOTE: everything is a directory here, only allow dot directories

names = {content.name};

for k = numel(names):-1:1
	
	if (names{k}(1) ~= '.')
		value = 0; return;
	end
	
end

% NOTE: if we are here we are empty

value = 1;
