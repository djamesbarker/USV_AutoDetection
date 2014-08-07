function browser_refresh(par, data, fast)

%--
% handle input
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

if nargin < 1 || isempty(par)
	par = get_active_browser;
end

if nargin < 2 || isempty(data)
	data = get_browser(par);
end

if nargin < 3 || isempty(fast)
	fast = 0;
end

%--
% get scrollbar value and update time
%--

% NOTE: the scrollbar is also tagged as well as stored

slider = get_time_slider(par);

%--
% do lightweight update if forced
%--

if fast
	browser_time_slide(par, slider.value); drawnow; click_sound; return;
end

data.browser.time = slider.value;

% NOTE: this should not be required

data.browser.slider = slider.handle(1);

%--
% perform active detection if needed
%--

% TODO: active detection log is volatile, and typically small, store in environment

try
	data.browser.active_detection_log = active_detection(par, data);
catch
	nice_catch(lasterror, 'Failed to perform active detection');
end
	
%--
% enable and disable navigation menus
%--

browser_navigation_update(par, data);

%--
% update view state array and browser state
%--

% NOTE: this update should not happen all the time, look at top note

% data.browser.view = browser_view_update(par, data);

%--
% get and clear browser selection
%--

sel = get_browser_selection(par, data);

data = delete_selection(par, data);

%--
% update widget and browser displays
%--

browser_display(par, 'update', data);

update_widgets(par, 'page', data);

% NOTE: the browser should be a widget

%--
% update browser state
%--

% NOTE: this leaves display (browser/widget) updates working with stale figure data!!

set(par, 'userdata', data);

%--
% update selection if it makes sense
%--

selection_update(par, data, sel);


