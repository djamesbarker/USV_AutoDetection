function file = library_save(lib)

% library_save - save library data to file
% -----------------------------------------
%
% file = library_save(lib)
%
% Input:
% ------
%  lib - library to save
%
% Output:
% -------
%  file - library file

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
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------

%--
% handle multiple libraries recursively
%--

if (numel(lib) > 1)

	for k = 1:numel(lib)
		file{k} = library_save(lib(k));
	end
	
	return;
	
end

%--
% create library file path and update modification date
%--

lib.modified = now;

file = get_library_file(lib);

%--
% save library data to file
%--

% TODO: consider output of library file info

try
	save(file, 'lib');
catch
	file = ''; disp(['WARNING: Failed to save library ''', lib.name, ''' to file.']);
end

