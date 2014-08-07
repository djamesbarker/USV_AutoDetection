function [pal, c] = browser_palettes(par, str)

% browser_palettes - create browser palettes
% ------------------------------------------
%
%  names = browser_palettes
%
%  [g,c] = browser_palettes(par, str)
%
% Input:
% ------
%  par - parent handle
%  str - palette name
%
% Output:
% -------
%  names - names of browser palettes
%  g - palette figure handle
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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

% TODO: factor out setting of common figure properties

% TODO: evaluate further common figure properties

%--------------------------------------------------
% COLOR CODE PALETTE SEPARATORS
%--------------------------------------------------

% NOTE: browser palettes are currently highlighted in yellow

COLOR_ON = get_extension_color('sound_browser_palette');

% COLOR_ON = (2 * LIGHT_GRAY + 4 * [1 1 0.1]) / 6; 
	
%--
% create persistent list of available palettes
%--
	
% TODO: allow for more dynamic control palettes

persistent PAL_TABLE;

if isempty(PAL_TABLE)
	
	% NOTE: this table is currently used to create a menu for the palettes
	
	PAL_TABLE = { ...
		'XBAT', ...
		'Colormap', ...
		'Event', ...
		'Grid', ...
		'Jog', ...
		'Log', ...
		'Navigate', ...
		'Page', ...
		'Play', ...
		'Record', ...
		'Selection', ...
		'Spectrogram' ...
	};

end

%--
% output palette names
%--

if ~nargin
	pal = PAL_TABLE; return;
end

%--
% set command string
%--

if nargin < 2
	str = 'Show';
end

%--
% set parent figure
%--

if nargin < 1
	par = get_active_browser;
end

%--
% check for existing palette,  bring to front and center
%--

pal = get_palette(par, str);

if ~isempty(pal)
	position_palette(pal, par, 'center'); c = 0; return;
end

%--
% indicate that the palette will be created
%--

c = 1;

%--
% get parent userdata
%--

data = get_browser(par);

%--
% show palettes
%--

