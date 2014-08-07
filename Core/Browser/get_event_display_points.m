function [vertex, control, center] = get_event_display_points(event)

%--
% get event time and frequency limits
%--

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

start = event.time(1); stop = start + diff(event.time);

low = event.freq(1); high = low + diff(event.freq);

%--
% compute event vertices
%--

% NOTE: these are typically used to draw a single line

vertex.x = [start, stop, stop, start, start]'; 

vertex.y = [low, low, high, high, low]';

%--
% compute control points if needed
%--

if (nargout < 2)
	return; 
end

% NOTE: these are used to draw multiple marker lines
	
center.x = 0.5 * (start + stop);

center.y = 0.5 * (low + high);

% control = [ ...
% 	stop, center.y; ...
% 	stop, high; ...
% 	center.x, high; ...
% 	start, high; ...
% 	start, center.y; ...
% 	start, low; ...
% 	center.x, low; ...
% 	stop, low; ...
% 	center.x, center.y ...
% ];

% NOTE: this assignment seems slightly faster

control = [ ...
	stop * ones(1,2), center.x, start * ones(1, 3), center.x, stop, center.x; ...
	center.y, high * ones(1, 3), center.y, low * ones(1, 3), center.y ...
]';
