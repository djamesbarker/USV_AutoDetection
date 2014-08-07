function handles = action_menu(par, type)

% action_menu - attach actions to actions menu
% --------------------------------------------
%
% handles = action_menu(par, type)
%
% Input:
% ------
%  par - action menus parent 
%  type - action type
%
% Output:
% -------
%  handles - handles

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

%------------------
% HANDLE INPUT
%------------------

if ~is_action_type(type)
	error('Unrecognized action type.');
end

%------------------
% CREATE MENU
%------------------

%--
% prepare parent by clearing children and callback
%--

delete(allchild(par)); set(par, 'callback', []);

%--
% get actions
%--

ext = get_extensions([type, '_action']);

% NOTE: return early creating informative menu

handles = [];

if isempty(ext)
	handles(end + 1) = uimenu(par, 'label', '(No Actions Found)', 'enable', 'off'); return;
end

%--
% create action menus
%--

% TODO: create categorical action menus, perhaps further organization

for k = 1:length(ext)
	
	% NOTE: add menus to control framework, tag information helps for now
	
	handles(end + 1) = uimenu(par, ...
		'label', ext(k).name, ...
		'tag', ext(k).name, ...
		'callback', {@action_dispatch, type} ...
	);

end
