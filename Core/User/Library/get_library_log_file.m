function file = get_library_log_file(lib, sound, name)

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

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

if nargin < 3
	error('Sound name input is required.');
end

if isstruct(sound)
	sound = sound_name(sound);
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
		file{k} = get_library_log_file(lib, sound, name{k});
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
% BUILD LOG FILE LOCATION
%-----------------------------------

%--
% build log file name
%--

file = [lib.path, sound, filesep, 'Logs', filesep, name, '.mat'];

