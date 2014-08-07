function [in, created] = create_dir(in)

% create_dir - create a directory and required parents
% ----------------------------------------------------
%
% [out, created] = create_dir(in)
%
% Input:
% ------
%  in - directory path
%
% Output:
% -------
%  out - path if directory exists, empty if not
%  created - creation indicator

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

%-----------------
% HANDLE INPUT
%-----------------

%--
% check for existence of directory
%--

if exist_dir(in)
	created = 0; return;
end

%-----------------
% CREATE DIR
%-----------------

%--
% separate path into parent and leaf
%--

[par, leaf] = path_parts(in); 

%--
% consider parent recursively
%--

par = create_dir(par);

% NOTE: return on failure to create parent

if isempty(par)
	in = []; created = -1; return;
end

%--
% create directory as leaf of parent
%--

mkdir(par, leaf); created = 1;
