function export_user(user,root,view)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

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
% HANDLE INPUT
%--------------------------------

%--
% set default view
%--

% NOTE: the name default is a convention

if ((nargin < 3) || isempty(view))
	view = 'default';
end

%--------------------------------
% EXPORT USER
%--------------------------------

%--
% create users root directory if needed
%--

% NOTE: this creates the user parent directory if needed

user_root = create_dir([root, filesep, 'User', filesep, user.name]);

if (isempty(user_root))
	return;
end

%--
% create user page
%--

% data.id = user.id;

data.user = user;

out = 'index.html'

process_template(view,'user',data,user_root,out);

%--
% export user linked libraries
%--

libs = get_libraries(user);

for lib = libs
	export_library(lib,root,view);
end
