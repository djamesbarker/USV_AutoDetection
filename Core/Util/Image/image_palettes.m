function [out,c] = image_palettes(h,str)

% image_palettes - create browser palettes
% ------------------------------------------
%
% PAL = image_palettes
%
% [g,c] = image_palettes(h,str)
%
% Input:
% ------
%  h - browser figure handle
%  str - toy name
%
% Output:
% -------
%  PAL - names of browser palettes
%  g - toy figure handle
%  c - indicator of creation

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
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--------------------------------------------------
% COLOR CODE PALETTE SEPARATORS
%--------------------------------------------------

LIGHT_GRAY  = [192, 192, 192] / 255;

COLOR_ON = (2 * LIGHT_GRAY + 4 * [1 1 0.1]) / 6; % yellow highlight
	
%--
% create list of available toys (palettes)
%--

PAL = { ...
	'Colormap', ...
	'Grid', ...
	'Histogram', ...
	'Selection', ...
};

%--
% output palette names
%--

if (~nargin)
	out = PAL;
	return;
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Show';
end

%--
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% check for existing palette and bring to front and center
%--

out = get_palette(h,str);

if (~isempty(out))	
	position_palette(out,h,'center');
	c = 0;
	return;
end

%--
% indicate that the palette will be created
%--

c = 1;

%--
% get parent userdata
%--

data = get(h,'userdata');
		
%--
% show palettes
%--

switch (str)
	
	%-----------------------------------
	% Colormap Palette
	%-----------------------------------
	
	case ('Colormap')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
		
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Colormap', ...
			'space',0.75 ... % 'space',0.5 ... before colormap plot
		);
	
% 		%--
% 		% Colormap_Plot
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Colormap_Plot', ...
% 			'label',0, ...
% 			'lines',1, ...
% 			'space',0.5, ...
% 			'style','axes' ...
% 		);
% 	
% 		%--
% 		% Colormap
% 		%--
% 				
% 		tmp = colormap_to_fun;
% 		ix = find(strcmp(tmp,data.browser.colormap.name));
% 		if (isempty(ix))
% 			ix = 1;
% 		end
% 	
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Colormap', ...
% 			'tooltip','Colormap of image display', ...
% 			'style','popup', ...
% 			'space',1.25, ... % 'space',1.25, ... before colormap plot
% 			'lines',1, ...
% 			'string',tmp, ...
% 			'value',ix ...
% 		);
	
		%--
		% Colormap
		%--
				
		tmp = colormap_to_fun;
		ix = find(strcmp(tmp,data.browser.colormap.name));
		if (isempty(ix))
			ix = 1;
		end
	
		j = j + 1;
		control(j) = control_create( ...
			'name','Colormap', ...
			'tooltip','Colormap of image display', ...
			'style','popup', ...
			'space',0.75, ... % 'space',1.25, ... before colormap plot
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
		
		%--
		% Colormap_Plot
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Colormap_Plot', ...
			'label',0, ...
			'lines',1, ...
			'space',0.75, ...
			'style','axes' ...
		);
	
		%--
		% Colorbar
		%--
		
		tmp = ~isempty(findobj(h,'tag','Colorbar','type','axes'));
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Colorbar', ...
			'tooltip','Toggle display of colorbar (C)', ...
			'style','checkbox', ...
			'lines',0, ...
			'value',tmp ...
		);
	
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Contrast' ...
		);
	
% 		'string','Scale' ...
		
		%--
		% Brightness
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Brightness', ...
			'tooltip','Center of dynamic range', ...
			'style','slider', ...
			'active',1, ...
			'value',data.browser.colormap.brightness ...
		);
	
		%--
		% Contrast
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Contrast', ...
			'tooltip','Width of dynamic range', ...
			'style','slider', ...
			'active',1, ...
			'value',data.browser.colormap.contrast ...
		);
	
		%--
		% Auto Scale
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Auto Scale', ...
			'alias','Auto', ...
			'tooltip','Toggle automatic scaling of colormap (A)', ...
			'style','checkbox', ...
			'space',0.75, ...
			'lines',0, ...
			'value',data.browser.colormap.auto_scale ...
		);

% 		%--
% 		% Separator
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'style','separator' ...
% 		);
	
		%--
		% Invert
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Invert', ...
			'tooltip','Toggle inversion of colormap (I)', ...
			'style','checkbox', ...
			'space',0.75, ...
			'lines',0, ...
			'value',data.browser.colormap.invert ...
		);
	
% 		%--
% 		% Separator
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'style','separator', ...
% 			'type','header', ...
% 			'string','Colorbar' ...
% 		);
% 	
% 		%--
% 		% Colorbar
% 		%--
% 		
% 		tmp = ~isempty(findobj(h,'tag','Colorbar','type','axes'));
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Colorbar', ...
% 			'tooltip','Toggle display of colorbar (C)', ...
% 			'style','checkbox', ...
% 			'space',0.75, ...
% 			'lines',0, ...
% 			'value',tmp ...
% 		);
		
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end

		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1.25;
		
		opt.handle_to_callback = 1;
				
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%--
		% update controls state
		%--
		
		if (data.browser.colormap.auto_scale)
			control_update(h,'Colormap','Brightness','__DISABLE__');
			control_update(h,'Colormap','Contrast','__DISABLE__');
		end
		
		if (data.browser.colormap.contrast == 0)
			control_update(h,'Colormap','Brightness','__DISABLE__');
		end
		
		%--
		% display colorbar type image in plot axes
		%--
		
		g = findobj(out,'type','axes','tag','Colormap_Plot');
		
		axes(g);
				
		hold on;
		
		tmp = imagesc(0:255);
		
		set(g, ...
			'linewidth',2, ...
			'ycolor',get(out,'color'), ...
			'xcolor',get(out,'color'), ...
			'xtick',[], ...
			'ytick',[], ...
			'xlim',[0,1], ...
			'ylim',[0,1] ...
		);
	
		set(tmp, ...
			'xdata',[0,1], ...
			'ydata',[0,1] ...
		);
	
		tmp = plot([0 1 1 0 0],[0 0 1 1 0],'k');
	
		set(tmp,'color',0.5*ones(1,3));
		
		set(out, ...
			'colormap',feval(colormap_to_fun(data.browser.colormap.name),256) ...
		);
		
	%-----------------------------------
	% Channel Palette
	%-----------------------------------
	
	case ('Channel')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
	
		%--
		% Array Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Array', ...
			'space',0.5 ...
		);
	
		%--
		% Channel
		%--

		nch = data.browser.sound.channels;
		
		for k = 1:nch
			L{k} = ['Channel ' int2str(k)];
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Channel', ...
			'style','popup', ...
			'string',L, ...
			'space',1.25, ...
			'value',1 ...
		);
	
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator' ...
		);
	
		%--
		% Geometry_Plot
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Geometry_Plot', ...
			'width',1, ...
			'align','center', ...
			'lines',6, ...
			'label',0, ...
			'style','axes' ...
		);
	
		%--
		% Position
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Position', ...
			'style','edit', ...
			'string','' ...
		);
	
		%--
		% Calibration
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Calibration', ...
			'style','edit', ...
			'string','' ...
		);
		
	
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1;
		
		opt.handle_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%--
		% display microphone locations geometry axes
		%--
		
		g = findobj(out,'type','axes','tag','Geometry_Plot');
		
		axes(g);
		
		hold on;
		
		nch = data.browser.sound.channels;
		
		%--
		% create patch markers to display microphone locations
		%--
		
		tmp = scatter(randn(nch,1),randn(nch,1));
		
		for k = 1:length(nch)
			set(tmp(k),'tag',int2str(k));
		end
		
		set(tmp, ...
			'markerfacecolor',[0 0 0], ...
			'markeredgecolor',[1 1 1] ...
		);
	
		%--
		% highlight control selected channel
		%--
		
		set(tmp(1), ...
			'markerfacecolor',[1 0 0], ...
			'markeredgecolor',[1 1 1] ...
		);
	
		%--
		% highlight displayed channels
		%--

	%-----------------------------------
	% Event Palette
	%-----------------------------------
	
	case ('Event')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
	
		%-----------------------------------
		% Events Header
		%-----------------------------------

		j = j + 1;
		control(j) = control_create( ...
			'string','Events', ...
			'style','separator', ...
			'space',0.5, ...
			'type','header' ...
		);

		%-----------------------------------
		% Find Events
		%-----------------------------------

		j = j + 1;
		control(j) = control_create( ...
			'name','find_events', ...
			'alias','Search', ...
			'space',0.75, ... 
			'color',ones(1,3), ...
			'style','edit' ...
		);
	
		%-----------------------------------
		% Events
		%-----------------------------------

		j = j + 1;
		control(j) = control_create( ...
			'alias','Events', ...
			'name','event_display', ...
			'style','listbox', ...
			'lines',8, ... % used to be 2
			'space',0.75, ...
			'min',0, ...
			'max',2 ...
		);

		%-----------------------------------
		% Visible
		%-----------------------------------
		
		j = j + 1;
		control(j) = control_create( ...
			'name','visible_events_only', ...
			'alias','Visible', ...
			'tooltip','Only display visible log events', ...
			'style','checkbox', ...
			'space',0.75, ... % used to be 0.75 when using the toggle based display
			'lines',0, ...
			'value',0 ...
		);
	
		%-----------------------------------
		% Page
		%-----------------------------------
		
		j = j + 1;
		control(j) = control_create( ...
			'name','page_events_only', ...
			'alias','Page', ...
			'tooltip','Only display events on current page', ...
			'style','checkbox', ...
			'space',0.75, ... % used to be 0.75 when using the toggle based display
			'lines',0, ...
			'value',0 ...
		);
	
		% NOTE: double-click operation of this function seems sufficient
		
