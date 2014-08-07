function event = browser_bdfun(event)

% browser_bdfun - enable selection in spectrogram display axes
% ------------------------------------------------------------
% 
% event = browser_bdfun(event)
% 
% Input:
% ------
%  event - event to display as selection
%
% Output:
% -------
%  event - selection event structure

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
% $Revision: 1951 $
% $Date: 2005-10-19 08:25:25 -0400 (Wed, 19 Oct 2005) $
%--------------------------------

% TODO: this function should take the parent figure handle as input to
% prevent problems when setting the selection programmaticaly

%--
% get userdata and return if selection is off
%--

par = get_active_browser;

data = get(par, 'userdata'); 

if ~data.browser.selection.on
	return;
end

% NOTE: this test solves a strange problem updating the selection grid from the palette

%--
% actual browser button down function
%--

if ~nargin
	
	if ~isempty(get(gco, 'type'))
		
		%--
		% check for double click
		%--
		
		if double_click(gco)
			browser_sound_menu(par, 'Play Page'); return;
		end	
		
	end
	
	%--
	% pause marching ants
	%--
	
	ants_timer = timerfind('name', 'XBAT Marching Ants');
	
	if strcmp(get(ants_timer, 'running'), 'on')
		stop(ants_timer); ants_flag = 1;
	else
		ants_flag = 0;
	end
	
	%--
	% check for double click to set a zero extent event or marker
	%--
		
	% TODO: develop cues, cues are stored in cue sheets
	
	% NOTE: display a label and time tag on the cue, we can select using the tag and hang a context menu

	% NOTE: we should also user markers to allow hiding the tag
	
% 	if double_click(gco)
% 		
% 		%--
% 		% get channel and time location of double click
% 		%--
% 		
% 		ch = eval(get(gca,'tag'));
% 		
% 		p = get(gca,'currentpoint');
% 		p = p(1);
% 		
% 		%--
% 		% create zero time and nyquist extent event
% 		%--
% 		
% 		event = event_create( ...
% 			'level', 1, ...
% 			'channel', ch, ...
% 			'time', [p, p], ...
% 			'freq', [0, data.browser.sound.samplerate / 2] ...
% 		);
% 	
% 		%--
% 		% display event as selection and return
% 		%--
% 		
% 		browser_bdfun(event);
% 
% 		return;
% 		
% 	end
	
	%--
	% check for play timer and toggle play state
	%--
		
	% NOTE: this behavior can also be effected through a control
	
	% NOTE: eventually there may be multiple players, one per parent
	
	tmp = timerfind('name', 'PLAY_TIMER');
	
	if ~isempty(tmp)
		
		%--
		% toggle if we are running the button down function as we play
		%--
		
		if get(tmp, 'running')
			set_env('PLAY_STATE', ~get_env('PLAY_STATE'));
		end
		
	end
	
	%--
	% get current axes
	%--
	
	dax = gca;
	
	%--
	% check pointer state to determine action
	%--
	
	% NOTE: new mode framework has been introduced after this code 
	
	ptr = get(par, 'pointer');
	
	if strcmp(ptr, 'watch')
		ptr = 'arrow';
	end
	
	%--
	% get coordinates for current selection
	%--
	
	if strcmp(ptr,'arrow')
		
		%--
		% selection behavior
		%--
		
		set(par, 'pointer', 'arrow');
		
		try	
	
			p1 = get(dax,'CurrentPoint');
			r = rbbox;	 	 	 
			p2 = get(dax,'CurrentPoint');	
			
			p1 = p1(1,1:2);	
			p2 = p2(1,1:2);
		
		catch	
			
			set(par,'pointer',ptr); return;
			
		end
		
		set(par,'pointer',ptr);
		
	else
		
		%--
		% cursor behavior
		%--
		
		% this is in progress.
		
		% the idea is to support the display of slice based information in
		% another window, such as the comparison of various types of spectrum 
		% estimates for this location
		
		return;
		
	end
	
	%--
	% restart marching ants if needed
	%--
	
	if ants_flag
		start(ants_timer);
	end
	
	%--
	% sort points and compute anchor point and offset representation
	%--
	
	tmp = max(p1,p2);
	
	p1 = min(p1,p2);
	p2 = tmp;
	
	dp = p2 - p1;
	
	%--
	% check that selection is contained in axes and not too small
	%--
	
	% TODO: this test should use relative size of selection within the page
	
	xl = get(dax,'xlim');
	yl = get(dax,'ylim');
	
	% NOTE: consider frequency scaling in size test
	
	if (strcmp(data.browser.grid.freq.labels,'Hz'))
		test = (dp(2) < 1);
	else
		test = (dp(1) < 0.001);
	end
	
