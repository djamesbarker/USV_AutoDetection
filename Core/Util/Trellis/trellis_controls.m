function out = trellis_controls(h,str,c)

% trellis_controls - callbacks for trellis controls
% -------------------------------------------------
%
% trellis_controls(h,str,c)
%
% Input:
% ------
%  h - browser figure handle
%  str - command string
%  c - control object handle

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
% $Revision: 1.1 $
% $Date: 2003-03-07 00:30:19-05 $
%--------------------------------

%--
% get control handle if needed
%--

% this functionality is provided by function handle callbacks automatically

if ((nargin < 3) | isempty(c))
	c = gcbo;
end

%--
% indicate control action using pointer
%--

pal = get(c,'parent'); % get control figure

ptr = get(pal,'pointer');

if (strcmp(ptr,'watch'))
	ptr = 'arrow';
end

set(pal,'pointer','watch');

%---------------------------------------------------------------
% CONSTANTS USED BY CONTROLS
%---------------------------------------------------------------

%--
% minimum band width for page display
%--

persistent MIN_BAND;

if (isempty(MIN_BAND))
	MIN_BAND = 10;
end

%--
% set display flag to empty
%--

display_flag = [];

%---------------------------------------------------------------
% FIGURE USERDATA TO UPDATE
%---------------------------------------------------------------

data = get(h,'userdata');

%---------------------------------------------------------------
% GET VALUE FROM CONTROL
%---------------------------------------------------------------

if (strcmp(get(c,'type'),'uicontrol'))
	
	tmp = get(c,'style');
	
else
	
	if (strcmp(get(c,'type'),'axes'))
		tmp = 'axes';
	else
		return; % this may change to support within axes editing
	end
	
end

switch (tmp)
	
	%--
	% slider control
	%--
	
	case ('slider')
		
		%--
		% value returned is a number
		%--
		
		value = get(c,'value');
		
	%--
	% edit box control
	%--
	
	case ('edit')
		
		%--
		% try to find a matching slider
		%--
		
		g = findobj(get(c,'parent'), ...
			'style','slider', ...
			'tag',get(c,'tag') ...
		);
		
		%--
		% get value from edit box considering matching slider
		%--
		
		if (isempty(g))
			
			%--
			% no matching slider
			%--
			
			value = get(c,'string');
			
		else
			
			%--
			% consider slider type
			%--
			
			type = get(g,'userdata');
			
			if (isempty(type))
				type = '';
			end
			
			switch (type)
				
				%--
				% time slider
				%--
				
				case ('time')
					value = clock_to_sec(get(c,'string'));
				
				%--
				% integer slider
				%--
				
				case ('integer')
					value = round(str2num(get(c,'string')));
				
				%--
				% normal slider
				%--
				
				otherwise
					value = str2num(get(c,'string'));
					
			end
							
		end
		
	%--
	% listbox
	%--
	
	case ('listbox')
	
		action = 'Selection';
		
		% supports multiple selections, hence value is a cell array
		
		value = get(c,'value');
		tmp = get(c,'string');
		value = tmp(value);
		
	%--
	% popupmenu
	%--
	
	case ('popupmenu')
		
		% support single selection, hence value is a string
		
		value = get(c,'value');
		tmp = get(c,'string');
		value = tmp{value};
		
	%--
	% checkbox
	%--
	
	case ('checkbox')
		
		% value returned is zero or one
		
		value = get(c,'value');
		
	%--
	% pushbutton
	%--
	
	case ('pushbutton')
		
		%--
		% try to find a matching listbox
		%--
		
		g = findobj(get(c,'parent'), ...
			'style','listbox', ...
			'tag',get(c,'tag') ...
		);
		
		%--
		% get value from listbox if available
		%--
		
		if (~isempty(g))
			
			%--
			% check for cancel or apply button
			%--
						
			action = get(c,'string');
			
			switch (action)
				
				case ('Cancel')
					
					% this retrieves previously applied values stored in
					% the cancel button userdata
					
					value = get(c,'userdata');
					tmp = get(g,'string');
					value = tmp(value);
					
				case ('Apply')
					
					% this gets new values from the associated listbox
					
					value = get(g,'value');
					tmp = get(g,'string');
					value = tmp(value);
					
			end
			
		%--
		% get pushbutton label as action
		%---
		
		else
			
			action = get(c,'string');
			
		end
		
end

%---------------------------------------------------------------
% UPDATE USERDATA ACCORDING TO COMMAND STRING
%---------------------------------------------------------------