% 		%--
% 		% Jump
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','event_jump', ...
% 			'alias','Jump', ...
% 			'tooltip','Jump to event on selection', ...
% 			'style','checkbox', ...
% 			'space',0.75, ... % used to be 0.75 when using the toggle based display
% 			'lines',0, ...
% 			'value',0 ...
% 		);
	
		%--
		% Previous and Next
		%--
	
		j = j + 1;
		control(j) = control_create( ...
			'alias',{'Previous','Next'}, ...
			'name',{'previous_event','next_event'}, ...
			'style','buttongroup', ...
			'lines',1.75, ...
			'space',1.25 ...
		);
	
		% TODO: consider adding play button 
		
		%-----------------------------------
		% Event Info Separator
		%-----------------------------------

		j = j + 1;
		control(j) = control_create( ...
			'string','Event Info', ...
			'style','separator', ...
			'align','right' ...
		);

		%-----------------------------------
		% Event Info
		%-----------------------------------

		j = j + 1;
		control(j) = control_create( ...
			'name','event_info', ...
			'style','listbox', ...
			'label',0, ...
			'space',0, ...
			'min',0, ...
			'max',2, ...
			'lines',3 ...
		);
	
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		for k = 1:length(control)
			if (strcmp(control(k).style,'separator') & ~isempty(control(k).string))
				control(k).color = COLOR_ON;
			end
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0;
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 12;
		opt.top = 0;
		opt.bottom = 1.5;
		
		opt.handle_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		% this is the standard kpfun that sends the key to the parent
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%--
		% update controls state
		%--
		
		update_find_events(h,[],data);
		
		%--
		% attach contextual menu to display
		%--
		
		% TODO: implement 'delete_events' function and add other menus
		
		g = findobj(out,'tag','event_display','style','listbox');
	
		cm = uicontextmenu;
		
		set(g,'uicontextmenu',cm);
		
		uimenu(cm, ...
			'label','Delete Event(s) ...', ...
			'separator','on', ...
			'callback',@delete_events ...
		);
		
	%-----------------------------------
	% Grid Palette
	%-----------------------------------
	
	case ('Grid')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
		
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'space',0.5, ...
			'type','header', ...
			'string','Color' ...
		);
	
		%--
		% Color
		%--
		
		tmp = color_to_rgb;
		ix = find(strcmp(tmp,rgb_to_color(data.browser.grid.color)));
		if (isempty(ix))
			ix = 1;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Color', ...
			'tooltip','Color used to display axes, grids, and associated text', ...
			'style','popup', ...
			'space',1.25, ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
	
% 		%--
% 		% Separator
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'style','separator', ...
% 			'type','header', ...
% 			'string','Time' ...
% 		);
	
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',0.1, ...
			'string','Grid' ...
		);
	
		%--
		% Grid Tabs
		%--
		
		if (~strcmp(data.browser.sound.type,'File'))
			tabs = {'Time','Freq','File'};
		else
			tabs = {'Time','Freq'}; 
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'style','tabs', ...
			'name','Grid Tabs', ...
			'label',0, ... % this should be set by control group
			'lines',1.25, ...% this should be set by control group
			'tab',tabs ...
		);
	
		%--
		% Time Spacing
		%--
		
		dt = data.browser.grid.time.spacing;
		if (isempty(dt))
			dt = 0;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Time Spacing', ...
			'alias','Spacing', ...
			'tab','Time', ...
			'tooltip','Spacing between time ticks in seconds', ...
			'style','slider', ...
			'min',0.05, ...
			'max',120, ...
			'value',dt ...
		);
	
		%--
		% Time Labels
		%--
		
		tmp = {'Seconds','Clock','Date and Time'};
		ix = find(strcmp(lower(tmp),data.browser.grid.time.labels));
		
		% original
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Time Labels', ...
			'alias','Labels', ...
			'tab','Time', ...
			'tooltip','Format of displayed times', ...
			'style','popup', ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
		
		%--
		% Time Grid
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Time Grid', ...
			'alias','On', ...
			'tab','Time', ...
			'tooltip','Toggle display of time grid', ...
			'style','checkbox', ...
			'space',0, ... % used to be 0.75 when using the toggle based display
			'lines',0, ...
			'value',data.browser.grid.time.on ...
		);
	
% 		%--
% 		% Separator
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'style','separator', ...
% 			'type','header', ...
% 			'string','Frequency' ...
% 		);
	
		%--
		% Freq Spacing
		%--
		
		r = data.browser.sound.samplerate;
		df = data.browser.grid.freq.spacing;
		
		if (isempty(df))
			df = 0;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Freq Spacing', ...
			'tab','Freq', ...
			'alias','Spacing', ...
			'tooltip','Spacing between frequency ticks in Hz', ...
			'style','slider', ...
			'min',0, ...
			'max',(r / 2), ...
			'value',df ...
		);
		
		%--
		% Freq Labels
		%--
				
		tmp = {'Hz','kHz'};
		ix = find(strcmp(tmp,data.browser.grid.freq.labels));
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Freq Labels', ...
			'alias','Labels', ...
			'tab','Freq', ...
			'tooltip','Format of displayed frequencies', ...
			'style','popup', ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
		
		%--
		% Freq Grid
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Freq Grid', ...
			'alias','On', ...
			'tab','Freq', ...
			'tooltip','Toggle display of frequency grid', ...
			'style','checkbox', ...
			'space',0, ... % used to be 0.75 when using the toggle based display
			'lines',0, ...
			'value',data.browser.grid.freq.on ...
		);
		
		%--
		% add file grid control only when the sound is not a single file
		%--
		
		if (~strcmp(data.browser.sound.type,'File'))
			
% 			%--
% 			% Separator
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'style','separator', ...
% 				'type','header', ...
% 				'string','File' ...
% 			);
		
			%--
			% File Grid
			%--
				
			% what does it mean for the checkbox to have zero lines
			
			j = j + 1;
			control(j) = control_create( ...
				'name','File Grid', ...
				'alias','On', ...
				'tab','File', ...
				'tooltip','Toggle display of file boundaries grid', ...
				'style','checkbox', ...
				'space',0, ... % let this space be given by the margin
				'lines',0, ... % this should be set in the control_group
				'value',data.browser.grid.file.on ...
			);

		end
		
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1.25;
		
		opt.handle_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%--
		% update controls state
		%--
		
		if (data.browser.colormap.auto_scale)
			control_update(h,'Colormap','Brightness','__DISABLE__');
			control_update(h,'Colormap','Contrast','__DISABLE__');
		end
	
	%-----------------------------------
	% Log Palette
	%-----------------------------------
	
	case ('Log')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
		
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Active', ...
			'type','header', ...
			'space',0.75 ...
		);
	
		%--
		% get log information and sort logs
		%--
		
		if (isempty(data.browser.log))
			
			%--
			% these are all dummy values required to produce display
			%--
			
			nl = 0; % number of logs open
						
			L = {'(No Open Logs)'}; % sorted log names
			
			aix = 1; % active log

			visible = []; % visible logs
			
		else
			
			% number of logs open
			
			nl = length(data.browser.log);
			
			% sorted log names
			
			L = file_ext(struct_field(data.browser.log,'file'));
			
			[L,ix] = sort(L); 

			% active log
			
			m = data.browser.log_active;
			
			aix = find(ix == m);

			% visible logs
			
			visible = struct_field(data.browser.log,'visible');
			
			visible = visible(ix); 
			
			visible = find(visible);
			
		end
		
		%--
		% Active
		%--

		j = j + 1;
		control(j) = control_create( ...
			'name','Active', ...
			'tooltip','Active log, default for saving new events', ...
			'style','popup', ...
			'space',0.75, ... % 'space',1.25, ...
			'lines',1, ...
			'string',L, ...
			'value',aix ...
		);
		
		%--
		% New and Open Log
		%--
	
		j = j + 1;
		control(j) = control_create( ...
			'name',{'New Log','Open Log ...'}, ...
			'style','buttongroup', ...
			'lines',1.75, ...
			'space',1.25 ...
		);
	
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Display', ...
			'type','header', ...
			'space',0.75 ...
		);
	
		%--
		% Display
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Display', ...
			'tooltip','Logs displayed', ...
			'style','listbox', ...
			'min',0, ...
			'max',2, ...
			'lines',5, ...
			'space',1.25, ...
			'value',visible, ...
			'string',L, ...
			'confirm',1 ...
		);
	
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Options', ...
			'type','header', ...
			'space',0.5 ...
		);
	
		%--
		% Log
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Log', ...
			'tooltip','Log updated through options', ...
			'style','popup', ...
			'space',1.25, ...
			'lines',1, ...
			'string',L, ...
			'value',aix ...
		);
	
		%--
		% Separator
		%--
		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'style','separator', ...
