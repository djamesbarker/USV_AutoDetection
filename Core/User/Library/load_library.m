function [lib, info] = load_library(file)

% load_library - load library from file
% -------------------------------------
%
% lib = load_library(file)
%
% Input:
% ------
%  file - library file
%
% Output:
% -------
%  lib - library

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

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% check for library file
%--

% NOTE: return empty if there is no file to load from

if ~exist(file, 'file')
	lib = []; return;
end

%----------------------------
% LOAD LIBRARY FROM FILE
%----------------------------

%--
% load library
%--

content = load(file);

% NOTE: return empty if there is no library in file

if ~isfield(content, 'lib')
	lib = []; return;
end

lib = content.lib;

% TODO: don't add the filesep at the end and deal with the consequences

lib.path = [fileparts(file), filesep];

%--
% load info string
%--

% TODO: store info string library summary in file

if (nargout > 1)
	info = [];
end
