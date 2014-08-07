function [lib, user] = get_active_library(user)

% get_active_library - get currently active library
% -------------------------------------------------
%
% lib = get_active_library
%
% Input:
% ------
%  user - user (def: active user)
%
% Output:
% -------
%  lib - active library

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

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% get active user as default
%--

if ((nargin < 1) || isempty(user))
	user = get_active_user;
end

% NOTE: return empty when no user is available

if (isempty(user))
	lib = []; return;
end

%--
% handle multiple users recursively
%--

if (numel(user) > 1)
	
	for k = 1:numel(user)
		lib(k) = get_active_library(user(k));
	end
	
	return;
	
end

%------------------------------
% GET ACTIVE LIBRARY
%------------------------------

%--
% get active library from user
%--

% NOTE: the 'active' user field contains the active library index


[libs, user] = get_libraries(user); active = user.active;

if active > numel(libs)
	active = 1;
end

lib = libs(active);

