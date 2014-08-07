function lib = add_library(lib)

% add_library - add library to system
% -----------------------------------
%
% lib = add_library(lib)
%
% Input:
% ------
%  lib - library to add
%
% Output:
% -------
%  lib - library added

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
% $Revision: 5153 $
% $Date: 2006-06-01 18:48:31 -0400 (Thu, 01 Jun 2006) $
%--------------------------------

% TODO: consider the problem of updating path information after relocation

%--------------------------------
% HANDLE INPUT
%--------------------------------

if ((nargin < 1) || isempty(lib))
	lib = []; return;
end

%--------------------------------
% ADD LIBRARY TO FILE SYSTEM
%--------------------------------

%--
% get library root directory
%--

lib_path = create_dir(lib.path);

if (isempty(lib_path))
	error('Unable to create library root directory.');
end 

%--
% create library file
%--

% NOTE: the library path should not include the trailing filesep, but it does

file = get_library_file(lib);

% NOTE: loads the 'lib' variable from library file when library exists

if (exist(file,'file'))
	
	load(file);  	
	
	if ~strcmp(lib_path, lib.path)
		lib.path = lib_path;
	end
	
% 	if isempty(get_users('name', lib.author))
% 		author = get_active_user;
% 		lib.author = author.name;
% 	end
	
	save(file, 'lib');
	
	get_library_sounds(lib, 'refresh');
	
else

	save(file,'lib');

end



