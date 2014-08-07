function [lib, user] = set_active_library(lib, user)

% set_active_library - set the active library
% -------------------------------------------
%
%  lib = set_active_library(lib)
%
% Input:
% ------
%  lib - library to set active
%  user - the user for which to set 'lib' as the active library
%
% Output:
% -------
%  lib - the updated library

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------


%----------------------------
% HANDLE INPUT
%----------------------------

if nargin < 2 || isempty(user)
	user = get_active_user;
end

active = isequal(user, get_active_user);

switch class(lib)
	
	case 'char', [lib, user] = get_libraries(user, 'name', lib);
		
	case 'cell', [lib, user] = get_libraries(user, 'name', lib{1});
		
	case 'struct'
		
		if ~isfield(user, 'name')
			user = [];
		end
		
	otherwise, lib = [];
		
end

if nargin < 1 || isempty(lib)	
	[lib, user] = get_active_library(user); 
end

%----------------------------
% SET ACTIVE LIBRARY
%----------------------------

%--
% set user's active library and store user if necessary
%--

[libs, user] = get_libraries(user);

ix = find(strcmp(lib.path, {libs.path}));

%--
% do nothing if specified library is already active
%--
	
if user.active ~= ix

	user.active = ix;

	user_save(user);

	if active
		set_env('xbat_user', user);
	end
	
end

lib = libs(ix);

%--
% update palette controls
%--

update_controls(lib);	


%-----------------------------------------
% UPDATE CONTROLS
%-----------------------------------------

function update_controls(lib)

% update_controls - find and update all controls dealing with library
% -------------------------------------------------------------------

%-----------------------------------------------
% UPDATE XBAT PALETTE CONTROLS
%-----------------------------------------------

pal = xbat_palette;

if isempty(pal) 
	return;
end

if isempty(lib)
	return;
end

user = get_active_user;

%--
% update 'Library' control
%--

handles = get_control(pal, 'Library', 'handles');

names = library_name_list;

ix = find(strcmp(get_library_name(lib, user), names));

if isempty(ix)
	ix = 1;
end

set(handles.obj, ...
	'string', names, ...
	'value', ix ...
);

%--
% disable edit for non-owned libraries
%--

if strcmp(lib.author, user.name)
    set_control(pal, 'edit_library', 'enable', 'on');
else
    set_control(pal, 'edit_library', 'enable', 'off');
end

%--
% disable unsubscribe for default library
%--

if length(names) < 2	
	set_control(pal, 'unsubscribe_user', 'enable', 'off');
else
	set_control(pal, 'unsubscribe_user', 'enable', 'on');
end

%--
% Update Sounds List
%--

set_control(pal, 'find_sounds', 'value', '');

xbat_palette('find_sounds');


