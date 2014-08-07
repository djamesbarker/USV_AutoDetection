function str = page_time_string(page, sound, grid, interval)

% page_time_string - generate string to describe a scan page
% ----------------------------------------------------------
%
% str = page_time_string(page, sound, grid, interval)
%
% Input:
% ------
%  page - the page
%  sound - the sound (for time mapping)
%  grid - the grid, for string format
%  interval - 0: display only start time, 1: display interval
%
% Output:
% -------
%  str - string

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

if nargin < 4
	interval = 0;
end

if (nargin < 3) || isempty(grid)
	grid = [];
end

%--
% map start time
%--

start_time = map_time(sound, 'slider', 'record', page.start);

%--
% generate start time string using grid
%--

if isempty(grid)
	start_str = sec_to_clock(start_time);
else
	start_str = get_grid_time_string(grid, start_time, sound.realtime);
end

if ~interval
	str = start_str; return;
end

%--
% map end time
%--

end_time = map_time(sound, 'slider', 'record', page.start + page.duration);

%--
% generate end time string
%--

if isempty(grid)
	end_str = sec_to_clock(end_time);
else
	end_str = get_grid_time_string(grid, end_time, sound.realtime);
end

%--
% concatenate strings together
%--

str = ['[' start_str, ' - ', end_str, ']']; 
