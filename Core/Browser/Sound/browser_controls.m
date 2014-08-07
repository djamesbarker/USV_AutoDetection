function out = browser_controls(h, str, c)

% browser_controls - callbacks for browser controls
% -------------------------------------------------
%
% browser_controls(h, str, c)
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
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

% NOTE: callback object handles are provided by function handle callback framework

% NOTE: in the current palette framework the string can then be replaced by
% the tag of the callback object, this leads to a better switch

% NOTE: the switch can be broken into a separate function for each palette

% TODO: return after callback for any relevant listbox controls

%--
% get control handle if needed
%--

if (nargin < 3) || isempty(c)
	c = gcbo;
end

%----------------------------------------------------------------------
% BRAVE NEW WORLD
%----------------------------------------------------------------------

%--
% get callback context
%--

callback = get_callback_context(c, 'pack');

%--
% get parent state
%--

% NOTE: the palette extensions will take state as input and output modified state if needed

data = get(callback.par.handle, 'userdata');

%--
% dispatch palette callback to handler
%--

% NOTE: dispatch will be dynamic once palette extensions are implemented

switch lower(callback.pal.name)
	
	case 'colormap'	
		
		colormap_callback(callback, data); return;
		
	case 'grid'
		
		grid_callback(callback, data); return;
		
	case 'page'
		
		page_callback(callback, data); return;
		
	case 'spectrogram'
		
		spectrogram_callback(callback, data); return;
		
	otherwise
	
end

%----------------------------------------------------------------------

%--
% indicate control action using pointer
%--

% TODO: the watch pointer is disabled, this needs to be resolved

pal = get(c, 'parent'); % get control figure

% ptr = get(pal,'pointer');
% 
% if (strcmp(ptr,'watch'))
% 	ptr = 'arrow';
% end
% 
% set(pal,'pointer','watch');

%---------------------------------------------------------------
% SET CONSTANTS USED BY CONTROLS
%---------------------------------------------------------------

%--
% minimum band width for page display
%--

persistent MIN_BAND;

if isempty(MIN_BAND)
	MIN_BAND = 10;
end

%--
% set display flag to empty
%--

display_flag = [];

%---------------------------------------------------------------
% GET VALUE FROM CONTROL
%---------------------------------------------------------------

% NOTE: apart from the control value, there is a control action

%--
% get control style
%--

% NOTE: we need to handle axes controls separately

if strcmp(get(c, 'type'), 'uicontrol')
	
	tmp = get(c, 'style');
	
else
	
	% NOTE: axes control values are currently supported in control_update
	
	if strcmp(get(c, 'type'), 'axes')
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

		value = get(c,'value');
		
	%--
	% edit box control
	%--
	
	% NOTE: the slider edit boxes return when the string is invalid
	
	case ('edit')
		
		%--
		% try to find a matching slider for edit box
		%--
		
		g = findobj(get(c,'parent'), ...
			'style','slider', ...
			'tag',get(c,'tag') ...
		);
		
		%--
		% get value from edit box considering matching slider
		%--
		
		if (isempty(g))

			value = get(c,'string');
			
		else
			
			%--
			% consider slider type
			%--
			
			% NOTE: the slider type is stored in the slider userdata
			
			% TODO: consider storing slider type at the palette level
	
			type = get(g,'userdata');
			
			if (isempty(type))
				type = '';
			end
			
			if (~ischar(type))
				if (isstruct(type) && isfield(type,'type'))
					type = type.type;
				else
					type = '';
				end
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
					value = round(str2double(get(c,'string')));
				
				%--
				% normal slider
				%--
				
				otherwise
					value = str2double(get(c,'string'));
					
			end
							
		end
		
	%--
	% listbox
	%--
	
	case ('listbox')
	
		action = 'Selection';
		
		% NOTE: because of multiple selections make value a cell array
		
		L = get(c,'string'); ix = get(c,'value');
						
		% NOTE: is this an ugly workaround ?
		
		if (ix <= length(L))
			value = L(ix);
		else
			ix = 1; value = cell(0);
		end
		
	%--
	% popupmenu
	%--
	
	case ('popupmenu')
		
		% NOTE: only support single selection, hence value is a string
	
		L = get(c,'string'); ix = get(c,'value');
		
		value = L{ix};
		
	%--
	% checkbox
	%--
	
	case ('checkbox')
		
		% NOTE: values returned are min and max of uicontrol
		
		value = get(c,'value');
		
	%--
	% pushbutton
	%--
	
	case ('pushbutton')
		
		%--
		% try to find a matching listbox
		%--
		
		% NOTE: this approach has not been used extensively
	
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
					
					% NOTE: retrieve previously applied values stored in the cancel button userdata
					
					L = get(g,'string'); ix = get(c,'userdata');
					
					value = L(ix);
					
				case ('Apply')
					
					% NOTE: gets new values from the associated listbox
					
					L = get(g,'string'); ix = get(g,'value');
					
					value = L(ix);
					
			end
			
		%--
		% get pushbutton label as action
		%---
		
		else
			
			% NOTE: label is action for button, the button has no value
			
			action = get(c,'string');
			
		end
		
end


%---------------------------------------------------------------
% PERFORM CONTROL UPDATE AND/OR ACTION
%---------------------------------------------------------------

% HACK: remove any spaces in the command, this could lead to a problem with 'Gray'

str = strtrim(str);

