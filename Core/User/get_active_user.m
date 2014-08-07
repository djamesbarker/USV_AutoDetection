function user = get_active_user

% get_active_user - get currently active user
% -------------------------------------------
%
% user = get_active_user
%
% Output:
% -------
%  user - currently active user

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

%--
% get active user
%--

user = get_env('xbat_user');
	
%--
% consider no active user case
%--

if isempty(user)
	
	%--
	% check for available users
	%--

	users = get_users;

	if isempty(users)

		%--
		% create default user and set to active user when there are no users
		%--
		
		user = default_user;

		if isempty(user)
			error('Failed to create default user.');
		end

	else

		%--
		% set default user or first user
		%--

		user = get_users('name', 'Default');

		if isempty(user)
			user = users(1);
		end

	end

	%--
	% set active user
	%--

	set_env('xbat_user', user(1));
	
end
	
%--
% check user still exists
%--

if ~exist(user_root(user), 'dir')

	%--
	% report and clear missing active user
	%--

% 	disp(['WARNING: User ''' user.name ''' no longer exists.']); 
	
	rm_env('xbat_user', 0);

	%--
	% get active user make sure we have one, this always ends	
	%--

	user = get_active_user;

end
