function daemon = live_control_daemon

% live_control_daemon - timer that implements live controls
% ---------------------------------------------------------
%
% daemon = live_control_daemon
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
% $Revision: 3302 $
% $Date: 2006-01-31 01:31:56 -0500 (Tue, 31 Jan 2006) $
%--------------------------------

%-------------------------------
% SETUP
%-------------------------------

name = 'XBAT Live Control Daemon';

mode = 'fixedRate'; 

rate = 0.1; 

%-------------------------------
% GET SINGLETON TIMER
%-------------------------------

%--
% try to find timer
%--

daemon = timerfind('name',name);

%--
% create and configure timer if needed
%--

if (isempty(daemon))
	
	daemon = timer;

	set(daemon, ...
		'name', name, ...
		'executionmode', 'fixedRate', ...
		'period', rate, ...
		'timerfcn', @timer_callback ...
	);

end


%---------------------------------------------------
% TIMER_CALLBACK
%---------------------------------------------------

function timer_callback(obj,eventdata)

% timer_callback - timer callback to implement live controls
% ----------------------------------------------------------
%
% timer_callback(obj,eventdata)
%
% Input:
% ------
%  obj - callback object
%  eventdata - reserved by matlab

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3302 $
% $Date: 2006-01-31 01:31:56 -0500 (Tue, 31 Jan 2006) $
%--------------------------------

% NOTE: the callback object is the timer

%---------------------------------------
% CHECK CONTEXT
%---------------------------------------

%--
% test for slider hover
%--

obj = overobj2('uicontrol');

if (~strcmp(get(obj,'style'),'slider'))
	return;
end
	
%--
% test for palette
%--

par = get(obj,'parent');

if (~is_palette(par))
	return; 
end

%---------------------------------------
% PERFORM LIVE CONTROL CALLBACK
%---------------------------------------

%--
% check that control is active
%--

name = get(obj,'tag'); 

data = get(par,'userdata');

ix = find(strcmp(name,data.active.name));

if (isempty(ix))
	return;
end

%--
% check for control value change
%--

% TODO: implement some notion of tolerance

value = get(obj,'value'); lastvalue = data.active.lastvalue(ix);

if (value == lastvalue)	
	return;
end

%--
% execute callback depending on type of callback
%--

% NOTE: this code is repetitive and should be a function, look at 'control_callback'

callback = get(obj,'callback');

switch (class(callback))

	case ('char')
		eval(callback);

	case ('cell')
		fun = callback{1}; fun(obj,[],callback{2:end});

	case ('function_handle')
		callback(obj,[]);

end

%--
% update live control last value store
%--

data.active.lastvalue(ix) = value;

set(par,'userdata',data);
