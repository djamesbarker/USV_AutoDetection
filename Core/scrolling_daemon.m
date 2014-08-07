function daemon = scrolling_daemon

% scrolling_daemon - timer that implements scrolling display
% ----------------------------------------------------------
%
% daemon = scrolling_daemon
%
% Output:
% -------
%  daemon - configured timer

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
% $Revision: 6855 $
% $Date: 2006-09-29 16:30:15 -0400 (Fri, 29 Sep 2006) $
%--------------------------------

% TODO: update to use 'get_time_slider' and 'set_time_slider'

%-------------------------------
% SETUP
%-------------------------------

name = 'XBAT Scrolling Daemon';

mode = 'fixedRate'; 

rate = 0.06; 

%-------------------------------
% GET SINGLETON TIMER
%-------------------------------

%--
% try to find timer
%--

daemon = timerfind('name', name);

if ~isempty(daemon)
	return;
end

%--
% create and configure timer if needed
%--
	
daemon = timer;

set(daemon, ...
	'name',name, ...
	'executionmode', mode, ...
	'busymode', 'drop', ...
	'period', rate, ...
	'timerfcn',@scroll_callback ...
);


%---------------------------------------------------
% SCROLL_CALLBACK
%---------------------------------------------------

function scroll_callback(obj, eventdata, par)

% scroll_callback - timer callback to implement scrolling display
% --------------------------------------------------------------
%
% scroll_callback(obj, eventdata, par)
%
% Input:
% ------
%  obj - callback object
%  eventdata - reserved by matlab
%  par - browser handle

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6855 $
% $Date: 2006-09-29 16:30:15 -0400 (Fri, 29 Sep 2006) $
%--------------------------------

%----------------------
% SETUP
%----------------------

%--
% get and check browser handle
%--

if (nargin < 3) || isempty(par)
	par = get_active_browser;
end

if ~is_browser(par)
	return;
end

%--
% get slider value
%--

slider = get_time_slider(par);

if isempty(slider)
	return;
end

%----------------------
% SCROLL IF NEEDED
%----------------------

% TODO: figure out where the scroll request originates

%--
% check for slider change
%--

change = get_browser_history(par, 'time') - slider.value;

if ~change
	return;
end

%--
% detect slider motion
%--

motion = slider.previous_value - slider.value; 

%--
% detect a slow-update condition
%--

slow_update = get_browser_history(par, 'elapsed') > 1.5 * get(obj, 'period');

%--
% select update mode
%--

if isempty(motion) || isempty(slow_update)
	fast = 0;
else
	fast = motion && slow_update;
end

%--
% perform update
%--

% TODO: move big time display to this function to produce more sophisticated interaction

try	
	browser_refresh(par, [], fast);
catch
	nice_catch(lasterror);
end

set_time_slider(par, 'previous_value', slider.value);

