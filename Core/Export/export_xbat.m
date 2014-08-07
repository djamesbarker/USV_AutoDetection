function export_xbat(users, root, view)

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

if (nargin < 3) || isempty(view)
	view = 'default';
end

%--
% set root if needed
%--

% NOTE: the default value uses the export root repository

if (nargin < 2) || isempty(root)
	root = export_root;
end

%--
% set users to export
%--

% NOTE: default is active user

if (nargin < 1)
	users = get_active_user;
end

% NOTE: return if there is nothing to export

if isempty(users)
	return;
end

%--------------------------------
% EXPORT XBAT
%--------------------------------

%--
% create root directory if needed
%--

root = create_dir([root, filesep, 'XBAT']);

% NOTE: return if we were unable to create root

if isempty(root)
	return;
end

%--
% create main page
%--

% NOTE: package template variables in data

data.users = users;

out = 'index.html';

% NOTE: process view main and place result in root

process_template(view, 'main', data, root, out);

%--
% export users
%--

for user = users
	export_user(user, root, view);
end
