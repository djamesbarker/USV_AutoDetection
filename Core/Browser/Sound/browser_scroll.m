function browser_scroll(h,time,speed)

% browser_scroll - scroll browser display
% ---------------------------------------
%
% browser_scroll(h,time,speed)
%
% Input:
% ------
%  h - browser figure handle
%  time - start and end time for scroll
%  speed - scrolling speed (def: 1)

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
% $Date: 2005-08-25 10:08:40 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1658 $
%--------------------------------

% NOTE: this code is a first step towards scrolling play

%--
% set time step constant
%--

% NOTE: this is fixed as it interacts with the display update timer

% NOTE: should this timer interact with the other timer directly ???

% consider stopping the other timer and taking over the updating ourselves

TIME_STEP = 0.05;

%--
% check figure for slider handle
%--

slider = findobj(h,'tag','BROWSER_TIME_SLIDER');

if (isempty(slider))
	disp(' ');
	error('Figure does not contain time scrolling slider.');
end

%--
% get parent userdata
%--

data = get(h,'userdata');

%--
% get speed from userdata
%--

if ((nargin < 3) || isempty(speed))
	speed = data.browser.play.speed;
end 

%--
% get time from userdata and slider handle
%--

% NOTE: default starts scrolling where we are until the end

if ((nargin < 2) || isempty(time))
	time = [data.browser.time, get(slider,'max')];
end

%--
% create and configure
%--

% NOTE: the timer should self delete at the end of the scroll

daemon = timer;

t0 = clock;

set(daemon, ...
	'name','DELETE ME', ...
	'timerfcn',{@scroll,t0,slider,time,speed}, ...
	'executionmode','fixedRate', ...
	'period',TIME_STEP ...
);

start(daemon);


%-------------------------------------------------------------
% SCROLL
%-------------------------------------------------------------

function scroll(obj,eventdata,t0,slider,time,speed)

% scroll - browser scrolling timer callback
% -----------------------------------------
% 
% scroll(obj,eventdata,t0,slider,time,speed)
%
% Input:
% ------
%  obj - timer handle
%  eventdata - currently not used
%  t0 - time when timer was started
%  time - time interval to scroll
%  speed - scrolling speed

%--
% get scrolling daemon timer
%--

% we should abort if  this timer is not found

daemon = timerfind('name','XBAT Scrolling Daemon');

% this is a function handle

scroll_display = get(daemon,'timerfcn');

%--
% compute time where we should be
%--

% based on time since timer started and scrolling speed

% this global way of updating does not permit updating speed

elapsed = etime(clock,t0);

value = time(1) + (elapsed * speed);

value = min(value,time(2));

%--
% scroll action
%--

if (value < time(2))
	
	%--
	% set slider to desired time
	%--
	
	set(slider,'value',value);

	scroll_display(daemon,[],get(slider,'parent'));
	
else
	
	%--
	% we are done, last update and delete timer
	%--

	set(slider,'value',time(2));
	
	scroll_display(daemon,[],get(slider,'parent'));
	
	stop(obj); delete(obj);
	
end





