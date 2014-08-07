function args = menu_args(name)

% menu_args - argument description for menu functions
% ---------------------------------------------------
%
% args = menu_args(name)
%
% Input:
% ------
%  name - name of object to display in menu (def: 'obj')
%
% Output:
% -------
%  args - argument description

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%--
% set default name
%--

if (nargin < 1)
	name = 'obj';
end

%--
% create argument description
%--

% NOTE: the first cell contains output names, the second cell input names

% NOTE: input contains menu parent handle, object to display, and display options

% NOTE: output contains handles to created menus

args = {{'handles'}, {'par', name, 'context'}};
