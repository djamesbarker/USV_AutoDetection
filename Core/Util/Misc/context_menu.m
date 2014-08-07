function handle = context_menu(par)

% context_menu - get context menu for object, create if needed
% ------------------------------------------------------------
%
% handle = context_menu(par)
%
% Input:
% ------
%  par - context menu parent handle 
%
% Output:
% -------
%  handle - context menu handle 

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
% $Revision: 587 $
% $Date: 2005-02-22 23:28:55 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% deal with parent handle array recursively
%--

if (numel(par) > 1)
	
	% NOTE: we use a cell array for the output handles so we can return empty

	handle = cell(size(par));
	
	for k = 1:numel(par)
		handle{k} = context_menu(par(k));
	end
	
	return;
	
end

%--------------------------------
% GET OR CREATE CONTEXT MENU
%--------------------------------

%--
% check for context menu capacity in proposed parent
%--

prop = get(par);

name = 'UIContextMenu';

% NOTE: proposed parent cannot hold proposed child, return empty

if (~isfield(prop,name))
	handle = []; return;
end

%--
% get current context menu
%--

handle = prop.(name);

%--
% create context menu if none was available
%--

% NOTE: create context menu with common parent figure and attach

if (isempty(handle))
	
	handle = uicontextmenu('parent',ancestor(par,'figure')); set(par,name,handle);
	
end

