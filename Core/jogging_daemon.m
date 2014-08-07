function daemon = jogging_daemon

% jogging_daemon - create a timer object to handle jogging display
% ----------------------------------------------------------------
%
% daemon = jogging_daemon
%
% Output:
% -------
%  daemon - timer object

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create timer object
%--

daemon = timer;

%--
% configure timer object
%--

set(daemon, ...
	'name','XBAT Jogging Daemon', ...
	'timerfcn',@jog_display, ...
	'executionmode','fixedRate', ...
	'period',0.1 ...
);


%---------------------------------------------------
% JOG_DISPLAY
%---------------------------------------------------

function jog_display(obj,eventdata)

% jog_display - timer callback to update jogging display
% -------------------------------------------------------
%
% jog_display(obj,eventdata)
%
% Input:
% ------
%  obj - callback object
%  eventdata - currently not used

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%----------------------------------------------------
% UPDATE CURRENT BROWSER
%----------------------------------------------------

% NOTE: this could be slightly more efficient, get it working first

persistent CURR_FIG CURR_BROWSER FIG_CHANGE;

%--
% set current figure
%--

if (isempty(CURR_FIG))
	CURR_FIG = gcf;
	FIG_CHANGE = 1;
end

%--
% update current figure
%--

if (CURR_FIG ~= gcf)
	CURR_FIG = gcf;
	FIG_CHANGE = 1;
else
	FIG_CHANGE = 0;
end

%--
% update current sound browser
%--

if (FIG_CHANGE && strncmp(get(CURR_FIG,'tag'),'XBAT_SOUND_BROWSER',18))
	CURR_BROWSER = CURR_FIG;
end

%----------------------------------------------------
% GET JOG STATE PARAMETERS
%----------------------------------------------------

%--
% get jog palette handle
%--

% NOTE: assume only parent palettes are visible to make selection faster

pal = findobj( ...
	findobj(get(0,'children'),'flat','visible','on'), ...
	'flat','name','Jog' ...
);

% NOTE: jogging does not happen when palette is hidden

if (isempty(pal))
	return;
end 

%--
% get jog speed
%--

[ignore,speed] = control_update([],pal,'jog_speed');

% NOTE: the state value is obtained from the button label string

%--
% get jog state
%--

toggle = control_update([],pal,'jog_toggle');

state = get(toggle,'string');
	
% NOTE: when the button displays 'Go' the state is 'Stop' and viceversa

if (strcmp(state,'Go'))
	return;
end

%----------------------------------------------------
% JOG
%----------------------------------------------------

%--
% get parent slider
%--

par = getfield(get(pal,'userdata'),'parent');

slider = findobj(par,'tag','BROWSER_TIME_SLIDER');

% NOTE: it is not cleat when this would happen

if (isempty(slider))
	return;
end

%--
% compute time update and state update flag
%--

time = get(slider,'value') + (get(obj,'period') * speed);

max_time = get(slider,'max');

flag = 0;

% NOTE: this condition only happens when going forward in time

if (time > max_time)
	
	% NOTE: we only need the loop state during edge conditions
	
	[ignore,loop] = control_update([],pal,'jog_loop');

	if (loop)
		time = mod(time,max_time);
	else
		time = max_time;
		flag = 1;
	end
	
end

% NOTE: this condition only happens when going backwards in time

if (time < 0)
	
	% NOTE: we only need the loop state during edge conditions
	
	[ignore,loop] = control_update([],pal,'jog_loop');
	
	if (loop)
		time = mod(time,max_time);
	else
		time = 0;
		flag = 1;
	end
	
end

% NOTE: the resulting behavior is not intuitive

% %--
% % turn off jog on direct slider update
% %--
% 
% if (gco == slider)
% 	set(toggle,'string','Go');
% end 

%--
% update slider position
%--
	
set(slider,'value',time);

if (CURR_FIG ~= CURR_BROWSER)
	set(0,'currentfigure',CURR_BROWSER);
end

%--
% update jog state when time goes off sound edges
%--

if (flag)
	set(toggle,'string','Go');
end 

