function edit_dir(in, fun)

% edit_dir - edit all files in directory
% --------------------------------------
%
% edit_dir(in, fun)
%
% Input:
% ------
%  in - directory to get files from (def: pwd)
%  fun - edit function

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

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% set default edit function
%--

if nargin < 2
	fun = @edit;
end

%--
% set default directory
%--

if nargin < 1
	in = pwd;
end

%--
% check directory exists
%--

if ~exist_dir(in)
	error('Unable to find input directory.');
end 

%--------------------------
% OPEN FILES FOR EDIT
%--------------------------

% TODO: make the edit function return the editable file extensions

% NOTE: consider making the editable file extension as an input

% NOTE: these are the files currently supported by the matlab editor

editable = {'m','c','html'};

%--
% get files in directory
%--

files = dir(in);

% NOTE: we remove dot files and directories

files(strmatch('.', {files.name})) = []; files([files.isdir]) = [];

files = strcat(in, filesep, {files.name});

%--
% call edit function on each of the files
%--

for k = 1:length(files) 
	fun(files{k});
end

