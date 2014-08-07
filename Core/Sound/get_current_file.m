function [file, ix] = get_current_file(sound, time)

% get_current_file - get file at specific time
% --------------------------------------------
%
% [file, ix] = get_current_file(sound, time)
%
% Input:
% ------
%  sound - sound
%  time - slider time
%
% Output:
% -------
%  file - file at sound time
%  ix - index of file in sound files

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

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% check input time to be non-negative
%--

if time < 0
	error('Sound times are always positive.');
end

%--
% single file sounds are special
%--

if ischar(sound.file)
	ix = 1; file = sound.file; return;
end

%---------------------------
% GET CURRENT FILE
%---------------------------

%--
% get file start sound times
%--

% NOTE: get_file_times.m was written to accept 'real' time

time = map_time(sound, 'real', 'slider', time);

start = get_file_times(sound);

%--
% locate time within file start times
%--

ix = find(time >= start, 1, 'last'); 

file = sound.file{ix};
