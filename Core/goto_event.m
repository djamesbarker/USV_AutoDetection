function flag = goto_event(par, log, id, data)

% goto_event - move display to event and select
% ---------------------------------------------
%
% flag = goto_event(par, log, id, data)
%
% Input:
% ------
%  par - parent browser figure handle
%  log - log name
%  id - event id
%  data - browser state

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

% TODO: clean this up and make it pretty

%--
% set success flag
%--

flag = 1;

if ~nargin || isempty(par)
	par = get_active_browser;
end

%--
% get state of browser if needed
%--

if (nargin < 4) || isempty(data)
	data = get_browser(par);
end

%--
% get log index
%--
	
if ischar(log)

	logs = get_browser(par, 'log'); m = find(strcmp(log_name(logs), log));
	
	log = logs(m);
	
end
	
[event, ix] = log_select(log, 'id', id);

if numel(event) ~= 1
	flag = 0; return;
end

%--------------------------------------------
% move to time position and select event
%--------------------------------------------

% NOTE: this has problems for page duration smaller than event duration

%--
% get parent time slider
%--

slider = get_time_slider(par);

%--
% get relevant variables for time computation
%--

sound = data.browser.sound; 

page = data.browser.page;

%--
% check that event is fully visible in page
%--

time = map_time(sound, 'slider', 'record', event.time);

% TODO: consider the option of always centering the event on goto

if any(time < slider.value) || any(time > (slider.value + page.duration))
	
	%--
	% time required to put event at center of page
	%--
	
	% NOTE: we need to consider the ends of the sound
	
	t = (sum(time) - page.duration) / 2;
	
	if (t > slider.max)
		t = slider.max;
	end
	
	if (t < 0)
		t = 0;
	end
	
	%--
	% move to required time
	%--
	
	set_time_slider(par, 'value', t); 
	
end

%--
% select event
%--

% NOTE: this pause is sensitive to the scrolling daemon period

pause(0.15);

% TODO: an error ocurrs when event channel is not currently displayed

double_click('off');

if log.visible
	
	event_bdfun(par, m, ix);
	
else
	
	% NOTE: clearing id makes the system believe this is just a selection
	
	event.id = []; figure(par); browser_bdfun(event);
	
end

double_click('on');

