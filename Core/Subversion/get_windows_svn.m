function tool = get_windows_svn

% get_windows_svn - get system installed svn client location
% ----------------------------------------------------------
%
% tool = get_windows_svn
%
% Output:
% -------
%  tool - tool

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

%--
% check for subversion element of path
%--

% NOTE: we assume an install that adds an element to the path with 'subversion'

path = get_windows_path('subversion');

if isempty(path)
	tool = []; return;
end

%--
% try to get tool
%--

root = path{1}; file = fullfile(root, 'svn.exe');

tool = get_tool(file);
