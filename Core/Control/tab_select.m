function flag = tab_select(h, palette, tab, data)

% tab_select - select tab in control group
% ----------------------------------------
%
% tab_select(h, palette, tab, data)
%
% Input:
% ------
%  h - handle to palette parent
%  palette - name of palette or handle to palette
%  tab - name of tab
%  data - parent userdata
%
% Output:
% -------
%  flag - confirmation of selection

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
% $Revision: 5970 $
% $Date: 2006-08-07 16:01:00 -0400 (Mon, 07 Aug 2006) $
%--------------------------------

% NOTE: this does not produce a sound

%----------------------------------------------------
% HANDLE INPUT
%----------------------------------------------------

% TODO: modify so that we can use this function from within 'control_group'

%--
% see if we need to get palette handle from the parent
%--

if isempty(h)
	
	%--
	% when no parent is provided palette needs to be a figure handle
	%--
		
	if ishandle(palette) && strcmp(get(palette, 'type'), 'figure')
		pal = palette;
	end
	
else
	
	%--
	% when a parent is provided see if palette is a string
	%--
	
	if ischar(palette)
		
		if ((nargin < 4) || isempty(data))
			data = get(h,'userdata');
		end
		
		pal = get_palette(h,palette,data);
		
	else
		
		if (ishandle(palette) && strcmp(get(palette,'type'),'figure'))
			pal = palette;
		end
		
	end
	
end

%--
% return if we did not get the palette handle
%--

if (isempty(pal))
	flag = 0; return;
end

%--
% check for tab input
%--

if ((nargin < 3) || isempty(tab))
	flag = 0; return;
end

%----------------------------------------------------
% SELECT TAB
%----------------------------------------------------

%--
% get compiled tabs from palette
%--

data = get(pal,'userdata');

tabs = data.tabs;

% NOTE: return quickly if there are no tabs

if (isempty(tabs))
	return;
end

%--------------------------------
% UPDATE CONTROLS
%--------------------------------

%--
% find tab to select in tabs
%--

tab_ix = [];

for k = 1:length(tabs)
	
	%--
	% get tab index within tabs and parent tabs
	%--
	
	tab_ix = find(strcmp(tabs(k).tab.name,tab),1);
	
	% NOTE: we can discard other tabs at this point
	
	if (~isempty(tab_ix))
		tabs = tabs(k); break;
	end
	
end

% NOTE: return quickly if we did not find tab in tabs

if (isempty(tab_ix))
	return;
end

%--
% hide other tab controls and show selected tab controls
%--

for k = 1:length(tabs.child.name)
	
	switch (tabs.child.parent{k})
		
		case (tab)
			set_control(pal,tabs.child.name{k},'command','__SHOW__');
			
		otherwise
			set_control(pal,tabs.child.name{k},'command','__HIDE__');
			
	end
	
end

%--------------------------------
% UPDATE TABS
%--------------------------------

%--
% get actual tab objects
%--

% NOTE: rectangle and text tagged with tab name, not tabs name

obj = findobj(findall(pal,'type','rectangle'),'flat','tag',tab);

if (isempty(obj))
	flag = 0; return;
end

%--
% get parent axes and figure of tabs
%--

ax = get(obj,'parent');

%--
% get tabs information form palette userdata
%--

tabs = get(ax,'tag');

tab = get(obj,'tag');

%--
% get other elements in same tabs set
%--

g = findall(get(obj,'parent'));

%----------------------------------------------------
% HIDE ALL TABS
%----------------------------------------------------

% NOTE: background face color is darker than the selected tab face color

% NOTE: the tab colors are hard coded here and in 'control_group'

%--
% send all tabs to back
%--

set(findobj(g,'type','rectangle'), ...
	'edgecolor', 0.6 * ones(1,3), ...
	'facecolor', 0.95 * get(pal,'color') ...	
);

set(findobj(g,'type','text'), ...
	'color', 0.6 * ones(1,3) ...
);

%--
% the lines help to produce the physical effect of the tab setting
%--

set(findobj(g,'type','line'), ...
	'visible','on' ...
);

%-------------------------------
% SHOW CURRENT TAB
%-------------------------------

%--
% bring tab to front
%--

tag = get(obj,'tag');

tmp = findobj(g,'tag',tag,'type','line');

set(tmp,'visible','off');

set(findobj(g,'tag',tag,'type','text'),'color',zeros(1,3));

tmp = findobj(g,'tag',tag,'type','rectangle');

set(tmp, ...
	'edgecolor',zeros(1,3), ...
	'facecolor',get(pal,'color') ...
);

flag = 1;