switch (str)
		
	%---------------------------------------------------------------
	% TRELLIS CONTROLS
	%---------------------------------------------------------------
	
	%--
	% Row Margin
	%--
	
	case ('margin_row');
		
		%--
		% update userdata
		%--
		
		data.trellis.opt.margin.row = value;
		set(h,'userdata',data);
		
		%--
		% update display
		%--
		
		feval(get(h,'resizefcn'),h,[]);
		
	%--
	% Column Margin
	%--
	
	case ('margin_col');
		
		%--
		% update userdata
		%--
		
		data.trellis.opt.margin.col = value;
		set(h,'userdata',data);
		
		%--
		% update display
		%--
		
		feval(get(h,'resizefcn'),h,[]);
				
	%--
	% Auto Scale
	%--
	
	case ('Auto Scale');
		
		%--
		% update userdata
		%--
		
		data.browser.colormap.auto_scale = value;
		set(h,'userdata',data);
		
		%--
		% update menu
		%--
		
		if (value)
			state = 'on';
		else
			state = 'off';
		end
		
		set(get_menu(data.browser.view_menu.colormap_options,'Auto Scale'),'check',state);
		
		%--
		% update controls
		%--
		
		if (~value)
			state = '__ENABLE__';
		else
			state = '__DISABLE__';
		end
		
		control_update(h,'Colormap','Brightness',state,data);
		control_update(h,'Colormap','Contrast',state,data);
		
		if (data.browser.colormap.contrast == 0)
			control_update(h,'Colormap','Brightness','__DISABLE__',data);
		end
		
		%--
		% update display
		%--
		
		browser_view_menu(h,data.browser.colormap.name);
		
	%--
	% Brightness
	%--
	
	case ('Brightness')
		
		%--
		% update userdata
		%--
		
		data.browser.colormap.brightness = value;
		set(h,'userdata',data);
		
		%--
		% update display
		%--
		
		browser_view_menu(h,data.browser.colormap.name);
		
	%--
	% Contrast
	%--
	
	case ('Contrast')
		
		%--
		% update userdata
		%--
		
		data.browser.colormap.contrast = value;
		set(h,'userdata',data);
		
		%--
		% update display
		%--
		
		browser_view_menu(h,data.browser.colormap.name);
		
		%--
		% update controls
		%--
		
		if (value == 0)
			control_update(h,'Colormap','Brightness','__DISABLE__',data);
		else
			control_update(h,'Colormap','Brightness','__ENABLE__',data);
		end
		
	%--
	% Invert
	%--
	
	case ('Invert')
		
		%--
		% update userdata
		%--
		
		data.browser.colormap.invert = value;
		set(h,'userdata',data);
		
		%--
		% update display
		%--
		
		browser_view_menu(h,data.browser.colormap.name);
		
	%--
	% Colorbar
	%--
	
	case ('Colorbar')

		%--
		% update display
		%--
		
		browser_view_menu(h,'Colorbar');
		
		
	%---------------------------------------------------------------
	% GRID CONTROLS
	%---------------------------------------------------------------
	
	%--
	% Color
	%--
	
	case ('Color')
		
		%--
		% get palette name
		%--
		
		pal_name = get(pal,'name');
		
		%--
		% update depending on palette name
		%--
		
		% this approach of using the palette name along with the control
		% name should be used to make the control names unique, then this
		% larget switch can work on the concatenation of the palette and
		% control name
		
		switch (pal_name)
			
			%--
			% update grid display
			%--
			
			case ('Grid')
				browser_view_menu(h,value);
				
			%--
			% update log color
			%--
				
			case ('Log')
				
				%--
				% get index of log to update
				%--
				
				L = file_ext(struct_field(data.browser.log,'file'));
				
				[tmp,tmp_value] = control_update(h,'Log','Log',[],data);
				
				m = find(strcmp(L,tmp_value));
				
				%--
				% update userdata
				%--
				
				data.browser.log(m).color = color_to_rgb(value);
				
				set(h,'userdata',data);
					
