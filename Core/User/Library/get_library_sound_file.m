function [file, test] = get_library_sound_file(lib, name)

% get_library_sound_file - get location of sound file in library
% --------------------------------------------------------------
%
% [file, test] = get_library_sound_file(lib, name)
%
% Input:
% ------
%  lib - library 
%  name - name of sound
%
% Output:
% -------
%  file - location of sound file in library
%  test - file existence test

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
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

if (nargin < 2)
	error('Sound name input is required.');
end

%--
% set library to active library
%--

if (nargin < 1) || isempty(lib)
	lib = get_active_library;
end
	
%--
% handle multiple sounds recursively
%--

if iscellstr(name)
		
	file = cell(length(name), 1);
	
	for k = 1:length(name)
		file{k} = get_library_sound_file(lib, name{k});
	end 
	
	return;
	
end

%--
% check sound name
%--

if ~ischar(name)
	error('Sound name input must be string of string cell array.');
end

%-----------------------------------
% BUILD SOUND FILE LOCATION
%-----------------------------------

%--
% build sound file name
%--

file = [lib.path, name, filesep, name, '.mat'];

%--
% test for file existence
%--

if (nargout > 1)
	test = exist(file, 'file');
end