switch str
	
	%-----------------------------------
	% Record Palette
	%-----------------------------------
	
	case 'Record'
		
		pal = record_palette(data.browser.sound);
		
		%--
		% set figure tag
		%--
		
		set(pal,'tag',['XBAT_PALETTE::CORE::', str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata', data, ...
			'buttondown', 'browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal, 'closerequestfcn', ['delete_palette(', num2str(par), ',''', str, ''');']);
		
		%--
		% set parent
		%--
		
		temp = get(pal, 'userdata');
		
		temp.parent = par;
		
		set(pal, 'userdata', temp);
		
		return;
		
	%-----------------------------------
	% XBAT Palette
	%-----------------------------------
	
	case 'XBAT'
		
		xbat_palette; return;
		
	%-----------------------------------
	% Colormap Palette
	%-----------------------------------
	
	case 'Colormap'
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
				
		%--
		% Separator
		%--
		
		control(1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Colormap', ...
			'space',0.75 ... % 'space',0.5 ... before colormap plot
		);

		%--
		% Colormap
		%--
				
		tmp = colormap_to_fun;
		
		ix = find(strcmp(tmp,data.browser.colormap.name));
		
		if isempty(ix)
			ix = 1;
		end
	
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
			'name','Colormap_Plot', ...
			'label',0, ...
			'lines',1, ...
			'space',0.75, ...
			'style','axes' ...
		);
	
		%--
		% Colorbar
		%--
		
		tmp = ~isempty(findobj(par,'tag','Colorbar','type','axes'));
		
		control(end + 1) = control_create( ...
			'name','Colorbar', ...
			'tooltip','Toggle display of colorbar (C)', ...
			'style','checkbox', ...
			'lines',0, ...
			'value',tmp ...
		);
	
		%--
		% Separator
		%--
		
		control(end + 1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Contrast' ...
		);
			
	
		control(end + 1) = control_create( ...
			'name','dB', ...
			'tooltip','Display decibels', ...
			'style','checkbox', ...
			'value', 1 ...
		);
		
		control(end + 1) = control_create( ...
			'style','separator' ...
		);
	
		%--
		% Brightness
		%--
		
		control(end + 1) = control_create( ...
			'name','Brightness', ...
			'tooltip','Center of dynamic range', ...
			'style','slider', ...
			'active',1, ...
			'value',data.browser.colormap.brightness ...
		);
	
		%--
		% Contrast
		%--
		
		control(end + 1) = control_create( ...
			'name','Contrast', ...
			'tooltip','Width of dynamic range', ...
			'style','slider', ...
			'active',1, ...
			'value',data.browser.colormap.contrast ...
		);
	
		%--
		% Auto Scale
		%--
		
		control(end + 1) = control_create( ...
			'name','Auto Scale', ...
			'alias','Auto', ...
			'tooltip','Toggle automatic scaling of colormap (A)', ...
			'style','checkbox', ...
			'space',0.75, ...
			'lines',0, ...
			'value',data.browser.colormap.auto_scale ...
		);

		%--
		% Invert
		%--
		
		control(end + 1) = control_create( ...
			'name','Invert', ...
			'tooltip','Toggle inversion of colormap (I)', ...
			'style','checkbox', ...
			'space',0.75, ...
			'lines',0, ...
			'value',data.browser.colormap.invert ...
		);

		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		% TODO: consider letting the control space provide bottom margin
		
		% NOTE: this lets the space be given by the margin
		
		control(end).space = 0;
		
		%--
		% set control group (palette) options
		%--
		
		opt = control_group;
		
		opt.width = 9;
		
		opt.top = 0;
		
		opt.bottom = 1.25;
		
		opt.header_color = COLOR_ON;
		
		% NOTE: this comes from callbacks preceding function handles
		
		opt.handle_to_callback = 1;
				
		%--
		% create new control group (palette)
		%--
		
		pal = control_group(par, 'browser_controls', str, control, opt);
		
		%--
		% register palette and set parent buttondown function
		%--
		
		n = length(data.browser.palettes);
		
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set various palette figure properties
		%--
		
		% NOTE: the close request unregisters, the keypress bubbles up
		
		set(pal, ...
			'DockControls','off', ...
			'closerequestfcn', ['delete_palette(' num2str(par) ',''' str ''');'], ...
			'keypressfcn',['palette_kpfun(', num2str(par), ');'], ...
			'tag', ['XBAT_PALETTE::CORE::' str] ...
		);
			
		%-----------------------------------
		% INITIALIZE PALETTE
		%-----------------------------------
		
		%--
		% update controls state
		%--
		
		if (data.browser.colormap.auto_scale)
			control_update(par,'Colormap','Brightness','__DISABLE__');
			control_update(par,'Colormap','Contrast','__DISABLE__');
		end
		
		if (data.browser.colormap.contrast == 0)
			control_update(par,'Colormap','Brightness','__DISABLE__');
		end
		
		%--
		% display colorbar type image in plot axes
		%--
		
		g = findobj(pal,'type','axes','tag','Colormap_Plot');
		
		axes(g);
				
		hold on;
		
		tmp = imagesc(0:255);
		
		set(g, ...
			'linewidth',2, ...
			'ycolor',get(pal,'color'), ...
			'xcolor',get(pal,'color'), ...
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
		
		set(pal, ...
			'colormap',feval(colormap_to_fun(data.browser.colormap.name),256) ...
		);
		
	%-----------------------------------
	% Channel Palette
	%-----------------------------------
	
	case 'Channel'
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		%--
		% Array Header
		%--
		
		control(1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Array', ...
			'space',0.5 ...
		);
	
		%--
		% Channel
		%--

		nch = data.browser.sound.channels;
		
% 		for k = 1:nch
% 			L{k} = ['Channel ' int2str(k)];
% 		end
		
		L = strrep(strcat({'Channel '}, int2str((1:nch)')), '  ', ' ');
		
		control(end + 1) = control_create( ...
			'name','Channel', ...
			'style','popup', ...
			'string',L, ...
			'space',1.25, ...
			'value',1 ...
		);
	
		%--
		% Separator
		%--
		
		control(end + 1) = control_create( ...
			'style','separator' ...
		);
	
		%--
		% Geometry_Plot
		%--
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
			'name','Position', ...
			'style','edit', ...
			'string','' ...
		);
	
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
		
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
		
		pal = control_group(par,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);
		
		%-----------------------------------
		% INITIALIZE PALETTE
		%-----------------------------------
	
		%--
		% display microphone locations geometry axes
		%--
		
		g = findobj(pal,'type','axes','tag','Geometry_Plot');
		
		geometry_plot(get_geometry(data.browser.sound), pal, g);
	
	%-----------------------------------
	% Palette
	%-----------------------------------
	
	case 'Event'
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
	
		control(1) = control_create( ...
			'string','Events', ...
			'style','separator', ...
			'space',0.75, ...
			'type','header' ...
		);

		control(end + 1) = control_create( ...
			'name','find_events', ...
			'alias','Search', ...
			'space',0.75, ... 
			'color',ones(1,3), ...
			'style','edit' ...
		);
		
		orders = sort({'Name', 'Time', 'Score', 'Rating'});
		
		control(end + 1) = control_create( ...
			'name', 'sort_order', ...
			'style','popup', ...
			'label', 0, ...
			'color', get(0, 'defaultuicontrolbackgroundcolor'), ...
			'width', 0.4, ...
			'align', 'right', ...
			'tooltip', 'Event sort order', ...
			'space', -0.5, ...
			'string', orders, ...
			'value', 3 ...
		);

		control(end + 1) = control_create( ...
			'name', 'event_display', ...
			'alias', 'events', ...
			'style', 'listbox', ...
			'lines', 12, ... 
			'space', 0.75, ...
			'min', 0, ...
			'max', 2 ...
		);
		
		control(end + 1) = control_create( ...
			'name', 'visible_events_only', ...
			'alias', 'Visible', ...
			'tooltip', 'Only display visible log events', ...
			'style', 'checkbox', ...
			'space', 0.5, ...
			'value', 1 ...
		);
	
		% TODO: finish implementing this functionality
		
% 		control(end + 1) = control_create( ...
% 			'name','page_events_only', ...
% 			'alias','Page', ...
% 			'tooltip','Only display events on current page', ...
% 			'style','checkbox', ...
% 			'value',0 ...
% 		);
	
		control(end).space = 0;
		
		control(end + 1) = control_create( ...
			'alias', {'Prev','Next'}, ...
			'name', {'previous_event','next_event'}, ...
			'style', 'buttongroup', ...
			'width', 2/3, ...
			'align', 'right', ...
			'lines', 1.75, ...
			'space', 1.25 ...
		);

		control(end + 1) = control_create( ...
			'name', 'event_header', ...
			'string','Event', ...
			'style','separator', ...
			'space', 0.75, ...
			'type','header' ...
		);
	
		% TODO: initialize this control properly
		
         control(end + 1) = control_create( ...
			'name', 'known_tags', ...
			'style', 'popup', ...
		    'string', {'one', 'two', 'three'}, ...
			'label', 0, ...
			'color', get(0, 'defaultuicontrolbackgroundcolor'), ...
			'width', 0.4, ...
			'align', 'right', ...
			'space', -0.5 ...
		);
	
		control(end + 1) = control_create( ...
			'name', 'event_tags', ...
			'alias', 'tags', ...
			'style', 'edit', ...
			'space', 0.75, ...
			'color', ones(1,3) ...
		);
		
% 		tags = {'red-tulip-1', 'pretty', 'load', 'sweep'};
% 		
% 		control(end).space = 0.25;
% 		
% 		control(end + 1) = control_create( ...
% 			'name', 'known_tags', ...
% 			'style','popup', ...
% 			'label', 0, ...
% 			'color', get(0, 'defaultuicontrolbackgroundcolor'), ...
% 			'width', 0.4, ...
% 			'space', 0, ...
% 			'align', 'right', ...
% 			'tooltip', 'Add known tag to tags', ...
% 			'string', tags, ...
% 			'value', 1 ...
% 		);
	
		control(end + 1) = control_create( ...
			'name', 'event_rating', ...
			'alias', 'rating', ...
			'style', 'rating', ...
			'marker', 'p', ...
			'space', 0.75, ...
			'max', 5, ...
			'width', 0.4 ...
		);
	
		control(end + 1) = control_create( ...
			'name', 'event_notes', ...
			'alias', 'notes', ...
			'style', 'edit', ...
			'color', ones(1,3), ...
			'lines', 4 ...
		);
	
		control(end + 1) = control_create( ...
			'name', 'event_info', ...
			'alias', 'info', ...
			'style', 'listbox', ...
			'min', 0, ...
			'max', 2, ...
			'space', 1.25, ...
			'lines', 4 ...
		);
	
		control(end + 1) = control_create( ...
			'alias', {'Prev','Next'}, ...
			'name', {'previous_event2','next_event2'}, ...
			'style', 'buttongroup', ...
			'width', 2/3, ...
			'align', 'right', ...
			'lines', 1.75, ...
			'space', 1.25 ...
		);
	
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
        % original XBAT
        % opt.width = 18; opt.top = 0; opt.bottom = 0;

        % CRP 20091105 hacked for wider Events dialog
		opt.width = 40; opt.top = 0; opt.bottom = 0;
		
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
		
		pal = control_group(par, 'browser_controls', str, control, opt);
		
		%--
		% add text menu to events palette
		%--
		
		text_opt = text_menu;
		
% 		text_opt.uicontrol = {'edit', 'listbox'};
		
		text_menu(pal, text_opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		% this is the standard kpfun that sends the key to the parent
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal, 'closerequestfcn', ['delete_palette(' num2str(par) ',''' str ''');']);
		
		%-----------------------------------
		% INITIALIZE PALETTE
		%-----------------------------------
		
		%--
		% update events control
		%--
		
		update_find_events(par, [], data);
		
		%--
		% attach contextual menu to display
		%--
		
		event_display_menu(pal);
		
	%-----------------------------------
	% Grid Palette
	%-----------------------------------
	
	case 'Grid'
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
				
		%--
		% Separator
		%--
		
		control(1) = control_create( ...
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
		
		if isempty(ix)
			ix = 1;
		end
		
		control(end + 1) = control_create( ...
			'name','Color', ...
			'tooltip','Color used to display axes, grids, and associated text', ...
			'style','popup', ...
			'space',1.5, ...
			'onload', 1, ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
	
		%--
		% Separator
		%--
		
		control(end + 1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',0.10, ...
			'string','Grid' ...
		);
	
		%--
		% Grid Tabs
		%--
	
		tabs = {'Time','Freq','Other'};
		
		control(end + 1) = control_create( ...
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
		
		if isempty(dt)
			dt = 0;
		end
		
		control(end + 1) = control_create( ...
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
		
		tmp = {'Seconds', 'Clock', 'Date and Time'};
		
		ix = find(strcmpi(tmp, data.browser.grid.time.labels));
				
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
			'name','Time Grid', ...
			'alias','On', ...
			'tab','Time', ...
			'tooltip','Toggle display of time grid', ...
			'style','checkbox', ...
			'space',0, ... 
			'lines',0, ...
			'value',data.browser.grid.time.on ...
		);
	
		%--
		% Freq Spacing
		%--
		
		r = get_sound_rate(data.browser.sound);
		
		df = data.browser.grid.freq.spacing;
		
		if (isempty(df))
			df = 0;
		end
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
			'name','Freq Grid', ...
			'alias','On', ...
			'tab','Freq', ...
			'tooltip','Toggle display of frequency grid', ...
			'style','checkbox', ...
			'space',0, ... 
			'lines',0, ...
			'value',data.browser.grid.freq.on ...
		);
	
		%--
		% File Grid
		%--

% 		control(end + 1) = control_create( ...
% 			'tab',tabs{3}, ...
% 			'string','File', ...
% 			'style','separator' ...
% 		);
		
		% NOTE: what does it mean for the checkbox to have zero lines?

		if strcmpi(data.browser.sound.type, 'File Stream')
		
			control(end + 1) = control_create( ...
				'name','File Grid', ...
				'alias','File Boundaries', ...
				'tab',tabs{3}, ...
				'tooltip','Toggle display of file boundaries grid', ...
				'style','checkbox', ...
				'space',0.5, ...
				'lines',0, ... 
				'value',data.browser.grid.file.on ...
			);

			control(end + 1) = control_create( ...
				'name','file_label', ...
				'tab',tabs{3}, ...
				'style','checkbox', ...
				'tooltip','Toggle display of file boundary labels', ...
				'space',1, ...
				'lines',0, ... 
				'value',data.browser.grid.file.labels ...
			);
	
		end
	
		%--
		% Session Grid
		%--
	
		% NOTE: what does it mean for the checkbox to have zero lines

		if has_sessions_enabled(data.browser.sound)

			control(end + 1) = control_create( ...
				'style', 'separator', ...
				'tab',tabs{3} ...
			);

			control(end + 1) = control_create( ...
				'name','Session Grid', ...
				'alias','Session Boundaries', ...
				'tab',tabs{3}, ...
				'tooltip','Toggle display of session boundaries grid', ...
				'style','checkbox', ...
				'space',0.5, ... 
				'lines',0, ... 
				'value',data.browser.grid.session.on ...
			);
		
			control(end + 1) = control_create( ...
				'name','session_label', ...
				'tab',tabs{3}, ...
				'style','checkbox', ...
				'tooltip','Toggle display of session boundary labels', ...
				'lines',0, ... 
				'value',data.browser.grid.session.labels ...
			);
	
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
		
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
		
		pal = control_group(par,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);
		
		%-----------------------------------
		% INITIALIZE PALETTE
		%-----------------------------------
		
		%--
		% set enable of brightness and contrast controls
		%--
		
		if data.browser.colormap.auto_scale
			
			set_control(pal, 'Brightness', 'enable', 0);
			set_control(pal, 'Contrast', 'enable', 0);
		
		end
	
	%-----------------------------------
	% Log Palette
	%-----------------------------------
	
	case 'Log'
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
				
		%--
		% Separator
		%--
		
		control(1) = control_create( ...
			'style', 'separator', ...
			'string', 'File', ...
			'type', 'header', ...
			'space', 0.75 ...
		);
	
		%--
		% get log information and sort logs
		%--
		
		if isempty(data.browser.log)
			
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

		control(end + 1) = control_create( ...
			'name', 'Active', ...
			'tooltip', 'Active log, default for saving new events', ...
			'style', 'popup', ...
			'space', 0.75, ... % 'space',1.25, ...
			'lines', 1, ...
			'string', L, ...
			'value', aix ...
		);
	
		%--
		% New and Open Log
		%--
	
		control(end + 1) = control_create( ...
			'name', {'New Log', 'Open Log'}, ...
			'alias', {'New ...', 'Open ...'}, ...
			'tooltip', {'Create new log', 'Open existing log ...'}, ...	
			'style', 'buttongroup', ...
			'lines', 1.75, ...
			'space', 1.25 ...
		);
	
		%--
		% Separator
		%--
		
		control(end + 1) = control_create( ...
			'style', 'separator', ...
			'string', 'Display', ...
			'type', 'header', ...
			'space', 0.75 ...
		);
	
		%--
		% Display
		%--
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
			'style','separator', ...
			'string','Options', ...
			'type','header', ...
			'space',0.5 ...
		);
	
		%--
		% Log
		%--
		
		control(end + 1) = control_create( ...
			'name','Log', ...
			'tooltip','Log updated through options', ...
			'style','popup', ...
			'space',1.25, ...
			'lines',1, ...
			'string',L, ...
			'value',aix ...
		);
	
		control(end + 1) = control_create( ...
			'style','separator', ...
			'space',0.12 ...
		);
	
		tabs = {'Display','View'};
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
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
		
		% TODO: there is now a way to set this control properly
		
% 		if (isempty(m))
% 			ix = 1;
% 		else
% 			ix = find(strcmp(L,rgb_to_color(data.browser.log(m).color)));			
% 			if (isempty(ix))
% 				ix = 1;
% 			end
% 		end
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
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
				
		if isempty(data.browser.log)
			tmp = 0;
		else
			tmp = data.browser.log(m).autosave;
		end
		
		control(end + 1) = control_create( ...
			'name','event_id', ...
			'alias','ID', ...
			'tab',tabs{2}, ...
			'tooltip',['Toggle display of event ID numbers.'], ...
			'style','checkbox', ...
			'lines',0, ...
			'space',0.75, ...
			'value',1 ...
		);
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
        % CRP 20091106 made even wider
		opt.width = 12; % used to be 8 / 7.5, made larger to accomodate longer log names
		opt.top = 0;
		opt.bottom = 1.5; % the longest pane ends in a checkbox 
		
	
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
	
		
		pal = control_group(par,'browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		% this is the standard kpfun that sends the key to the parent
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);

		% this function executes the callback for the edit box, however it
		% is still quirky, it is not clear that this is a better option
		
% 		set(pal, ...
% 			'tag',['XBAT_PALETTE::CORE::' str], ...
% 			'keypressfcn',@log_palette_kpfun ...
% 		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);
		
		%--
		% update controls state
		%--
		
		if isempty(data.browser.log)
			
			for k = 1:length(control)
				
				if ~strcmp(control(k).style, 'separator') && ~strcmp(control(k).style, 'tabs')
					
					if ~iscell(control(k).name)
						control_update(par, 'Log', control(k).name, '__DISABLE__', data);
					else
						for j = 1:numel(control(k).name)
							control_update(par, 'Log', control(k).name{j}, '__DISABLE__', data);
						end
					end
					
				end
				
			end
			
			control_update(par,'Log','New Log','__ENABLE__',data);
			
			control_update(par,'Log','Open Log','__ENABLE__',data);
			
		end
		
		%--
		% disable ID control
		%--
		
% 		control_update(par,'Log','event_id','__DISABLE__',data);
		
		%--
		% attach contextual menu to display
		%--
		
		g = findobj(pal,'tag','Display','style','listbox');
		
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
		
		% TODO: consider a way of implementing this with the log linked
		
		% NOTE: this should be possible when we move to the object model
		
% 		uimenu(cm, ...
% 			'label','Copy to Workspace', ...
% 			'separator','on', ...
% 			'callback',@copy_to_workspace ...
% 		);
	
		uimenu(cm, ...
			'label','Close', ...
			'separator','on', ...
			'callback',@close_logs ...
		);
		
		menu_group(tmp,@arrange_logs,L);
		
	%-----------------------------------
	% Jog Palette
	%-----------------------------------
	
	case 'Jog'
	
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
	
		control(1) = control_create( ...
			'style','separator', ...
			'string','Jog', ...
			'type','header', ...
			'space',0.75 ...
		);
		
		% NOTE: active controls are not stable
		
		control(end + 1) = control_create( ...
			'name','jog_speed', ...
			'alias','Speed', ...
			'style','slider', ...
			'active',1, ...
			'min',-32, ...
			'value',1, ...
			'max',32, ...
			'slider_inc',[1, 2] ...
		);
		
		% NOTE: this control introduces a button with changing label string
		
		control(end + 1) = control_create( ...
			'name','jog_toggle', ...
			'alias','Go', ...
			'width',2/3, ...
			'align','right', ...
			'style','buttongroup', ...
			'lines',1.75, ...
			'space',-1.75 ...
		);
	
		control(end + 1) = control_create( ...
			'name','jog_loop', ...
			'alias','Loop', ...
			'style','checkbox', ...
			'value',0 ...
		);
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 10; opt.top = 0; opt.bottom = 2;
		
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
		
		pal = control_group(par,'browser_controls',str,control,opt);
		
		
		%-----------------------------------
		% REGISTER PALETTE
		%-----------------------------------
		
		%--
		% set palette figure tag and key press function
		%--
		
		% this is the standard kpfun that sends the key to the parent
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);

		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);

	%-----------------------------------
	% Navigate Palette
	%-----------------------------------
	
	case 'Navigate'
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		control = empty(control_create);
		
		type = data.browser.sound.type;
	
		%--
		% time navigation
		%--

		control(end + 1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Time' ...
		);

		tmp = get(data.browser.slider);

		control(end + 1) = control_create( ...
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
		% file navigation
		%--

		control(end + 1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',0.5, ...
			'string','Boundaries' ...
		);

		%--
		% file navigation
		%--	
	
		state = '__DISABLE__';
	
		if strcmpi(type, 'File Stream')
			state = '__ENABLE__';	
		end
	
		tmp = data.browser.sound.file;
		
		if ~iscell(tmp)
			tmp = {tmp};
		end
		
		[ignore, ix] = get_current_file(data.browser.sound, data.browser.time);
		
		control(end + 1) = control_create( ...
			'name', 'File', ...
			'tooltip', 'Align page start with file start', ...
			'style', 'popup', ...
			'space', 0.75, ...
			'string', tmp, ...
			'initialstate', state, ...
			'value', ix ...
		);

		control(end + 1) = control_create( ...
			'name', {'Prev File','Next File'}, ...
			'tooltip', {'Go to start of previous file (''['')','Go to start of next file ('']'')'}, ...
			'style', 'buttongroup', ...
			'initialstate', state, ...
			'lines', 1.75 ...
		);
	
		%--
		% session navigation
		%--	
		
		if has_sessions_enabled(data.browser.sound)
			
			state = '__ENABLE__';
			
			stamps = data.browser.sound.time_stamp.table;
			
			tmp = sec_to_clock(stamps(:,2));
			
			ix = get_current_session(data.browser.sound, data.browser.time);
			
		else
			
			state = '__DISABLE__';
			
			tmp = '(NOT AVAILABLE)';
			
			ix = 1;
		
		end
		
		if ~iscell(tmp)
			tmp = {tmp};
		end
		
		control(end + 1) = control_create( ...
			'name', 'time_stamp', ...
			'style', 'popup', ...
			'string', tmp, ...
			'initialstate', state, ...
			'value', ix ...
		);
	
		control(end + 1) = control_create( ...
			'name', {'Prev Time-Stamp','Next Time-Stamp'}, ...
			'tooltip', {'Go to start of previous session','Go to start of next session'}, ...
			'style', 'buttongroup', ...
			'initialstate', state, ...
			'lines', 1.75 ...
		);	

		%--
		% set palette figure options
		%--

		opt = control_group;

		opt.width = 12;
		opt.top = 0;
		opt.bottom = 1.25;

		opt.handle_to_callback = 1;
		
		% NOTE: color code palette 
		
		opt.header_color = COLOR_ON;
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		%--
		% create control figure
		%--
		
		pal = control_group(par,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);	
		
		%-----------------------------------
		% UPDATE CONTROLS
		%-----------------------------------
		
		% this updates most of the navigation controls
		
		browser_navigation_update(par,data);
		
	%-----------------------------------
	% PAGE
	%-----------------------------------
	
	case 'Page'
			
		control = empty(control_create);
		
		%-----------------------------------
		% CHANNELS
		%-----------------------------------

		% NOTE: the only control that is useful for single channels is 'map'
		
		control(end + 1) = control_create( ...
			'style', 'separator', ...
			'type', 'header', ...
			'space', 0.1, ...
			'string', 'Channels' ...
		);

		tabs = {'Display', 'Array'};

		control(end + 1) = control_create( ...
			'style', 'tabs', ...
			'tab', tabs, ...
			'space', 0.75, ... % used to be 0.75
			'name', 'Channel Tabs' ...
		);

		%-----------------------------------
		% Channels
		%-----------------------------------

		%--
		% create channel name strings
		%--

		nch = data.browser.sound.channels;

		for k = 1:nch
			L{k} = ['Channel ', int2str(data.browser.channels(k, 1))];
		end

		%--
		% get currently displayed channels and define control
		%--

		value = find(data.browser.channels(:, 2));

        % CRP 20091105 changed 2 sizes to make Channel palette taller
        %  so all 19 Gateway channels can be seen without scrolling
		control(end + 1) = control_create( ...
			'name', 'Channels', ...
			'tab', tabs{1}, ...
			'tooltip', 'Channels displayed in page', ...
			'style', 'listbox', ...
			'min', 0, ...
			'max', 2, ...
			'lines', 0.75 * nch, ... % used to be 0.7
			'space', 0.5, ... % used to be 1.25
			'value', value, ...
			'string', L, ...
			'confirm', 0 ... % used before adding ordering 
		);

		%-----------------------------------
		% Ordering Buttons
		%-----------------------------------

		if nch > 1
			
			if nch > 2
				control(end + 1) = control_create( ...
					'name', {'Up','Down'; 'Top', 'Bottom'}, ...
					'tab', tabs{1}, ...
					'style', 'buttongroup', ...
					'lines', 2 * 1.75, ...
					'space', 0.5 ... % was 1.5 before adding apply-cancel buttons
				);
			else
				control(end + 1) = control_create( ...
					'name', 'Swap', ...
					'tab', tabs{1}, ...
					'style', 'buttongroup', ...
					'lines', 1.75, ...
					'space', 0.5 ... % was 1.5 before adding apply-cancel buttons
				);
			end
			
		else
			
			control(end).space = 1.25;
			
		end
		
		%--
		% Apply and Cancel Buttons
		%--

		if nch > 1
			control(end + 1) = control_create( ...
				'name', {'channels_apply', 'channels_cancel'}, ...
				'tab', tabs{1}, ...
				'alias', {'Apply', 'Cancel'}, ...
				'style', 'buttongroup', ...
				'lines', 1.75, ...
				'label', 0, ...
				'space', 1.25 ...
			);
		end
		
		%--
		% Geometry_Plot
		%--

		if nch > 1 && ~isempty(data.browser.sound.geometry)
			control(end + 1) = control_create( ...
				'name','Geometry_Plot', ...
				'alias','Layout', ...
				'tab',tabs{2}, ...
				'width',1, ...
				'align','center', ...
				'lines',8 - 4 * (nch == 1), ...
				'label',1, ...
				'space',0.5, ... % used to be 1.75 when separator was in place
				'style','axes' ...
			);
		
			%--
			% map button
			%--

			geom = data.browser.sound.geometry;

			if isempty(geom) || isempty(geom.global)
				state = '__DISABLE__';
			else
				state = '__ENABLE__';
			end

			control(end + 1) = control_create( ...
				'style', 'buttongroup', ...
				'name', 'display_map', ...
				'alias', 'map', ...
				'width', 0.5, ...
				'lines', 1.5, ...
				'space', 0, ...
				'align', 'right', ...
				'tab',tabs{2}, ...
				'initialstate', state ...
			);

			if nch < 2
				control(end).width = 1; control(end).lines = 1.75;
			end
			
			%--
			% Channel
			%--

			nch = data.browser.sound.channels;

			for k = 1:nch
				L{k} = ['Channel ' int2str(k)];
			end

			control(end + 1) = control_create( ...
				'name','Select Channel', ...
				'alias','Channel', ...
				'tab',tabs{2}, ...
				'style','popup', ...
				'string',L, ...
				'value',1 ...
			);

			%--
			% Position
			%--

			control(end + 1) = control_create( ...
				'name','Position', ...
				'tab',tabs{2}, ...
				'style','edit', ...
				'space', 1.25, ...
				'initialstate', '__DISABLE__', ...
				'string','' ...
			);
		
		end
		
		%---------------------------
		% TIME 
		%---------------------------
	
		%--
		% header and tabs
		%--
		
		control(end + 1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',0.1, ...
			'string','Time' ...
		);	
		
		tabs = {'Duration','Slices'};
		
		control(end + 1) = control_create( ...
			'name','time_tabs', ...
			'style','tabs', ...
			'tab',tabs ...
		);
	
		%--
		% Duration
		%--
		
		r = get_sound_rate(data.browser.sound);
		
		T = get_sound_duration(data.browser.sound);
					
		control(end + 1) = control_create( ...
			'name','Duration', ...
			'tooltip','Displayed page duration in seconds', ...
			'tab',tabs{1}, ...
			'style','slider', ...
			'active',0, ...
			'min',1/10, ...
			'max',T, ... % this is currently arbitrary
			'slider_inc',[2,4], ...
			'value',data.browser.page.duration ...
		);
	
		%--
		% Overlap
		%--
	
		control(end + 1) = control_create( ...
			'name','Overlap', ...
			'tooltip','Page overlap as fraction of page duration', ...
			'tab',tabs{1}, ...
			'style','slider', ...
			'space',1.25, ...
			'active',0, ...
			'min',0, ...
			'max',0.75, ...
			'slider_inc',[0.05,0.1], ...
			'value',data.browser.page.overlap ...
		);
	
		%--
		% columns
		%--
		
		[ignore,cols] = specgram_size( ...
			data.browser.specgram, ...
			get_sound_rate(data.browser.sound), ...
			data.browser.page.duration ...
		);
		
		control(end + 1) = control_create( ...
			'name','Size', ...
			'tooltip','Spectrogram Image Size in Pixels', ...
			'tab',tabs{2}, ...
			'style','slider', ...
			'type','integer', ...
			'min', 100, ...
			'max', 10000, ...
			'value', cols ...
		);
	
		%---------------------------
		% FREQUENCY
		%---------------------------
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
			'name','Max Freq', ...
			'alias','Max', ...
			'tooltip','Maximum page displayed frequency in Hz', ...
			'style','slider', ...
			'type','integer', ...
			'space',1.25, ...
			'min',0, ...
			'max',ceil(r / 2), ...
			'value',freq(2) ...
		);
	
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
		
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
		
		pal = control_group(par,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);	
		
		%--
		% add contextual menu to channels listbox
		%--
		
		g = findobj(pal,'tag','Channels','style','listbox');
		
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
		
		g = findobj(pal,'tag','Select Channel','style','popupmenu');
		
		if (~isempty(g))
			browser_controls(par,'Select Channel',g);
		end
		
	%-----------------------------------
	% Play Palette
	%-----------------------------------
	
	case ('Play')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		%--
		% Separator/Header
		%--

		control(1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'string','Options' ...
		);
	
		%--
		% Rate
		%--
	
		control(end + 1) = control_create( ...
			'name','Rate', ...
			'tooltip','Play rate as multiple of natural (sampling) rate', ...
			'style','slider', ...
			'space',0.25, ...
			'min',1/32, ...
			'max',32, ...
			'sliderstep',1/(32 - (1/32)) * [1, 2], ...
			'value',data.browser.play.speed ...
		);

		control(end + 1) = control_create( ... 
			'name', {'1/2x', 'natural', '2x'}, ...
			'lines', 1.75, ...
			'space', 0.75, ...
			'style', 'buttongroup' ...
		);
	
		control(end + 1) = control_create( ...
			'name', 'band_filter', ...
			'alias', 'filter event band', ...
			'tooltip', 'Apply bandpass filter to exclude non-event frequencies', ...
			'style', 'checkbox', ... 
			'value', data.browser.play.band_filter ...
		); 
	
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		opt = control_group;
		
		opt.width = 10;
		opt.top = 0;
		opt.bottom = 1.5;
		
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
		
		pal = control_group(par,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);
		
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

		%--
		% Separator/Header
		%--
		
		control(1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',0.1, ...
			'string','Bounds' ...
		);
	
		%--
		% Bounds Tabs
		%--

		tabs = {'Time','Freq'}; 
		
		control(end + 1) = control_create( ...
			'style','tabs', ...
			'name','Bounds Tabs', ...
			'tab',tabs ...
		);
	
		%--
		% Start Time
		%--
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
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
	
		%--
		% Min Freq
		%--
		
		control(end + 1) = control_create( ...
			'name','min_freq', ...
			'alias','Min Freq', ...
			'tooltip','Minimum frequency of selection in Hz', ...
			'style','slider', ...
			'tab',tabs{2}, ...
			'active',1, ...
			'min',0, ...
			'max',get_sound_rate(data.browser.sound) / 2, ...
			'value',0 ...
		);
	
		%--
		% Bandwidth / Max Freq
		%--
		
		% NOTE: the negative space offset used provides a visual cue to
		% this control when used as title for the next control
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
			'name','freq_slider', ...
			'alias',' ', ...
			'tooltip','Bandwidth of selection in Hz', ...
			'style','slider', ...
			'tab',tabs{2}, ...
			'space',1.5, ...
			'active',1, ...
			'min',0, ...
			'max',get_sound_rate(data.browser.sound) / 2, ...
			'value',get_sound_rate(data.browser.sound) / 4 ...
		);
	
		%--
		% Separator/Header
		%--
		
		control(end + 1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',0.11, ...
			'string','Options' ...
		);
	
		%--
		% Options Tabs
		%--

		tabs = {'View','Display'}; 
		
		control(end + 1) = control_create( ...
			'style','tabs', ...
			'name','Options Tabs', ...
			'label',0, ... % this should be set by control group
			'lines',1.25, ...% this should be set by control group
			'tab',tabs ...
		);
	
		%--
		% Selection Grid
		%--
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
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
		
		control(end + 1) = control_create( ...
			'name','control_points', ...
			'alias','Control Points', ...
			'tooltip','Toggle display of control points', ...
			'style','checkbox', ...
			'tab',tabs{1}, ...
			'lines',0, ...
			'value',data.browser.selection.control ...
		);
	
		%--
		% Separator
		%--
		
		control(end + 1) = control_create( ...
			'tab',tabs{1}, ...
			'style','separator' ...
		);
	
		%--
		% Selection Zoom
		%--
		
		control(end + 1) = control_create( ...
			'name','selection_zoom', ...
			'alias','Zoom', ...
			'tooltip','Toggle display of selection zoom', ...
			'style','checkbox', ...
			'tab',tabs{1}, ...
			'lines',0, ...
			'value',data.browser.selection.zoom ...
		);
	
		%--
		% Color
		%--
		
		C = color_to_rgb;
						
		ix = find(strcmp(C,rgb_to_color(data.browser.selection.color)));		

		if (isempty(ix))
			ix = 1;
		end
					
		control(end + 1) = control_create( ...
			'name','selection_color', ...
			'alias','Color', ...
			'tab',tabs{2}, ...
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
		
		control(end + 1) = control_create( ...
			'name','selection_linestyle', ...
			'alias','Line Style', ...
			'tab',tabs{2}, ...
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
		
		control(end + 1) = control_create( ...
			'name','selection_linewidth', ...
			'alias','Line Width', ...
			'tab',tabs{2}, ...
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
		
		control(end + 1) = control_create( ...
			'name','selection_opacity', ...
			'alias','Opacity', ...
			'tab',tabs{2}, ...
			'tooltip',['Opacity level for selection display'], ...
			'style','slider', ...
			'space',1.5, ...
			'lines',1, ...
			'min',0, ...
			'max',1, ...
			'value',tmp ...
		);
	
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		opt = control_group;
		
		opt.width = 8.5;
		opt.top = 0;
		opt.bottom = 1.5;
		
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
		
		pal = control_group(par,'browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);
	
	%-----------------------------------
	% Spectrogram Palette
	%-----------------------------------
	
	% TODO: figure pal a way to produce the resolution controls
	
	case 'Spectrogram'
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
			
		%--
		% Slice Header
		%--
		
		control(1) = control_create( ...
			'style', 'separator', ...
			'type', 'header', ...
			'string', 'Slice' ...
		);
	
		%--
		% Slice Tabs
		%--

		control(end).space = 0.1;
		
		tabs = {'FFT', 'Summary'}; 
		
		control(end + 1) = control_create( ...
			'style', 'tabs', ...
			'name', 'slice_tabs', ...
			'label', 0, ... % this should be set by control group
			'lines', 1.25, ...% this should be set by control group
			'tab', tabs ...
		);
	
		%--
		% FFT Size
		%--
		
		control(end + 1) = control_create( ...
			'name', 'Size', ...
			'alias', 'Size', ...
			'tooltip', 'Size of FFT in number of samples', ...
			'style', 'slider', ...
			'type', 'integer', ...
			'tab', tabs{1}, ...
			'min', 16, ...
			'max', 4096, ...
			'value', data.browser.specgram.fft ...
		);
	
		%--
		% FFT Advance
		%--
		
		if data.browser.specgram.hop_auto
			state = '__DISABLE__';
		else
			state = '__ENABLE__'; 
		end
		
		control(end + 1) = control_create( ...
			'name','Advance', ...
			'tooltip','Data advance as fraction of FFT size', ...
			'style','slider', ...
			'space',0.75, ...
			'tab',tabs{1}, ...
			'min',1/100, ...
			'max',1, ...
			'initialstate', state, ... 
			'value',data.browser.specgram.hop ...
		);
	
		% NOTE: this will turn off 'Advance' control
		
		control(end + 1) = control_create( ...
			'name','hop_auto', ...
			'alias','auto', ...
			'tab',tabs{1}, ...
			'style','checkbox', ...
			'value',data.browser.specgram.hop_auto ...
		);

                %%% Modified SCK
                % initialize here--fix in future
                data.browser.specgram.smoothing = 0;
                control(end+1) = control_create( ...
                        'name','Smoothing', ...
                        'tab',tabs{1}, ...
                        'style','checkbox', ...
                        'space',0.75, ...
                        'lines',0, ...
                        'value',data.browser.specgram.smoothing ...
                );
                %%% end SCK

		
		%--
		% summary controls
		%--
	
		% TODO: create summary type access function
		
		types = title_caps({'Min', 'Mean', 'Max'});
		
		ix = find( ...
			strcmpi(types, data.browser.specgram.sum_type) ...
		);
		
		if isempty(ix)
			ix = 2;
		end
		
		control(end + 1) = control_create( ...
			'name','sum_type', ...
			'alias','type', ...
			'tab',tabs{2}, ...
			'style','popup', ...
			'string', types, ...
			'value',ix ...
		);
	
		quality_values = title_caps({'low', 'medium', 'high', 'highest'});
		
		ix = find( ...
			strcmpi(quality_values, data.browser.specgram.sum_quality) ...
		);
		
		if isempty(ix)
			ix = 1;
		end
		
		control(end + 1) = control_create( ...
			'name','sum_quality', ...
			'alias','quality', ...
			'tab',tabs{2}, ...
			'style','popup', ...
			'string', quality_values, ...
			'value',ix ...
		);
	
		%--
		% Window Header
		%--
		
		control(end + 1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'space',1, ... % before window plot 'space',0.75, ...
			'string','Window' ...
		);
	
		%--
		% Window_Plot
		%--
		
		control(end + 1) = control_create( ...
			'name','Window_Plot', ...
			'width',1, ...
			'align','center', ...
			'lines',4.5, ...
			'label',0, ...
			'space',0.75, ...
			'style','axes' ...
		);
		
		%--
		% Window Type
		%--
		
		[window_types, ignore, def_ix] = window_to_fun;
		
		ix = find(strcmpi(window_types, data.browser.specgram.win_type));
		
		if isempty(ix)
			ix = def_ix;
		end
		
		control(end + 1) = control_create( ...
			'name','Type', ...
			'tooltip','Type of data window', ...
			'style','popup', ...
			'string',window_types, ...
			'value',ix ...
		);
		
		%--
		% Window Parameter
		%--
		
		control(end + 1) = control_create( ...
			'name','Parameter', ...
			'tooltip','Data window parameter', ...
			'style','slider' ...
		);
		
		%--
		% Window Length
		%--
		
		control(end + 1) = control_create( ...
			'name','Length', ...
			'tooltip','Length of window as fraction of FFT size', ...
			'style','slider', ...
			'space',1.25, ...
			'min',1/64, ...
			'max',1, ...
			'value',data.browser.specgram.win_length ...
		);
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		control(end).space = 0; % let this space be given by the margin
		
		opt = control_group;
		
		opt.width = 7.5;
		
		opt.top = 0; opt.bottom = 1.5;
		
		opt.header_color = COLOR_ON;
		
		opt.handle_to_callback = 1;
		
		opt.palette_to_callback = 1;
		
		pal = control_group(par, 'browser_controls', str, control, opt);
		
		%--
		% set figure tag
		%--
		
		set(pal,'tag',['XBAT_PALETTE::CORE::' str]);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = pal;
		
		set(par, ...
			'userdata',data, ...
			'buttondown','browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(pal,'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');']);
		
		%-----------------------------------
		% UPDATE PALETTE
		%-----------------------------------
		
		%--
		% update window parameter control
		%--
		
		param = window_to_fun(data.browser.specgram.win_type,'param');
		
		if ~isempty(param)
			
			% update control

			set_control(pal,'Parameter','enable',1);
			
			handles = get_control(pal, 'Parameter', 'handles');
			
			set(handles.uicontrol.slider, 'min', param.min, 'max', param.max);
			
			set_control(pal, 'Parameter', 'value', data.browser.specgram.win_param);
		
		else
			
			g = control_update(par,'Spectrogram','Parameter','__DISABLE__', data);

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
		
		window_plot([], pal, data);
	
	%--
	% Show
	%--
	
	% TODO: separate this branch into a separate function
	
	case 'Show'
			
		%--
		% check for double click
		%--
		
		front = double_click(par);
		
		%--
		% check for timers
		%--
		
		% NOTE: this is probably best handled through the timer's errorfcn 
		
		if isempty(timerfind('name', 'XBAT Palette Daemon'))
			start(palette_daemon);
		end
		
		% NOTE: this is no currently in use, consider using again
		
% 		if (isempty(timerfind('name','XBAT Palette Glue Daemon')))
% 			start(palette_glue_daemon);
% 		end
	
		if isempty(timerfind('name', 'XBAT Browser Daemon'))
			start(browser_daemon);
		end
		
		%--------------------------
		% HIDE AND SHOW CODE
		%--------------------------
		
		% TODO: this functionality should be configurable globally
		
		%--
		% hide children of all other sound figures
		%--
		
		others = setdiff(get_xbat_figs('type', 'sound'), par);
		
		for k = 1:length(others)
			set(get_xbat_figs('parent', others(k)), 'visible', 'off');
		end
		
		% NOTE: also hide other sound windows, make this an option
				
		if ~show_other_sounds
						
			set(others, 'visible', 'off');
			
		else
			
			for k = 1:length(others)
				if strcmpi(get(others(k), 'visible'), 'off')
					set(others(k), 'visible', 'on');
				end
			end
			
		end
		
		%--
		% show our chidren
		%--

		% NOTE: separate children into palettes and non-palettes
		
		ch = get_xbat_figs('parent', par);
		
		pal = get_xbat_figs('parent', par, 'type', 'palette');
		
		ch = setdiff(ch, pal);
		
		%--
		% show non-palette children
		%--
		
		for k = 1:length(ch)
			
			%--
			% update visibility if needed
			%--
			
			if strcmpi(get(ch(k), 'visible'), 'off')
				set(ch(k), 'visible', 'on');
			end
			
			%--
			% update focus (using double click event)
			%--
			
% 			if front
% 				figure(ch(k));
% 			else
% 				figure(par);
% 			end
			
		end
		
		%--
		% update palette visibility
		%--
				
		data = get(par, 'userdata');
		
		if ~data.browser.palette_display
			palette_display(par, 'off');
		else
			palette_display(par, 'on');
		end
		
		% NOTE: this is cheap keep on always
		
		if strcmpi(get(par, 'visible'), 'off')
			set(par, 'visible', 'on');
		end
		
		figure(par);
		
		%--
		% output nothing
		%--
		
		pal = [];

end

%--
% position palette
%--

if ~isempty(pal)
	position_palette(pal, par, 'center'); 
end

%--
% set palette keypress
%--

if ~isempty(pal) 
	set(pal, 'keypressfcn', {@browser_keypress_callback, par});
end

%--
% hide dock controls
%--

set(pal, 'dockcontrols', 'off');

if ~nargout
	clear('pal'); clear('c');
end


%------------------------------------------------
% CREATE_PALETTE
%------------------------------------------------

function pal = create_palette(name, control, opt, par, data)

% create_palette - create palette
% -------------------------------
%
% pal = create_palette(name, control, opt, par, data)
%
% Input:
% ------
%  name - palette name
%  control - control array
%  opt - options
%  par - parent handle
%  data - parent data
%
% Output:
% -------
%  pal - palette handle

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% set no parent default
%--

if (nargin < 4)
	par = [];
end

%--
% get parent data if needed
%--

if (nargin < 5) && ~isempty(par)
	data = get(par, 'userdata');
else
	data = [];
end

%--
% set default options
%--

if (nargin < 3) || isempty(opt)
	opt = control_group;
end

%------------------------------
% CREATE PALETTE
%------------------------------

%--
% set dimensions and margins
%--

% NOTE: if a header starts palette set null top margin

first = control(1);

if strcmp(first.style, 'separator') && strcmp(first.type, 'header')
	opt.top = 0;
end

% NOTE: we want this space to be given by palette margin

control(end).space = 0;

opt.bottom = 1.25;

opt.width = 7.5;

%--
% set color and callback options
%--

% NOTE: this is the browser palette yellow color

opt.header_color = (2 * LIGHT_GRAY + 4 * [1 1 0.1]) / 6;

opt.handle_to_callback = 1;

opt.palette_to_callback = 1;

%--
% create palette
%--

pal = control_group(par,'browser_controls',name,control,opt);

%--
% set figure tag
%--

set(pal,'tag',['XBAT_PALETTE::CORE::' name]);

%------------------------------
% REGISTER PALETTE
%------------------------------

%--
% register palette and set parent buttondown
%--

% TODO: this should be a separate function

n = length(data.browser.palettes);

data.browser.palettes(n + 1) = pal;

set(par, ...
	'userdata',data,'buttondown','browser_palettes(gcf,''Show'');' ...
);

%--
% set palette close request to unregister
%--

set(pal, ...
	'closerequestfcn',['delete_palette(' num2str(par) ',''' name ''');'] ...
);


%------------------------------------------------
% LOG_PALETTE_KPFUN
%------------------------------------------------

function log_palette_kpfun(obj,eventdata)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%--
% check for return
%--

if (strcmp(get(gcf,'currentkey'),'return'))
	
	%--
	% check for new log edit box
	%--
	
	g = findobj(gcf,'tag','New Log Edit');
	
	if (~isempty(g))
		
		% NOTE: this depends on the known form of the callback for this control
		
		cb = get(g,'callback');
		
		feval(cb{1},g,[],cb{2},cb{3},cb{4},1);
		
	end
	
end


%------------------------------------------------
% AUTO_ORDER
%------------------------------------------------

function auto_order(obj, eventdata, h)

% auto_order - order channels in natural order or using channel distance
% ----------------------------------------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
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

switch get(obj,'label')
	
	case 'Default Order'
		
		%--
		% sort the channel matrix in channel index order
		%--
		
		% NOTE: this is the shortest way to produce this matrix keeping current selection
		
		[ignore,ix] = sort(C(:,1));
		
		[L,ix] = channel_strings(C(ix,:));
		
	case 'Distance to Channel Order'
		
		%--
		% get base channel
		%--
		
		ch = find(C(:,2));
		ch = C(ch,1);
		
		%--
		% compute distance to channel and sort
		%--
		
		G = get_geometry(data.browser.sound);
		
		if isempty(G)
			return;
		end
		
		V = G - repmat(G(ch,:),[size(G,1),1]);
		
		d = sum(V.^2,2);
		
		[d,ix] = sort(d);
		
		%--
		% create channel matrix in distance to channel order
		%--
		
		% NOTE: it is easy to regenerate the matrix since selection is the desired base channel
		
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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
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
% COPY_TO_WORKSPACE
%------------------------------------------------

function copy_to_workspace(obj,eventdata)



%------------------------------------------------
% CLOSE_LOGS
%------------------------------------------------

function close_logs(obj, eventdata)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%--
% get palette and parent figures
%--

pal = gcf;

par = get_field(get(pal, 'userdata'), 'parent');

%--
% get display control value
%--

value = get_control(pal, 'Display', 'value');

%--
% close logs
%--

for k = 1:length(value)
	log_close(par, value{k});
end

%--
% update log display listbox
%--

refresh(pal);

%--
% perform event search callback
%--

pal = get_palette(par, 'Event');

if ~isempty(pal)
	
	% NOTE: execute search callback in this way for other events

	c = findobj(control_update([], pal, 'find_events'), 'style', 'edit');
	
	browser_controls(par, 'find_events', c);
	
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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
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
% EVENT_DISPLAY_MENU
%------------------------------------------------

function event_display_menu(pal)

%---------------------------
% SETUP
%---------------------------

%--
% find event display
%--

g = findobj(pal, 'tag', 'event_display', 'style', 'listbox');

if isempty(g)
	return;
end 

%--
% get annotation and measurement information
%--

% NOTE: this is very old code, these are not current extensions

[ANNOT, ANNOT_NAME] = get_annotations;

par = get_palette_parent(pal);

[MEAS, MEAS_NAME] = get_measurements(par);

%---------------------------
% CREATE MENUS
%---------------------------

%--
% create context menu
%--

handle = context_menu(g);

%--
% action menu
%--

temp = uimenu(handle, ...
	'label', 'Actions' ...
);

action_menu(temp, 'event');

%--
% annotation menu
%--

temp = uimenu(handle, ...
	'separator', 'on', ...
	'label', 'Annotate' ...
);

for k = 1:length(ANNOT_NAME)
	uimenu(temp, ...
		'label', [ANNOT_NAME{k}, ' ...'], ...
		'callback', {@process_events, pal, par, ANNOT(k)} ...
	);
end

%--
% measurement menu
%--

temp = uimenu(handle, ...
	'label', 'Measure' ...
);

for k = 1:length(MEAS_NAME)
	uimenu(temp, ...
		'label', [MEAS_NAME{k}, ' ...'], ...
		'callback', {@process_events, pal, par, MEAS(k)} ...
	);
end

%--
% delete events command
%--

uimenu(handle, ...
	'label', 'Delete Events ...', ...
	'separator', 'on', ...
	'callback', @delete_events ...
);


%------------------------------------------------
% PROCESS EVENTS
%------------------------------------------------

function process_events(obj, eventdata, pal, par, ext)

%---------------------
% SETUP
%---------------------

%--
% get parent state
%--

data = get_browser(par); 

%--
% get control string
%--

value = get_control(pal, 'event_display', 'value');

if isempty(value)
	return;
end

%--
% get log and event index information from control string
%--

for k = 1:length(value)
	[ignore, ignore, m0(k), ix0(k)] = get_str_event(par, value{k}, data);
end

m = unique(m0);

for k = 1:length(m)
	ix{k} = ix0(m0 == m(k));
end

%--
% process events from the various logs
%--

for k = 1:length(m)
	process_browser_events(par, ext, m(k), ix{k});
end

%--
% update browser display and event palette
%--

browser_display(par, 'events');

update_find_events(par);
	

%------------------------------------------------
% DELETE_EVENTS
%------------------------------------------------

% NOTE: this function reorders the logs in the browser state

function delete_events(obj, eventdata)

%--
% get parent listbox value
%--

pal = get(get(obj, 'parent'), 'parent');

[g, value] = control_update([], pal, 'event_display');

%--
% get parent figure and userdata
%--

par = get_xbat_figs('child', pal);

data = get(par, 'userdata');

%--
% get log and event indices for events to delete
%--

for k = 1:length(value)
	
	[event(k), name{k}, m(k), ix(k)] = get_str_event(par, value{k}, data);
	
	value{k} = [int2str(k), '. ', value{k}];
	
end

if (length(value) > 1)
	str = ['Delete the ', int2str(numel(value)), ' selected events ?'];
else
	str = ['Delete the selected event ?'];
end

% NOTE: we permute the button positions to protect against habit
	
tmp = {'Yes', 'No', 'Cancel'};

% tmp = tmp(randperm(3));
	
action = quest_dialog(str, ['  Delete Event(s) ...'], tmp{:}, 'No');

if ~strcmp(action, 'Yes')
	return;
end

% NOTE: we could used a waitbar here, this is not the most efficient way of doing this

%--
% make sure we delete later events first
%--

[ix, p] = sort(ix, 'descend');

m = m(p);

for k = 1:length(ix)

	%--
	% put deleted event in deleted events array
	%--

	dix = length(data.browser.log(m(k)).deleted_event);

	if (dix == 1) && isempty(data.browser.log(m(k)).deleted_event(1).id)
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
% update browser state
%--

set(par, 'userdata', data);

%--
% update browser display and event palette
%--

browser_display(par, 'events', data);

update_find_events(par, [], data);
