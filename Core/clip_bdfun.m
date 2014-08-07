function clip_bdfun

% clip_bdfun - clip axes focus button down function
% -------------------------------------------------

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
% get parent handle and userdata
%--

h1 = gcf;
data_log = get(h1,'userdata');

h = data_log.browser.parent;
data = get(h,'userdata');

%--
% get and parse tag to get log and event indices
%--

ax = gca;

tag = get(ax,'tag');

[m,ix] = strtok(tag,'.');
m = str2num(m);
ix = str2num(ix(2:end));

%--
% remove previously displayed selection objects
%--

delete(findall(h1,'tag','selection'));

%--
% get event
%--

event = data.browser.log(m).event(ix);

%--
% compute vertex representation of selection
%--

t = event.time(1);
dt = event.duration;

if (strcmp(data.browser.grid.freq.labels,'Hz'))
	f = event.freq(1);
	df = event.bandwidth;
else
	f = event.freq(1) / 1000;
	df = event.bandwidth / 1000; 
end

x = [t, t + dt, t + dt, t, t];
y = [f, f, f + df, f + df, f];

%--
% compute modified vertex representation of selection
%--

tp = 0.0175;
t = t - tp;
dt = dt + 2*tp;

% there seems to be some interaction between channels displayed
% and aspect ratio ???

ar = get(ax,'dataaspectratio');

fp = tp * ar(2); %  * length(data.browser.channels);
f = f - fp;
df = df + 2*fp;

tmpx = [t, t + dt, t + dt, t, t];
tmpy = [f, f, f + df, f + df, f];

%--
% create event display objects and refresh
%--

g(1) = plot(tmpx,tmpy,'--','LineWidth',2,'color',[0,0,1]);

%--
% display crosshairs
%--

xl = get(ax,'xlim'); 
yl = get(ax,'ylim');

yl = [yl(1) y(1) nan y(3) yl(2)];
xl = [xl(1) x(1) nan x(2) xl(2)];

rgb = data.browser.grid.color;

g(2) = plot(x(1)*ones(1,5),yl,':','Color',rgb,'Linewidth',0.5);
g(3) = plot(x(2)*ones(1,5),yl,':','Color',rgb,'Linewidth',0.5);
g(4) = plot(xl,y(1)*ones(1,5),':','Color',rgb,'Linewidth',0.5);
g(5) = plot(xl,y(3)*ones(1,5),':','Color',rgb,'Linewidth',0.5);

set(g(2:5),'hittest','off');

%--
% display labels
%--

% create time label strings

if (strcmp(data.browser.grid.time.labels,'clock'))
	if (data.browser.grid.time.realtime & ~isempty(data.browser.sound.realtime))
		offset = datevec(data.browser.sound.realtime);
		offset = offset(4:6) * [3600, 60, 1]';
		tmp1 = sec_to_clock(event.time(1) + offset);
		tmp2{1} = sec_to_clock(event.time(2) + offset);
		time3 = [num2str(event.duration) ' sec'];
		tmp2{2} = ['(' time3 ')'];
	else
		tmp1 = sec_to_clock(event.time(1));
		tmp2{1} = sec_to_clock(event.time(2));
		time3 = [num2str(event.duration) ' sec'];
		tmp2{2} = ['(' time3 ')'];
	end
else
	tmp1 = [num2str(event.time(1)) ' sec'];
	tmp2{1} = [num2str(event.time(2)) ' sec'];
	tmp2{2} = ['(' num2str(event.duration) ' sec)'];	
end

% display start time and end time

% set(ax, ...
% 	'xtick',event.time, ...
% 	'xticklabel',{tmp1,tmp2{1}} ...
% );

% g(6) = text(x(1) - 0.0375,0.975*yl(end),tmp1);
% set(g(6),'HorizontalAlignment','right');
% set(g(6),'VerticalAlignment','top');
% 
% g(7) = text(x(2) + 0.0375,0.975*yl(end),tmp2);
% set(g(7),'HorizontalAlignment','left');
% set(g(7),'VerticalAlignment','top');

% create frequency label strings

if (strcmp(data.browser.grid.freq.labels,'Hz'))
	tmp1 = [num2str(event.freq(1),6) ' Hz'];
	tmp2{1} = ['(' num2str(event.bandwidth,6) ' Hz)'];
	tmp2{2} = [num2str(event.freq(2),6) ' Hz'];
else
	tmp1 = [num2str(event.freq(1) / 1000,6) ' kHz'];
	tmp2{1} = ['(' num2str(event.bandwidth / 1000,6) ' kHz)'];
	tmp2{2} = [num2str(event.freq(2) / 1000,6) ' kHz'];
end

% display frequency bounds

% set(ax, ...
% 	'ytick',event.freq, ...
% 	'yticklabel',{tmp1,tmp2{1}} ...
% );

% tt1 = event.time(1) - data.browser.time;
% tt2 = (data.browser.time + data.browser.page.duration) - event.time(2);
% 
% if (tt1 <= tt2)
% 	
% 	% min frequency
% 	
% 	g(8) = text(xl(end) - 0.0375,(0.975 * y(1)),tmp1);
% 	set(g(8),'HorizontalAlignment','right');
% 	set(g(8),'VerticalAlignment','top');
% 	
% 	% max frequency
% 	
% 	g(9) = text(xl(end) - 0.0375,(1.025 * y(3)),tmp2);
% 	set(g(9),'HorizontalAlignment','right');
% 	set(g(9),'VerticalAlignment','bottom');
% 	
% else
% 	
% 	% min frequency
% 	
% 	g(8) = text(xl(1) + 0.0375,(0.975 * y(1)),tmp1);
% 	set(g(8),'HorizontalAlignment','left');
% 	set(g(8),'VerticalAlignment','top');
% 	
% 	% max frequency
% 	
% 	g(9) = text(xl(1) + 0.0375,(1.025 * y(3)),tmp2);
% 	set(g(9),'HorizontalAlignment','left');
% 	set(g(9),'VerticalAlignment','bottom');
% 	
% end
% 
% set(g(6:9),'Color',rgb);
% text_highlight(g(6:9));

%--
% tag all selection display objects
%--

set(g,'tag','selection');

%--
% refresh figure
%--

refresh(h1);

%--
% update userdata
%--

data_log.browser.selection = ax;

set(h1,'userdata',data_log);
