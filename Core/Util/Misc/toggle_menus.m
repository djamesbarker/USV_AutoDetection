function state = toggle_menus(h)

% toggle_menus - toggle display of figure menus
% ---------------------------------------------
%
% state = toggle_menus(h)
%
% Input:
% ------
%  h - figure handle
%
% Output:
% -------
%  state - menu display state

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

%--
% check for handle and figure
%--

if (~ishandle(h))	
	state = 0; return;
end

if (~strcmp(get(h,'type'),'figure'))
	state = 0; return;
end

%--
% get top level menus of figure
%--

% NOTE: we check for menus which are figure children

g = get(h,'children');

g = findobj(g,'type','uimenu','parent',h); 

% NOTE: return empty when figure has no top level menus

if (isempty(g))
	state = []; return;
end

%--
% toggle visibility of menus
%--

state = cell(length(g),2);

for k = 1:length(g)
	
	label = get(g(k),'label');
	
	switch (get(g(k),'visible'))
	
		case ('on')
			state(k,:) = {label; 'off'};
			set(g(k),'visible','off');
			
		case ('off')
			state(k,:) = {label; 'on'};
			set(g(k),'visible','on');
			
	end
	
end