switch (str)
	
	%---------------------------------------------------------------
	% EVENT CONTROLS
	%---------------------------------------------------------------
	
	%--
	% Search
	%--
	
	case 'find_events'
		
		par = callback.par; pal = callback.pal;
		
		%--
		% generate and filter event info strings
		%--
	
		if isempty(data.browser.log)
		
			S = {'(No Logs Open)'}; enable = 'off'; N = 0;
			
		else
			
			%--
			% configure string generation using control values
			%--

			opt = events_info_str;
			
			opt.order = get_control(pal.handle, 'sort_order', 'value'); 
			
			% NOTE: we extract the string from the cell and lower to normalize
			
			opt.order = lower(opt.order{1});
			
			opt.visible = get_control(pal.handle, 'visible_events_only', 'value');
			
			%--
			% generate event strings
			%--

			[S, known_tags] = events_info_str(par.handle, [], opt);
			
			%--
			% filter strings based on search pattern
			%--
			
			% NOTE: this filtering is purely on the strings
			
			% TODO: consider how to support metadata search filtering 
			
			[S, value] = filter_strings(S, value);
			
			if ~isempty(S)
			
				enable = 'on'; N = length(S);
				
			else
				
				if isempty(value)
					S = {'(No Events Available)'};
				else
					S = {'(No Events Found)'};
				end
				
				enable = 'off'; N = 0;
			
			end
			
		end
		
		%--
		% update event display control
		%--
		
		handles = get_control(pal.handle, 'event_display', 'handles');
		
		set(handles.uicontrol.text, ...
			'string', ['Events (', int2str(N), ')'] ...
		);
	
		set(handles.uicontrol.listbox, ...
			'enable', enable, ...
			'value', [], ... 
			'string', S ...
		);
		
		set(allchild(get(handles.uicontrol.listbox, 'uicontextmenu')), 'enable', enable);

		%--
		% update event tags, notes, and info control
		%--
		
		% TODO: implement these updates using set control, which needs to be finished
		
		handles = get_control(pal.handle, 'event_info', 'handles');
		
		set(handles.uicontrol.listbox, ...
			'value', [], ...
			'string', [] ...
		);
	
		handles = get_control(pal.handle, 'event_tags', 'handles');
		
		set(handles.uicontrol.edit, ...
			'string', [] ...
		);
	
		handles = get_control(pal.handle, 'event_notes', 'handles');
		
		set(handles.uicontrol.edit, ...
			'string', [] ...
		);
	
		%--
		% update enable state of event navigation buttons
		%--
		
		set_control(pal.handle, 'previous_event', 'enable', enable);
		
		set_control(pal.handle, 'next_event', 'enable', enable);
		
		set_control(pal.handle, 'previous_event2', 'enable', enable);
		
		set_control(pal.handle, 'next_event2', 'enable', enable);

	%--
	% Search
	%--
	
	case 'sort_order'
		
		update_find_events(callback.par.handle, [], data); return;
		
	%--
	% Events
	%--
		
	case 'event_display'
		
		par = callback.par; pal = callback.pal;
		
		%--
		% go to event on double click
		%--
		
		if double_click(callback.obj) && ~isempty(value)
			
			[event, log] = get_str_event(par.handle, value{1}, data);
			
			goto_event(par.handle, log, event.id); figure(pal.handle); return;
			
		end

		%--
		% on single click update event tags, notes, and info
		%--
		
		tags = get_control(pal.handle, 'event_tags', 'handles');
		
		notes = get_control(pal.handle, 'event_notes', 'handles');
		
		info = get_control(pal.handle, 'event_info', 'handles');
				
		% TODO: implement these updates using set control, which needs to be finished
		
		if length(value) > 1

			set(tags.uicontrol.edit, ...
				'string', [] ...
			);

			set_control(pal.handle, 'event_rating', 'value', 0);
			
			set(notes.uicontrol.edit, ...
				'string', [] ...
			);

			set(info.uicontrol.listbox, ...
				'value', [], ...
				'string', [] ...
			);

		else
			
			%--
			% get event from control string
			%--
			
			[event, name] = get_str_event(par.handle, value{1}, data);
		 
			% NOTE: if we fail string may be stale ... this should not happen
			
			if isempty(event)	
				update_find_events(par.handle, [], data); return; 
			end
			
			if isempty(event.rating)
				event.rating = 0;
			end
			
			%--
			% update event tags, rating, notes, and info control
			%--
			
			set(tags.uicontrol.edit, ...
				'string', tags_to_str(event.tags) ...
			);

			set_control(pal.handle, 'event_rating', 'value', event.rating);
			
			set(notes.uicontrol.edit, ...
				'string', event.notes ...
			);

			str = event_info_str(name, event, data);
			
			set(info.uicontrol.listbox, ...
				'value', [], ...
				'string', str ...
			);

			%--
			% HACK: diplay event identity in header 
			%--
			
			header_text = findobj(pal.handle, 'tag', 'header_text');
			
			ix = strmatch('Events', get(header_text, 'string'));
			
			header_text(ix) = [];
		
			set(header_text, 'string', str{1});
		
		end
		
		%--
		% return to keep focus
		%--
		
		% NOTE: we want to avoid the 'figure(pal)' call
		
		return;
		
	%--
	% visible and page events only
	%--
	
	case 'visible_events_only'

		update_find_events(callback.par.handle, [], data); return; 
	
	case 'page_events_only'
		
		% NOTE: this control is currently hidden
		
		pal = callback.pal; par = callback.par;
		
		%--
		% enforce visible selection
		%--
		
		% NOTE: this is enforced to make the fast update possible
		
		if value
			
			control_update([], pal.handle, 'visible_events_only', 1);
			
			control_update([], pal.handle, 'visible_events_only', '__DISABLE__');
			
		else
			
			control_update([], pal.handle, 'visible_events_only', '__ENABLE__');
			
		end
		
		%--
		% perform event search callback
		%--

		update_find_events(par.handle, [], data);
		
		return;
				
	%--
	% previous and next event 
	%--
	
	case {'previous_event', 'previous_event2'}
		
		par = callback.par; pal = callback.pal;
		
		goto_button('previous', par.handle, pal.handle, data);
		
		figure(pal.handle); figure(par.handle);
		
		return;
	
	case {'next_event', 'next_event2'}
		
		par = callback.par; pal = callback.pal;
		
		goto_button('next', par.handle, pal.handle, data);
		
		figure(pal.handle); figure(par.handle);
		
		return;
		
	%--
	% event tags, rating, notes, and info
	%--
	
	case 'event_tags'
	
		edit_events(callback, 'tags', value, data); return;
	
	case 'event_rating'
		
		value = get_control(callback.pal.handle, 'event_rating', 'value');
		
		edit_events(callback, 'rating', value, data); return;
	
	case 'event_notes'

		edit_events(callback, 'notes', value, data); return;
	
	case 'event_info'
		
		% NOTE: there is curently no action associated to this control
			
	%---------------------------------------------------------------
	% JOG CONTROLS
	%---------------------------------------------------------------
	
	case 'jog_toggle'
			
		%--
		% update pushbutton label string
		%--
		
		% NOTE: this clearly updates the action associated to the next push
		
		switch action
			
			%--
			% start jogging, make button stop button
			%--
			
			case 'Go', set(callback.obj, 'string', 'Stop');
				
			%--
			% stop jogging make button go button
			%--
			
			case 'Stop', set(callback.obj, 'string', 'Go');
				
			% NOTE: consider handling error condition
				
		end
		
	%---------------------------------------------------------------
	% LOG CONTROLS
	%---------------------------------------------------------------

	%--
	% Active
	%--
	
	case 'Active'
		
		%--
		% get open logs and selection index
		%--
	
		L = get_log_names(h,data);
				
		%--
		% update active log
		%--
		
		m = find(strcmp(value,L));
		
		if isempty(m)
			return;
		end
					
		data.browser.log_active = m;
		
		set(h,'userdata',data);
		
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
		% update options log display
		%--
		
		g = findobj(pal,'tag','Log','style','popupmenu');
		
		str = get(g,'string');
		ix = find(strcmp(str,value));
		
		set(g,'value',ix);
		
		%--
		% update log options controls
		%--
		
		browser_controls(h,'Log',g);
		
	%--
	% New Log
	%--
	
	case 'New Log'
		
		new_log_dialog;
		
	%--
	% Open Log
	%--
	
	case 'Open Log'

		browser_file_menu(h, 'Open Log ...');
		
	%--
	% Backup
	%--
	
	case ('Backup')
					
		%--
		% get active log name
		%--
		
		[g, value] = control_update([], pal, 'Active');
				
		%--
		% get active log from parent and backup
		%--
		
		% TODO: add some fault tolerance in case we are working in non-writeable media
		
		m = get_log_index(h, value, data);
		
		if ~isempty(m)
			log_backup(data.browser.log(m));
		end
		
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
		
					test = (length(get(c,'string')) > 1) && (length(get(c,'value')) == 1);
					
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
				
				L = get_log_names(h,data);
								
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
				% update display options for single visible log 
				%--
				
				% NOTE: log controls were named before aliases were available
				
				if (length(value) == 1)
					
					control_update([],pal,'Log',value{1});
					control_callback([],pal,'Log');
					
				end
				
				%--
				% perform search events callback if needed
				%--
				
				% TODO: place into function which also takes search string input
				
				pal = get_palette(h,'Event',data);
				
				if (~isempty(pal))
					
					%--
					% check value of visible control
					%--
					
					[ignore,visible] = control_update([],pal,'visible_events_only');
					
					%--
					% perform event search callback if needed
					%--
					
					if (visible)
						update_find_events(h,[],data);
					end
					
				end
				
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
	
	% TODO: this code should be called when a new log is loaded
	
	case ('Log')
		
		%--
		% get index of log selected
		%--
				
		[m,L] = get_log_index(h,value,data);
		
		if (isempty(m))
			return;
		end
		
		%--
		% update other controls (this controls only controls other controls
		%--
		
		tmp = data.browser.log(m);
		
		name = L{m};
		
		% COLOR
		g = control_update(h,'Log','Color',rgb_to_color(tmp.color),data);
		
		set(findobj(g,'style','popupmenu'), ...
			'tooltipstring',['Color for ''' name ''' event display'] ...
		);
		
		% LINE STYLE
		g = control_update(h,'Log','Line Style',lt_to_linestyle(tmp.linestyle,'strict'),data);
		
		set(findobj(g,'style','popupmenu'), ...
			'tooltipstring',['Line style for ''' name ''' event display'] ...
		);
		
		% LINE WIDTH
		g = control_update(h,'Log','Line Width',tmp.linewidth,data);
		
		set(findobj(g,'style','slider'), ...
			'tooltipstring',['Line width for ''' name ''' event display'] ...
		);
		
		% OPACITY
		g = control_update(h,'Log','Opacity',tmp.patch,data);
		
		set(findobj(g,'style','slider'), ...
			'tooltipstring',['Opacity level for ''' name ''' event display'] ...
		);
	
		% ID
		g = control_update(h,'Log','event_id',tmp.event_id,data);
		
		set(findobj(g,'style','checkbox'), ...
			'tooltipstring',['State of ''', name, ''' event ID display'] ...
		);
			
	%--
	% Color
	%--
	
	case ('Color')
		
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
		
	%--
	% Line Style
	%--
	
	case ('Line Style')
		
		%--
		% get index of log to update
		%--
		
		[g,name] = control_update(h,'Log','Log',[],data);
		
		m = get_log_index(h,name,data);
		
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
		ix = find(strcmp(get(tmp,'tag'),name));
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
		
		[g,name] = control_update(h,'Log','Log',[],data);
		
		m = get_log_index(h,name,data);
		
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
		ix = find(strcmp(get(tmp,'tag'),name));
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
		
		[g,name] = control_update(h,'Log','Log',[],data);
		
		m = get_log_index(h,name,data);
		
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
% 		ix = find(strcmp(get(tmp,'tag'),name));
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
		
	%--
	% ID
	%--
	
	case 'event_id'
		
		%--
		% get index of log to update
		%--
		
		[g, name] = control_update(h, 'Log', 'Log', [], data);
		
		m = get_log_index(h, name, data);
		
		%--
		% update userdata
		%--
		
		data.browser.log(m).event_id = value;
		
		set(h, 'userdata', data);
		
		%--
		% update display
		%--
		
		browser_display(h, 'events', data);
		
	%---------------------------------------------------------------
	% NAVIGATE CONTROLS
	%---------------------------------------------------------------
	
	case 'Time'
	
		% NOTE: the 'time' slider is watched by the scrolling_daemon and
		% thus requires no explicit callback!

	case 'File'

		browser_view_menu(h, value);

	case 'Prev File'

		out = browser_view_menu(h, 'Previous File');
		
	case 'Next File'
		
		out = browser_view_menu(h, 'Next File');
		
	% FIXME: it's about time views come back
	
	case 'Prev View'
		
		browser_view_menu(h, 'Previous View');
		
	case 'Next View'
		
		browser_view_menu(h, 'Next View');
		
	case 'time_stamp'
		
		pal = get_palette(h, 'Navigate', data);
		
		ix = get_control(pal, 'time_stamp', 'index');
		
		%--
		% get session boundaries in real time
		%--
		
		sessions = get_sound_sessions(data.browser.sound, 0);
		
		time = map_time( ...
			data.browser.sound, 'slider', 'real', sessions(ix).start ...
		);
	
		set_time_slider(h, 'value', time);
		
	case 'Prev Time-Stamp'
		
		sessions = get_sound_sessions(data.browser.sound, 0);
		
		ix = get_current_session(data.browser.sound);
		
		time = map_time( ...
			data.browser.sound, 'slider', 'real', sessions(ix - 1).start ...
		);
	
		set_time_slider(h, 'value', time);
		
	case 'Next Time-Stamp'
		
		sessions = get_sound_sessions(data.browser.sound, 0);

		ix = get_current_session(data.browser.sound);
		
		time = map_time( ...
			data.browser.sound, 'slider', 'real', sessions(ix + 1).start ...
		);
	
		set_time_slider(h, 'value', time);		
		
		
	%---------------------------------------------------------------
	% SOUND CONTROLS
	%---------------------------------------------------------------
	
	%--
	% Rate
	%--
	
	case {'Rate', '1/2x', 'natural', '2x'}
		
		%--
		% update userdata
		%--
		
		switch str

			case '1/2x'
				value = 0.5 * data.browser.play.speed;
				
			case 'natural'
				value = 1;
				
			case '2x' 
				value = 2 * data.browser.play.speed;
		end
	
		% TODO: 'set_control' returns a 'control', but with a stale value
		
		set_control(pal, 'Rate', 'value', value);
	
		% NOTE: we do this because controls constraints implement value constraints
		
		control = get_control(pal, 'Rate');
		
		data.browser.play.speed = control.value;
		
		set(h, 'userdata', data);
		
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
		
	case 'band_filter'
		
		data.browser.play.band_filter = value;
		
		set(h, 'userdata', data);
		
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
	% SELECTION CONTROLS
	%---------------------------------------------------------------

	%--
	% Grid, Control Points
	%--
	
	case ({'selection_grid','selection_labels','control_points','selection_zoom'})
		
		%--
		% update userdata and menu
		%--
		
		% NOTE: the updates performed by these controls do not use the menu callback
		
		data = get(h,'userdata');
		
		switch (str)
			
			case ('selection_grid')
				
				data.browser.selection.grid = value;
				set(get_menu(h,'Grid'),'check',bin2str(value));
				
			case ('selection_labels')
				
				data.browser.selection.label = value;
				set(get_menu(h,'Labels'),'check',bin2str(value));
				
			case ('control_points')
				
				data.browser.selection.control = value;
				set(get_menu(h,'Control Points'),'check',bin2str(value));
				
			case ('selection_zoom')
				data.browser.selection.zoom = value;
				set(get_menu(h,'Selection Zoom'),'check',bin2str(value));
				
		end
		
		set(h,'userdata',data);
			
		%--
		% update selection display if needed
		%--
				
		selection_update(h, data);
		
	%--
	% UNRECOGNIZED CONTROL
	%--
	
	% NOTE: consider some kind of message
	
	otherwise, return;
		
end

%--
% update spectrogram parameters if needed
%--

data = get_browser(callback.par.handle);

data = update_specgram_param(callback.par.handle, data, 1);

%--
% update display that may require active detection
%--

% NOTE: support display depending on flag

if ~isempty(display_flag)
	
	%--
	% perform active detection if needed
	%--
	
	% NOTE: at the moment frequency display updates do not update active detection
	
	if display_flag
		
		if ~isempty(data.browser.sound_detector.active)
			data.browser.active_detection_log = active_detection(h, data);
		end
		
	end
	
	set(h, 'userdata', data);
	
	%--
	% update display
	%--
	
	browser_display(h, 'update', data);
	
	%--
	% browser_navigation update
	%--
	
	browser_navigation_update(h, data);
	
	%--
	% update controls
	%--
	
	% NOTE: this may be required during duration updating
	
	if strcmp(str, 'Duration')
		
		g = control_update(h,'Navigate','Time',[],data);
	
		if ~isempty(g)
			
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
% update selection display if needed
%--

selection_update(h, data);

%--
% return pointer state to arrow
%--

% set(pal,'pointer',ptr);

%--
% make palette current figure
%--

% TODO: this is an unresolved problem, the exception to protect the hack

% NOTE: after callback, the control has system focus and the parent does not handle keystrokes

% NOTE: we want to reset focus to the parent figure and provide smooth keystroke handoff
%
% NOTE: a known exception to the above concerns listboxes, these should
% keep focus after selection (single click) to allow scrollwheel scrolling

try
	figure(pal);
end

%-----------------------------------------------------
% GET_LOG_NAMES
%-----------------------------------------------------

function L = get_log_names(h, data)

% get_log_names - get index ordered list of log names
% ---------------------------------------------------
%
% L = get_log_names(h, data)
%
% Input:
% ------
%  h - figure handle
%  data - userdata
%
% Output:
% -------
%  L - index ordered list of log names

% NOTE: this function allows for either input to be empty, not both

%--
% get userdata if needed
%--

if (nargin < 2) || isempty(data)
	data = get(h, 'userdata');
end

%--
% get index-ordered list of log names
%--

L = file_ext(struct_field(data.browser.log, 'file'));


%-----------------------------------------------------
% GET_LOG_INDEX
%-----------------------------------------------------

function [m, L] = get_log_index(h, str, data)

% get_log_index - get browser index of log by name
% ------------------------------------------------
% 
% [m, L] = get_log_index(h, str, data)
%
% Input:
% ------
%  h - figure handle
%  str - log name
%  data - userdata
%
% Output:
% -------
%  m - options log index
%  L - index ordered list of log names

% NOTE: this function only needs the handle when the missing later arguments

%--
% get userdata if needed
%--

if (nargin < 3) || isempty(data)
	data = get(h, 'userdata');
end

%--
% get log name from options log control 
%--

if (nargin < 2) || isempty(str)
	
	pal = get_palette(h, 'Log', data);

	% NOTE: if the name is not provided we must get it from palette
	
	if isempty(pal)
		m = []; return;
	end
	
	[ignore, name] = control_update([], pal, 'Log', [], data);
	
end

%--
% get index ordered list of log names
%--

L = get_log_names(h, data);

%--
% find specified name in list and return index
%--

m = find(strcmp(L, str));
		
		


%-----------------------------------------------------
% POSITION_STRING
%-----------------------------------------------------

function out = position_string(in)

% position_string - create and parse position strings
% ---------------------------------------------------
%
% pos = position_string(str)
%
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

if ischar(in)
	
	%--
	% remove matrix brackets if needed
	%--
	
	in = strrep(in, '[', ''); in = strrep(in, ']', '');
	
	%--
	% get tokens by separating using commas
	%--
	
	% get tokens, note we discard comma in the second loop line
	
	for k = 1:3
		[str{k}, in] = strtok(in, ','); in = in(2:end);
	end
		
	%--
	% evaluate strings to get position
	%--
	
	pos = zeros(1, 3);
	
	for k = 1:3
		try
			pos(k) = eval(str{k});
		catch
			out = []; return;
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

%-----------------------------------------------------
% MOVE_TO_EVENT
%-----------------------------------------------------

function goto_button(move, h, pal, data)

% goto_button - previous and next event button callbacks
% ------------------------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

%--
% get event display listboc information
%--

g = findobj(control_update([],pal,'event_display',[],data), ...
	'flat', ...
	'style','listbox' ...
);

S = get(g, 'string');

ix = get(g, 'value');

%--
% update event display listbox
%--

switch move
	
	case 'previous'
		
		if ix == 1
			return;
		end

		if isempty(ix)
			ix = 1;
		else
			ix = ix - 1;
		end
		
	case 'next'
		
		if ix == length(S)
			return;
		end

		if isempty(ix)
			ix = 1;
		else
			ix = ix + 1;
		end
		
end

set(g, ...
	'value', ix, 'listboxtop', ix ...
);

%--
% create info string for event
%--

% NOTE: that value is not a string but a cell array

[event, name] = get_str_event(h, S{ix}, data);

info = event_info_str(name, event, data);

%--
% update event info control
%--

g = findobj(control_update([],pal,'event_info',[],data), ...
	'flat', ...
	'style','listbox' ...
);

set(g,'string',info,'value',[]);

%--
% make event selection
%--

goto_event(h, name, event.id, data); 


%------------------------------------------------------------
% NORMAL_NAME
%------------------------------------------------------------

function name = normal_name(name)

% NOTE: names should be valid variable names, this simple test is temporary

name = strrep(lower(strtrim(name)), ' ', '_');


%------------------------------------------------------------
% NORMAL_VALUE
%------------------------------------------------------------

function value = normal_value(value)

% NOTE: this should not happen for listbox control

if iscellstr(value) && (length(value) == 1)
	value = value{1};
end

if ischar(value)
	value = lower(value);
end


%------------------------------------------------------------
% COLORMAP_CALLBACK
%------------------------------------------------------------

function [result, data] = colormap_callback(callback, data)

% colormap_callback - callbacks for colormap palette controls
% -----------------------------------------------------------
%
% [result, data] = colormap_callback(callback, data)
%
% Input:
% ------
%  callback - callback context
%  data - initial state
%
% Output:
% -------
%  result - result and requests
%  data - updated state

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

result = [];

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% unpack callback
%--

control = callback.control; pal = callback.pal; par = callback.par;

%--
% handle simpler colorbar callback
%--

if strcmpi(control.name, 'colorbar')
	browser_view_menu(par.handle, 'Colorbar'); return;
end

%--
% get parent state
%--

if nargin < 2
	data = get(par.handle, 'userdata');
end

%---------------------------
% PERFORM CALLBACKS
%---------------------------

%--
% get control state
%--

value = get_control(pal.handle, control.name, 'value');

%--
% normalize name and value
%--

% TODO: follow naming conventions so we can get rid of this code

control.name = normal_name(control.name);

switch control.name
	
	case 'colormap', control.name = 'name';	
		
end

value = normal_value(value);

%--
% use naming conventions to update parent state
%--

% NOTE: palette name is parent field, control name is value field

data.browser.colormap.(control.name) = value; 

%--
% update interface elements
%--

switch control.name

	case 'auto_scale'

		%--
		% menu update
		%--
		
		set(get_menu(par.handle, 'Auto Scale'), 'check', bin2str(value));

		%--
		% palette update
		%--
		
		set_control(pal.handle, 'Brightness', 'enable', ~value);
		
		set_control(pal.handle, 'Contrast', 'enable', ~value);
		
		if ~data.browser.colormap.contrast
			set_control(pal.handle, 'Brightness', 'enable', 0);
		end
	
	case 'contrast'

		%--
		% palette update
		%--
		
		set_control(pal.handle, 'Brightness', 'enable', value);
			
end

%--
% store updated parent state
%--

set(par.handle, 'userdata', data);

%--
% update colormap display
%--

browser_view_menu(par.handle, data.browser.colormap.name);


%------------------------------------------------------------
% SPECTROGRAM_CALLBACK
%------------------------------------------------------------

function spectrogram_callback(callback, data)

% spectrogram_callback - callbacks for spectrogram palette controls
% -----------------------------------------------------------------
%
% spectrogram_callback(callback, data)
%
% Input:
% ------
%  callback - callback context

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% unpack callback
%--

control = callback.control; pal = callback.pal; par = callback.par;

%--
% get parent state if needed
%--

if nargin < 2
	data = get(par.handle, 'userdata');
end

%---------------------------
% PERFORM CALLBACKS
%---------------------------

%--
% get control state
%--

% NOTE: the callback control is not as rich as the get control

value = get_control(pal.handle,control.name,'value');

handles = get_control(pal.handle,control.name,'handles');

%--
% enforce naming and value conventions
%--

% TODO: follow naming conventions so we can get rid of this code

control.name = normal_name(control.name);

value = normal_value(value);

switch (control.name)
	
	case ('size'), control.name = 'fft'; value = round(value);
	
	case ('advance'), control.name = 'hop';
		
	case ('length'), control.name = 'win_length';
		
	case ('type'), control.name = 'win_type';
		
	case ('parameter'), control.name = 'win_param';
		
end

%--
% use naming conventions to update parent state
%--

% NOTE: this duplication needs to be removed throughout

data.browser.specgram.(control.name) = value;

data.browser.sound.specgram.(control.name) = value;

%--
% update interface elements
%--

switch control.name

	case 'fft'
		
		%--
		% menu update
		%--

		ch = get(get_menu(par.handle, 'FFT Size'), 'children');

		set(ch, 'check', 'off');

		ix = find(value == [128, 256, 512, 1024]);

		if ~isempty(ix)
			set(ch(ix), 'check', 'on');
		else
			set(ch(end), 'check', 'on');
		end

		%--
		% update page time
		%--

		% NOTE: this should not be neccesary, only page duration should affect this
		
		T = data.browser.sound.duration;

		ddt = data.browser.specgram.fft / data.browser.sound.samplerate; % this has been updated

		if (data.browser.time + data.browser.page.duration) >= (data.browser.sound.duration - ddt)
			
			data.browser.time = max(0, (T - (value + ddt))); % ensure positive value
			
		end
		
		%--
		% display fft size factorization
		%--

		if handles.uicontrol.edit
			
			set(handles.uicontrol.edit, ...
				'tooltipstring', factor_str(value) ...
			);
		
		end

	case ('hop_auto')
		
		%--
		% palette update
		%--

		set_control(pal.handle,'Advance','enable',~value);

	case ('advance')

		%--
		% menu update
		%--
		
		ch = get(get_menu(par.handle,'FFT Advance'),'children');

		set(ch,'check','off');

		ix = find(value == [1, 3/4, 1/2, 1/4, 1/8]);
		
		if (~isempty(ix))
			set(ch(ix),'check','on');
		else
			set(ch(end),'check','on');
		end

	case ('sum_auto')

		%--
		% palette update
		%--

		set_control(pal.handle,'sum_length','enable',~value);

	case ('win_type')

		%--
		% palette update
		%--

		% NOTE: check for parametrized window and update parameter value
		% and control
		
		param = window_to_fun(value,'param');

		if (isempty(param))

			%--
			% no parameter window
			%--
			
			% update control
			
			g = control_update([],pal.handle,'Parameter','__DISABLE__');

			set(findobj(g,'flat','style','slider'), ...
				'min',0, ...
				'max',1, ...
				'value',0 ...
			);

			set(findobj(g,'flat','style','edit'), ...
				'string',[] ...
			);

		else

			%--
			% parametrized window
			%--
			
			% update state
			
			data.browser.specgram.win_param = param.value;

			data.browser.sound.specgram.win_param = param.value;

			% update control

			set_control(pal.handle,'Parameter','enable',1);
			
			handles = get_control(pal.handle, 'Parameter', 'handles');
			
			set(handles.uicontrol.slider, 'min', param.min, 'max', param.max);
			
			set_control(pal.handle, 'Parameter', 'value', param.value);

		end

end

% NOTE: for palette extensions we get callback and state, then output updated state and display request

update_state_and_display(callback.par.handle, data);


%------------------------------------------------------------
% PAGE_CALLBACK
%------------------------------------------------------------

function page_callback(callback, data)

% page_callback - callbacks for page palette controls
% ---------------------------------------------------
%
% page_callback(callback, data)
%
% Input:
% ------
%  callback - callback context
%  data - parent state

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

%---------------------------
% SETUP
%---------------------------

%--
% minimum band width for page display
%--

persistent MIN_BAND;

if isempty(MIN_BAND)
	MIN_BAND = 10;
end

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% unpack callback
%--

control = callback.control; pal = callback.pal; par = callback.par;

%--
% get parent state if needed
%--

if nargin < 2
	data = get_browser(par.handle);
end

%---------------------------
% PERFORM CALLBACKS
%---------------------------

%--
% get callback control state
%--

% NOTE: the callback control is not as rich as the get control

value = get_control(pal.handle, control.name, 'value');

handles = get_control(pal.handle, control.name, 'handles');

%--
% enforce naming and value conventions
%--

% TODO: follow naming conventions so we can get rid of this code

control.name = normal_name(control.name);

switch control.name
	
	otherwise
		
end

value = normal_value(value);

%--
% update interface elements
%--

% NOTE: at the moment this code is the same as in the origical callback

switch control.name

	%--
	% channel display and order
	%--
	
	case 'channels'

		enable_channels_buttons(pal,1);
		
		%--
		% turn on distance order for single selection 
		%--
		
		% NOTE: find menu using label in listbox context menu children
		
		% TODO: allow get menu to work on tag, tag distance menu
		
% 		distance = get_menu( ...
% 			context_menu(handles.uicontrol.listbox), 'Distance to Channel Order' ...
% 		);
		
		g = control_update(par.handle,'Page','Channels',[],data);

		g = findobj(g,'flat','style','listbox');

		tmp = get_menu(get(g,'uicontextmenu'),'Distance to Channel Order');

		if (length(get(g,'value')) == 1)
			set(tmp,'enable','on');
		else
			set(tmp,'enable','off');
		end
		
		return;
		
		
	case {'up','down','top','bottom','swap'}

		enable_channels_buttons(pal,1);
		
		% NOTE: channel display and order are stored in the listbox until apply or cancel

		%--
		% get associated control handles
		%--

		g = control_update(par.handle,'Page','Channels',[],data);

		g = findobj(g,'flat','style','listbox');

		%--
		% get channel matrix corresponding to control display
		%--

		C = channel_strings(get(g,'string'),get(g,'value'));

		%--
		% update channel matrix
		%--

		if strcmp(control.name, 'swap')

			C = flipud(C); ix = find(C(:,2));

		else

			ch = find(C(:,2) == 1); ch = C(ch,1);

			[C,ix] = channel_matrix_update(C,lower(control.name),ch);

		end

		%--
		% update control
		%--

		set(g,'string',channel_strings(C),'value',ix);
		
		return;
		

	case ('channels_apply')

		enable_channels_buttons(pal,0);
		
		%--
		% get associated control handles
		%--

		g = control_update(par.handle,'Page','Channels',[],data);

		g = findobj(g,'flat','style','listbox');

		%--
		% get channel matrix corresponding to control display
		%--

		C = channel_strings(get(g,'string'),get(g,'value'));

		%--
		% update userdata and apply channel selection
		%--

		data.browser.channels = C;
		

	case ('channels_cancel')

		enable_channels_buttons(pal,0);

		%--
		% get associated control handles
		%--

		g = control_update(par.handle,'Page','Channels',[],data);

		g = findobj(g,'flat','style','listbox');

		%--
		% get channel metrix from browser and update control
		%--

		[L,value] = channel_strings(data.browser.channels);

		set(g,'string',L,'value',value);
		
		return;
		

	case ('geometry_plot')

		%--
		% plot channel geometry
		%--
		
		geometry_plot(get_geometry(data.browser.sound), pal.handle);
		
		return;

		
	case ('display_map')
		
		%--
		% display map
		%--
		
		geometry_map(data.browser.sound.geometry);
		
		return;
		
		
	case ('select_channel')

		%--
		% get channel from control
		%--

		[ignore,value] = strtok(value,' ');

		value = eval(value);

		%--
		% get position and calibration
		%--

		if ~isempty(data.browser.sound.geometry)

			%--
			% update 'Position' control
			%--
			
			geometry = get_geometry(data.browser.sound);
			
			pos = geometry(value,:);

			handles = get_control(pal.handle, 'Position', 'handles');

			set(handles.uicontrol.edit, 'string', mat2str(pos, 4));	

		end

		if isempty(data.browser.sound.calibration)

			data.browser.sound.calibration = zeros(data.browser.sound.channels,1);
			
			set(par.handle,'userdata',data);

		end

		%--
		% update 'Geometry_Plot' display
		%--

		tmp = overobj('axes');

		if ((isempty(tmp) || ~strcmp(get(tmp,'tag'),'Geometry_Plot')))

			g = findobj(pal.handle,'tag','Geometry_Plot','type','axes');

			geometry_plot(get_geometry(data.browser.sound), pal.handle, g);

		end		
		
		return;
		
	%--
	% page time duration, overlap fraction, and size in time slices
	%--
	
	case 'duration'
		
		set_browser_duration(par.handle, value, data); return;
		
	case ('overlap')

		%--
		% update userdata
		%--

		data.browser.page.overlap = value;
		
		set(par.handle,'userdata',data);

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

		% NOTE: the slider properties update should be done more
		% economically

		% this updates the browser slider properties

		% NOTE: this update happens anyway during "update_state_and_display"
		
% 		browser_display(par.handle,'update',data);

		%--
		% update controls
		%--

		% FIXME: we update browser time slider through it's set

		% NOTE: here we check the time slider and update it as well

		g = control_update(par.handle,'Navigate','Time',[],data);

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
		
	case ('size')

		var = ['specgram_size_' md5(callback.par.tag)];

		specgram_size = get_env(var);

		if (isempty(specgram_size)) || (value ~= specgram_size)
			set_env(var,value);
		end

	%--
	% page frequency bounds
	%--

	case ({'min_freq','max_freq'})

		%--
		% get relevant state
		%--

		nyq = get_sound_rate(data.browser.sound) / 2;

		freq = data.browser.page.freq;

		if (isempty(freq))
			freq = [0, nyq];
		end

		%--
		% enforce band constraints
		%--
		
		% TODO: simplify this code
		
		switch (control.name)
			
			case ('min_freq')

				if ((value >= freq(2)) || ((freq(2) - value) < MIN_BAND))
					value = freq(2) - MIN_BAND;
					control_update(par.handle,'Page','Min Freq',value,data);
				end

				freq(1) = value;

			case ('max_freq')

				if ((value <= freq(1)) || ((value - freq(1)) < MIN_BAND))
					value = freq(1) + MIN_BAND;
					control_update(par.handle,'Page','Max Freq',value,data);
				end

				freq(2) = value;

		end
		
		%--
		% update frequency bounds
		%--

		data.browser.page.freq = freq;

end

% NOTE: for palette extensions we get callback and state, then output state
% and display request

update_state_and_display(callback.par.handle, data);


%------------------------------------------------------------
% ENABLE_CHANNELS_BUTTONS
%------------------------------------------------------------

function enable_channels_buttons(pal, state)

set_control(pal.handle,'channels_apply','enable',state);
		
set_control(pal.handle,'channels_cancel','enable',state);


%------------------------------------------------------------
% GRID_CALLBACK
%------------------------------------------------------------

function result = grid_callback(callback, data)

result = [];

%--
% handle input
%--

control = callback.control; pal = callback.pal; par = callback.par;

if nargin < 2
	data = get_browser(par.handle);
end

%--
% get parent state and control value
%--

value = get_control(pal.handle,control.name,'value');

%--
% perform callback based on control name
%--

switch callback.control.name

	case 'Color'

		browser_view_menu(par.handle, value);

	case {'Time Grid', 'Freq Grid', 'File Grid', 'Session Grid'} 

		browser_view_menu(par.handle, control.name);		
		
	case 'file_label'
		
		data.browser.grid.file.labels = value;
		
		set(par.handle, 'userdata', data);

		browser_display(par.handle, 'update', data);		
	
	case 'session_label'
		
		data.browser.grid.session.labels = value;
		
		set(par.handle, 'userdata', data);

		browser_display(par.handle, 'update', data);		
		
	case 'Freq Spacing'

		data.browser.grid.freq.spacing = value;
		
		set(par.handle, 'userdata', data);

		browser_display(par.handle, 'update', data);

	case 'Freq Labels'

		browser_view_menu(par.handle, value);
	
	case 'Time Spacing'

		data.browser.grid.time.spacing = value;
		
		set(par.handle, 'userdata', data);

		browser_display(par.handle, 'update', data);

	case 'Time Labels'

		browser_view_menu(par.handle, value);

		%--
		% update controls
		%--

		% get handles of time control

		g = control_update(par.handle,'Navigate','Time',[],data);
		
		g = [];

		if ~isempty(g)

			%--
			% get indices of slider and edit box handles
			%--

			tmp = get(g,'style');

			ix1 = find(strcmp(tmp,'slider'));
			ix2 = find(strcmp(tmp,'edit'));

			%--
			% update type of slider in slider userdata and update callback
			%--
			
			switch (value{1})

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

			control_update(par.handle,'Navigate','Time',data.browser.time,data);

		end
		
end

value = get_control(pal.handle, 'Session Grid', 'value');

set_control(pal.handle, 'session_label', 'enable', value);	

value = get_control(pal.handle, 'File Grid', 'value');

set_control(pal.handle, 'file_label', 'enable', value);

%--------------------------------------------
% EDIT_EVENTS
%--------------------------------------------

function n = edit_events(callback, field, value, data)

% edit_events - update events using the event palette
% ---------------------------------------------------
%
% n = edit_events(callback, field, value, data)
%
% Input:
% ------
%  callback - callback context
%  field - update field
%  value - field value
%  data - parent state
%
% Output:
% -------
%  n - number of events updated

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% check field
%--

fields = {'tags', 'rating', 'notes'};

if ~ismember(field, fields)
	n = 0; return;
end

%--
% get parent state if needed
%--

if (nargin < 4) || isempty(data)
	data = get_browser(callback.par.handle);
end

%--------------------------
% SETUP
%--------------------------

%--
% unpack callback
%--

par = callback.par; pal = callback.pal;

%--
% get selected events
%--

control = get_control(pal.handle, 'event_display');

if isempty(control.value)
	n = 0; return;
end

%--------------------------
% UPDATE EVENTS
%--------------------------

for k = 1:length(control.value)
	
	%--
	% get event from events string
	%--

	[event, ignore, m, ix] = get_str_event(par.handle, control.value{k}, data);
	
	%--
	% edit event
	%--
	
	switch field

		% NOTE: it is cumbersome to have to convert the string to tags here
		
		case 'tags', event = set_tags(event, str_to_tags(value));
			
		case 'notes', event.notes = value;
	
		case 'rating', event.rating = value;

	end
	
	%--
	% store event
	%--
	
	event.modified = now;

	data.browser.log(m).event(ix) = event;

end

%--
% update browser state
%--

set(par.handle, 'userdata', data);

%--
% update event display
%--

% PALETTE

% TODO: consider integrating this code into 'update_find_events'

box = control.handles.uicontrol.listbox; prop = get(box);

update_find_events(par.handle, [], data);

% NOTE: this tries to keep the listbox display from changing

if length(prop.String) == length(get(box, 'string'))
	
	set(box, ...
		'listboxtop', prop.ListboxTop, 'value', prop.Value ...
	);

	handles = get_control(pal.handle, 'event_display', 'handles');
	
	browser_controls(par.handle, 'event_display', handles.uicontrol.listbox);
	
end

% BROWSER

sel = get_browser_selection(par.handle, data);

browser_display(par.handle, 'events', data);

if ~isempty(sel.event)
	set_browser_selection(par.handle, sel.event, sel.log);
end

	
