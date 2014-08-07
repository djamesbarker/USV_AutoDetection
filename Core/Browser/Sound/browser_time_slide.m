function browser_time_slide(par, time, data)

% browser_time_slide - slide browser grid
% ---------------------------------------
%
% browser_time_slide(par, time)
%
% Inputs:
% -------
%  par - browser handle
%  time - page start time

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
% Author: Matt Robbins
%--------------------------------
% $Revision: 4580 $
% $Date: 2006-04-14 17:24:52 -0400 (Fri, 14 Apr 2006) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% check browser handle
%--

if ~is_browser(par)
	return;
end

%--
% get browser time if needed
%--

if (nargin < 2) || isempty(time)
	slider = get_time_slider(par); time = slider.value;
end

%--
% get browser state and copy some fields
%--

if (nargin < 3) || isempty(data)
	data = get_browser(par);
end

sound = data.browser.sound; page = data.browser.page;

ax = data.browser.axes; grid = data.browser.grid;

%--------------------------------
% DISPLAY UPDATE
%--------------------------------

% NOTE: this is meant to be a lightweight display for browser

%--
% update axes time position and grid
%--

limits = [time, time + page.duration];

set(ax, 'xlim', limits);

set_time_grid(ax, grid, limits, sound.realtime, sound);

%--
% display events
%--

% NOTE: event display was moved here because it was clearing boundaries

display_events(par, time, page.duration, data, 1);

%--
% display selection
%--

% TODO: consider how to fade the selection display

sel = get_browser_selection(par, data);

if ~isempty(sel.event)
	selection_event_display(sel.event, [], data);
end

%--
% display file boundaries
%--

[times, files] = get_file_boundaries(sound, time, page.duration);

display_file_boundaries(ax, times, files, data);

%--
% display session boundaries
%--

[times, start] = get_session_boundaries(sound, time, page.duration);

display_session_boundaries(ax, times, start, [], data);

%--
% display page start time
%--

big_time_display(ax(1), time, grid, sound);

%--
% update navigate palette
%--

update_navigate_palette(par, data);