% 			'space',0.75 ...
% 		);
	
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'space',0.12 ...
		);
	
		tabs = {'Display','View'};
		
		j = j + 1;
		control(j) = control_create( ...
			'style','tabs', ...
			'label',0, ...		% this should be set by control group
			'lines',1.25, ...	% this should be set by control group
			'tab',tabs, ...
			'name','Log Option Tabs' ...
		);

		%--
		% Color
		%--
		
		C = color_to_rgb;
		
		if (isempty(data.browser.log))
			
			ix = 1;
			name = '';
			
		else
						
			ix = find(strcmp(C,rgb_to_color(data.browser.log(m).color)));		
			
			if (isempty(ix))
				ix = 1;
			end
			
			name = file_ext(data.browser.log(m).file);
			
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Color', ...
			'tab',tabs{1}, ...
			'tooltip',['Color for ''' name ''' event display'], ...
			'style','popup', ...
			'space',1, ...
			'lines',1, ...
			'string',C, ...
			'confirm',0, ... % the confirm variable is used to produce the visual feedback axes
			'value',ix ...
		);
		
		%--
		% Line Style
		%--
		
		L = linestyle_to_str('','strict');
		
		ix = 1;
		
		% there is now a way to set this control properly
		
% 		if (isempty(m))
% 			ix = 1;
% 		else
% 			ix = find(strcmp(L,rgb_to_color(data.browser.log(m).color)));			
% 			if (isempty(ix))
% 				ix = 1;
% 			end
% 		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Line Style', ...
			'tab',tabs{1}, ...
			'tooltip',['Line style for ''' name ''' event display'], ...
			'style','popup', ...
			'space',1, ...
			'lines',1, ...
			'string',L, ...
			'value',ix ...
		);
		
		%--
		% Line Width
		%--
			
		if (isempty(data.browser.log))
			tmp = 1;
		else
			tmp = data.browser.log(m).linewidth;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Line Width', ...
			'tab',tabs{1}, ...
			'tooltip',['Line width for ''' name ''' event display'], ...
			'style','slider', ...
			'type','integer', ...
			'space',1, ...
			'lines',1, ...
			'min',1, ...
			'max',4, ...
			'sliderstep',[1,1] ./ 3, ...
			'value',tmp ...
		);
	
		%--
		% Opacity
		%--
				
		if (isempty(data.browser.log))
			tmp = 0;
		else
			tmp = data.browser.log(m).patch;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Opacity', ...
			'tab',tabs{1}, ...
			'tooltip',['Opacity level for ''' name ''' event display'], ...
			'style','slider', ...
			'space',0, ...
			'lines',1, ...
			'min',0, ...
			'max',1, ...
			'value',0 ...
		);
	
		%--
		% Auto Save
		%--
				
		if (isempty(data.browser.log))
			tmp = 0;
		else
			tmp = data.browser.log(m).autosave;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','event_id', ...
			'alias','ID', ...
			'tab',tabs{2}, ...
			'tooltip',['Toggle display of event ID numbers.'], ...
			'style','checkbox', ...
			'lines',0, ...
			'space',0.75, ...
			'value',1 ...
		);
		
% 		%--
% 		% Auto Save
% 		%--
% 				
% 		if (isempty(data.browser.log))
% 			tmp = 0;
% 		else
% 			tmp = data.browser.log(m).autosave;
% 		end
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Auto Save', ...
% 			'alias','Auto Save', ...
% 			'tab','Save', ...
% 			'tooltip',['Toggle automatic saving of ''' name '''.'], ...
% 			'style','checkbox', ...
% 			'lines',0, ...
% 			'space',0.75, ...
% 			'value',tmp ...
% 		);
% 	
% 		%--
% 		% Save and Save As ...
% 		%--
% 				
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name',{'Save Log','Save Log As ...'}, ...
% 			'alias',{'Save','Save As ...'}, ...
% 			'tab','Save', ...
% 			'style','buttongroup', ...
% 			'lines',1.75 ...
% 		);
% 	
% 		%--
% 		% Separator
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Backup Separator', ...
% 			'style','separator', ...
% 			'tab','Save' ...
% 		);
% 	
% 		%--
% 		% Backup Log
% 		%--
% 				
% 		if (isempty(data.browser.log))
% 			tmp = 0;
% 		else
% 			tmp = data.browser.log(m).autosave;
% 		end
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Backup Log', ...
% 			'alias','Auto Backup', ...
% 			'tab','Save', ...
% 			'tooltip',['Toggle automatic backup of ''' name '''.'], ...
% 			'style','checkbox', ...
% 			'space',0.75, ...
% 			'lines',0, ...
% 			'value',tmp ...
% 		);
% 	
% 		%--
% 		% Backup and Backup To ...
% 		%--
% 				
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name',{'Backup','Backup To ...'}, ...
% 			'tab','Save', ...
% 			'style','buttongroup', ...
% 			'lines',1.75 ...
% 		);
% 	
% 		%--
% 		% Separator
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Read Only Separator', ...
% 			'style','separator', ...
% 			'tab','Save' ...
% 		);
% 
% 		%--
% 		% Read Only
% 		%--
% 				
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Read Only', ...
% 			'tab','Save', ...
% 			'tooltip',['Toggle automatic backup of ''' name '''.'], ...
% 			'style','checkbox', ...
% 			'lines',0, ...
% 			'label',0, ...
% 			'space',0, ...
% 			'value',0 ... % will be replaced by data.browser.log(m).readonly
% 		);

		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (strcmp(control(tmp(k)).type,'header'))
% 			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 8; % used to be 7.5, made larger to accomodate longer log names
		opt.top = 0;
		opt.bottom = 1.5; % the longest pane ends in a checkbox 
		
		opt.handle_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		% this is the standard kpfun that sends the key to the parent
		
		set(out,'tag',['XBAT_PALETTE::' str]);

		% this function executes the callback for the edit box, however it
		% is still quirky, it is not clear that this is a better option
		
% 		set(out, ...
% 			'tag',['XBAT_PALETTE::' str], ...
% 			'keypressfcn',@log_palette_kpfun ...
% 		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%--
		% update controls state
		%--
		
		if (isempty(data.browser.log))
			
			for k = 1:length(control)
				
				if (~strcmp(control(k).style,'separator') & ~strcmp(control(k).style,'tabs'))
					
					if (~iscell(control(k).name))
						control_update(h,'Log',control(k).name,'__DISABLE__',data);
					else
						for j = 1:(prod(size(control(k).name)))
							control_update(h,'Log',control(k).name{j},'__DISABLE__',data);
						end
					end
					
				end
				
			end
			
			control_update(h,'Log','New Log','__ENABLE__',data);
			
			control_update(h,'Log','Open Log ...','__ENABLE__',data);
			
		end
		
		%--
		% disable ID control
		%--
		
		control_update(h,'Log','event_id','__DISABLE__',data);
		
		%--
		% attach contextual menu to display
		%--
		
		g = findobj(out,'tag','Display','style','listbox');
		
		L = { ...
			'Bring to Front', ...
			'Bring Forward', ...
			'Send Backward', ...
			'Send to Back' ...
		};
	
		cm = uicontextmenu;
		
		set(g,'uicontextmenu',cm);
		
		tmp = uimenu(cm, ...
			'label','Arrange', ...
			'enable','off' ...
		);
		
		uimenu(cm, ...
			'label','Close', ...
			'separator','on', ...
			'callback',@close_logs ...
		);
		
		menu_group(tmp,@arrange_logs,L);
		
	%-----------------------------------
	% Jog Palette
	%-----------------------------------
	
	case ('Jog')
	
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
				
		%--
		% Separator
		%--
		
		j = 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Jog', ...
			'type','header', ...
			'space',0.75 ...
		);
		
		%--
		% Speed
		%--
	
		% NOTE: active controls are not stable yet
		
		j = j + 1;
		control(j) = control_create( ...
			'name','jog_speed', ...
			'alias','Speed', ...
			'tooltip',['Jog speed'], ...
			'style','slider', ...
			'active',1, ...
			'space',0.75, ...
			'lines',1, ...
			'min',-32, ...
			'max',32, ...
			'sliderstep',[1/64, 1/32], ...
			'value',1 ...
		);
	
		%--
		% Go/Stop
		%--
		
		% NOTE: this control introduces a button with changing label string
		
		j = j + 1;
		control(j) = control_create( ...
			'name',{'jog_toggle'}, ...
			'alias',{'Go'}, ...
			'style','buttongroup', ...
			'lines',1.75, ...
			'space',0.75 ... % before loop control % 'space',1.25 ...
		);
	
		%--
		% Loop
		%--
		
		% NOTE: no looping seems a reasonable default
		
		j = j + 1;
		control(j) = control_create( ...
			'name','jog_loop', ...
			'alias','Loop', ...
			'tooltip','Loop sound if jogging', ...
			'style','checkbox', ...
			'lines',0, ...
			'space',0, ...
			'value',0 ...
		);
	
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (strcmp(control(tmp(k)).type,'header'))
% 			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 10; % used to be 7.5, made larger to accomodate longer log names
		opt.top = 0;
		opt.bottom = 1; % the longest pane ends in a checkbox 
		
		opt.handle_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		% this is the standard kpfun that sends the key to the parent
		
		set(out,'tag',['XBAT_PALETTE::' str]);

		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);

	%-----------------------------------
	% Navigate Palette
	%-----------------------------------
	
	case ('Navigate')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		type = data.browser.sound.type;
		
		if (strcmp(type,'File'))

			j = 0;
			
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'type','header', ...
				'string','Time' ...
			);
		
			%--
			% Time
			%--
			
			% FIXME: making this slider active leads to a number of
			% problems that should be addressed in the implementation of
			% active controls and display. mostly these have to do with
			% relying on current figure and object concepts within the
			% system. adding some state to this functionality may resolve
			% this, how to this is largely the challenge
			
			% get slider properties from browser slider
			
			tmp = get(data.browser.slider);
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Time', ...
				'tooltip','Start time of page in current time format', ...
				'style','slider', ...
				'active',1, ...
				'string',0.45, ...
				'type','time', ...
				'min',tmp.Min, ...
				'max',tmp.Max, ...
				'sliderstep',tmp.SliderStep, ...
				'value',tmp.Value ...
			);
	
% 			%--
% 			% Separator/Header
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'style','separator', ...
% 				'type','header', ...
% 				'string','View' ...
% 			);
% 		
% 			%--
% 			% View
% 			%--
% 			
% 			tmp = data.browser.view;
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'name','View', ...
% 				'tooltip','Move to saved previous view', ...
% 				'style','slider', ...
% 				'space',1.25, ...
% 				'string',0.45, ...
% 				'type','integer', ...
% 				'min',1, ...
% 				'max',tmp.max, ...
% 				'sliderstep',[1,5] / (tmp.max - 1), ...
% 				'value',tmp.position ...
% 			);
		
			%--
			% set palette figure options
			%--
			
			opt = control_group;
		
			opt.width = 7.5;
			opt.top = 0;
			opt.bottom = 1.25;
			
			opt.handle_to_callback = 1;
				
		else
		
			j = 0;
			
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'type','header', ...
				'string','Time' ...
			);
		
			%--
			% Time
			%--
			
			% get slider properties from browser slider
			
			tmp = get(data.browser.slider);
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Time', ...
				'tooltip','Start time of page in current time format', ...
				'style','slider', ...
				'space',1.25, ...
				'string',0.45, ...
				'type','time', ...
				'min',tmp.Min, ...
				'max',tmp.Max, ...
				'sliderstep',tmp.SliderStep, ...
				'value',tmp.Value ...
			);
	
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'type','header', ...
				'space',0.5, ...
				'string','File' ...
			);
		
			%--
			% File
			%--
			
			tmp = data.browser.sound.file;
			
			j = j + 1;
			control(j) = control_create( ...
				'name','File', ...
				'tooltip','Align page start with file start', ...
				'style','popup', ...
				'space',0.75, ...
				'string',tmp, ...
				'value',1 ...
			);
		
			%--
			% Prev-Next File
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name',{'Prev File','Next File'}, ...
				'tooltip',{'Go to start of previous file (''['')','Go to start of next file ('']'')'}, ...
				'style','buttongroup', ...
				'lines',1.75 ...
			);
		
% 			%--
% 			% Separator/Header
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'style','separator', ...
% 				'type','header', ...
% 				'string','View' ...
% 			);
% 		
% 			%--
% 			% View
% 			%--
% 			
% 			tmp = data.browser.view;
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'name','View', ...
% 				'tooltip','Move to saved previous view', ...
% 				'style','slider', ...
% 				'string',0.45, ...
% 				'type','integer', ...
% 				'min',1, ...
% 				'max',tmp.max, ...
% 				'sliderstep',[1,5] / (tmp.max - 1), ...
% 				'value',tmp.position ...
% 			);
		
			%--
			% set palette figure options
			%--
			
			opt = control_group;
		
% 			opt.width = 7.5;
			opt.width = 9;
			opt.top = 0;
			opt.bottom = 1.25;
			
			opt.handle_to_callback = 1;
		
		end
		
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control figure
		%--
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);	
		
		%-----------------------------------
		% UPDATE CONTROLS
		%-----------------------------------
		
		% this updates most of the navigation controls
		
		browser_navigation_update(h,data);
		
	%-----------------------------------
	% Page Palette
	%-----------------------------------
	
	case ('Page')

		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
		
		% display for this control element depends on whether we are
		% dealing with a single or multiple channel recording. further
		% variation could be considered such as offering channel reordering
		% functions only when there are more than two channels, this would
		% make the display for stereo recordings less cluttered, another
		% possibility is to include a simple swap control for stereo
		% recordings
		
		switch (data.browser.sound.channels)
			
		case (1)
			
			% there are no channel controls for single channel sounds
			
		case (2)
			
			%-----------------------------------
			% Channels Header and Tabs
			%-----------------------------------
		
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'type','header', ...
				'space',0.1, ...
				'string','Channels' ...
			);
		
			j = j + 1;
			control(j) = control_create( ...
				'style','tabs', ...
				'label',0, ... % this should be set by control group
				'lines',1.25, ...% this should be set by control group
				'tab',{'Display','Array'}, ...
				'space',0.75, ...
				'name','Channel Tabs' ...
			);
		
			%-----------------------------------
			% Channels
			%-----------------------------------
						
			%--
			% create channel name strings
			%--
			
			nch = data.browser.sound.channels;
			
			for k = 1:nch
				L{k} = ['Channel ' int2str(data.browser.channels(k,1))];
			end
			
			%--
			% add channel play information to strings
			%--
			
			% this does not fit well with the multiple uses of the listbox
			% or the reassignment of play channels
			
% 			chp = data.browser.play.channel;
% 			
% 			if (~diff(chp))
% 				ix = find(data.browser.channels(:,1) == chp(1));
% 				L{ix} = [L{ix} '  (LR)'];
% 			else
% 				ix = find(data.browser.channels(:,1) == chp(1));
% 				L{ix} = [L{ix} '  (L)'];
% 				ix = find(data.browser.channels(:,1) == chp(2));
% 				L{ix} = [L{ix} '  (R)'];
% 			end
				
			%--
			% get currently displayed channels and define control
			%--
			
			value = find(data.browser.channels(:,2));
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Channels', ...
				'tab','Display', ...
				'tooltip','Channels displayed in page', ...
				'style','listbox', ...
				'min',0, ...
				'max',2, ...
				'lines',0.7 * nch, ...
				'space',0.5, ... % used to be 1.25
				'value',value, ...
				'string',L, ...
				'confirm',0 ... % used before adding ordering 
			);
		
			%-----------------------------------
			% Ordering Buttons
			%-----------------------------------
			
			% the use of the cell array for the buttongroup name is a
			% problem. the button group should have a name, and the button
			% labels should perhaps be stored in the string field.
			
			% currently this is generating a problem in the use of struct
			% field to extract the name field from an array of controls,
			% which could be fixed in struct_field, nevertheless it is not
			% semantically consistent to have the cell array as a name
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Swap', ...
				'tab','Display', ...
				'align','left', ...
				'style','buttongroup', ...
				'lines',1.75, ...
				'space',0.5 ... % was 1.5 before adding apply-cancel buttons
			);
		
			%--
			% Apply and Cancel Buttons
			%--
			
			% perhaps apply could be called 'Update', apply is more
			% universal but generic
			
			j = j + 1;
			control(j) = control_create( ...
				'name',{'Apply Channels','Cancel Channels'}, ...
				'tab','Display', ...
				'alias',{'Apply','Cancel'}, ...
				'style','buttongroup', ...
				'lines',1.75, ...
				'label',0, ...
				'space',1.25 ...
			);
		
			%--
			% Channel
			%--
	
			nch = data.browser.sound.channels;
			
			for k = 1:nch
				L{k} = ['Channel ' int2str(k)];
			end
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Select Channel', ...
				'alias','Channel', ...
				'tab','Array', ...
				'style','popup', ...
				'string',L, ...
				'space',1.25, ...
				'value',1 ...
			);
		
			%--
			% Separator
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'tab','Array', ...
				'space',0.75, ...
				'style','separator' ...
			);
		
			%--
			% Position
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Position', ...
				'tab','Array', ...
				'style','edit', ...
				'string','' ...
			);
		
			%--
			% Calibration
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Calibration', ...
				'tab','Array', ...
				'style','edit', ...
				'space',1.25, ...
				'string','' ...
			);
			
		otherwise
			
			%-----------------------------------
			% Channels Header and Tabs
			%-----------------------------------
		
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'type','header', ...
				'space',0.1, ...
				'string','Channels' ...
			);
		
			j = j + 1;
			control(j) = control_create( ...
				'style','tabs', ...
				'label',0, ... % this should be set by control group
				'lines',1.25, ...% this should be set by control group
				'tab',{'Display','Array'}, ...
				'space',0.75, ... % used to be 0.75
				'name','Channel Tabs' ...
			);
	
			%-----------------------------------
			% Channels
			%-----------------------------------
						
			%--
			% create channel name strings
			%--
			
			nch = data.browser.sound.channels;
			
			for k = 1:nch
				L{k} = ['Channel ' int2str(data.browser.channels(k,1))];
			end
			
			%--
			% add channel play information to strings
			%--
			
			% this does not fit well with the multiple uses of the listbox
			% or the reassignment of play channels
			
% 			chp = data.browser.play.channel;
% 			
% 			if (~diff(chp))
% 				ix = find(data.browser.channels(:,1) == chp(1));
% 				L{ix} = [L{ix} '  (LR)'];
% 			else
% 				ix = find(data.browser.channels(:,1) == chp(1));
% 				L{ix} = [L{ix} '  (L)'];
% 				ix = find(data.browser.channels(:,1) == chp(2));
% 				L{ix} = [L{ix} '  (R)'];
% 			end
				
			%--
			% get currently displayed channels and define control
			%--
			
			value = find(data.browser.channels(:,2));
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Channels', ...
				'tab','Display', ...
				'tooltip','Channels displayed in page', ...
				'style','listbox', ...
				'min',0, ...
				'max',2, ...
				'lines',0.7 * nch, ...
				'space',0.5, ... % used to be 1.25
				'value',value, ...
				'string',L, ...
				'confirm',0 ... % used before adding ordering 
			);
		
			%-----------------------------------
			% Ordering Buttons
			%-----------------------------------

			j = j + 1;
			control(j) = control_create( ...
				'name',{'Up','Down'; 'Top', 'Bottom'}, ...
				'tab','Display', ...
				'style','buttongroup', ...
				'lines',2 * 1.75, ...
				'space',0.5 ... % was 1.5 before adding apply-cancel buttons
			);
		
			%--
			% Ordering buttons
			%--
			
			% these commands should appear in a contextual menu associated
			% to the channels control
			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'name',{'Default','Order'}, ...
% 				'style','buttongroup', ...
% 				'lines',1.75, ...
% 				'space',0 ... % was 1.5 before adding apply-cancel buttons
% 			);
		
			%--
			% Apply and Cancel Buttons
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name',{'Apply Channels','Cancel Channels'}, ...
				'tab','Display', ...
				'alias',{'Apply','Cancel'}, ...
				'style','buttongroup', ...
				'lines',1.75, ...
				'label',0, ...
				'space',1.25 ...
			);
		
			%--
			% Geometry_Plot
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Geometry_Plot', ...
				'alias','Layout', ...
				'tab','Array', ...
				'width',1, ...
				'align','center', ...
				'lines',8, ...
				'label',1, ...
				'space',0.75, ... % used to be 1.75 when separator was in place
				'style','axes' ...
			);
		
% 			%--
% 			% Separator
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'tab','Array', ...
% 				'space',0.5, ...
% 				'style','separator' ...
% 			);
		
			%--
			% Channel
			%--
	
			nch = data.browser.sound.channels;
			
			for k = 1:nch
				L{k} = ['Channel ' int2str(k)];
			end
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Select Channel', ...
				'alias','Channel', ...
				'tab','Array', ...
				'style','popup', ...
				'string',L, ...
				'label',1, ...
				'space',1, ...
				'value',1 ...
			);
		
% 			%--
% 			% Separator
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'tab','Array', ...
% 				'space',0.75, ...
% 				'style','separator' ...
% 			);
		
			%--
			% Position
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Position', ...
				'tab','Array', ...
				'style','edit', ...
				'string','' ...
			);
		
			%--
			% Calibration
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Calibration', ...
				'tab','Array', ...
				'style','edit', ...
				'space',1, ...
				'string','' ...
			);
		
% 			%--
% 			% Import Array Attributes
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'name','Import Array', ...
% 				'alias','Import Array Data ...', ...
% 				'tab','Array', ...
% 				'style','buttongroup', ...
% 				'lines',1.75, ...
% 				'space',1.25, ...
% 				'string','' ...
% 			);
		
		
		end
		
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Time' ...
		);
	
		%--
		% Duration
		%--
		
		r = data.browser.sound.samplerate;
		T = data.browser.sound.duration;
		
		% this leads to a counterintuitive control
		
		% compute maximum page duration, 4000 spectrogram slices with fft of 512 and hop 0.25
		
		ddt = data.browser.specgram.fft / data.browser.sound.samplerate;
		
% 		M = (4000 * 512 * 0.25) / r;
			
		j = j + 1;
		control(j) = control_create( ...
			'name','Duration', ...
			'tab','One', ...
			'tooltip','Displayed page duration in seconds', ...
			'style','slider', ...
			'active',0, ...
			'min',1/10, ...
			'max',T - 4*ddt, ... % this is currently arbitrary
			'value',data.browser.page.duration ...
		);
	
		%--
		% Overlap
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Overlap', ...
			'tab','One', ...
			'tooltip','Page overlap as fraction of page duration', ...
			'style','slider', ...
			'active',0, ...
			'space',1.25, ...
			'min',0, ...
			'max',0.75, ...
			'value',data.browser.page.overlap ...
		);
	
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Frequency' ...
		);
	
		%--
		% Min Freq
		%--
		
		freq = data.browser.page.freq;
		
		if (isempty(freq))
			freq = [0, r / 2];
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Min Freq', ...
			'alias','Min', ...
			'tooltip','Minimum page displayed frequency in Hz', ...
			'style','slider', ...
			'type','integer', ...
			'min',0, ...
			'max',r / 2, ...
			'value',freq(1) ...
		);

		%--
		% Max Freq
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Max Freq', ...
			'alias','Max', ...
			'tooltip','Maximum page displayed frequency in Hz', ...
			'style','slider', ...
			'space',1.25, ...
			'type','integer', ...
			'min',0, ...
			'max',ceil(r / 2), ...
			'value',freq(2) ...
		);
	
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control figure
		%--
		
		opt = control_group;
		
		opt.width = 8;
		opt.top = 0;
		opt.bottom = 1.25;
		
		opt.handle_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);	
		
		%--
		% add contextual menu to channels listbox
		%--
		
		g = findobj(out,'tag','Channels','style','listbox');
		
		cm = uicontextmenu; 
		
		set(g,'uicontextmenu',cm); 
		
		L = { ...
			'Default Order', ...
			'Distance to Channel Order' ...
		};
	
		mg = menu_group(cm,@auto_order,L);
	
		% enable or disable distance to channel order
		
		if (length(get(g,'value')) > 1)
			set(mg(2),'enable','off');
		end
		
		%--
		% initialize channel layout display by selecting channel
		%--
		
		g = findobj(out,'tag','Select Channel','style','popupmenu');
		
		if (~isempty(g))
			browser_controls(h,'Select Channel',g);
		end
		
	%-----------------------------------
	% Play Palette
	%-----------------------------------
	
	case ('Play')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
			
		j = 0;
		
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Rate' ...
		);
	
		%--
		% Rate
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Rate', ...
			'tooltip','Play rate as multiple of natural (sampling) rate', ...
			'style','slider', ...
			'space',1.25, ...
			'min',1/32, ...
			'max',32, ...
			'sliderstep',1/(32 - (1/32)) * [1, 2], ...
			'value',data.browser.play.speed ...
		);
	
% 		%--
% 		% Separator/Header
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'style','separator', ...
% 			'type','header', ...
% 			'string','Play', ...
% 			'space',0.5 ...
% 		);
% 	
% 		%--
% 		% Play
% 		%--
% 		
% 		% note that the name is a column cell array
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'string','Play', ...
% 			'name',{'Selection', 'Page'}, ... 
% 			'tooltip',{'Play selection (P)','Play page (Shift + P)'}, ... 
% 			'style','buttongroup', ...
% 			'lines',5/3, ...
% 			'space',1.5 ...
% 		);
		
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
	
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1.25;
		
		opt.handle_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
	%-----------------------------------
	% Selection Palette
	%-----------------------------------
	
	% TODO: this selection palette should enable the editing of existing
	% selections. at the moment not the creation of selections. at the
	% moment only consider the bound controls and use it to test the active
	% controls
	
	% NOTE: this palette must be updated on paging, and on the creation and
	% deletion of selections
	
	% NOTE: this palette is also a testbed for the events that must be
	% supported in providing a zoom display for selections
	
	% NOTE: the selection bounds could be a section of this palette with
	% tabs. another section of the palette could control say display
	% options, eventually grouping functions
	
	case ('Selection')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
			
		j = 0;
		
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',0.11, ...
			'string','Bounds' ...
		);
	
		%--
		% Bounds Tabs
		%--

		tabs = {'Time','Freq'}; 
		
		j = j + 1;
		control(j) = control_create( ...
			'style','tabs', ...
			'name','Bounds Tabs', ...
			'label',0, ... % this should be set by control group
			'lines',1.25, ...% this should be set by control group
			'tab',tabs ...
		);
	
		%--
		% Start Time
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','start_time', ...
			'alias','Start Time', ...
			'tooltip','Starting time of selection', ...
			'style','slider', ...
			'tab',tabs{1}, ...
			'active',1, ...
			'type','time', ...
			'min',data.browser.time, ...
			'max',data.browser.time + data.browser.page.duration, ...
			'value',data.browser.time ...
		);
	
		%--
		% Duration / End Time
		%--
		
		% NOTE: the negative space offset used provides a visual cue to
		% this control when used as title for the next control
		
		j = j + 1;
		control(j) = control_create( ...
			'name','time_mode', ...
			'label',0, ...
			'color',get(0,'defaultuicontrolbackgroundcolor'), ...
			'width',0.5, ...
			'tooltip','Selection end mode', ...
			'style','popup', ...
			'tab',tabs{1}, ...
			'space',-0.5, ...
			'string',{'Duration','End Time'}, ...
			'value',1 ...
		);
	
		%--
		% Time Slider
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','time_slider', ...
			'alias',' ', ...
			'tooltip','Duration of selection in seconds', ...
			'style','slider', ...
			'tab',tabs{1}, ...
			'active',1, ...
			'min',0, ...
			'max',data.browser.page.duration, ...
			'value',data.browser.page.duration / 2 ...
		);
	
% 		%--
% 		% Separator/Header
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'style','separator', ...
% 			'type','header', ...
% 			'string','Freq' ...
% 		);
	
		%--
		% Min Freq
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','min_freq', ...
			'alias','Min Freq', ...
			'tooltip','Minimum frequency of selection in Hz', ...
			'style','slider', ...
			'tab',tabs{2}, ...
			'active',1, ...
			'min',0, ...
			'max',data.browser.sound.samplerate / 2, ...
			'value',0 ...
		);
	
		%--
		% Bandwidth / Max Freq
		%--
		
		% NOTE: the negative space offset used provides a visual cue to
		% this control when used as title for the next control
		
		j = j + 1;
		control(j) = control_create( ...
			'name','freq_mode', ...
			'label',0, ...
			'color',get(0,'defaultuicontrolbackgroundcolor'), ...
			'width',0.5, ...
			'tooltip','Selection freqency end mode', ...
			'style','popup', ...
			'tab',tabs{2}, ...
			'space',-0.5, ...
			'string',{'Bandwidth','Max Freq'}, ...
			'value',1 ...
		);
	
		%--
		% Freq Slider
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','freq_slider', ...
			'alias',' ', ...
			'tooltip','Bandwidth of selection in Hz', ...
			'style','slider', ...
			'tab',tabs{2}, ...
			'space',1.5, ...
			'active',1, ...
			'min',0, ...
			'max',data.browser.sound.samplerate / 2, ...
			'value',data.browser.sound.samplerate / 4 ...
		);
	
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',0.11, ...
			'string','Options' ...
		);
	
		%--
		% Options Tabs
		%--

		tabs = {'View','Display'}; 
		
		j = j + 1;
		control(j) = control_create( ...
			'style','tabs', ...
			'name','Options Tabs', ...
			'label',0, ... % this should be set by control group
			'lines',1.25, ...% this should be set by control group
			'tab',tabs ...
		);
	
		%--
		% Selection Grid
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','selection_grid', ...
			'alias','Grid', ...
			'tooltip','Toggle display of selection grid', ...
			'style','checkbox', ...
			'tab',tabs{1}, ...
			'lines',0, ...
			'value',data.browser.selection.grid ...
		);
	
		%--
		% Selection Grid Labels
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','selection_labels', ...
			'alias','Labels', ...
			'tooltip','Toggle display of selection labels', ...
			'style','checkbox', ...
			'tab',tabs{1}, ...
			'lines',0, ...
			'value',data.browser.selection.label ...
		);
	
		%--
		% Selection Control Points
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','control_points', ...
			'alias','Control Points', ...
			'tooltip','Toggle display of control points', ...
			'style','checkbox', ...
			'tab',tabs{1}, ...
			'lines',0, ...
			'value',data.browser.selection.control ...
		);
	
		%--
		% Color
		%--
		
		C = color_to_rgb;
						
		ix = find(strcmp(C,rgb_to_color(data.browser.selection.color)));		

		if (isempty(ix))
			ix = 1;
		end
					
		j = j + 1;
		control(j) = control_create( ...
			'name','selection_color', ...
			'alias','Color', ...
			'tab','Display', ...
			'tooltip',['Color for selection display'], ...
			'style','popup', ...
			'space',1, ...
			'lines',1, ...
			'string',C, ...
			'confirm',0, ... % the confirm variable is used to produce the visual feedback axes
			'value',ix ...
		);
		
		%--
		% Line Style
		%--
		
		L = linestyle_to_str('','strict');
		
		ix = 1;

		j = j + 1;
		control(j) = control_create( ...
			'name','selection_linestyle', ...
			'alias','Line Style', ...
			'tab','Display', ...
			'tooltip',['Line style for selection display'], ...
			'style','popup', ...
			'space',1, ...
			'lines',1, ...
			'string',L, ...
			'value',ix ...
		);
		
		%--
		% Line Width
		%--
		
		tmp = data.browser.selection.linewidth;
		
		j = j + 1;
		control(j) = control_create( ...
			'name','selection_linewidth', ...
			'alias','Line Width', ...
			'tab','Display', ...
			'tooltip',['Line width for selection display'], ...
			'style','slider', ...
			'type','integer', ...
			'space',1, ...
			'lines',1, ...
			'min',1, ...
			'max',4, ...
			'sliderstep',[1,1] ./ 3, ...
			'value',tmp ...
		);
	
		%--
		% Opacity
		%--
		
		tmp = data.browser.selection.patch;
		
		j = j + 1;
		control(j) = control_create( ...
			'name','selection_opacity', ...
			'alias','Opacity', ...
			'tab','Display', ...
			'tooltip',['Opacity level for selection display'], ...
			'style','slider', ...
			'space',1.5, ...
			'lines',1, ...
			'min',0, ...
			'max',1, ...
			'value',tmp ...
		);
	
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
	
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		opt = control_group;
		
		opt.width = 8.5;
		opt.top = 0;
		opt.bottom = 1.25;
		
		opt.handle_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
	
	%-----------------------------------
	% Spectrogram Palette
	%-----------------------------------
	
	case ('Spectrogram')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
		
		%--
		% FFT Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','FFT' ...
		);
	
		%--
		% FFT Size
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Size', ...
			'tooltip','Size of FFT in number of samples', ...
			'style','slider', ...
			'type','integer', ...
			'min',16, ...
			'max',4096, ...
			'value',data.browser.specgram.fft ...
		);
	
		%--
		% FFT Advance
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Advance', ...
			'tooltip','Data advance as fraction of FFT size', ...
			'style','slider', ...
			'space',1.25, ...
			'min',1/100, ...
			'max',1, ...
			'value',data.browser.specgram.hop ...
		);
	
		%--
		% figure out a way to produce the resolution controls
		%--
		
		% the approach attempted in what follows reveals a number of
		% problems with 'control_group' !!!
		
% 		%--
% 		% Separator
% 		%--
% 		
% 		control(j).space = 1.5;
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'string','Resolution', ...
% 			'space',1.25, ...
% 			'style','separator' ...
% 		);
% 	
% 		%--
% 		% Time Resolution
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Time Resolution', ...
% 			'alias','Time ', ...
% 			'layout','compact', ...
% 			'style','edit', ...
% 			'width',0.75, ...
% 			'min',1/100, ...
% 			'max',1, ...
% 			'value',data.browser.specgram.hop ...
% 		);
% 	
% 		%--
% 		% Frequency Resolution
% 		%--
% 		
% 		j = j + 1;
% 		control(j) = control_create( ...
% 			'name','Freq Resolution', ...
% 			'alias','Freq ', ...
% 			'layout','compact', ...
% 			'style','edit', ...
% 			'width',0.75, ...
% 			'align','center', ...
% 			'space',1.25, ...
% 			'min',1/100, ...
% 			'max',1, ...
% 			'value',data.browser.specgram.hop ...
% 		);
		
		%--
		% Window Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',1, ... % before window plot 'space',0.75, ...
			'string','Window' ...
		);
	
		%--
		% Window_Plot
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Window_Plot', ...
			'width',1, ...
			'align','center', ...
			'lines',4, ...
			'label',0, ...
			'space',0.75, ...
			'style','axes' ...
		);
		
		%--
		% Window Type
		%--
		
		tmp = window_to_fun;
		ix = find(strcmp(data.browser.specgram.win_type,tmp));
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Type', ...
			'tooltip','Type of data window', ...
			'style','popup', ...
			'string',tmp, ...
			'value',ix ...
		);
		
		%--
		% Window Parameter
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Parameter', ...
			'tooltip','Data window parameter', ...
			'style','slider' ...
		);
		
		%--
		% Window Length
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Length', ...
			'tooltip','Length of window as fraction of FFT size', ...
			'style','slider', ...
			'space',1.25, ...
			'min',1/64, ...
			'max',1, ...
			'value',data.browser.specgram.win_length ...
		);
		
		%-----------------------------------
		% COLOR CODE PALETTE
		%-----------------------------------
		
		tmp = find(strcmp(struct_field(control,'style'),'separator'));
	
		for k = 1:length(tmp)
			if (~isempty(control(tmp(k)).string))
				control(tmp(k)).color = COLOR_ON;
			end
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1.25;
		
		opt.handle_to_callback = 1;
		
		opt.palette_to_callback = 1;
		
		out = control_group(h,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out,'tag',['XBAT_PALETTE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','image_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%-----------------------------------
		% UPDATE PALETTE
		%-----------------------------------
		
		%--
		% update window parameter control
		%--
		
		param = window_to_fun(data.browser.specgram.win_type,'param');
		
		if (~isempty(param))
			
			control_update(h,'Spectrogram','Parameter','__ENABLE__', data);
			
			g = control_update(h,'Spectrogram','Parameter', ...
				data.browser.specgram.win_param, data);
			
			set(findobj(g,'flat','style','slider'), ...
				'min',param.min, ...
				'max',param.max ...
			);
		
		else
			
			g = control_update(h,'Spectrogram','Parameter','__DISABLE__', data);

			set(findobj(g,'flat','style','slider'), ...
				'min',0, ...
				'max',1, ...
				'value',0 ...
			);
		
			set(findobj(g,'flat','style','edit'), ...
				'string',[] ...
			);
			
		end
			
		%--
		% display window in plot axes
		%--
		
		g = findobj(out,'type','axes','tag','Window_Plot');
		
		axes(g);
				
		n = 256;
		
		if (isempty(window_to_fun(data.browser.specgram.win_type,'param')))
			y = feval( ...
				window_to_fun(data.browser.specgram.win_type), ...
				n ...
			);
		else
			y = feval( ...
				window_to_fun(data.browser.specgram.win_type), ...
				n, ...
				data.browser.specgram.win_param ...
			);
		end
			
		
		hold on;
		
		tmp = plot(y,'k','linewidth',1);
		
		tmp = plot([1,n],[0 0],':');
		set(tmp,'color',0.5*ones(1,3));
		
		tmp = plot([1,n],[1 1],':');
		set(tmp,'color',0.5*ones(1,3));
		
		set(g, ...
			'xlim',[1,n], ...
			'ylim',[-0.1,1.1] ...
		);
	
	%--
	% Show
	%--
	
	case ('Show')
			
		%--
		% check for double click
		%--
		
		front = double_click(h);
		
		%--
		% check for timers
		%--
		
		% NOTE: this is probably best handled through the timer's errorfcn 
		
		if (isempty(timerfind('name','XBAT Palette Daemon')))
			start(palette_daemon);
		end
		
		% NOTE: this is no longer in use, some of the ideas should be used
		% in other code
		
% 		if (isempty(timerfind('name','XBAT Palette Glue Daemon')))
% 			start(palette_glue_daemon);
% 		end
		
		if (isempty(timerfind('name','XBAT Browser Daemon')))
			start(browser_daemon);
		end
		
		%------------------------------------------
		% HIDE OTHER PALETTES
		%------------------------------------------
		
		% TODO: extend this to handle other type of children, possibly move
		% to a separate function. in general we need some child handling
		% functions
		
		%--
		% get all palette figures
		%--
		
		pals = findobj(0,'type','figure');
		
		tag = get(pals,'tag');
		
		ix = strmatch('XBAT_PALETTE',tag);
				
		%--
		% remove parent less figures from list
		%--
				
		for k = length(ix):-1:1
			
			% NOTE: very rarely palette userdata corruption leads to an error here
	
			% NOTE: this seems to happen to the event palette
			
% 			get(pals(ix(k)),'name')
			
			tmp = get_field(get(pals(ix(k)),'userdata'),'parent');
			
			if (isempty(tmp))
				ix = setdiff(ix,ix(k));
			end
			
		end
		
		%--
		% remove current figure palettes from list
		%--
		
		pals = pals(ix);
		
		pals = setdiff(pals,data.browser.palettes);
		
		%--
		% hide any remaining visible palettes
		%--
		
		visible = get(pals,'visible');
		
		if (iscell(visible))
			
			% sometimes cell2mat fails if there is a stored deleted object
			% handle ?
			
			try
				visible = cell2mat(visible);
			catch
				visible = 1;
			end
			
		end
				
		if (any(visible))
			set(pals,'visible','off');
		end
		
		%------------------------------------------
		% SHOW OUR PALETTES
		%------------------------------------------

		%--
		% make palettes visible and possibly bring to front
		%--
				
		flag = 0;
		
		for k = length(data.browser.palettes):-1:1
			
			pal = data.browser.palettes(k);
			
			if (ishandle(pal))
				
				if (strcmp(get(pal,'visible'),'off'))
					set(pal,'visible','on');
					if (~front)
						figure(h);
					end
				else
					if (front)
						figure(pal);
					end
				end
		
			else
				
				data.browser.palettes(k) = [];
				
				flag = 1;
				
			end
			
		end
		
		%--
		% update userdata if needed
		%--
		
		if (flag)
			set(h,'userdata',data);
		end
		
		%--
		% output nothing
		%--
		
		out = [];

end

%--
% position palette
%--

if (~isempty(out))
	position_palette(out,h,'center');
end


%------------------------------------------------
% LOG_PALETTE_KPFUN
%------------------------------------------------

function log_palette_kpfun(obj,eventdata)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--
% check for return
%--

if (strcmp(get(gcf,'currentkey'),'return'))
	
	%--
	% check for new log edit box
	%--
	
	g = findobj(gcf,'tag','New Log Edit')
	
	if (~isempty(g))
		
		% note that this depends on the known form of the callback for this
		% control
		
		cb = get(g,'callback')
		
		feval(cb{1},g,[],cb{2},cb{3},cb{4},1);
		
	end
	
end

%------------------------------------------------
% AUTO_ORDER
%------------------------------------------------

function auto_order(obj,eventdata,h)

% auto_order - order channels in natural order or using channel distance
% ----------------------------------------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--
% get palette figure and its parent and userdata
%--

pal = get(get(obj,'parent'),'parent');

data = get(pal,'userdata');

par = data.parent;

data = get(par,'userdata');

%--
% get control equivalent channel matrix
%--

g = findobj(pal,'tag','Channels','style','listbox');

C = channel_strings(get(g,'string'),get(g,'value'));

%--
% update channel matrix
%--

switch (get(obj,'label'))
	
	case ('Default Order')
		
		%--
		% sort the channel matrix in channel index order
		%--
		
		% note that this is the shortest way to produce this matrix while
		% keeping the current selection
		
		[ignore,ix] = sort(C(:,1));
		
		[L,ix] = channel_strings(C(ix,:));
		
	case ('Distance to Channel Order')
		
		%--
		% get base channel
		%--
		
		ch = find(C(:,2));
		ch = C(ch,1);
		
		%--
		% compute distance to channel and sort
		%--
		
		G = data.browser.sound.geometry;
		
		V = G - repmat(G(ch,:),[size(G,1),1]);
		
		d = sum(V.^2,2);
		
		[d,ix] = sort(d);
		
		%--
		% create channel matrix in distance to channel order
		%--
		
		% note that is it easy to regenerate the matrix since the selection
		% is simply the desired base channel
		
		C = channel_matrix(size(C,1));
		C = channel_matrix_update(C,'display',ch);
		C = C(ix,:);
		
		[L,ix] = channel_strings(C);
		
end

%--
% update control to reflect order
%--

set(g,'string',L,'value',ix);

%------------------------------------------------
% ARRANGE_LOGS
%------------------------------------------------

% NOTE: this function reorders the logs in the browser state

function arrange_logs(obj,eventdata)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--
% get palette and parent figures
%--

pal = gcf;

par = get_field(get(pal,'userdata'),'parent');

str = get(obj,'label');

%--
% get display control value
%--

g = findobj(pal,'tag','Display','style','listbox');

value = get(g,'string');

value = value(get(g,'value'));

%--
% match control log to parent figure log
%--

data = get(par,'userdata');

names = file_ext(struct_field(data.browser.log,'file'));

n = length(names);

ix = find(strcmp(names,value));

%--
% rearrange logs
%--

% NOTE: logs are displayed in stored order leading to a reversal of stacking

switch (str)
	
	case ('Bring to Front')
		
		%--
		% update if log is not already up front
		%--
		
		if (ix < n)
			
			tmp = data.browser.log(ix);
			
			data.browser.log(ix) = [];
			data.browser.log = [data.browser.log, tmp];
						
			set(par,'userdata',data);
			
		end
		
	case ('Bring Forward')
		
		%--
		% update if log is not already up front
		%--
		
		if (ix < n)
			
			tmp = data.browser.log(ix);
			
			data.browser.log(ix) = [];
			data.browser.log = [data.browser.log(1:ix), tmp, data.browser.log((ix + 1):end)];
						
			set(par,'userdata',data);
		
		end
		
	case ('Send Backward')
		
		%--
		% update if log is not already in back
		%--
		
		if (ix > 1)
			
			tmp = data.browser.log(ix);
			
			data.browser.log(ix) = [];
			data.browser.log = [data.browser.log(1:(ix - 2)), tmp, data.browser.log((ix - 1):end)];
						
			set(par,'userdata',data);
			
		end
		
	case ('Send to Back')
		
		%--
		% update if log is not already in back
		%--
		
		if (ix > 1)
			
			tmp = data.browser.log(ix);
			
			data.browser.log(ix) = [];
			data.browser.log = [tmp, data.browser.log];
			
			set(par,'userdata',data);
			
		end
		
end

%--
% update display
%--

browser_display(par);


%------------------------------------------------
% CLOSE_LOGS
%------------------------------------------------

function close_logs(obj,eventdata)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--
% get palette and parent figures
%--

pal = gcf;

par = get_field(get(pal,'userdata'),'parent');

%--
% get display control value
%--

g = findobj(pal,'tag','Display','style','listbox');

value = get(g,'string');

value = value(get(g,'value'));

%--
% close logs
%--

for k = 1:length(value)
	log_close(par,value{k});
end

%--
% update log display listbox
%--

refresh(pal);

%--
% perform event search callback
%--

pal = get_palette(par,'Event');

if (~isempty(pal))
	
	% NOTE: execute search callback in this way for other events

	c = findobj(control_update([],pal,'find_events'),'style','edit');
	browser_controls(par,'find_events',c);
	
end


%------------------------------------------------
% LOG_CONTROL_SETUP
%------------------------------------------------

function [n,L,aix,vix] = log_control_setup(data)

% log_control_setup - variables used in log control setup
% -------------------------------------------------------
%
% [L,aix,vix] = log_control_setup(data)
%
% Input:
% ------
%  data - sound browser state
%
% Output:
% -------
%  n - number of logs open in browser
%  L - sorted log names
%  aix - active log index
%  vix - visible log indices

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--
% create variables used in log control setup
%--

if (isempty(data.browser.log))
	
	n = 0; 

	% NOTE: the following are dummy variables used to setup controls
	
	L = {'(No Open Logs)'};
	
	aix = 1; 
	
	vix = [];

else

	n = length(data.browser.log);

	%--
	% get and sort log names
	%--

	L = file_ext(struct_field(data.browser.log,'file'));
	
	[L,ix] = sort(L); 

	%--
	% active log index
	%--
	
	% NOTE: we consider the sorting permutation
	
	aix = find(ix == data.browser.log_active);

	%--
	% visible logs
	%--
	
	vix = struct_field(data.browser.log,'visible');
	
	vix = vix(ix); 
	
	vix = find(vix);

end


%------------------------------------------------
% DELETE_EVENTS
%------------------------------------------------

% NOTE: this function reorders the logs in the browser state

function delete_events(obj,eventdata)

%--
% get parent listbox value
%--

pal = get(get(obj,'parent'),'parent');

[g,value] = control_update([],pal,'event_display');

%--
% get parent figure and userdata
%--

par = get_xbat_figs('child',pal);

data = get(par,'userdata');

%--
% get log and event indices for events to delete
%--

for k = 1:length(value)
	
	[event(k),name{k},m(k),ix(k)] = get_str_event(par,value{k},data);
	
	value{k} = [int2str(k), '. ', value{k}];
	
end

if (length(value) > 1)
	value = {['Delete the ', int2str(length(value)), ' listed events ?'], value{:}};
else
	value = {'Delete the listed event ?', value{:}};
end

str = double_space(value);

str{end + 1} = ' ';

% NOTE: we permute the button positions to protect against habit
	
tmp = {'Yes','No','Cancel'};

tmp = tmp(randperm(3));
	
action = quest_dialog(str,['  Delete Event(s) ...'], tmp{:}, 'No');

if (strcmp(action,'Yes'))

	% NOTE: we could used a waitbar here, this is not the most efficient way of doing this
	
	%--
	% make sure we delete later events first
	%--
	
	[ix,p] = sort(ix,'descend');
	
	m = m(p);

	disp(' ');
	
	for k = 1:length(ix)

		%--
		% put deleted event in deleted events array
		%--
		
		dix = length(data.browser.log(m(k)).deleted_event);

		if ((dix == 1) && isempty(data.browser.log(m(k)).deleted_event(1).id))
			dix = 0;
		end

		data.browser.log(m(k)).deleted_event(dix + 1) = data.browser.log(m(k)).event(ix(k));

		%--
		% delete event from log event array
		%--
		
		data.browser.log(m(k)).event(ix(k)) = [];
		
		data.browser.log(m(k)).length = data.browser.log(m(k)).length - 1;
		
	end

	%--
	% update userdata
	%--

	set(par,'userdata',data);

	%--
	% update event display in sound browser
	%--

	browser_display(par,'events',data);
	
	%--
	% update event palete
	%--
	
	update_find_events(par,[],data);
	
end


