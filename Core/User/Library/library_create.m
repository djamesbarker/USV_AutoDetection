function lib = library_create(name, user, root)

% library_create - create library structure
% -----------------------------------------
%
% lib = library_create(name, user, root)
%
% Input:
% ------
%  name - name of library or library path
%  user - user creating library (def: active user)
%  root - root directory of library (def: in user home libraries if not provided in name)
%
% Output:
% -------
%  lib - library structure

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

% TODO: add library fields to contain summary information

%---------------------------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------------------------

%--
% return empty library structure
%--

% TODO: this is used in import update operations 

if (nargin < 1)
	lib = library_create_in; return;
end

%--
% check name
%--

if isempty(name)
	error('A name must be provided to create a library.');
end

% NOTE: name is an existing directory or a proper filename

if exist_dir(name) && nargin < 3

	[root, name] = path_parts(name);
	
elseif ~proper_filename(name)
	
	error('Library name must be an existing directory or a proper filename.');
	
end

%--
% get active user as default
%--

if (nargin < 2) || isempty(user)
	user = get_active_user;
end

if isempty(user)
	error('There is no user to author library.');
end

%--
% set default library location
%--

% NOTE: second condition makes sure we don't overwrite name extracted root

if (nargin < 3) && ~exist('root', 'var')
	
	% NOTE: we create the user default directory if needed
	
	root = create_dir(user_root(user, 'lib'));
	
	if isempty(root)
		error('Unable to create default user libraries directory.');
	end
	
end

%--
% get root interactively
%--

% NOTE: this happens when we are passed an empty root input

if isempty(root)

	root = uigetdir( ...
		pwd, 'Select XBAT library directory' ...
	);

	% NOTE: return empty and silently on cancel

	if ~root
		lib = []; return;
	end

end

%--
% check for existing root
%--

% NOTE: at the moment suggested root must exist

if ~exist_dir(root)
	error('Unable to find library root directory.');
end

%--
% check proposed directory
%--

% NOTE: an directory must be empty or already a library

lib_path = [root, filesep, name, filesep];

if exist_dir(lib_path) && ~isempty_dir(lib_path) && ~is_library_dir(lib_path)
	lib = []; return;
end
	
%---------------------------------------------------------------------
% CREATE LIBRARY STRUCTURE
%---------------------------------------------------------------------

lib = library_create_in;

%--------------------------------
% PRIMITIVE FIELDS
%--------------------------------

% NOTE: the library has an 'id', however it is typically identified by the path

lib.name = name;

lib.path = lib_path;

%--------------------------------
% ADMINISTRATIVE FIELDS
%--------------------------------

lib.author = user.name;

lib.user = {user.name}; 


%---------------------------------------------------------------------
% LIBRARY_CREATE_IN
%---------------------------------------------------------------------

function lib = library_create_in

%--------------------------------
% PRIMITIVE FIELDS
%--------------------------------

% NOTE: the library has an 'id', however it is typically identified by the path

lib.type = 'library';

rand('state', sum(100*clock));

lib.id = round(rand * 10^12);

lib.name = '';

lib.path = '';

%--------------------------------
% ADMINISTRATIVE FIELDS
%--------------------------------

lib.author = [];

lib.user = []; 

lib.created = now;

lib.modified = [];

%--------------------------------
% METADATA FIELDS
%--------------------------------

% TODO: implement library measurement and metadata

% lib.annotation = annotation_create; % array of annotation structures
% 
% lib.measurement = measurement_create; % array of measurement structures

%--------------------------------
% USERDATA FIELD
%--------------------------------

lib.userdata = []; % userdata field is not used by system
