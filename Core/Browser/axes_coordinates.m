function [x,y,ctrl] = axes_coordinates(event, sound, khz, map) 

% axes_coordinates - get coordinates to draw event and control points
% -------------------------------------------------------------------
%
% [x,y,ctrl] = axes_coordinates(event, sound, khz, map) 
%
% Input:
% ------
%  event - event
%  sound - sound
%  khz - kilohertz display indicator
%  map - sound time mapping indicator
%
% Output:
% -------
%  x - x coordinates
%  y - y coordinates
%  ctrl - control point coordinate matrix
 
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

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set sound time mapping
%--

if (nargin < 4) || isempty(map)
	map = 1;
end

%--
% set kilohertz display
%--

if (nargin < 3) || isempty(khz)
	khz = 1;
end

%---------------------------------
% COMPUTE EVENT VERTICES
%---------------------------------

%--
% prepare event considering axes mapping
%--

% TIME

start = event.time(1);

if map && ~isempty(sound)
	start = map_time(sound, 'slider', 'record', start);
end

stop = start + diff(event.time);

event.time = [start, stop];

% FREQUENCY

if khz
	event.freq = event.freq / 1000;
end

%--
% get event display points
%--

[vertex, control] = get_event_display_points(event); 

x = vertex.x; 

y = vertex.y; 

ctrl = control;
