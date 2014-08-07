function test = has_menu(h)

% has_menu - test whether figure has a menu bar
% ---------------------------------------------
%
% test = has_menu(h)
%
% Input:
% ------
%  h - figure handle
%
% Output:
% -------
%  test - menu indicator

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
% $Revision: 915 $
% $Date: 2005-04-05 18:59:46 -0400 (Tue, 05 Apr 2005) $
%--------------------------------

% TODO: generalize this to handles, and possibly output other results

%--
% check for handle and figure
%--

if (~ishandle(h))	
	test = 0; return;
end

if (~strcmp(get(h,'type'),'figure'))
	test = 0; return;
end

%--
% check for top level menus of figure
%--

% NOTE: we check for menus which are figure children

tmp = get(h,'children');

tmp = findobj(tmp,'type','uimenu','parent',h); 

test = ~isempty(tmp);
