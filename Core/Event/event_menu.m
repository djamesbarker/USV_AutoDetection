function event_menu(g,str,h,m,ix)

% event_menu - menu for displayed events
% --------------------------------------
%
% event_menu(g,str,h,m,ix)
%
% Input:
% ------
%  g - handle to parent
%  str - command string
%  h - handle to browser figure (def: gcf)
%  m - log index (def: saved in parent tag)
%  ix - event index (def: saved in parent tag)

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
% $Revision: 1160 $
% $Date: 2005-07-05 14:55:22 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

%------------------------------------------------------------------
% HANDLE INPUT
%------------------------------------------------------------------

%--
% set command string
%--

if (nargin < 2) || isempty(str)
	str = 'Initialize';
end

%--
% set figure and get userdata
%--

if (nargin < 3) || isempty(h)
	h = gcf;
end

data = get(h, 'userdata');

%-- 
% set mode and parent if needed
%--

if isempty(data.browser.parent)
	mode = 'sound';
else
	mode = 'log'; parent = get(data.browser.parent, 'userdata');
end

%--
% get available annotations and measurements
%--

[ANNOT,ANNOT_NAME] = get_annotations;

[MEAS,MEAS_NAME] = get_measurements(h);

%------------------------------------------------------------------
% MAIN SWITCH
%------------------------------------------------------------------

switch (str)

%------------------------------------------------------------------
% Initialize
%------------------------------------------------------------------

case ('Initialize')
	
    %--
	% get log and event indices from parent tag as address 'm.ix'
	%--

	if (nargin < 5)
		
		[m,ix] = strtok(get(g,'tag'),'.');
		
		m = str2double(m);
		ix = str2double(ix(2:end));
		
	end
	
	%--
	% get event stucture and log file name
	%--

	if (strcmp(mode,'sound'))
		
		event = data.browser.log(m).event(ix);
		file = data.browser.log(m).file;	
		
	else
		
		event = parent.browser.log(m).event(ix);
		file = parent.browser.log(m).file;
		
	end
	
    %--
    % Event
    %--
		
	tmp = findstr(file,'.');
	
	file = file(1:tmp(end) - 1);
	
	%--
	% sound browser mode
	%--
	
	if (strcmp(mode,'sound'))
		
		if (length(data.browser.log) == 1)
		
			L = { ...
				[file ' # ' int2str(event.id)], ...
				'Event', ...
				'Hierarchy', ...
				'Annotation', ...
				'Measure', ...
				'Template', ...
				'Play Event', ...
				'Center Event', ...
				'Cut Selection', ...
				'Copy Selection', ...
				'Delete Selection', ...
				'Delete Event ...' ...
			};
		
			n = length(L);
				
			S = bin2str(zeros(1,n));
			S{2} = 'on';
			S{4} = 'on';
			S{7} = 'on';
			S{9} = 'on';
			S{end} = 'on';
			
		else
			
			L = { ...
				[file ' # ' int2str(event.id)], ...
				'Event', ...
				'Hierarchy', ...
				'Annotation', ...
				'Measure', ...
				'Template', ...
				'Play Event', ...
				'Center Event', ...
				'Copy Event To', ...
				'Cut Selection', ...
				'Copy Selection', ...
				'Delete Selection', ...
				'Delete Event ...' ...
			};
		
			n = length(L);
				
			S = bin2str(zeros(1,n));
			S{2} = 'on';
			S{4} = 'on';
			S{7} = 'on';
			S{10} = 'on';
			S{end} = 'on';
				
		end
		
% 		disp('we are in browser mode');
		
	%--
	% log browser mode
	%--
	
	else
		
