function [lib, cancel] = migrate_libraries(source, user)

% migrate_libraries - migrate user libraries
% ------------------------------------------
% 
% lib = migrate_libraries(source, user)
%
% Input:
% ------
%  source - source libraries root
%  user - user requesting library migration
%
% Output:
% -------
%  lib - migrated libraries

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

%--
% get active user if needed
%--

if nargin < 2 || isempty(user)
	user = get_active_user;
end

%--
% pack into cell
%--

if ischar(source)
	source = {source};
end

names = dir_name(source);

%--
% migrate libraries
%--

lib = {}; cancel = 0;

migrate_wait('Libraries', length(source), names{1});

for k = 1:length(source)
	
	[lib{end + 1}, cancel] = migrate_library(source{k}, user); 
	
	if cancel
		break;
	end
	
end

lib = [lib{:}];