% 				%--
% 				% update control
% 				%--
% 				
% 				g = control_update(h,'Log','Color',[],data);
% 				
% 				% set color of confirm axes
% 				set(findobj(g,'type','axes'),'color',color_to_rgb(value));
				
				%--
				% update menus
				%--
				
				% get parent menu handle
				
				tmp = findobj(findall(data.browser.log_menu.log(1)),'flat','label','Color');
				ix = find(strcmp(get(tmp,'tag'),tmp_value));
				tmp = tmp(ix);
						
				% update children checks
				
				ch = get(tmp,'children');
						
				set(ch,'check','off');
				set(get_menu(ch,value),'check','on');
				
				%--
				% update display
				%--
				
				browser_display(h,'events',data);
				
		end
		
	%--
	% Time Grid
	%--
	
	case ('Time Grid')
		
		%--
		% update display
		%--
		
		browser_view_menu(h,'Time Grid');
		
	%--
	% Freq Grid
	%--
	
	case ('Freq Grid')
		
		%--
		% update display
		%--
		
		browser_view_menu(h,'Freq Grid');
		
	%--
	% Time Spacing
	%--
	
	case ('Time Spacing')
		
		%--
		% update userdata
		%--
		
		data.browser.grid.time.spacing = value;
		set(h,'userdata',data);
		
		%--
		% update menu
		%--
		
		%--
		% update display
		%--
		
		browser_display(h,'update',data);
	
	%--
	% Time Labels
	%--
	
	case ('Time Labels')
		
		%--
		% update display
		%--
		
		browser_view_menu(h,value);
		
		%--
		% update controls
		%--
		
		% get handles of time control
		
		g = control_update(h,'Navigate','Time',[],data);
		
		if (~isempty(g))
			
			%--
			% get indices of slider and edit box handles
			%--
			
			tmp = get(g,'style');
			
			ix1 = find(strcmp(tmp,'slider'));
			ix2 = find(strcmp(tmp,'edit'));
			
			%--
			% update type of slider in slider userdata and update callback
			%--
			
			switch (value)
				
				%--
				% Second labels
				%--
				
				case ('Seconds')
					
					%--
					% set slider userdata
					%--
					
					set(g(ix1),'userdata',[]);
					
					%--
					% update slider callback
					%--
					
					tmp = get(g(ix1),'callback');
					
					pat = '''slider''';
					ix = strfind(tmp,pat);
					tmp(ix + length(pat) + 1) = '0';
					
					set(g(ix1),'callback',tmp);
					
					%--
					% update edit callback
					%--
					
					tmp = get(g(ix2),'callback');
					
					pat = '''edit''';
					ix = strfind(tmp,pat);
					tmp(ix + length(pat) + 1) = '0';
					
					set(g(ix2),'callback',tmp);
					
				%--
				% Clock labels
				%--
				
				case ('Clock')
					
					%--
					% update slider type in userdata
					%--
					
					set(g(ix1),'userdata','time');
					
					%--
					% update slider callback
					%--
					
					tmp = get(g(ix1),'callback');
					
					pat = '''slider''';
					ix = strfind(tmp,pat);
					tmp(ix + length(pat) + 1) = '1';
					
					set(g(ix1),'callback',tmp);
					
					%--
					% update edit callback
					%--
					
					tmp = get(g(ix2),'callback');
					
					pat = '''edit''';
					ix = strfind(tmp,pat);
					tmp(ix + length(pat) + 1) = '1';
					
					set(g(ix2),'callback',tmp);
					
				%--
				% Date and Time labels
				%--
				
				case ('Date and Time')
					
					%--
					% update slider userdata
					%--
					
					set(g(ix1),'userdata','time');
					
					%--
					% update slider callback
					%--
					
					tmp = get(g(ix1),'callback');
					
					pat = '''slider''';
					ix = strfind(tmp,pat);
					tmp(ix + length(pat) + 1) = '1';
					
					set(g(ix1),'callback',tmp);
					
					%--
					% update edit callback
					%--
					
					tmp = get(g(ix2),'callback');
					
					pat = '''edit''';
					ix = strfind(tmp,pat);
					tmp(ix + length(pat) + 1) = '1';
					
					set(g(ix2),'callback',tmp);
					
			end
			
			%--
			% update slider control
			%--
			
			control_update(h,'Navigate','Time',data.browser.time,data);
			
		end

	%--
	% Freq Spacing
	%--
	
	case ('Freq Spacing')
		
		%--
		% update userdata
		%--
		
		data.browser.grid.freq.spacing = value;
		set(h,'userdata',data);
		
		%--
		% update menu
		%--
		
		%--
		% update display
		%--
		
		browser_display(h,'update',data);
		
	%--
	% Freq Labels
	%--
	
	case ('Freq Labels')
		
		%--
		% update display
		%--
		
		browser_view_menu(h,value);
	
	%--
	% File Grid
	%--
	
	case ('File Grid')
		
		%--
		% update display
		%--
		
		browser_view_menu(h,'File Grid');
			
		
	%---------------------------------------------------------------
	% LOG CONTROLS
	%---------------------------------------------------------------

	%--
	% Active
	%--
	
	case ('Active')
		
		%--
		% get open logs and selection index
		%--
		
		L = file_ext(struct_field(data.browser.log,'file'));
		
		%--
		% update active log
		%--
		
		m = find(strcmp(value,L));
		
		if (~isempty(m))
			
			data.browser.log_active = m;
			set(h,'userdata',data);
			
		else
			
			return;
			
		end
		
		%--
		% update active and log selection to menu
		%--
		
		tmp = data.browser.log_menu.active;
		
		set(tmp,'check','off'); 
		set(get_menu(tmp,value),'check','on');
		
		tmp = data.browser.edit_menu.log_to;
		
		set(tmp,'check','off'); 
		set(get_menu(tmp,value),'check','on');
		
		%--
		% update log options display
		%--
		
		g = findobj(pal,'tag','Log','style','popupmenu');
		
		str = get(g,'string');
		ix = find(strcmp(str,value));
		
		set(g,'value',ix);
		
		trellis_controls(h,'Log',g);
		
	%--
	% New Log
	%--
	
	case ('New Log')
		
		show_new_log(h,pal,data);
		
	%--
	% Open Log
	%--
	
	case ('Open Log ...')

		browser_file_menu(h,'Open Log ...');
		
	%--
	% Display
	%--
	
	case ('Display')
		
		%--
		% update according to action
		%--
		
		switch (action)
			
			%--
			% constraint to conserve selection of play channels
			%--
			
			case ('Selection')
				
				%--
				% enable apply and cancel buttons
				%--
						
				set(findobj(pal,'tag',str,'style','pushbutton'),'enable','on');
				
				%--
				% provide display toggle for single log
				%--
				
				% double click turns selection off
				
				if (length(get(c,'value')) == 1)
					
					if (strcmp(get(get(c,'parent'),'selectiontype'),'open'))
						set(c,'value',[]);
					end
					
				end
				
				%--
				% enable display context menu
				%--
				
				tmp = get(c,'uicontextmenu');
				
				if (~isempty(tmp))
		
					test = (length(get(c,'string')) > 1) & (length(get(c,'value')) == 1);
					
					if (test)
						set(get_menu(tmp,'Arrange'),'enable','on');
					else
						set(get_menu(tmp,'Arrange'),'enable','off');
					end
					
				end

			%--
			% apply log visiblity selection
			%--
			
			case ('Apply')
				
				%--
				% update userdata
				%--
				
				L = file_ext(struct_field(data.browser.log,'file'));
				
				for k = 1:length(L)
					data.browser.log(k).visible = 0;
				end
				
				for k = 1:length(value)
					ix = find(strcmp(L,value{k}));
					data.browser.log(ix).visible = 1;
				end
				
				set(h,'userdata',data);
				
				%--
				% update menus
				%--
				
				tmp = data.browser.log_menu.display;
				
				set(tmp,'check','off');
				
				for k = 1:length(value)
					set(get_menu(tmp,value{k}),'check','on');
				end
				
				%--
				% update display
				%--
				
				browser_display(h,'events',data);
				
				%--
				% disable apply and cancel buttons
				%--
						
				set(findobj(pal,'tag',str,'style','pushbutton'),'enable','off');
				
			%--
			% reset log visibility to current log visibility
			%--
			
			case ('Cancel')
				
				%--
				% get current visibility state
				%--
				
				tmp = struct_field(data.browser.log,'file','visible');
				
				file = file_ext(tmp.file);
				ix = find(tmp.visible);
				
				set(findobj(pal,'tag',str,'style','listbox'),'value',ix);
				
				%--
				% disable apply and cancel buttons
				%--
						
				set(findobj(pal,'tag',str,'style','pushbutton'),'enable','off');
					
		end
		
	%--
	% Log
	%--
	
	case ('Log')
		
		%--
		% get index of log selected
		%--
		
		L = file_ext(struct_field(data.browser.log,'file'));
				
		m = find(strcmp(L,value));
		
		%--
		% update other controls (this controls only controls other controls
		%--
		
		tmp = data.browser.log(m);
		
		name = file_ext(tmp.file);
		
		g = control_update(h,'Log','Color',rgb_to_color(tmp.color),data);
		
		set(findobj(g,'style','popupmenu'), ...
			'tooltipstring',['Color for ''' name ''' event display'] ...
		);
		
		g = control_update(h,'Log','Line Style',lt_to_linestyle(tmp.linestyle,'strict'),data);
		
		set(findobj(g,'style','popupmenu'), ...
			'tooltipstring',['Line style for ''' name ''' event display'] ...
		);
		
		g = control_update(h,'Log','Line Width',tmp.linewidth,data);
		
		set(findobj(g,'style','slider'), ...
			'tooltipstring',['Line width for ''' name ''' event display'] ...
		);
		
		g = control_update(h,'Log','Opacity',tmp.patch,data);
		
		set(findobj(g,'style','slider'), ...
			'tooltipstring',['Opacity level for ''' name ''' event display'] ...
		);
			
	%--
	% Line Style
	%--
	
	case ('Line Style')
		
		%--
		% get index of log to update
		%--
		
		L = file_ext(struct_field(data.browser.log,'file'));
		
		[tmp,tmp_value] = control_update(h,'Log','Log',[],data);
		
		m = find(strcmp(L,tmp_value));
		
		%--
		% update userdata
		%--
		
		data.browser.log(m).linestyle = linestyle_to_str(value);
		
		set(h,'userdata',data);
			
		%--
		% update menus
		%--
		
		% get parent menu handle
		
		tmp = findobj(findall(data.browser.log_menu.log(1)),'flat','label','Line Style');
		ix = find(strcmp(get(tmp,'tag'),tmp_value));
		tmp = tmp(ix);
				
		% update children checks
		
		ch = get(tmp,'children');
				
		set(ch,'check','off');
		set(get_menu(ch,value),'check','on');
		
		%--
		% update display
		%--
		
		browser_display(h,'events',data);
		
	%--
	% Line Width
	%--
	
	case ('Line Width')
		
		%--
		% get index of log to update
		%--
		
		L = file_ext(struct_field(data.browser.log,'file'));
		
		[tmp,tmp_value] = control_update(h,'Log','Log',[],data);
		
		m = find(strcmp(L,tmp_value));
		
		%--
		% update userdata
		%--
		
		data.browser.log(m).linewidth = value;
		
		set(h,'userdata',data);
			
		%--
		% update menus
		%--
		
		% get parent menu handle
		
		tmp = findobj(findall(data.browser.log_menu.log(1)),'flat','label','Line Width');
		ix = find(strcmp(get(tmp,'tag'),tmp_value));
		tmp = tmp(ix);
				
		% update children checks
		
		ch = get(tmp,'children');
				
		set(ch,'check','off');
		set(get_menu(ch,[int2str(value) ' pt']),'check','on');
		
		%--
		% update display
		%--
		
		browser_display(h,'events',data);
		
	%--
	% Opacity
	%--
	
	case ('Opacity')
		
		%--
		% get index of log to update
		%--
		
		L = file_ext(struct_field(data.browser.log,'file'));
		
		[tmp,tmp_value] = control_update(h,'Log','Log',[],data);
		
		m = find(strcmp(L,tmp_value));
		
		%--
		% update userdata
		%--
		
		data.browser.log(m).patch = value;
		
		set(h,'userdata',data);
			
		%--
		% update menus
		%--
		
% 		% get parent menu handle
% 		
% 		tmp = findobj(findall(data.browser.log_menu.log(1)),'flat','label','Opacity');
% 		ix = find(strcmp(get(tmp,'tag'),tmp_value));
% 		tmp = tmp(ix);
% 				
% 		% update children checks
% 		
% 		ch = get(tmp,'children');
% 				
% 		set(ch,'check','off');
% 		set(get_menu(ch,[int2str(value) ' pt']),'check','on');
		
		%--
		% update renderer and display
		%--
		
		update_renderer(h,[],data);
		
		browser_display(h,'events',data);
		
	%---------------------------------------------------------------
	% NAVIGATE CONTROLS
	%---------------------------------------------------------------

	%--
	% Time
	%--
	
	case ('Time')
		
		% this should be moved into 'browser_view_menu'
		
		%--
		% update time
		%--
				
		data.browser.time = value;
		
		%--
		% set display flag
		%--
		
		display_flag = 1;
		
	%--
	% Prev-Next Page
	%--
	
	case ('Prev Page')
		
		browser_view_menu(h,'Previous Page');
		
	case ('Next Page')
		
		browser_view_menu(h,'Next Page');

	%--
	% File
	%--
	
	case ('File')
		
		%--
		% move to file
		%--
		
		browser_view_menu(h,value);
		
		%--
		% update controls
		%--
		
		% get updated time
		
		data = get(h,'userdata');
		
		control_update(h,'Navigate','Time',data.browser.time,data);
		
	%--
	% Prev-Next File
	%--
	
	case ('Prev File')

		out = browser_view_menu(h,'Previous File');
		
	case ('Next File')
		
		out = browser_view_menu(h,'Next File');
		
	%--
	% Prev-Next View
	%--
	
	case ('Prev View')
		
		browser_view_menu(h,'Previous View');
		
	case ('Next View')
		
		browser_view_menu(h,'Next View');
		
		
	%---------------------------------------------------------------
	% PAGE CONTROLS
	%---------------------------------------------------------------

	%--
	% Channels
	%--
	
	case ('Channels')

		%--
		% selection changes the control state, enable apply and cancel
		%--
		
		control_update(h,'Page','Apply Channels','__ENABLE__',data);
		
		control_update(h,'Page','Cancel Channels','__ENABLE__',data);
		
		%--
		% when given a single selection turn on distance order
		%--
		
		g = control_update(h,'Page','Channels',[],data);
		
		g = findobj(g,'flat','style','listbox');
		
		tmp = get_menu(get(g,'uicontextmenu'),'Distance to Channel Order');
		
		if (length(get(g,'value')) == 1)
			set(tmp,'enable','on');
		else
			set(tmp,'enable','off');
		end
						
	%--
	% Order (Up, Down, Top, Bottom, Swap)
	%--
	
	case ({'Up','Down','Top','Bottom','Swap'})
		
		% the changes to the channel display and order are stores in the
		% listbox control until the apply channels control is used to
		% update the browser state
			
		%--
		% get associated control handles
		%--
	
		g = control_update(h,'Page','Channels',[],data);
		
		g = findobj(g,'flat','style','listbox');
		
		%--
		% get channel matrix corresponding to control display
		%--
		
		C = channel_strings(get(g,'string'),get(g,'value'));
		
		%--
		% update channel matrix
		%--
		
		if (strcmp(str,'Swap'))
			
			C = flipud(C);
			ix = find(C(:,2));
			
		else
			
			ch = find(C(:,2) == 1);
			ch = C(ch,1);
		
			[C,ix] = channel_matrix_update(C,lower(str),ch);
			
		end
			
		%--
		% update control
		%--
		
		set(g,'string',channel_strings(C),'value',ix);
		
		%--
		% update controls
		%--
		
		control_update(h,'Page','Apply Channels','__ENABLE__',data);
		
		control_update(h,'Page','Cancel Channels','__ENABLE__',data);

	%--
	% Apply Channels (Apply)
	%--
	
	case ('Apply Channels')
		
		%--
		% get associated control handles
		%--
		
		g = control_update(h,'Page','Channels',[],data);
		
		g = findobj(g,'flat','style','listbox');
		
		%--
		% get channel matrix corresponding to control display
		%--
		
		C = channel_strings(get(g,'string'),get(g,'value'));
		
		%--
		% update controls
		%--
		
		control_update(h,'Page','Apply Channels','__DISABLE__',data);
		
		control_update(h,'Page','Cancel Channels','__DISABLE__',data);
		
		%--
		% update userdata and apply channel selection
		%--
		
		data.browser.channels = C;
		
		set(h,'userdata',data);
		
		browser_view_menu(h,'Update Channels');
		
	%--
	% Cancel Channels (Cancel)
	%--
	
	case ('Cancel Channels')
		
		%--
		% get associated control handles
		%--
		
		g = control_update(h,'Page','Channels',[],data);
		
		g = findobj(g,'flat','style','listbox');
		
		%--
		% get channel metrix from browser and update control
		%--
		
		[L,value] = channel_strings(data.browser.channels);
		
		set(g,'string',L,'value',value);
		
		%--
		% update controls
		%--
		
		control_update(h,'Page','Apply Channels','__DISABLE__',data);
		
		control_update(h,'Page','Cancel Channels','__DISABLE__',data);
		
	%--
	% Geometry_Plot
	%--
	
	case ('Geometry_Plot')
				
		%--
		% get display axes
		%--
		
		ax = findobj(pal,'tag','Geometry_Plot','type','axes');
		
		delete(get(ax,'children'));
		
		%--
		% check whether we are here through clicking
		%--
		
		if (ax == overobj('axes'))
			flag = 1;
		else
			flag = 0;
		end
						
		%--
		% update display
		%--
		
		axes(ax);
		
		hold on;
		
		G = data.browser.sound.geometry;
		
		ch = get_channels(data.browser.channels);
		
		tmp = scatter(G(:,1),G(:,2),36,0.25 * ones(1,3));
		
		for k = 1:length(tmp)
			set(tmp(k),'tag',int2str(k));
		end
		
		set(tmp(ch),'markerfacecolor',0.5 * ones(1,3));
		
		xlim = fast_min_max(G);
		
		dx = 0.1 * diff(xlim);
		
		xlim = [xlim(1) - dx, xlim(2) + dx];
		
		set(ax,'xlim',xlim,'ylim',xlim);
		
		%--
		% select closest channel
		%--
	
		if (flag == 1)
			
			%--
			% get closest channel
			%--
			
			p = get(ax,'currentpoint');
			
			p = p(1,:);
			p(3) = 0;
			
			d = sum((G - repmat(p,[size(G,1),1])).^2,2);
			
			[ignore,ix] = sort(d);
						
			%--
			% display highlight
			%--
						
			m = findobj(tmp,'flat','tag',int2str(ix(1)));
			
			x = get(m,'xdata');
			y = get(m,'ydata');
			s = get(m,'markersize');
			
			test = scatter(x,y,81,[1 0 0]);
			
			set(test,'linewidth',1);
			
			%--
			% update select channel
			%--
			
			g = findobj(pal,'tag','Select Channel','style','popupmenu');
			
			set(g,'value',ix(1));
			
			trellis_controls(h,'Select Channel',g);
			
		else
			
			%--
			% get select channel value
			%--
			
			g = findobj(pal,'tag','Select Channel','style','popupmenu');
			
			value = get(g,'value');
			
			%--
			% display highlight
			%--
						
			m = findobj(tmp,'flat','tag',int2str(value));
			
			x = get(m,'xdata');
			y = get(m,'ydata');
			s = get(m,'markersize');
			
			test = scatter(x,y,81,[1 0 0]);
			
			set(test,'linewidth',1);
			
		end 
		
	%--
	% Select Channel
	%--
	
	case ('Select Channel')
		
		%--
		% get channel from control
		%--
		
		[ignore,value] = strtok(value,' ');
		
		value = eval(value);
		
		%--
		% get position and calibration
		%--
		
		if (isempty(data.browser.sound.geometry))
			
			data.browser.sound.geometry = default_geometry(data.browser.sound.channels);
			set(h,'userdata',data);
			
		end
		
		pos = data.browser.sound.geometry(value,:);
		
		if (isempty(data.browser.sound.calibration))
			
			data.browser.sound.calibration = zeros(data.browser.sound.channels,1);
			set(h,'userdata',data);
			
		end
		
		cal = data.browser.sound.calibration(value);
		
		%--
		% update position and calibration controls
		%--
		
		g = findobj(pal,'tag','Position','style','edit');
		
		set(g,'string',position_string(pos));
		
		g = findobj(pal,'tag','Calibration','style','edit');
		
		set(g,'string',mat2str(cal,4));
				
		%--
		% update 'Geometry_Plot' display
		%--
				
		tmp = overobj('axes');
		
		if ((isempty(tmp) | ~strcmp(get(tmp,'tag'),'Geometry_Plot')) & (data.browser.sound.channels > 2))
			
			g = findobj(pal,'tag','Geometry_Plot','type','axes');
			
			trellis_controls(h,'Geometry_Plot',g);
			
		end
		
	%--
	% Position
	%--
	
	case ('Position')
		
		%--
		% try to parse input string
		%--
		
		pos = position_string(value);
		
		%--
		% get channel to update
		%--
		
		g = findobj(pal,'tag','Select Channel','style','popupmenu');
		
		ch = get(g,'value');
		
		%--
		% update position of channel
		%--
		
		if (~isempty(pos))
			
			%--
			% update parent userdata
			%--
			
			data.browser.sound.geometry(ch,:) = pos;
			
			set(h,'userdata',data);
			
			%--
			% update channel display
			%--
			
			g = findobj(pal,'tag','Geometry_Plot','type','axes');
			
			if (~isempty(g))
				trellis_controls(h,'Geometry_Plot',g);
			end
			
			%--
			% update menu containing position information
			%--
			
			% this is changing, leave this for later
			
		else
			
			set(c,'string',position_string(data.browser.sound.geometry(ch,:)));
			
		end
		
	%--
	% Calibration
	%--
	
	case ('Calibration')
		
		%--
		% try to parse input string
		%--
		
		% this parsing can be moved elsewhere to include error checking in
		% a non-obstrusive way
		
		try
			
			cal = eval(value);
			
			if (~isreal(cal) | (length(cal) > 1))
				cal = [];
			end
			
		catch
			
			cal = [];
			
		end
		
		%--
		% get channel to update
		%--
		
		g = findobj(pal,'tag','Select Channel','style','popupmenu');
		
		ch = get(g,'value');
		
		%--
		% update channel calibration
		%--
		
		if (~isempty(cal))
			
			%--
			% update parent userdata
			%--
			
			data.browser.sound.calibration(ch) = cal;
			
			set(h,'userdata',data);
			
			%--
			% update channel layout display
			%--
			
			% there is currently no display associated to this
			
			%--
			% update menu containing position information
			%--
			
			% this is changing, leave this for later
			
		else
			
			set(c,'string',num2str(data.browser.sound.calibration(ch,:)));
			
		end
		
	%--
	% Duration
	%--
	
	case ('Duration')
		
		%--
		% get current time and sound duration
		%--
		
		t = data.browser.time;
		
		T = data.browser.sound.duration;
		
		%--
		% update time if current time plus page exceeds available sound duration
		%--
		
		ddt = data.browser.specgram.fft / data.browser.sound.samplerate;
		
		if ((t + value) >= (T - ddt))
			data.browser.time = max(0,(T - (value + ddt))); % ensure positive value
		end
		
		%--
		% update userdata
		%--
		
		data.browser.page.duration = value;
		
		%--
		% set display flag
		%--
		
		display_flag = 1;
				
		%--
		% update menus
		%--
		
		tmp = data.browser.view_menu.page_duration;
		
		set(tmp,'check','off'); 
		
		ix = find(value == [1,2,3,4,10,20,30,60]);
		if (~isempty(ix))
			set(tmp(ix),'check','on');
		else
			set(tmp(end),'check','on');
		end
		
	%--
	% Overlap
	%--
	
	case ('Overlap')
		
		%--
		% update userdata
		%--
		
		data.browser.page.overlap = value;
		set(h,'userdata',data);
		
		%--
		% update menus
		%--
		
		tmp = data.browser.view_menu.page_overlap;
		
		set(tmp,'check','off'); 
		
		ix = find(value == [0, 1/2, 1/4, 1/8]); % change these to the actual
		if (~isempty(ix))
			set(tmp(ix),'check','on');
		else
			set(tmp(end),'check','on');
		end
		
		%--
		% update display
		%--
		
		% this updates the browser slider properties
		
		browser_display(h,'update',data);
		
		%--
		% update controls
		%--
		
		g = control_update(h,'Navigate','Time',[],data);
	
		if (~isempty(g))
			
			%--
			% get properties of browser slider
			%--
			
			tmp = get(data.browser.slider);
			
			%--
			% update relevant control slider properties
			%--
		
			ix = find(strcmp(get(g,'style'),'slider'));
			
			set(g(ix), ...
				'value',tmp.Value, ...
				'max',tmp.Max, ...
				'sliderstep',tmp.SliderStep ...
			);
		
		end
	
	%--
	% Min Frequency
	%--
	
	% this could be used to impact the band options for a detector
	
	case ('Min Freq')
		
		%--
		% check max frequency and set down if needed
		%--
		
		nyq = data.browser.sound.samplerate / 2;
		
		freq = data.browser.page.freq;
		
		if (isempty(freq))
			freq = [0, nyq];
		end
		
		if ((value >= freq(2)) | ((freq(2) - value) < MIN_BAND))
			value = freq(2) - MIN_BAND;
			control_update(h,'Page','Min Freq',value,data);
		end
		
		%--
		% update displayed frequency
		%--
		
		freq(1) = value;
		
		data.browser.page.freq = freq;
		
		%--
		% set display flag
		%--
		
		display_flag = 0;
		
	%--
	% Max Frequency
	%--
	
	% this could be used to impact the band options for a detector
	
	case ('Max Freq')
		
		%--
		% check min frequency and set up if needed
		%--
		
		nyq = data.browser.sound.samplerate / 2;
		
		freq = data.browser.page.freq;
		
		if (isempty(freq))
			freq = [0, nyq];
		end
		
		if ((value <= freq(1)) | ((value - freq(1)) < MIN_BAND))
			value = freq(1) + MIN_BAND;
			control_update(h,'Page','Max Freq',value,data);
		end
		
		%--
		% update displayed frequency
		%--
		
		freq(2) = value;
		
		data.browser.page.freq = freq;
		
		%--
		% set display flag
		%--
		
		display_flag = 0;
		
	%---------------------------------------------------------------
	% SOUND CONTROLS
	%---------------------------------------------------------------
	
	%--
	% Rate
	%--
	
	case ('Rate')
		
		%--
		% update userdata
		%--
		
		data.browser.play.speed = value;
		
		set(h,'userdata',data);
		
		%--
		% update menus
		%--
		
		tmp = data.browser.sound_menu.play_speed;
		
		ix = find(value == [1, 1/2, 1/4, 1/8, 1/16, 1/32, 2, 4, 8, 16, 32]);
		
		set(tmp,'check','off');
		
		if (isempty(ix))
			set(tmp(end),'check','on');
		else 
			set(tmp(ix),'check','on');
		end
		
	%--
	% Play Selection
	%--
	
	case ('Selection')
		
		browser_sound_menu(h,'Play Selection');
		
	%--
	% Play Page
	%--
	
	case ('Page')
		
		browser_sound_menu(h,'Play Page');
		
	%---------------------------------------------------------------
	% SPECTROGRAM CONTROLS
	%---------------------------------------------------------------

	%--
	% FFT::Size
	%--
	
	case ('Spectrogram::Size')
		
		%--
		% update fft size
		%--
		
		data.browser.specgram.fft = value;
		
		%--
		% update menus
		%--
		
		tmp = data.browser.view_menu.fft_length;
		
		set(tmp,'check','off'); 
		
		ix = find(value == [128, 256, 512, 1024]);
		
		if (~isempty(ix))
			set(tmp(ix),'check','on');
		else
			set(tmp(end),'check','on');
		end
		
		%--
		% update time if current time plus page exceeds available sound duration
		%--
		
		T = data.browser.sound.duration;
		
		ddt = data.browser.specgram.fft / data.browser.sound.samplerate; % this has been updated
		
		if ((data.browser.time + data.browser.page.duration) >= (data.browser.sound.duration - ddt))
			data.browser.time = max(0,(T - (value + ddt))); % ensure positive value
		end
		
		%--
		% set display flag
		%--
		
		display_flag = 1;
		
		%--
		% get handle to edit box
		%--
				
		tmp = findobj(get(gcbo,'parent'),'tag','Size','style','edit');
		
		% it would be nice to warn about prime sizes or sizes with few
		% factors
		
		if (~isempty(tmp))
			set(tmp,'tooltipstring',factor_str(value));
		end
		
	%--
	% FFT::Advance (used to be called 'Hop Length')
	%--
	
	case ('Spectrogram::Advance')
		
		%--
		% update userdata
		%--
		
		data.browser.specgram.hop = value;
		
		%--
		% update menus
		%--
		
		tmp = data.browser.view_menu.hop_length;
		
		set(tmp,'check','off'); 
		
		ix = find(value == [1, 3/4, 1/2, 1/4, 1/8]);
		if (~isempty(ix))
			set(tmp(ix),'check','on');
		else
			set(tmp(end),'check','on');
		end
		
		%--
		% set display flag
		%--
		
		display_flag = 1;
				
	%--
	% Window Length
	%--
	
	case ('Spectrogram::Length')
		
		%--
		% update userdata
		%--
		
		data.browser.specgram.win_length = value;
		
		%--
		% update menus
		%--
		
% 		tmp = data.browser.view_menu.window_length;
% 		
% 		set(tmp,'check','off'); 
% 		
% 		ix = find(value == [1, 3/4, 1/2, 1/4, 1/8]);
% 		if (~isempty(ix))
% 			set(tmp(ix),'check','on');
% 		else
% 			set(tmp(end),'check','on');
% 		end
		
		%--
		% set display flag
		%--
		
		display_flag = 1;
		
	%--
	% Window Type
	%--
	
	case ('Spectrogram::Type')
		
		%--
		% check for parametrized window
		%--
		
		param = window_to_fun(value,'param');
		
		%--
		% parameter free window
		%--
		
		if (isempty(param))

			%--
			% update window type
			%--
			
			data.browser.specgram.win_type = value;
			
			%--
			% disable parameter control
			%--
			
			g = control_update(h,'Spectrogram','Parameter','__DISABLE__',data);
			
			set(findobj(g,'flat','style','slider'), ...
				'min',0, ...
				'max',1, ...
				'value',0 ...
			);
		
			set(findobj(g,'flat','style','edit'), ...
				'string',[] ...
			);
			
		%--
		% parametrized window
		%--
		
		else
		
			%--
			% update window type and parameter
			%--
			
			data.browser.specgram.win_type = value;
			
			data.browser.specgram.win_param = param.value;
			
			%--
			% enable and update parameter control
			%--
			
			control_update(h,'Spectrogram','Parameter','__ENABLE__',data);
			
			% this line also updates the edit box
			
			g = control_update(h,'Spectrogram','Parameter',param.value,data);
			
			g = findobj(g,'flat','style','slider');
			set(g, ...
				'min',param.min, ...
				'max',param.max ...
			);
						
		end
		
		% these menus no longer exist
		
% 		%--
% 		% update menus
% 		%--
% 		
% 		% window parameter editing is not available in the menu interface 
% 		% map window changes to parametrized windows to spectrogram palette
% 		
% 		tmp = data.browser.view_menu.window_type;
% 		
% 		set(tmp,'check','off'); 
% 		set(get_menu(tmp,value),'check','on');
		
		%--
		% update window plot in palette
		%--
		
		window_plot(h,pal,data);
		
		%--
		% set display flag
		%--
		
		display_flag = 1;
		
	%--
	% Window Parameter
	%--
	
	case ('Spectrogram::Parameter')
		
		%--
		% update window parameter
		%--
		
		data.browser.specgram.win_param = value;
		
		%--
		% update window plot in palette
		%--
		
		window_plot(h,pal,data);
		
		%--
		% set display flag
		%--
		
		display_flag = 1;

	%---------------------------------------------------------------
	% UNRECOGNIZED CONTROL
	%---------------------------------------------------------------
	
	otherwise
		
		% put these into some kind of log file ???
		
% 		%--
% 		% display warning
% 		%--
% 		
% 		disp(' ');
% 		warning(['Unrecognized control ''' str '''.']);
		
end

%--
% update display that may require active detection
%--

% support display depending on flag !

if (~isempty(display_flag))
	
	%--
	% perform active detection if needed
	%--
	
	% at the moment frequency display updates do not update active
	% detection
	
	if (display_flag)
		
		if (~isempty(data.browser.detector.active))
			data.browser.active_detection_log = active_detection(h,data);
		end
		
	end
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	browser_display(h,'update',data);
	
	%--
	% browser_navigation update
	%--
	
	browser_navigation_update(h,data);
	
	%--
	% update controls
	%--
	
	% this may be required during duration updating
	
	if (strcmp(str,'Duration'))
		
		g = control_update(h,'Navigate','Time',[],data);
	
		if (~isempty(g))
			
			%--
			% get properties of browser slider
			%--
			
			tmp = get(data.browser.slider);
			
			%--
			% update relevant control slider properties
			%--
		
			ix = find(strcmp(get(g,'style'),'slider'));
			
			set(g(ix), ...
				'value',tmp.Value, ...
				'max',tmp.Max, ...
				'sliderstep',tmp.SliderStep ...
			);
		
		end
		
	end
	
end
	
%--
% return pointer state to arrow
%--

set(pal,'pointer',ptr);


%-------------------------------------------------------------------------
% SHOW_NEW_LOG
%-------------------------------------------------------------------------

function show_new_log(h,pal,data)

% show_new_log - create new log for sound
% ----------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1.3 $
% $Date: 2003-11-24 21:01:27-05 $
%--------------------------------

%--
% get control information
%--

opt = get_field(get(pal,'userdata'),'opt');

%--------------------------------
% CHECK FOR EXISTING EDIT BOX
%--------------------------------

if (~isempty(findobj(pal,'style','edit','tag','New Log Edit')))
	return;
end
	
%--------------------------------
% CREATE EDIT BOX
%--------------------------------

%--
% get active log control handles
%--
		
g = control_update(h,'Log','Active',[],data);

%--
% get position of active popup
%--

tmp = findobj(g,'style','popupmenu');

units = get(tmp,'units');

set(tmp,'units','normalized');

pos = get(tmp,'position');

set(tmp,'units',units);

%--
% compute edit box and cancel positions
%--

pos(1) = pos(1) + 1/3 * pos(3);

pos(2) = pos(2) + pos(4);

pos(3) = 2/3 * pos(3);

% note position depends on the palette size due to the normalized units

fac = opt.width - (opt.left + opt.right);

fac = 1 * (3 / (2 * fac));

pos2 = pos;

pos2(1) = pos(1) + pos(3) - fac*pos(3);

pos2(3) = fac*pos(3);

% shorten edit box to accomodate confirm button

pos(3) = pos(3) - pos2(3); 

%--
% create edit control 
%--

uicontrol(pal, ...
	'style','edit', ...
	'units','normalized', ...
	'tag','New Log Edit', ...
	'background',[1 1 1], ...
	'position', pos, ...
	'horizontalalignment','left', ...
	'fontunits','pixels', ...
	'fontsize',get(tmp,'fontsize'), ...
	'string','New Log' ...
);

%--
% create confirm edit control
%--

tmp = findobj(pal,'tag','toggle');
tmp = tmp(1);

uicontrol(pal, ...
	'style','pushbutton', ...
	'units','normalized', ...
	'tag','New Log Confirm', ...
	'background',get(pal,'color'), ...
	'position', pos2, ...
	'horizontalalignment','left', ...
	'fontunits','pixels', ...
	'fontname',get(tmp,'fontname'), ...
	'fontsize',get(tmp,'fontsize') - 1, ...
	'string','+', ...
	'callback',{@handle_new_log,h,pal,data} ...
);

%--
% update button states buttons while editing
%--

control_update(h,'Log','New Log','__DISABLE__',data); 

control_update(h,'Log','Open Log ...','__DISABLE__',data); 


%-------------------------------------------------------------------------
% HANDLE_NEW_LOG
%-------------------------------------------------------------------------

function handle_new_log(obj,eventdata,h,pal,data)

% handle_new_log - handle new log control
% ---------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1.3 $
% $Date: 2003-11-24 21:01:27-05 $
%--------------------------------

%--
% get proposed log name from edit control
%--

tmp = findobj(pal,'tag','New Log Edit');

fn = deblank(get(tmp,'string'));

%--
% check button string to produce cancel
%--

if (strcmp(get(obj,'string'),'-'))
	fn = '';
end

%--
% check for empty string
%--

if (~isempty(fn))
	
	%--
	% check for proper filename
	%--
	
	if (~proper_filename(fn))
		return;
	end
	
	%--
	% get user, library, and sound information from figure tag
	%--
	
	user = get_active_user;
	
	info = parse_tag(get(h,'tag'));
	
	lib = get_libraries(user,'name',info.library);
	
	name = sound_name(data.browser.sound);
		
	%--
	% check whether a log with this name already exists
	%--
		
	logs = get_library_logs('info',lib,data.browser.sound);
		
	ix = find(strcmp(logs,[name filesep fn]));
	
	if (~isempty(ix))
		return;
	end
	
	%--
	% create new log and open
	%--

	lib_path = lib.path;
		
	str = [lib_path name filesep 'Logs'];
	
	str = [str filesep fn '.mat'];
		
	log = log_create(str,'sound',data.browser.sound,'author',get_field(user,'name'));
	
	log_open(h,str);
	
	%--
	% update XBAT palette if available
	%--
	
	xbat_palette('Sounds');
	
end
	
%--
% delete edit box and restore other control states
%--

delete([obj,tmp]);

%--
% enable buttons after save
%--

control_update(h,'Log','New Log','__ENABLE__',data);

control_update(h,'Log','Open Log ...','__ENABLE__',data);

%--
% display log options
%--

% this should only happen when creating a new log, not on cancel

if (~isempty(fn))
	palette_toggle(h,'Log','Options','open',data);
end


%-------------------------------------------------------------------------
% WINDOW_PLOT
%-------------------------------------------------------------------------

function window_plot(h,pal,data)

%--
% display window in plot axes
%--
	
g = findobj(pal,'type','axes','tag','Window_Plot');

%--
% remove previous lines
%--

delete(get(g,'children'));

%--
% draw new window line
%--

axes(g);
		
n = 512;

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

if (1)
	
	%--
	% DISPLAY WINDOW SHAPE (working)
	%--
	
	tmp = plot(y,'k');
	set(tmp,'linewidth',1);
	
	hold on;
	
	tmp = plot([1,n],[0 0],':');
	set(tmp,'color',0.5*ones(1,3));
	
	tmp = plot([1,n],[1 1],':');
	set(tmp,'color',0.5*ones(1,3));
	
	set(g, ...
		'xlim',[1,n], ...
		'ylim',[-0.1,1.1] ...
	);

else
	
	%--
	% DISPLAY FREQUENCY RESPONSE (test)
	%--
	
	[h,w] = freqz(y,1,100);
	
	h = 20*log10(abs(h)); % display in dB
	
% 	fig; 
	
	plot(w,h,'k');
	
	tmp = ylabel('dB'); % the axes should have smaller width when using labels
	
	set(tmp, ...
		'fontsize',get_field(get_palette_settings,'fontsize') + 1, ...
		'verticalalignment','middle', ...
		'rotation',90 ...
	);
	
	set(g, ...
		'xlim',[0,pi], ...
		'ylim',fast_min_max(h), ...
		'yscale','linear' ...
	);

end


%-------------------------------------------------------------------------
% POSITION_STRING
%-------------------------------------------------------------------------

function out = position_string(in)

% position_string - create and parse position strings
% ---------------------------------------------------
%
% pos = position_string(str)
% str = position_string(pos)
%
% Input:
% ------
%  str - position string representation
%  pos - position vector
%
% Output:
% -------
%  str - position string representation
%  pos - position vector

%--
% parse position string
%--

if (isstr(in))
	
	%--
	% remove matrix brackets if needed
	%--
	
	in = strrep(in,'[','');
	in = strrep(in,']','');
	
	%--
	% get tokens by separating using commas
	%--
	
	% get tokens, note we discard comma in the second loop line
	
	for k = 1:3
		[str{k},in] = strtok(in,',');
		in = in(2:end);
	end
		
	%--
	% evaluate strings to get position
	%--
	
	pos = zeros(1,3);
	
	for k = 1:3
		try
			pos(k) = eval(str{k});
		catch
			out = [];
			return;
		end 
	end
	
	%--
	% output position
	%--
	
	out = pos;
	
%--
% generate position string
%--

else
	
	%--
	% create string from matrix
	%--
	
	out = mat2str(in,5);
	
	out = out(2:(end - 1));
	
	out = strrep(out,' ',', ');
	
end

