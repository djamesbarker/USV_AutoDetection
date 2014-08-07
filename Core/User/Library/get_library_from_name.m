function [lib, user] = get_library_from_name(name, user)

% get_library_from_name - get library from its full user/library name
% -------------------------------------------------------------------
%
% [lib, user] = get_library_from_name(name, user)
%
% Input:
% ------
%  name - full library name string
%  user - user in context
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

%--------------------------------
% Author: Matt Robbins
%--------------------------------
% $Revision: 1632 $
% $Date: 2005-08-23 13:09:06 -0400 (Tue, 23 Aug 2005) $
%--------------------------------

if nargin < 2
	user = get_active_user;
end

%--
% handle multiple inputs recursively
%--

if iscell(name)
	
	% NOTE: consider output of multiple users? 
	
	lib = empty(library_create); users = empty(user_create);
	
	for k = 1:length(name)	
		[lib(end + 1), users(end + 1)] = get_library_from_name(name{k}, user);
	end
	
	user = users; return;

end
	
%--
% parse string
%--

info = parse_tag(name, filesep, {'author', 'libname'});

% NOTE: in this case the library name is simple, it does not contain the user

if isempty(info.libname)
	lib = get_libraries(user, 'name', info.author); return;	
end

%--
% get user and then library
%--

% NOTE: in this case user and library name are obtained from 'name' string input

user = get_users('name', info.author); 

lib = get_libraries(user, 'name', info.libname);

