function users = get_users(varargin)

% get_users - get and select available users
% ------------------------------------------
%
% users = get_users
%       = get_users('field', value, ...)
%
% Input:
% ------
%  field - user field name
%  value - user field value
%
% Output:
% -------
%  users - selected available users

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
% $Revision: 2025 $
% $Date: 2005-10-27 16:35:03 -0400 (Thu, 27 Oct 2005) $
%--------------------------------

%---------------------------------------------------------------
% GET AVAILABLE USERS
%---------------------------------------------------------------

%--
% get potential user root directories
%--

roots = dir(users_root);

% NOTE: remove directory pointers

roots = roots(3:end);

% NOTE: remove non directory children and known non user directories

for k = length(roots):-1:1
	
	if ~roots(k).isdir || strcmp(roots(k).name, '.svn') || strcmp(roots(k).name, '__BACKUP')
		roots(k) = [];
	end

end

%--
% return empty if we find no users
%-

if isempty(roots)
	users = default_user; return;
end

%--
% get users from user files
%--

% NOTE: create empty users array

users = empty(user_create);

for k = 1:length(roots)
	
	% NOTE: handle corrupt and missing user files with an exception
	
	try

		load([user_root(roots(k).name), filesep, roots(k).name, '.mat']);

		users(end + 1) = user;
		
	catch

		warning(['Failed to load user ''' roots(k).name ''' from user file.  ', lasterr]);
		
	end
	
end

%--
% return empty on no users
%--

% NOTE: should we try to create the default user here?

if isempty(users)
	users = []; return;
end

%--
% return if there are no selection criteria
%--

if isempty(varargin)
	
	if (nargout < 1)
		user_disp(users)
	end

	return;
	
end

%---------------------------------------------------------------
% SELECT FROM AVAILABLE USERS
%---------------------------------------------------------------

%--
% extract selection field value pairs
%--

[field, value] = get_field_value(varargin);

%--
% loop over selection fields
%--

for j = 1:length(field)
	
	%--
	% use field if it is in fact a library field
	%--
	
	if isfield(users(1), field{j})
		
		%--
		% check library fields for value match
		%--
		
		for k = length(users):-1:1
			if ~isequal(users(k).(field{j}), value{j})
				users(k) = [];
			end
		end
		
	end
end

if (nargout < 1)
	user_disp(users)
end


%---------------------------------------------------------------
% USER_DISP
%---------------------------------------------------------------

function user_disp(users)

% user_disp - user display function
% ---------------------------------

%--
% get active user
%--

active = get_active_user;

% TODO: improve active user display, and display overall

disp(' ')
disp('------------');
disp(' XBAT USERS ');
disp('------------');
disp(' ')

for k = 1:length(users)
	
	user = users(k); library = get_libraries(user);
	
	%--
	% display user info
	%--
	
	str = user.name;
	
	if isfield(user, 'email') && ~isempty(user.email)
		str = [str, ' (', user.email, ')'];
	end
	
	if strcmp(user.name, active.name)
		str = [str, ' **ACTIVE**'];
	end
	
	disp(str);
	str_line(length(str));

	%--
	% display user libraries info
	%--
	
	for j = 1:length(library)
		
		% TODO: library summary should be computed once for each unique library
		
		info = get_library_summary(library(j));
		
		if j > 1
			disp('  ');
		end
		
		disp(['  ', library(j).name, '(', int2str(info.sounds), ', ', sec_to_clock(info.total_duration) ')']);
		disp(['  ', strrep(library(j).path, xbat_root, '$XBAT_ROOT')]);
		
	end
	
	disp(' ');
	
end

disp(' ');
