function value = is_library_dir(in)

% value - checks whether a specified in is a library
% --------------------------------------------------
%
% value = is_library_dir(in)
%
% Input:
% ------
%  in - directory to check (def: pwd)
%
% Output:
% -------
%  value - library directory indicator

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
% $Revision: 4391 $
% $Date: 2006-03-27 13:52:56 -0500 (Mon, 27 Mar 2006) $
%--------------------------------

%-------------------------------
% HANDLE INPUT
%-------------------------------

%--
% set default and check for existence
%--

if (nargin < 1)
	in = pwd;
end

if (~exist_dir(in))
	error('Input directory does not exist.');
end

%-------------------------------
% TEST AND RETURN
%-------------------------------

%--
% check for library file
%--

[root,name] = path_parts(in);

file = get_library_file(root,name);

if (~exist(file,'file'))
	value = 0; return;
end

%--
% try to load library file
%--

if (isempty(load_library(file)))
	value = 0; return;
end

%--
% we loaded the library, it's a library
%--

value = 1;




