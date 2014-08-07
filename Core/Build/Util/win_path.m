function path = win_path;

% win_path - get windows path
% ---------------------------
%
% path = win_path
%
% Output:
% -------
%  path - cell array with elements of windows path

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
% $Revision: 879 $
% $Date: 2005-03-31 18:20:23 -0500 (Thu, 31 Mar 2005) $
%--------------------------------

%--
% get path from system
%--

[ignore,path] = system('path');

%--
% pack string into cell array
%--

% NOTE: remove 'PATH=' prefix and 'end of line' the split at semicolons

path = strread(path(6:(end - 1)),'%s','delimiter',';');
