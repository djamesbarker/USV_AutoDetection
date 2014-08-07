function [time, duration] = set_browser_page(par, mode, varargin)

% set_browser_page - set browser page properties
% ----------------------------------------------
%
% set_browser_page(par, mode, 'field', 'value', ...)
%
% Input:
% ------
%  par - parent browser handle
%  mode - input time line mode
%  field - fieldname (time, 
%
% Output:
% -------
%  time - browser slider time
%  duration - browser page duration

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
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

if isempty(par)
	
	par = get_active_browser;
	
	if isempty(par)
		return;
	end
	
end

if isempty(mode)
	mode = 'real';
end

if ~ismember(mode, time_modes)
	error('Invalid sound time mode.');
end

[field, value] = get_field_value(varargin);

data = get_browser(par);

%---------------------------
% SET PAGE PROPERTIES
%---------------------------

stop(scrolling_daemon);

change = 0;

%--
% set overlap
%--

ix = find(strcmp('overlap', field));

if ~isempty(ix)
	data = set_overlap(par, value{ix}, data);
end

%--
% set duration
%--

ix = find(strcmp('duration', field));

if ~isempty(ix)
	data = set_duration(par, value{ix}, data);
end

%--
% set time
%--

ix = find(strcmp('time', field));

if ~isempty(ix)
	data = set_time(par, mode, value{ix}, data);
end

%--
% update display
%--

browser_view_menu(par, 'scrollbar');

daemon = scrolling_daemon;

if ~strcmp(daemon.running, 'on')
	start(scrolling_daemon);
end


%--------------------------------
% SET_TIME
%--------------------------------

function data = set_time(par, mode, time, data)

if ischar(time)
	time = clock_to_sec(time);
end

if isempty(time)
	error('invalid time string');
end

%--
% map time
%--

time = map_time(data.browser.sound, 'slider', mode, time);
		
change = time ~= data.browser.time;

%--
% set time 
%--

set_time_slider(par, 'value', time);


%--------------------------------
% SET_DURATION
%--------------------------------

function data = set_duration(par, duration, data)

if ischar(duration)
	duration = clock_to_sec(duration);
end

if isempty(duration)
	error('invalid time string');
end

%--
% get current time and sound duration
%--

t = data.browser.time;

T = get_sound_duration(data.browser.sound);

%--
% update time if current time plus page exceeds available sound duration
%--

change = data.browser.page.duration ~= duration;

fullpage = data.browser.page.duration == T;

if duration > T
	duration = T;
end

if (t + duration) > T
	data = set_time(par, 'real', T - duration, data);
end

%--
% update userdata
%--

data.browser.page.duration = duration;

%--
% update menus
%--

% NOTE: this is really old stuff, these menus are rarely used

handles = get(get_menu(par, 'Page Duration'), 'children');

set(handles, 'check', 'off');

ix = find(duration == [1, 2, 3, 4, 10, 20, 30, 60]);

if ~isempty(ix)
	set(handles(ix), 'check', 'on');
else
	set(handles(end), 'check', 'on');
end

%--
% update state
%--

data = update_specgram_param(par, data, 1);

update_time_slider(par, data);

%--
% update page palette if necessary
%--

pal = get_palette(par, 'Page');

if isempty(pal)
	return;
end

set_control(pal, 'Duration', 'value', duration);


%--------------------------------
% SET_OVERLAP
%--------------------------------

function data = set_overlap(par, overlap, data)

%--
% handle input
%--

% NOTE: are we testing for change so we can return?

change = data.browser.page.overlap ~= overlap;

%--
% update userdata
%--

data.browser.page.overlap = overlap;

set(par, 'userdata', data);

update_time_slider(par, data);

%--
% update menus
%--

% NOTE: this is really old stuff, these menus are rarely used

handles = data.browser.view_menu.page_overlap;

set(handles, 'check', 'off');

ix = find(overlap == [0, 1/2, 1/4, 1/8]); % change these to the actual

if ~isempty(ix)
	set(handles(ix), 'check', 'on');
else
	set(handles(end), 'check', 'on');
end

%--
% update controls
%--

pal = get_palette(par, 'Page', data);

if isempty(pal)
	return;
end

set_control(pal, 'Overlap', 'value', overlap);


