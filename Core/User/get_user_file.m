function file = get_user_file(user, root)

% get_user_file - get user file name
% ----------------------------------
%
% file = get_user_file(user, root)
%
%      = get_user_file(name, root)
%
% Input:
% ------
%  user - user
%  name - name
%  root - parent application root (def: xbat_root)
%
% Output:
% -------
%  file - user file name

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

%---------------------
% HANDLE INPUT
%---------------------

%--
% set application root
%--

if nargin < 2
	root = xbat_root;
end

%--
% handle user input
%--

switch class(user)
	
	case 'char'
		
		name = user;
		
		if ~proper_filename(name)
			error('User name must be a proper filename.');
		end
		
	case 'struct'
		
		if ~isfield(user, 'name')
			error('Input does not seem to be user.');
		end
		
		name = user.name;
		
	otherwise, error('User input must be user or user name.');
		
end

%---------------------
% USER FILE
%---------------------

file = [users_root(root), filesep, name, filesep, name, '.mat'];

