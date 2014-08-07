function [lib, user] = get_user_library(name)

% get_user_library - get library from full name
% ---------------------------------------------
%
% [lib, user] = get_user_library(name)
%
% Input:
% ------
%  name - full library name
%
% Output:
% -------
%  lib - library
%  user - user

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

%----------------------
% HANDLE INPUT
%----------------------

% TODO: check for proper full library name

lib = []; user = [];

%----------------------
% GET LIBRARY
%----------------------

%--
% get user and library name from full library name
%--

info = parse_tag(name, filesep, {'user', 'name'}); 

user = info.user;

name = info.name;

%--
% get actual user and library
%--

user = get_users('name', user);

if isempty(user)
	return;
end

lib = get_libraries(user, 'name', name);
