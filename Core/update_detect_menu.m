function flag = update_detect_menu

% update_detect_menu - update detect menu for open browsers
% ---------------------------------------------------------
%
% update_detect_menu

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
% $Revision: 1814 $
% $Date: 2005-09-21 15:24:01 -0400 (Wed, 21 Sep 2005) $
%--------------------------------

%--
% get handles to open browser figures
%--

if (nargin < 1)
	par = get_xbat_figs('type', 'sound');
end

% NOTE: return if there is nothing to update

if isempty(par)
	return;
end

%--
% destroy and create filter menus
%--

% NOTE: this destroys any detector state stored in browsers, change this

for k = 1:length(par)
	
	%--
	% find parent menu
	%--
	
	menu = findobj(par(k), 'type', 'uimenu', 'label', 'Detect');
	
	if isempty(menu)
		continue;
	end
	
	%--
	% kill all children then parent
	%--
	
	try
		delete(allchild(menu)); delete(menu);
	end
		
	%--
	% recreate filter menu
	%--
	
	browser_detect_menu(par(k));
	
end
