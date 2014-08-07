function names = library_name_list(user, mode)

% library_name_list - get list of library names for a given user
% --------------------------------------------------------------
%
% names = library_name_list(user, mode)
%
% Input:
% ------
%  user - user
%  mode - {'display', 'full'}
%
% Output:
% -------
%  names - library names

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

if nargin < 2 || isempty(mode)
	mode = 'display';
end

if nargin < 1 || isempty(user)
	user = get_active_user;
end

%--
% handle multiple inputs recursively
%--

if length(user) > 1
	
	names = {};
	
	for j = 1:length(user)
		list = library_name_list(user(j), 'own');
		names = {names{:}, list{:}};
	end
	
	return;
	
end
		
%--
% get user libraries
%--

library = get_libraries(user);

if isempty(library)
	names = {'(No Libraries)'};
end

%--
% build library name using author and library names
%--

names = cell(0);

for j = 1:length(library)
	
	switch (mode)
		
		case ('display'), names{end + 1} = get_library_name(library(j), user);
			
		case ('full'), names{end + 1} = get_library_name(library(j));
			
		case ('own')	
			
			if ~strcmpi(library(j).author, user.name)
				continue;
			end
			
			names{end + 1} = get_library_name(library(j));
			
	end
	
end

%--
% put default on top
%--

ix = find(strcmp('Default', names));

if ~isempty(ix)
	names(ix) = []; names = {'Default', names{:}};
end

