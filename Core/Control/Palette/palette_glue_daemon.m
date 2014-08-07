function daemon = palette_glue_daemon

% palette_glue_daemon - create a timer object to handle palette position
% ----------------------------------------------------------------------
%
% daemon = palette_glue_daemon
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
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%--
% create timer object
%--

daemon = timer;

%--
% configure timer object
%--

set(daemon, ...
	'name','XBAT Palette Glue Daemon', ...
	'timerfcn',@update_palette_position, ...
	'executionmode','fixedRate', ...
	'period',0.05 ...
);


%---------------------------------------------------
% UPDATE_PALETTE_POSITION
%---------------------------------------------------

function update_palette_position(obj,evendata)

% update_palette_position - timer callback to update palette display
% -----------------------------------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%--
% create persistent values for current figure and position
%--

persistent CURRENT_POSITION COUNT STATE

if (isempty(CURRENT_POSITION))
	CURRENT_POSITION = get(gcf,'position');
end

if (isempty(COUNT))
	COUNT = 0;
else
	COUNT = COUNT + 1;
end

if (isempty(STATE))
	STATE = 0;
end

%--
% check type of figure
%--

if (isempty(gcf))
	return;
end

info = parse_tag(get(gcf,'tag'));
			
if (~strcmp(info.type,'XBAT_SOUND_BROWSER'))
	return;
end

%--
% get position and flock state from timer
%--

pos = get(gcf,'position');

glue_timer = timerfind('name','XBAT Palette Glue Daemon');

flock = get(glue_timer,'userdata');

%--
% update smoothed flock state
%--

% goes up slow comes down fast

OLD_STATE = STATE;

if (flock)
	STATE = 0.05 * (19 * STATE + flock);
else
	STATE = 0.1 * (9 * STATE);
end

%--
% udpate flock state indicator
%--

if ((OLD_STATE < 0.5) & (STATE >= 0.5))
	
	indicator = 'on';
	
elseif ((OLD_STATE >= 0.5) & (STATE < 0.5))
	
	indicator = 'off';
	
else
	
	indicator = '';
	
end

color = get(0,'defaultuicontrolbackgroundcolor');
	
status = findobj(gcf,'type','axes','tag','Status');

switch (indicator)
	
	case ('on')
		
% 		status_update(gcf,'right','message',['U    XBAT ' xbat_version]);
		
		status_update(gcf,'right','message',['(flock)   XBAT ' xbat_version]);
		
% 		%--
% 		% colored status bar indicator
% 		%--
% 		
% 		if (~isempty(status))
% 			set(status,'color',(color + [1 1 0]) / 2);
% 		end
% 		
% 		drawnow;
% 		pause(0.05);
		
		% this tries to force a display update
		
		jit = pos;
		jit(1:2) = jit(1:2) - 1;
		jit(3:4) = jit(3:4) + 1;
		
		set(gcf,'position',jit);
		set(gcf,'position',pos);

		
	case ('off')
		
		status_update(gcf,'right','message',['XBAT ' xbat_version]);
		
% 		%--
% 		% colored status bar indicator
% 		%--
% 		
% 		if (~isempty(status))
% 			set(status,'color',color);
% 		end
% 		
% 		drawnow;
% 		pause(0.05);
		
		% this tries to force a display update
		
		jit = pos;
		jit(1:2) = jit(1:2) - 1;
		jit(3:4) = jit(3:4) + 1;
		
		set(gcf,'position',jit);
		set(gcf,'position',pos);

end
	
if (STATE < 0.5)
	
	%--
	% update position if we are not flocking
	%--
		
	CURRENT_POSITION = pos;
	
	return;
	
end

%--
% check for parent move
%--

offset = pos - CURRENT_POSITION;

offset = offset(1:2);

if (sum(abs(offset)))
		
	%--
	% get palettes displayed
	%--

	g = get_xbat_figs('type','palette');
		
	% remove invisible palettes and XBAT palette
	
	for k = length(g):-1:1
		if (strcmp(get(g(k),'visible'),'off') | strcmp(get(g(k),'name'),'XBAT'))
			g(k) = [];
		end
	end
	
	% remove parent less figures
	
	% this is the most expensive test henece it is performed last
	
	for k = length(g):-1:1		
		if (isempty(get_field(get(g(k),'userdata'),'parent')))
			g(k) = [];
		end
	end
		
	%--
	% update position of palettes
	%--
			
	for k = 1:length(g);
		tmp = get(g(k),'position');
		tmp(1:2) = tmp(1:2) + offset;
		set(g(k),'position',tmp);
	end
			
end

%--
% update persistent current position
%--

CURRENT_POSITION = pos;

%--
% update flock state
%--
 
if (mod(COUNT,5) == 0)
	set(glue_timer,'userdata',0);
end