% 	if (test || (dp(1) < 0.05) || (p1(1) < xl(1)) || (p2(1) > xl(2)) || (p1(2) < yl(1)) || (p2(2) > yl(2)))
% 		return;
% 	end
	
	%--
	% find (single) session that selection is in
	%--

	session_boundaries = [];
	
	if has_sessions_enabled(data.browser.sound)
		
		sessions = get_sound_sessions(data.browser.sound);
		
		session_ix = find([[sessions.end] > p2(1)] & [[sessions.start] < p1(1)]);
		
		if isempty(session_ix)
			test = 1;
		else
			session_boundaries = [sessions(session_ix).start,sessions(session_ix).end];
		end
		
	end	
	
	%--
	% permit selection of events with zero starting frequency or nyquist end
	%--
	
	if (test || (dp(1) < 0.001) || (p1(1) < xl(1)) || (p2(1) > xl(2)))
		return;
	end

	%--
	% fix selection boundaries at frequency limits
	%--
	
	if (p1(2) < yl(1))
		p1(2) = 0;
		dp(2) = p2(2);
	end
	
	if (p2(2) > yl(2))
		p2(2) = yl(2);
		dp(2) = p2(2) - p1(2);
	end
	
	%--
	% create event structure for selection
	%--
	
	event = event_create;
	
	event.channel = str2double(get(dax,'tag'));
	
	event.time = [p1(1), p1(1) + dp(1)];
	
	event.duration = dp(1);
	
	event.level = 1; % the setting of level will have to be reconsidered when we move to hierarchical events
	
	if (strcmp(data.browser.grid.freq.labels,'Hz'))
		event.freq = [p1(2), p1(2) + dp(2)];
		event.bandwidth = dp(2);
	else
		event.freq = 1000 * [p1(2), p1(2) + dp(2)];
		event.bandwidth = 1000 * dp(2);
	end

%--
% display event based on input event
%--

else
	
	%--
	% get current axes
	%--
	
	% NOTE: this is valid in the case that we are clicking on a logged event and
	% we are displaying it as a selection, however this should get the axes
	% handle by finding the axes with the right tag
	
	% this is only slighly better
	
	dax = findobj(par, 'type', 'axes', 'tag', int2str(event.channel));
	
end

%----------------------------------------------------------------
% DELETE PREVIOUS SELECTION OBJECTS
%----------------------------------------------------------------

% TODO: consider removing one of the currently used lines, and using patch border

if all(ishandle(data.browser.selection.handle))
	delete(data.browser.selection.handle);
end

%----------------------------------------------------------------
% UPDATE PARENT MENUS AND CONTROLS
%----------------------------------------------------------------

%--
% turn on play selection menu 
%--

set(get_menu(data.browser.sound_menu.play,'Selection'),'enable','on');

%--
% turn on selection commands in edit menu
%--

tmp = data.browser.edit_menu.edit;

set(get_menu(tmp,'Cut Selection'),'enable','on');

set(get_menu(tmp,'Copy Selection'),'enable','on');

set(get_menu(tmp,'Delete Selection'),'enable','on'); 

% if (length(data.browser.log))
% 	set(get_menu(tmp,'Log Selection To'),'enable','on');
% end

set(get_menu(tmp,'Log Selection To'),'enable','on');

%--
% update controls
%--

control_update(par,'Sound','Selection','__ENABLE__',data);
	
control_update(par,'Navigate','Previous Event','__DISABLE__',data);

control_update(par,'Navigate','Next Event','__DISABLE__',data);

% NOTE: the idea of having a ply selection button is not a bad one

% hp = get_palette(par,'Sound',data);
% 
% if (~isempty(hp))
% 	set(get_button(hp,'Play Selection'),'enable','on');
% end

if isempty(dax)
	return;
end

%-------------------------------------------------------------
% DISPLAY SELECTION AND CREATE SELECTION CONTEXT MENU
%-------------------------------------------------------------

gp = selection_event_display(event, dax, data);

if isempty(gp)
	return;
end

%--
% attach context menu to selection patch
%--

gm = uicontextmenu('parent', par);

set(gp(2),'uicontextmenu',gm);


%----------------------------------------------
% selection menu when there are open logs
%----------------------------------------------

