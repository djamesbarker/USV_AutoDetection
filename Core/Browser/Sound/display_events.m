function display_events(par, time, duration, data, light)

% display_events - display events in time range
% ---------------------------------------------
%
% display_events(par, time, duration, data, light)
%
% Input:
% ------
%  par - parent browser handle
%  time - page beginning
%  duration - page duration
%  data - parent browser state
%  light - lightweight display flag
%
% Output:
% -------
%  (none)

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
% set light display 
%--

if (nargin < 5) || isempty(light)
	light = 0;
end

%--
% get browser state
%--

if (nargin < 4) || isempty(data)
	data = get_browser(par);
end

%---------------------------
% SETUP
%---------------------------

%--
% convenience variables
%--

sound = data.browser.sound;

ch = get_channels(get_browser(par, 'channels', data));

nch = length(ch);

%--
% get axes 
%--

ax = data.browser.axes;

%--
% delete current selection objects
%--

tmp = data.browser.selection.handle;

delete(tmp(find(ishandle(tmp)))); % this selection may not be needed

%--
% remove currently displayed events
%--

type = {'line', 'patch', 'text'};

for k = 1:length(type)	

	h1 = findall(ax, 'type', type{k});

	n1 = length(h1);

	%--
	% get patch children
	%--

	if strcmp(type{k}, 'patch') && n1

		%--
		% get context menus and menu children
		%--

		if (n1 > 1)
			tmp1 = cell2mat(get(h1, 'uicontextmenu'));
		else
			tmp1 = get(h1, 'uicontextmenu');
		end

		tmp2 = findobj(tmp1, 'type', 'uimenu');

		%--
		% delete patch menus
		%--

		delete(tmp2);
		
		delete(tmp1);

	end

	% TODO: there is a problem with invalid handles in the findall during active scrolling

	h2 = findall(h1, 'flat', 'tag', 'file_boundary');

	if ~isempty(h2)
		h1 = setdiff(h1, h2);
	end

	h2 = findall(h1, 'flat', 'tag', '');

	if ~isempty(h2)
		h1 = setdiff(h1, h2);
	end

	delete(h1);

end

%--
% disable selection options
%--

if isfield(data.browser, 'sound_menu')

	tmp = data.browser.sound_menu.play;

	set(get_menu(tmp, 'Selection'), 'enable', 'off');
	
end

%--
% display active detection selected events
%--

% NOTE: the idea of temporary logs can be extended to have multiple
% active detectors, somehow they must be distinguished from each
% other

if ~isempty(data.browser.sound_detector.active)

	tmp = data.browser.active_detection_log.length;

	if tmp
		event_view('sound', par, '__ACTIVE_DETECTION__', 1:tmp, ax, data, light);
	end

end

%--
% display page-visible events from logs
%--

t1 = time; t2 = time + duration;

page.start = t1; page.duration = duration; page.channel = ch;

for k = 1:length(data.browser.log)

	%--
	% skip invisible or empty logs
	%--
	
	if ~data.browser.log(k).visible || ~data.browser.log(k).length
		continue;
	end
	
	%--
	% select events in page
	%--

	event_ind = event_in_page(data.browser.log(k).event, page, sound);
	
	ix = find(event_ind);

	if isempty(ix)
		continue;
	end
	
	%--
	% display events from log
	%--
	
	ghost = [event_ind(ix) < 0];

	event_view('sound', par, k, ix, ax, data, light | ghost);

end

%--
% get out for light display
%--

if light
	return;
end

%--
% update event palette for events in page display
%--

% NOTE: we try to skip over code as fast as possible

%--
% check for open event palette
%--

pal = get_palette(par, 'Event', data);

if ~isempty(pal)

	%--
	% check page events only control
	%--

	[ignore, value] = control_update([], pal, 'page_events_only', [], data);

	%--
	% update event palette display
	%--

	% TODO: consider we know displayed events for efficiency

	if value
		update_find_events(par, [], data);			
	end

end
