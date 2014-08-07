function out = selection_display(h,event,opt,data,sel)

% selection_display - produce or update display of selection zoom
% ---------------------------------------------------------------
%
% opt = selection_display
%
% sel = selection_display(h,event,opt,data,sel)
%
% Input:
% ------
%  h - parent figure handle
%  event - selection event
%  opt - selection display options
%  data - parent userdata
%  sel - selection display figure handle
%
% Output:
% -------
%  opt - selection display options
%  sel - selection display figure handle

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
% $Revision: 819 $
% $Date: 2005-03-27 15:06:08 -0500 (Sun, 27 Mar 2005) $
%--------------------------------

% TODO: display log and id in the case of such display? add context menus?

% NOTE: this function should be lean and fast, the above is probably not right

% TODO: rename to 'selection_zoom_display'

%----------------------------------------------
% HANDLE INPUT
%----------------------------------------------

out = []; 

%--
% set default and possibly output display options
%--

if (nargin < 3) || isempty(opt)

	%--
	% set display options
	%--
	
	% NOTE: these are be used by 'selection_edit' to indicate need to place, resize, and bring to front

	opt.place = 0;
	
	opt.show = 0;
	
	opt.resize = 1;

	%--
	% return display options
	%--
	
	if ~nargin
		out = opt; return;
	end
	
end

%--
% set empty display handle
%--

if nargin < 5
	sel = [];
end

%--
% get userdata if needed
%--

% NOTE: we require at least the parent input for the updates

if (nargin < 4) || isempty(data)
	data = get(h, 'userdata');
end

%--
% get selection event if needed
%--

if (nargin < 2) || isempty(event)
	event = data.browser.selection.event;
end

% NOTE: we are using selection events, which already live in SLIDER time,
% so there is no need to do any mapping.

%----------------------------------------------
% CHECK FOR SELECTION DISPLAY
%----------------------------------------------

%--
% look for existing selection display figure 
%--

% NOTE: there should be a way to save on this by registering the child

if isempty(sel)
	sel = get_xbat_figs('parent', h, 'type', 'selection');
end

%--
% return if no display figure and we are not asked to show
%--

if isempty(sel) && ~opt.show
	return;
end 

%----------------------------------------------
% CHECK ZOOM DISPLAY
%----------------------------------------------

% TODO: at the moment this does not get called there is no selection

if ~data.browser.selection.zoom
	try
		delete(sel); 
	end
	return;
end

%----------------------------------------------
% GET SELECTION STATE
%----------------------------------------------

%--
% create selection display if needed
%--

% TODO: return focus to parent figure on creation

if isempty(sel)
	
	% NOTE: this is used to handle current figure focus
	
	create_flag = 1;
	
	%--
	% create figure and display elements
	%--
	
	sel = figure; 
	
	ax = axes( ...
		'parent', sel, ...
		'tag', ['selection ', int2str(event.channel)] ...
	);
			
	im = image(0);
	
	%--
	% create figure state
	%--
	
	% NOTE: this variable is typically called data
	
	state.parent = h;
	
	state.axes = ax;
	
	state.image = im;
	
	state.zoom = 1;
	
	%--
	% set figure properties and state
	%--
	
	set(sel, ...
		'name','Selection Zoom', ...
		'numbertitle','off', ...
		'tag','XBAT_SELECTION', ...
		'menubar','none', ...
		'toolbar','none', ...
		'doublebuffer','on', ...
		'backingstore','on', ...
		'DockControls','off', ...
		'resize','off', ...
		'userdata',state ...
	);

	%--
	% set selection view menu
	%--
	
	selection_view_menu(sel); 
	
	%--
	% force place on create
	%--
	
	opt.place = 1;
	
else
	
	% NOTE: this is used to handle current figure focus
	
	create_flag = 0;
	
	%--
	% get state from existing selection display figure
	%--
	
	state = get(sel, 'userdata');
	
end

%----------------------------------------------
% UPDATE SELECTION DISPLAY
%----------------------------------------------

%--
% update colormap
%--

% NOTE: the parent and selection colormap are kept in sync

set(sel, ...
	'color', get(h, 'color'), ...
	'colormap', get(h, 'colormap') ...
);

%--
% return on empty or flat selection event
%--

% NOTE: the clauses of this condition are not related

if ( ...
	isempty(event.freq) || ...
	isempty(event.time) || ...
	(event.freq(1) >= event.freq(2)) || ...
	(event.time(1) >= event.time(2)) ...
)
	return;
end

%--
% get axes and image handles by using selection and parent data
%--

if is_log_browser(h)
	tag = '';
else
	tag = int2str(event.channel);
end

hax = findobj(data.browser.axes, 'tag', tag);

if isempty(hax)
	return;
end

him = findobj(hax, 'type', 'image');

%--
% get selection channel image and size
%--

X = get(him, 'cdata'); 

[m, n] = size(X);

%--
% compute indices for selection subimage
%--

xl = get(hax, 'xlim');

