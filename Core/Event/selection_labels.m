function [time,freq] = selection_labels(h, event, data)

% selection_labels - construct label strings for event selection grid
% ---------------------------------------------------------------
%
%  [time,freq] = selection_labels(h, event, data)
%
% Input:
% ------
%  h - handle to parent display figure
%  event - event to be labelled
%  data - browser figure userdata
%
% Output:
% -------
%  time - time labels
%  freq - frequency labels

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
% $Revision: 532 $
% $Date: 2005-02-15 23:17:09 -0500 (Tue, 15 Feb 2005) $
%--------------------------------

%--
% get userdata
%--

if (nargin < 3) || isempty(data)
	data = get(h, 'userdata');
end


%----------------------------------
% TIME LABELS
%----------------------------------

%--
% get relavent fields from browser
%--

sound = data.browser.sound;

grid = data.browser.grid;

%--
% create time label strings
%--

event.time = map_time(sound, 'real', 'record', event.time);	

bounds = get_grid_time_string(grid, event.time, sound.realtime);

duration = get_grid_time_string(grid, diff(event.time));

%--
% create time grid labels
%--

time = {bounds{:} duration};

% NOTE: time{4} is {end-time, duration}

time{4}{1} = time{2}; time{4}{2} = ['(',time{3},')'];


%----------------------------------
% FREQUENCY LABELS
%----------------------------------

event_bandwidth = diff(event.freq);

if (strcmp(data.browser.grid.freq.labels,'Hz'))
	
	freq = strcat( ...
		{num2str(event.freq(1),6), num2str(event.freq(2),6), num2str(event_bandwidth,6)}, ...
		' Hz' ...
	);

	freq{4}{1} = ['(' freq{3} ')']; freq{4}{2} = freq{2};
	
else
	
	event.freq = event.freq / 1000;
	
	freq = strcat( ...
		{num2str(event.freq(1),4), num2str(event.freq(2),4), num2str(event_bandwidth / 1000,4)}, ...
		' kHz' ...
	);

	freq{4}{1} = ['(' freq{3} ')']; freq{4}{2} = freq{2};
	
end
