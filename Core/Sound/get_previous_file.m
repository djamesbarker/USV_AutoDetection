function [file,ix] = get_previous_file(sound,time)

% get_previous_file - get previous file from specific time
% --------------------------------------------------------
%
% [file,ix] = get_previous_file(sound,time)
%
% Input:
% ------
%  sound - sound
%  time - sound time
%
% Output:
% -------
%  file - previous file from sound time
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

% NOTE: previous file is previous or the same

[file,ix] = get_current_file(sound,time);

if (ischar(sound.file) || (ix == 1))
	return;
end

file_time = get_file_times(sound, file);

if file_time >= map_time(sound, 'real', 'slider', time)
	ix = ix - 1;
end

file = sound.file{ix};
	
