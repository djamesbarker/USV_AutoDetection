function root = miktex_root(type)

% miktex_root - get miktex root
% -----------------------------
%
% root = miktex_root(type)
%
% Input:
% ------
%  type - root type 'bin' or 'doc'
%
% Output:
% -------
%  root - root, empty if directory does not exist
% 
% NOTE: to see and change directories edit this file

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
% set default root type
%--

if ~nargin
	type = 'bin';
end

%--
% set default root
%--

switch type
	
	case 'bin'
		root = 'C:\texmf\miktex\bin';
		
	case 'doc'
		root = 'C:\texmf\doc';
		
end

%--
% check for existence of root
%--

if ~exist_dir(root)
	root = '';
end