% NOTE: getting the vertical limits does not work for non-trivial frequency display

yl = get(hax, 'ylim');

ix = round(n * ((event.time - xl(1)) ./ diff(xl)));

ix = [max(1, ix(1)), min(n, ix(2))];

iy = round(m * ((event.freq/1000 - yl(1)) ./ diff(yl)));

iy = [max(1, iy(1)), min(m, iy(2))];

%--
% crop image and get new size
%--

X = X(iy(1):iy(2), ix(1):ix(2)); 

[m, n] = size(X);

%--
% return on empty image
%--

if ~m || ~n
	return;
end 

%--
% consider frequency scaling
%--

if strcmp(data.browser.grid.freq.labels,'kHz')
	event.freq = event.freq / 1000;
end

%--
% update selection image display
%--

set(state.image, ...
	'xdata',event.time, ...
	'ydata',event.freq, ...
	'cdatamapping','scaled', ...
	'cdata',X ...
);

% NOTE: we get axes color limits from parent channel axes

set(state.axes, ...
	'tag', ['selection ', int2str(event.channel)], ...
	'xlim',event.time, ...
	'xdir','normal', ...
	'ylim',event.freq, ...
	'ydir','normal', ...
	'clim',get(hax,'clim') ...
);


%--
% set grid properties
%--

set_time_grid(state.axes, data.browser.grid, event.time, data.browser.sound.realtime, data.browser.sound);

set_freq_grid(state.axes, data.browser.grid, event.freq);

%--
% set channel label
%--

set(get(state.axes,'ylabel'),'string',['Ch ' int2str(event.channel)]);

%--
% handle display options
%--

if (opt.place)
	position_palette(sel,h,'bottom left'); 
end

% NOTE: this was taking too long

% if (opt.show)
% 	figure(sel); 
% end

if opt.resize	
	selection_resize(sel, X, state.zoom, 32 * [1.25, 1, 1.25, 1.75]);
end

% NOTE: try to reset figure focus, not very reliable

if create_flag
	figure(h);
end

%--
% return figure handle
%--

out = sel;


%-----------------------------------------------
% SELECTION_RESIZE
%-----------------------------------------------

% NOTE: the description of the figure layout is the essential element here

function selection_resize(sel, X, r, M)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 819 $
% $Date: 2005-03-27 15:06:08 -0500 (Sun, 27 Mar 2005) $
%--------------------------------

%--
% return if figure is being deleted
%--

if strcmp(get(sel, 'beingdeleted'), 'on')
	return;
end

%--
% get initial position
%--

pos = get(sel, 'position');

%--
% compute size of figure using margins
%--

% NOTE: all units in pixels

[R,C] = size(X);

R = r * R; 
C = r * C;

H = R + M(1) + M(3);
W = C + M(2) + M(4);

%--
% update figure position
%--

set(sel,'units','pixels');

pos(2) = pos(2) - (H - pos(4));
pos(3) = W;
pos(4) = H;

set(sel,'position',pos);

%--
% update axes position
%--

ax = get_field(get(sel,'userdata'),'axes');

set(ax,'units','pixels');

set(ax,'position',[M(4), M(3), C, R]);


%-----------------------------------------------
% PARSE_LAYOUT
%-----------------------------------------------

function M = parse_layout(layout)

% NOTE: the mnemonic for this layout description convention is TRBL ('trouble')

switch (length(layout))
	
	%--
	% single margin for all sides
	%--
	
	case (1)
		
		M(1) = parse_layout_str(layout{1});
		M(2:4) = M(1);
	
	%--
	% margins for top and bottom, and right and left
	%--
	
	case (2)
		
		M(1) = parse_layout_str(layout{1});
		M(2) = parse_layout_str(layout{2});
		M(3) = M(1);
		M(4) = M(2);
	
	%--
	% margins for top, right and left, and bottom
	%--
	
	case (3)
		
		M(1) = parse_layout_str(layout{1});
		M(2) = parse_layout_str(layout{2});
		M(3) = parse_layout_str(layout{3});
		M(4) = M(2);
	
	%--
	% margin for each side independently
	%--
	
	case (4)
		
		M(1) = parse_layout_str(layout{1});
		M(2) = parse_layout_str(layout{2});
		M(3) = parse_layout_str(layout{3});
		M(4) = parse_layout_str(layout{4});
		
end


%-----------------------------------------------
% PARSE_LAYOUT_STR
%-----------------------------------------------

function M = parse_layout_str(str)

% NOTE: this layout string evaluation is using eval which is slow

%--
% percent string
%--

if (strcmp(str(end),'%'))
	
	M.value = eval(str(1:(end - 1)));
	M.units = 'percent';

%--
% pixel string
%--

elseif (strcmp(str((end - 1):end),'px'))
	
	M.value = eval(str(1:(end - 2)));
	M.units = 'pixels';

%--
% unrecognized string
%--

else
	
	disp(' ');
	error(['Unable to parse layout string: ''' str '''.']);
	
end 
