function user = set_active_user(user)

% set_active_user - set active user
% ---------------------------------
% 
% user = set_active_user(user)
%
% Input:
% ------
%  user - user to make active
%
% Output:
% -------
%  user - active user

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%-------------------------------
% HANDLE INPUT
%-------------------------------

%--
% output active user when given no input
%--

if (nargin < 1)
	user = get_active_user; return;
end

%--
% check input and get user from input
%--

switch class(user)

	case 'char', user = get_users('name', user);
		
	case 'cell', user = get_users('name', user{1});
	
	case 'struct'

		if ~isfield(user, 'name')
			user = [];
		end

	otherwise, user = []; % NOTE: no proper way to set using input

end

%--
% return active user if no proper way to update
%--

if isempty(user)
	user = get_active_user; return;
end

% TODO: consider warning when we don't find the requested user

%-------------------------------
% SET ACTIVE USER
%-------------------------------

set_env('xbat_user', user);

%--
% Set user's active library
%--

% NOTE: the user can be modified if there is a missing library!

[lib, user] = set_active_library([], user);

%--
% Update controls
%--

update_controls(user);


%-------------------------------
% UPDATE CONTROLS
%-------------------------------

function update_controls(user)

% update_controls - find and update all controls dealing with active user
% -----------------------------------------------------------------------

%-----------------------------------------------
% UPDATE XBAT PALETTE CONTROLS
%-----------------------------------------------

pal = xbat_palette;

if isempty(pal) 
	return;
end

if isempty(user)
	return;
end

%--
% update 'User' control
%--

handles = get_control(pal, 'User', 'handles');

names = user_name_list; ix = find(strcmp(user.name, names));
% %--
% % disable delete user for default user
% %--
% 
% set_control(pal, 'edit_user', ...
% 	'enable', ~strcmp(user.name, 'Default') ...
% );

set(handles.obj, ...
	'string', names, 'value', ix ...
);


%----------------------------------
% UPDATE XBAT USER MENUS
%----------------------------------

session_menu(pal, user);

user_menu(pal);
