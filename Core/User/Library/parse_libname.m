function [lib, usr] = parse_libname(str)

% parse_libname - parse a libray name into [user, library]
% --------------------------------------------------------
%
% [usr,lib] = parse_libname(str)
%
% Inputs:
% ------
% str - the name string
%
% Outputs:
% --------
% usr - the name of owner of the library
% lib - the name of the library

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
% $Revision: 4335 $
% $Date: 2006-03-21 12:12:34 -0500 (Tue, 21 Mar 2006) $
%--------------------------------

if (~nargin || ~isstr(str))
	error('input must exist and be a string');
end

[usr, lib] = strtok(str, filesep);

if isempty(lib)	
	lib = usr;
	usr = [];
	return;	
end

lib = lib(2:end);

