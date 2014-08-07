function daemon = measurement_display_daemon

% measurement_display_daemon - create a timer object to handle palette display
% ----------------------------------------------------------------
%
% daemon = measurement_display_daemon
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

% this daemon currently provides selection triggered display for events

% create a daemon to display marching ants as part of active detection !!!

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
	'name','XBAT Measure Display Daemon', ...
	'timerfcn',@update_display, ...
	'executionmode','fixedRate', ...
	'period',0.25 ...
);

%---------------------------------------------------
% UPDATE_DISPLAY
%---------------------------------------------------

function update_display(obj,evendata)

% update_palette_display - timer callback to update palette display
% -----------------------------------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%------------------------------------------
% PRELIMINARY TESTS FOR DISPLAY
%------------------------------------------

%--
% create persitent variable to keep track of tag
%--

persistent CURRENT_TAG

if (isempty(CURRENT_TAG))
	CURRENT_TAG = [];
end

%--
% check if current object is a patch
%--

tmp = gco;

if (~strcmp(get(tmp,'type'),'patch'))
	return;
end

tag = get(tmp,'tag');

% if (strcmp(tag,CURRENT_TAG))
% 	return;
% end
% 
% CURRENT_TAG = tag;

%--
% check for measure context menu
%--

context = get(tmp,'uicontextmenu');

if (isempty(context))
	return;
end

%--
% check for measurement context menu
%--

measure = 'Time-Freq Quartiles';

par = findobj(context,'label',measure);

if (isempty(par))
	return;
end

%------------------------------------------
% UPDATE DISPLAY
%------------------------------------------

%--
% delete previous plot
%--

delete(findobj(gcf,'tag','MY_DISPLAY_TAGS'));

%--
% get event and measurement values
%--

[m,ix] = strtok(tag,'.');

m = eval(m); 

ix = eval(ix(2:end));

data = get(gcf,'userdata');

event = data.browser.log(m).event(ix);

ixm = find(strcmp(struct_field(event.measurement,'name'),measure));

value = event.measurement(ixm).value;

%--
% produce measurement display
%--

x = get(tmp,'xdata');
x = x(2);

y = get(tmp,'ydata');
y = y(3);

tmp = text(x,y,['Mediod: (' num2str(value.time_q2) ',' num2str(value.freq_q2) ')']);

set(tmp, ...
	'hittest','off', ...
	'clipping','off', ...
	'color',[0 0 0], ...
	'backgroundcolor',rand(1,3), ...
	'rotation',(get(tmp,'rotation') + 2*randn), ...
	'tag','MY_DISPLAY_TAGS', ...
	'fontsize',10 ...
);

refresh;
