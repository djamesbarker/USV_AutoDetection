function data = delete_selection(par, data)

% delete_selection - delete browser selection
% -------------------------------------------
%
% data = delete_selection(par, data)
%
% Input:
% ------
%  par - handle
%  data - state

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

% NOTE: eventually we will handle multiple selections

%------------------------
% HANDLE INPUT
%------------------------

%--
% get state from browser
%--

if nargin < 2
	data = get_browser(par); update = 1;
else
	update = 0;
end

%------------------------
% UPDATE SELECTION
%------------------------

%--
% copy for clarity
%--

selection = get_browser_selection(par, data);

%--
% delete selection display
%--

% NOTE: take care to remove non-existent handles

ix = find(~ishandle(selection.handle));

if ~isempty(ix)
	selection.handle(ix) = [];
end

delete(selection.handle); refresh(par);
	
%--
% set empty selection state
%--

selection.event = empty(event_create);

selection.handle = [];

selection.log = [];
	
%--
% update selection state
%--

data.browser.selection = selection;

%------------------------
% UPDATE PARENT
%------------------------

%--
% disable selection options in edit menu
%--

tmp = data.browser.edit_menu.edit;

set(get_menu(tmp, 'Cut Selection'), 'enable', 'off');

set(get_menu(tmp, 'Copy Selection'),'enable', 'off');

set(get_menu(tmp, 'Delete Selection'), 'enable', 'off');

set(get_menu(tmp, 'Log Selection To'), 'enable', 'off');

tmp = data.browser.sound_menu.play;

set(get_menu(tmp, 'Selection'), 'enable', 'off');

%--
% control update
%--

control_update(par,'Sound', 'Selection', '__DISABLE__', data);

control_update(par, 'Navigate', 'Previous Event', '__DISABLE__', data);

control_update(par, 'Navigate', 'Next Event', '__DISABLE__', data);

%--
% update selection if needed
%--

selection_update(par, data);

%--
% update widgets
%--

update_widgets(par, 'selection__delete', data);

%--
% disable zoom to selection button
%--

update_selection_buttons(par, selection);

%--
% update userdata
%--

% NOTE: we only store state if we obtained it ourselves

if update
	set(par, 'userdata', data);
end


