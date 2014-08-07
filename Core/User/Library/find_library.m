function path = find_library(path)

% find_library - find library that may have been moved
% ----------------------------------------------------
%
% lib = find_library(path)
%
% Input:
% ------
%  path - last known path for library
%
% Output:
% -------
%  path - likely new path for library

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 4286 $
% $Date: 2006-03-15 19:04:03 -0500 (Wed, 15 Mar 2006) $
%--------------------------------

% TODO: the relocation may need some kind of time stamp

%--------------------------------
% HANDLE INPUT
%--------------------------------

% NOTE: consider relocating to default location for active user or author

%--
% return if no new root is provided
%--

if ((nargin < 2) || isempty(root))
	return;
end
