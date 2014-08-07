function libs = get_unique_libraries(users)

% get_unique_libraries - get unique user libraries
% ------------------------------------------------
%
% libs  = get_unique_libraries(users)
%
% Input:
% ------
%  users - array of users (def: all users)
%
% Output:
% -------
%  libs - unique libraries linked to by users

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
% $Revision: 1161 $
% $Date: 2005-07-05 16:25:08 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

% NOTE: consider an independent store for libraries hidden '__MASTER' user

%-----------------------------
% HANDLE INPUT
%-----------------------------

%--
% set default users to be all users
%--

if (nargin < 1)
	users = get_users;
end

% NOTE: return empty when there are no users

if (isempty(users))
	libs = []; return;
end

%-----------------------------
% GET UNIQUE LIBRARIES
%-----------------------------

%--
% get libraries linked to by users
%--

libs = [];

for user = users

	%--
	% get user libraries
	%--

	lib = get_libraries(user);
	
	if (isempty(lib))
		continue;
	end
	
	%--
	% append user libraries to list
	%--
	
	if (isempty(libs))
		libs = lib;
	else
		libs = [libs, lib];
	end
	
end

%--
% get unique libraries
%--

% NOTE: we get unique libraries based on unique paths

[ignore,ix] = unique({libs.path}');

libs = libs(ix);