% 		disp('we are in log_browser mode');
		
		L = { ...
			[file ' # ' int2str(event.id)], ...
			'Event', ...
			'Hierarchy', ...
			'Annotation', ...
			'Measure', ...
			'Template', ...
			'View in Sound', ...
			'Play Event', ...
			'Play Clip', ...
			'Delete Event ...' ...
		};
				
		%--
		% add option to add event to other logs
		%--
				
		if (length(parent.browser.log) > 1)
			
			L{9} = 'Copy Event To';
			L{10} = 'Delete Event ...';
			
			n = length(L);
			
			S = bin2str(zeros(1,n));
			S{2} = 'on';
			S{4} = 'on';
			S{7} = 'on';
			S{end} = 'on';
						
		else
		
			n = length(L);
			
			S = bin2str(zeros(1,n));
			S{2} = 'on';
			S{4} = 'on';
			S{7} = 'on';
			S{end} = 'on';
						
		end
		
	end
	
	%--
	% attach event menu to parent (typically 'uicontextmenu')
	%--
	
	h1 = menu_group(g,'event_menu',L,S); 
	
	%--
	% set callbacks to other functions
	%--
	
	set(h1(1),'callback','');
	
	set(get_menu(h1,'Cut Selection'), ... 
		'callback', 'browser_edit_menu(gcf,''Cut Selection'')' ...
	);

	set(get_menu(h1,'Copy Selection'), ...
		'callback', 'browser_edit_menu(gcf,''Copy Selection'')' ...
	);

	set(get_menu(h1,'Delete Selection'), ...
		'callback', 'browser_edit_menu(gcf,''Delete Selection'')' ...
	);
	
	%--
	% Event
	%--
	