if data.browser.log_active
	
	%----------------------------------------------
	% menu when there are multiple logs open
	%----------------------------------------------
	
	if (length(data.browser.log) == 1)
		
		%----------------------------------------------
		% create selection menu
		%----------------------------------------------
		
		L = { ...
			['Selection'], ...
			'Play Selection', ...
			'Center Selection', ...
			'Log Selection To', ...
			'Cut Selection', ...
			'Copy Selection', ...
			'Delete Selection' ...
		};
		
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		S{5} = 'on';
		S{end} = 'on';
	
		tmp = menu_group(gm,'browser_edit_menu',L,S);
	
		%--
		% set other callbacks
		%--
		
		set(get_menu(tmp,'Play Selection'),'callback','browser_sound_menu(gcf,''Play Selection'')');
		
		%--
		% create open logs menu
		%--
		
		L = file_ext(struct_field(data.browser.log,'file'));
		
		tmp2 = menu_group(get_menu(tmp,'Log Selection To'),'browser_edit_menu',L);
		
		% display check on active log indicating 'Log Selection ...' logs to active log
		
		set(tmp2(data.browser.log_active),'check','on');
		
	%----------------------------------------------
	% menu when there is a single log open
	%----------------------------------------------
	
	else
		
		%----------------------------------------------
		% create selection menu
		%----------------------------------------------
		
		L = { ...
			['Selection'], ...
			'Play Selection', ...
			'Center Selection', ...
			'Log Selection To', ...
			'Cut Selection', ...
			'Copy Selection', ...
			'Delete Selection' ...
		};
		
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		S{5} = 'on';
		S{end} = 'on';
	
		tmp = menu_group(gm,'browser_edit_menu',L,S);
	
		%--
		% set other callbacks
		%--
		
		set(get_menu(tmp,'Play Selection'),'callback','browser_sound_menu(gcf,''Play Selection'')');
		
		%--
		% create open logs menu
		%--
		
		L = file_ext(struct_field(data.browser.log,'file'));
		
		tmp2 = menu_group(get_menu(tmp,'Log Selection To'),'browser_edit_menu',L);
		
		% display check on active log, this indicates that the log
		% selection behavior logs to the active log
		
		set(tmp2(data.browser.log_active),'check','on');
		
	end
	
%----------------------------------------------
% selection menu when there are no logs open
%----------------------------------------------

else
	
	%----------------------------------------------
	% create selection menu
	%----------------------------------------------
	
	L = { ...
		['Selection'], ...
		'Play Selection', ...
		'Center Selection', ...
		'Log Selection To', ...
		'Cut Selection', ...
		'Copy Selection', ...
		'Delete Selection' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{5} = 'on';
	S{end} = 'on';
	
	tmp = menu_group(gm,'browser_edit_menu',L,S);
	
	%--
	% set other callbacks
	%--
	
	set(get_menu(tmp,'Play Selection'),'callback','browser_sound_menu(gcf,''Play Selection'')');
	
	%--
	% create empty open logs menu
	%--
	
	L = {'(No Open Logs)'};
	
	tmp2 = menu_group(get_menu(tmp,'Log Selection To'),'browser_edit_menu',L);
	
	set(tmp2,'enable','off');
	
end

%----------------------------------------------
% create event information menu
%----------------------------------------------

%--
% compute event labels
%--

% NOTE: not all of these may be used

opt = event_labels;

opt.time = data.browser.grid.time.labels;

opt.freq = data.browser.grid.freq.labels;

[time,freq] = event_labels(event,data.browser.sound,opt);

%--
% create menu
%--

gm = [gm, tmp];

L = { ...
	['Channel:  ' int2str(event.channel)], ...
	['Start Time:  ' time{1}], ...
	['End Time:  ' time{2}], ...
	['Duration:  ' time{3}], ...
	['Min Freq:  ' freq{1}], ...
	['Max Freq:  ' freq{2}], ...
	['Bandwidth:  ' freq{3}], ...
};

n = length(L);
	
S = bin2str(zeros(1,n));
S{2} = 'on';
S{5} = 'on';

tmp = menu_group(tmp(1),'',L,S);

%--
% concatenate all created menu handles
%--

gm = [gm, tmp];

g = [gp(:); gm(:)];

%----------------------------------------------
% create detection values menu
%----------------------------------------------

% this will require a considerable amount of work, think about other ways

%--
% tag all selection display objects
%--

set(g, 'tag', 'selection');

%--
% update selection in browser structure
%--

data.browser.selection.event = event;

data.browser.selection.handle = g;

data.browser.selection.log = [];

set(par, 'userdata', data);

%--
% refresh figure
%--

refresh(par);

%--
% update selection zoom
%--

% TODO: implement this as a widget extension

opt = selection_display; opt.show = 1;

selection_display(par, event, opt, data);

%--
% update selection controls
%--

set_selection_controls(par, event, 'start', data);

%--
% update widgets
%--

update_widgets(par, 'selection__create', data);

if ~nargout
	clear('event');
end


