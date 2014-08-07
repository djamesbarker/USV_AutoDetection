function [libs, user] = get_libraries(user, varargin)

% get_libraries - get and select libraries from user
% --------------------------------------------------
%
% libs = get_libraries(user)
%      = get_libraries(user, 'field', value, ...)
%
% Input:
% ------
%  user - input user (def: active user)
%  field - library field name
%  value - library field value
%
% Output:
% -------
%  libs - selected libraries

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
% $Revision: 4335 $
% $Date: 2006-03-21 12:12:34 -0500 (Tue, 21 Mar 2006) $
%--------------------------------

%------------------------------------
% HANDLE INPUT
%------------------------------------

%--
% set default active user
%--

if (nargin < 1) || isempty(user)
	user = get_active_user;
end

active = isequal(user, get_active_user);

% NOTE: return quickly on empty user

if isempty(user)
	libs = []; return;
end

%------------------------------------
% GET USER LIBRRARIES
%------------------------------------

%--
% get libraries paths from user
%--

path = user.library;

% NOTE: return quickly on no library paths

if isempty(path)
	libs = []; return;
end

%--
% get libraries from paths
%--

libs = {};

for k = 1:numel(path)
	
	%--
	% load library if possible
	%--
		
	[root, name] = path_parts(path{k});
	
	file = get_library_file(root, name); 
		
	lib = load_library(file);
				
	%--
	% try to find missing libraries
	%--
	
	if isempty(lib)	
		
		str = {...
			['Unable to find library.''' name ''', '], ...
			'Would you like to find it?' ...
		};

		out = quest_dialog(double_space(str),' Missing Library','Cancel');
		
		if strcmp(out, 'Yes')
			[lib, user] = library_relocate(user, path{k});
		end	
			
	end	

	libs{end + 1} = lib;	
	
end

libs = [libs{:}];

user.library = {libs.path};

user_save(user);

if active
	set_env('xbat_user', user);
end

%--
% return if there are no selection criteria
%--

if isempty(varargin)
	return;
end

%---------------------------------------------------------------
% SELECT FROM AVAILABLE LIBRARIES
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
	
	if isfield(libs(1), field{j})
		
		%--
		% check library fields for value match
		%--
		
		for k = length(libs):-1:1
			
			if ~isequal(libs(k).(field{j}), value{j})
				libs(k) = [];
			end
			
		end
		
	end
end