% 	%--
% 	% create time and frequency bound strings
% 	%--
% 	
% 	gopt = data.browser.grid;
% 	
% 	if (strcmp(mode,'sound'))
% 		realtime = data.browser.sound.realtime;
% 	else
% 		realtime = parent.browser.sound.realtime;
% 	end
% 	
% 	switch (gopt.time.labels)
% 		
% 		case ('seconds')
% 			
% 			time1 = [num2str(event.time(1)) ' sec'];
% 			time2 = [num2str(event.time(2)) ' sec'];
% 			time3 = [num2str(event.duration) ' sec'];
% 		
% 		case ('clock')
% 			
% 			time1 = sec_to_clock(event.time(1));
% 			time2 = sec_to_clock(event.time(2));
% 			time3 = [num2str(event.duration) ' sec'];
% 			
% 		case ('date and time')
% 			
% 			if (gopt.time.realtime && ~isempty(realtime))
% 				
% 				offset = datevec(realtime);
% 				offset = offset(4:6) * [3600, 60, 1]';
% 				
% 				time1 = sec_to_clock(event.time(1) + offset);
% 				time2 = sec_to_clock(event.time(2) + offset);
% 				time3 = [num2str(event.duration) ' sec'];	
% 				
% 			else
% 				
% 				time1 = sec_to_clock(event.time(1));
% 				time2 = sec_to_clock(event.time(2));
% 				time3 = [num2str(event.duration) ' sec'];
% 				
% 			end
% 			
% 	end
% 	
% 
% 	
% 	% TODO: reconsider the conversion of frequency to strings
% 	
% 	if (strcmp(gopt.freq.labels,'Hz'))
% 		
% 		freq1 = [num2str(event.freq(1),6) ' Hz'];
% 		freq2 = [num2str(event.freq(2),6) ' Hz'];
% 		freq3 = [num2str(event.bandwidth,6) ' Hz'];
% 		
% 	else
% 		
% 		freq1 = [num2str(event.freq(1) / 1000,6) ' kHz'];
% 		freq2 = [num2str(event.freq(2) / 1000,6) ' kHz'];
% 		freq3 = [num2str(event.bandwidth / 1000,6) ' kHz'];
% 		
% 	end
	
	%--
	% compute event labels
	%--
	
	event.time = map_time(data.browser.sound, 'real', 'record', event.time);
	
	opt = event_labels;
	
	opt.time = data.browser.grid.time.labels;
	
	opt.freq = data.browser.grid.freq.labels;
	
	[time_label, freq_label] = event_labels( ...
		event, ...
		data.browser.sound, ...
		opt ...
	);
	
	%--
	% build menu
	%--
	
	L = { ...
		['Channel:  ' int2str(event.channel)], ...
		['Start Time:  ' time_label{1}], ...
		['End Time:  ' time_label{2}], ...
		['Duration:  ' time_label{3}], ...
		['Min Freq:  ' freq_label{1}], ...
		['Max Freq:  ' freq_label{2}], ...
		['Bandwidth:  ' freq_label{3}], ...
		'Event Info:', ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{5} = 'on';
	S{end} = 'on';
		
	tmp = menu_group(get_menu(h1,'Event'),'',L,S);
	
	%--
	% Event Info:
	%--
	 
	L = { ...
		['Author:  ' event.author], ...
		['Created:  ' datestr(event.created)] ...
	}; 

	if (~isempty(event.modified))
		L{3} = ['Modified:  ' datestr(event.modified)];
	end
	
	S = bin2str(zeros(1,3));
	S{2} = 'on';
	
	menu_group(get_menu(tmp,'Event Info:'),'',L,S);
	
	%--
	% Annotations
	%--
	
	tmp = get_menu(h1,'Annotation');
	
	for k  = 1:length(event.annotation)
		if (~isempty(event.annotation(k).name))
% 			try
				feval(event.annotation(k).fun,'menu',h,m,ix);
% 			catch
% 				disp(' ');
% 				warning(['Annotation ''' event.annotation(k).name ''' is not available.']);
% 			end
		end
	end
	
	%--
	% Add Annotation
	%--
	
	if (exist('ANNOT_NAME','var'))	
		L = setdiff(ANNOT_NAME,struct_field(event.annotation,'name'));
		if (length(L))
			L = strcat(L,' ...');
		end
	else 
		L = cell(0);
	end

	if (~isempty(L))
		
		ixa = find(strcmp(L,'Default'));

		if (~isempty(ixa) && (ixa > 1))	
			buf = L{1};
			L{1} = L{ixa};
			L{ixa} = buf;
		end
		
		tmp = menu_group(tmp,'',{'Add Annotation'});
		
		if (get(tmp,'position') > 1)
			set(tmp,'separator','on'); 
		end
		
		n = length(L);
		
		S = bin2str(zeros(1,n));
		if (~isempty(ixa) && (n > 1))
% 			S{2} = 'on';
			mg = menu_group(tmp,'event_menu',L,S);
		else
			mg = menu_group(tmp,'event_menu',L);
		end
		
	end
		
	%--
	% Measurements
	%--
	
	measurement_menu(h1, event, h, m, ix);
	
	% RENAME BECAUSE WE JUST WANT THAT 'S'!!!!
	
	try
		set(get_menu(h1, 'Measure'), 'label', 'Measures');
	end
	
	%--
	% tag all menus using the 'm.ix' tag
	%--

	set(findall(g),'tag',[int2str(m) '.' int2str(ix)]);
	
%------------------------------------------------------------------
% Play Event
%------------------------------------------------------------------

case ({'Play Event','Play Clip'})
	
	if (strcmp(mode,'sound'))
		browser_sound_menu(h,str);
		return;
	else
		log_sound_menu(h,str);
		return;
	end
	
%------------------------------------------------------------------
% Center Event
%------------------------------------------------------------------

% TODO: this command is causing errors if called during active detection,
% consider using the event navigation code to perform this action

case ('Center Event')
	
	selection = get_browser_selection(h);
	
	%--
	% reset display time to center selection
	%--
    
    t = (sum(selection.event.time) - data.browser.page.duration) / 2; 
	
    set_browser_time(h, t, 'slider'); 
    
%------------------------------------------------------------------
% View in Sound
%------------------------------------------------------------------

case ('View in Sound')

	%--
	% get event address and event
	%--
	
	try
		ax = get(data.browser.selection.handle(1),'parent');
	catch
		return;
	end
	
	[m,ix] = strtok(get(ax,'tag'),'.');
	
	m = str2double(m);
	ix = str2double(ix(2:end));
	
	event = parent.browser.log(m).event(ix);
	
	%--
	% check that event is available in sound browser page
	%--
	
	%--
	% time selection check
	%--
	
	t = parent.browser.time;
	dt = parent.browser.page.duration;
	
	if ((event.time(1) > t) && (event.time(2) < t + dt))
	
		update = 0;
		
	else
		
		t = max(0,(sum(event.time) / 2) - (dt / 2));
		if (t + dt > parent.browser.sound.duration)
			t = parent.browser.sound.duration - dt;
		end
		
		parent.browser.time = t;
		
		update = 1;
		
	end
	
	%--
	% ensure log is visible
	%--
	
	if (~parent.browser.log(m).visible)
		
		parent.browser.log(m).visible = 1;
		file = file_ext(parent.browser.log(m).file);
		
		visible = 1;
		
	else
		
		visible = 0;
		
	end
	
	%--
	% check that event channel is displayed
	%--
	
	chix = find(event.channel == parent.browser.channels);
	
	if (isempty(chix))
		ch = sort(unique([parent.browser.channels, event.channel]));
		parent.browser.channels = ch;
	end
	
	%--
	% update sound browser state to make event visible
	%--
	
	set(data.browser.parent,'userdata',parent);
	
	%--
	% bring sound browser to front and update display
	%--
	
	figure(data.browser.parent);
	
	if (~update)
		
		%--
		% only event update (to ensure that log is visible)
		%--
		
		if (visible)
			browser_display(data.browser.parent,'events',parent);
		end
		
	else
		
		%--
		% full display update
		%--
	
		browser_display(data.browser.parent,'update',parent);
		
		%--
		% enable and disable navigation menus
		%--
		
		browser_navigation_update(data.browser.parent,parent);
		
		%--
		% update view state array
		%--
		
		parent.browser.view = browser_view_update(data.browser.parent,parent);
		set(data.browser.parent,'userdata',parent);
		
	end
	
	%--
	% make event current selection in sound browser
	%--
	
	event_bdfun(data.browser.parent,m,ix);
	
%------------------------------------------------------------------
% Delete Event ...
%------------------------------------------------------------------

case ('Delete Event ...')
	
	%--
	% get log and event indices
	%--
	
	[m, ix] = strtok(get(gco,'tag'), '.');
	
	m = str2double(m); ix = str2double(ix(2:end));
	
	%--
	% confirm that we are going to delete event
	%--
	
	if strcmp(mode, 'sound')
		
		event = data.browser.log(m).event(ix);
		file = file_ext(data.browser.log(m).file);
		
	else 
	
		event = parent.browser.log(m).event(ix);
		file = file_ext(parent.browser.log(m).file);
		
	end
	
	% NOTE: we permute the button positions to protect against habit
	
	tmp = {'Yes','No','Cancel'};
	
	tmp = tmp(randperm(3));
	
	% NOTE: we add leading spaces to the title for better layout
	
	ans_dialog = quest_dialog( ...
		['Delete event ''' file ' # ' num2str(event.id) ''' ?'], ...
		'  Delete Event ...', ...
		tmp{:}, 'No' ...
	);

	if (isempty(ans_dialog) || strcmp(ans_dialog,'Cancel') || strcmp(ans_dialog,'No'))	
		
		%--
		% event deletion was cancelled
		%--
		
		return;
		
	else
		
		%--
		% update log and userdata and display
		%--
		
		if (strcmp(mode,'sound'))
			
			% TODO: this should be put in a separate function 
			
			%--
			% put deleted event in deleted events array
			%--
			
			dix = length(data.browser.log(m).deleted_event);
			
			if ((dix == 1) && isempty(data.browser.log(m).deleted_event(1).id))
				dix = 0;
			end
						
			data.browser.log(m).deleted_event(dix + 1) = data.browser.log(m).event(ix);
			
			%--
			% delete event from log event array
			%--
			
			data.browser.log(m).event(ix) = [];
			data.browser.log(m).length = data.browser.log(m).length - 1;
			
			%--
			% update userdata
			%--
			
			set(h,'userdata',data);
			
			%--
			% update event display in sound browser
			%--
			
			browser_display(h,'events',data);
			
		else
			
			%--
			% put deleted event in deleted events array
			%--
			
			dix = length(parent.browser.log(m).deleted_event);
			
			if ((dix == 1) && isempty(parent.browser.log(m).deleted_event(1).id))
				dix = 0;
			end
						
			parent.browser.log(m).deleted_event(dix + 1) = parent.browser.log(m).event(ix);
			
			%--
			% delete event from event array
			%--
			
			parent.browser.log(m).event(ix) = [];
			parent.browser.log(m).length = parent.browser.log(m).length - 1;
			
			%--
			% update parent browser userdata
			%--
			
			set(data.browser.parent,'userdata',parent);
			
			%--
			% update display in log browser
			%--
			
		% 	log_browser_display;
			
			[ax,im,sli] = log_browser_display('create', ...
				data.browser.log, ...
				data.browser.index, ...
				data.browser.dilation, ...
				data.browser.row, ... 
				data.browser.column ...
			);
		
			data.browser.axes = ax;
			data.browser.images = im;
			data.browser.slider = sli;
			
			% update log browser userdata
			
			set(h,'userdata',data);
			
			log_resizefcn;
			
			%--
			% update parent display
			%--
			
			% this may be somewhat distracting
			
			set(0,'currentfigure',data.browser.parent);
			browser_display;
			
			figure(h); % return focus to log browser
			
		end
	
	end
	
	%--
	% update event palette if needed
	%--
	
	update_find_events(h);
	
%------------------------------------------------------------------
% Annotation Schemes
%------------------------------------------------------------------

case strcat(ANNOT_NAME,' ...')
	
	%--
	% get log and event indices
	%--
	
	[m, ix] = strtok(get(gco,'tag'), '.');
	
	m = str2double(m); ix = str2double(ix(2:end));
		
	%--
	% get annotation extension
	%--
	
	ixa = strcmp(ANNOT_NAME, str(1:end - 4));
	
	ext = ANNOT(ixa);
	
	%--
	% call annotation scheme function and update event palette
	%--
	
	if strcmp(mode, 'sound')
		par = h;
	else
		par = data.browser.parent;
	end
	
	info = process_browser_events(par, ext, m, ix);

%------------------------------------------------------------------
% Measurements
%------------------------------------------------------------------

case strcat(MEAS_NAME, ' ...')
	
	%--
	% get log and event indices
	%--
	
	[m, ix] = strtok(get(gco,'tag'), '.');
	
	m = str2double(m); ix = str2double(ix(2:end));
		
	%--
	% get measurement extension
	%--
	
	ixa = strcmp(MEAS_NAME, str(1:end - 4));
	
	ext = MEAS(ixa);
	
	%--
	% call annotation scheme function
	%--
	
	if strcmp(mode, 'sound')
		par = h;
	else
		par = data.browser.parent;
	end
	
	info = process_browser_events(par, ext, m, ix);
	
%------------------------------------------------------------------
% Create Template ...
%------------------------------------------------------------------

case ('Create Template ...')
	
	%--
	% get log and event indices
	%--
	
	[m, ix] = strtok(get(gco, 'tag'), '.');
	
	m = str2double(m);
	ix = str2double(ix(2:end));
	
	%--
	% get event to use as template from userdata
	%--
	
	event = parent.browser.log(m).event(ix);
	
	%--
	% get annotations and meaurements to include
	%--

	def{1} = 'Template'; 
	
	annotation_name = struct_field(event.annotation,'name');

	n2 = length(annotation_name);
	
	if ((n2 == 1) && isempty(event.annotation(1).name))
		def{2} = {'No Annotation'};
	else
		def{2} = {annotation_name{:}, 1:n2};
		if (n2 == 1)
			n2 = 2;
		end
	end
	
	measurement_name = struct_field(event.measurement,'name');
	n3 = length(measurement_name);
	def{3} = {measurement_name{:}, 1:n3};
	if (n3 == 1)
		n3 = 2;
	end
	
	ans_dialog = input_dialog( ...
		{'Name','Annotation','Measures'}, ...
		'Create Template ...', ...
		[1,32; n2, 40; n3, 40], ...
		def ...
	);
	
	return;
	
	for k = 1:length(measurement_name)
		
		tmp = measurement_create;
		
		tmp.name = measurement_name{k};
		
		template.measurement(k) = tmp;
		
	end
	
	%--
	% save template in template folder
	%--
	
%------------------------------------------------------------------
% Copy Event To
%------------------------------------------------------------------

otherwise
	
	%--
	% find index of named log
	%--
	
	if strcmp(mode, 'log')
		file = struct_field(parent.browser.log, 'file');
	else
		file = struct_field(data.browser.log, 'file');
	end
	
	p = find(strcmp([str '.mat'], file));
	
	%--
	% get event address and event
	%--

	% saved in patch uicontextmenu tag as address 'm.ix'
	
	[m, ix] = strtok(get(get(get(gcbo, 'parent'), 'parent'), 'tag'), '.');
	
	m = str2double(m); ix = str2double(ix(2:end));
	
	if isnan(m) || isnan(ix)
		return;
	end
	
	if strcmp(mode, 'log')
		event = parent.browser.log(m).event(ix);
	else
		event = data.browser.log(m).event(ix);
	end
	
	%--
	% add event to other log
	%--

	if strcmp(mode, 'log')
		log_update(data.browser.parent, p, event);
	else
		log_update(h, p, event);
	end
	
	%--
	% update display
	%--
	
	if strcmp(mode, 'log')
		% no need to update display
	else
		browser_display(h, 'events', data);
	end
	
end
    
    
    
    
    
