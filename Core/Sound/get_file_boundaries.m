function [times, files, ix] = get_file_boundaries(sound, time, duration)

% get_file_boundaries - get sound file boundaries
% -----------------------------------------------
%
% [times, files, ix] = get_file_boundaries(sound, time, duration)
%
% Input:
% ------
%  sound - input sound
%  time - start of slider time interval
%  duration - duration of slider time interval
%
% Output:
% -------
%  times - boundary times
%  files - boundary files
%  ix - file indices

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

%--
% get all file start times and files
%--

% NOTE: this outputs a time for the end of the stream, remove it

times = get_file_times(sound); times(end) = [];

times = map_time(sound, 'slider', 'real', times); files = sound.file;

if ischar(files)
	files = {files};
end

%--
% select boundaries within interval
%--

% NOTE: we do not need the file boundary at the end of the interval

ix = find((times >= time) & (times < time + duration));

times = times(ix); files = files(ix);
		
