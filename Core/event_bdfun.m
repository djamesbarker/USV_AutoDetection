function event_bdfun(h, m, ix, flag)

% event_bdfun - event display button down function
% ------------------------------------------------
%
% event_bdfun(h, m, ix, flag)
%
% Input:
% ------
%  h - figure handle
%  m - index of log
%  ix - index of event
%  flag - update flag

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

% TODO: factor selection drawing code from this function

%--------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------

%--
% set default update
%--

if nargin < 4 || isempty(flag)
	flag = 1;
end

%--
% get figure handle and log and event indices
%--

if ~nargin

	%--
	% hold current figure handle
	%--
	
	h = gcf;
	
	if ~is_log_browser(h)
		return;
	end
	
	%--
	% get log and event indices looking at the patch tag
	%--
	
	tag = get(gco, 'tag');
	
	[m, ix] = strtok(tag, '.');
	
	m = str2num(m); ix = str2num(ix(2:end));
	
	%--
	% check for pointer state (this is where the state is stored)
	%--
	
% 	get_custom_pointer(h)
	
end

%--
% return if the event in question is nolonger available
%--

if isempty(ix) || isempty(m)
	return;
end

%--
% get current key to modify selection behavior
%--

% NOTE: selection on most GUI systems is modified by 'shift' and 'control'

% NOTE: should intervening events include events on other visible channels?

% key = get(h,'currentkey');

%--------------------------------------------------
% GET EVENT DATA
%--------------------------------------------------

%--
% get figure userdata
%--

data = get(h, 'userdata');

%--
% get event and linewidth
%--

if ~is_log_browser(h)
	
	event = data.browser.log(m).event(ix);
	
	line_width = data.browser.log(m).linewidth;
	
else
		
	parent = get(data.browser.parent, 'userdata');
	
	event = parent.browser.log(m).event(ix);
	
	line_width = parent.browser.log(m).linewidth;
	
end

%--------------------------------------------------
% UPDATE EVENT PALETTE
%--------------------------------------------------

%--
% check for open event palette
%--

pal = get_palette(h, 'Event', data);

%--
% update palette display if needed
%--

% NOTE: the number of arguments and flag help distinguish code and GUI calls

if ~isempty(pal) && (~nargin || flag) 
			
	%--
	% get event strings from palette
	%--
	
	handles = get_control(pal, 'event_display', 'handles');
	
	listbox = handles.uicontrol.listbox;
	
	str = get(listbox, 'string');
	
	%--
	% find event string among listbox strings
	%--
	
	% NOTE: we rely on strings containing log name and event id
	
	% NOTE: the first pattern is the log name the second the event id
	% CRP 2011-02-03 modified the pat to match the new
    %  format of events
    % logname_#_Dppppp: where _ stands for space
    % and p stands for space padding after the ID number
	pat = ['"', file_ext(data.browser.log(m).file), ...
        ' #" "# ', int_to_rts(event.id, 999999, ' '), ':"'];
	
	sel = filter_strings(str, pat, 'and');
	
	%--
	% get index of event string in string list if needed and update palette
	%--
	
	if ~isempty(sel)

		% TODO: consider how this may be part of control_update
		
		ix2 = strmatch(sel, str);

% 		set(listbox, ...
% 			'value', ix2, 'listboxtop', ix2 ...
% 		);		
% 	
		set_control(pal, 'event_display', 'value', ix2);
	
		double_click('off');
		
		control_callback([], pal, 'event_display');
		
		double_click('on');
		
	end
	
end

%--------------------------------------------------
% UPDATE BROWSER SELECTION
%--------------------------------------------------

% NOTE: this includes browser state and display elements

%--
% update selection state
%--

tmp = data.browser.selection.handle;

if all(ishandle(tmp))
	delete(tmp);
end

if isempty(event)
	return;
end

% TODO: there is a bug lurking here

if ~is_log_browser(h)
	
	ax = findobj(data.browser.axes, 'tag', num2str(event.channel));
	
% 	axes(ax);
	
else
	
	TAGS = get(data.browser.axes, 'tag');
	
	tag = [int2str(m) '.' int2str(ix)];
	
	tmp = find(strcmp(TAGS, tag));
	
	ax = data.browser.axes(tmp);
	
% 	axes(ax);

end

%--
% display selection
%--

g = selection_event_display(event, ax, data, m, ix);

%--
% turn on selection edit functions
%--

if isempty(data.browser.parent)
	
	%--
	% update menus
	%--
	
	set(get_menu(data.browser.sound_menu.play, 'Selection'), 'enable', 'on');
	
	tmp = data.browser.edit_menu.edit;
	
	set(get_menu(tmp,'Cut Selection'),'enable','on');
	set(get_menu(tmp,'Copy Selection'),'enable','on');
	set(get_menu(tmp,'Log Selection ...'),'enable','on');
	set(get_menu(tmp,'Delete Selection'),'enable','on');
	
	%--
	% update controls
	%--
	
	control_update(h,'Sound','Selection','__ENABLE__',data);
	
else
	
	
	tmp = data.browser.sound_menu.sound;
	
	set(get_menu(tmp,'Play Event'),'enable','on');
	set(get_menu(tmp,'Play Clip'),'enable','on');
	
	tmp = data.browser.edit_menu.edit;

	set(get_menu(tmp,'Delete Selection'),'enable','on');
	
end

%--
% refresh figure
%--

refresh(h);

%--
% make displayed event current selection in sound
%--

% TODO: check that this solves the double annotation problems

% NOTE: consider whether this is the right behavior. it seems like 'id',
% measurements, and annotations should be cleared

% NOTE: it seems that the 'id' is being used somewhere to distinguish
% logged event selection from simple selections

event.measurement = empty(measurement_create);

event.annotation = empty(annotation_create);

event.time = map_time(data.browser.sound, 'slider', 'record', event.time);

data.browser.selection.event = event;

% NOTE: this is the field that should be used to distinguish logged event
% selections from simple selections, perhaps an 'id' field separate from
% the one in the event is needed

data.browser.selection.log = m;

data.browser.selection.handle = g;

%--
% update userdata
%--

set(h, 'userdata', data);

%--
% update widgets
%--

% NOTE: the code above should be replaced by a 'set_browser_selection' call

update_widgets(h, 'selection__create');


%--------------------------------------------------
% UPDATE MEASURE DISPLAY
%--------------------------------------------------

% TODO: this is where selection triggered display goes


%--------------------------------------------------
% UPDATE ZOOM DISPLAY
%--------------------------------------------------

if ~is_log_browser(h)
	
	opt = selection_display;

	opt.show = 1;

	selection_display(h, event, opt, data);
	
end


%--------------------------------------------------
% UPDATE VARIOUS PALETTES
%--------------------------------------------------

%--
% update selection palette controls
%--

set_selection_controls(h,event,'start',data);

%--
% update palettes
%--

% TODO: reconsider this condition

if isempty(data.browser.parent)
		
	%--
	% update navigate palette
	%--
	
	if (ix > 1)
		control_update(h,'Navigate','Previous Event','__ENABLE__',data);
	else
		control_update(h,'Navigate','Previous Event','__DISABLE__',data);
	end
	
	if (ix < data.browser.log(m).length)
		control_update(h,'Navigate','Next Event','__ENABLE__',data);
	else
		control_update(h,'Navigate','Next Event','__DISABLE__',data);
	end
	
end
