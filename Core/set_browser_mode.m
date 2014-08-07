function set_browser_mode(par, mode, data)

% set_browser_mode - set browser selection mode
% ---------------------------------------------
%
% flag = set_browser_mode(par, 'hand')
%      = set_browser_mode(par, 'group')
%      = set_browser_mode(par, 'select')
% 
% Input:
% ------
%  par - handle to parent browser figure

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
% $Revision: 6895 $
% $Date: 2006-10-04 01:16:04 -0400 (Wed, 04 Oct 2006) $
%--------------------------------

% NOTE: at the moment the state saved in the browser selection mode

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% check mode
%--

modes = {'hand', 'select', 'group'};

if ~ischar(mode)
	error('Browser mode must be string.');
end

if ~ismember(mode, modes)
	error(['Unrecognized browser mode ''', mode, '''.']);
end

%--
% get parent data if needed
%--

if (nargin < 3) || isempty(data)
	data = get_browser(par);
end

%----------------------------------
% SET MODE
%----------------------------------

switch mode
	
	case 'select'
		
		% NOTE: the familiar selection mode available in earlier versions
		
		%--
		% turn off hand navigation callbacks
		%--
		
		set(par, ...
			'windowbuttondownfcn', [], ...
			'windowbuttonupfcn', [] ...
		);
	
		%--
		% set pointer and mode callbacks
		%--
		
		setptr(par, 'arrow');
		
		set(data.browser.images, 'buttondownfcn', 'browser_bdfun;');
		
	case 'hand'
		
		% NOTE: this mode permits fine tuned navigation in time
		
		%--
		% turn off selection callbacks
		%--
		
		set(data.browser.images, 'buttondownfcn', []);
		
		%--
		% set pointer and mode callbacks
		%--
		
		setptr(par, 'hand');
		
		set(par, ...
			'windowbuttondownfcn', {@drag_start, par}, ...
			'windowbuttonupfcn', {@drag_end, par} ...
		);
	
	case 'group'
	
		% NOTE: this mode will permit the creation of hierarchical events

	otherwise
		
		disp(['WARNING: Unrecognized browser mode ''', mode, '''.']); return;
		
end

%--
% update state
%--

data.browser.selection.mode = mode;

set(par, 'userdata', data);


%---------------------------------------------
% DRAG_START
%---------------------------------------------

function drag_start(obj, eventdata, par)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6895 $
% $Date: 2006-10-04 01:16:04 -0400 (Wed, 04 Oct 2006) $
%--------------------------------

stop(scrolling_daemon);

% NOTE: this fades the events and presents the big time display on click

browser_time_slide(par);

%--
% set pointer
%--

setptr(obj, 'closedhand');
	
%--
% create drag state structure
%--

ax = gca;

point = get(par, 'currentpoint'); point = point(1, 1:2);

slider = get_time_slider(par);

drag.axes = ax; drag.start = point; drag.end = point;

drag.start_time = slider.value;

set_env('DRAG_STRUCT', drag);

%--
% set button motion function
%--

set(gcf, 'windowbuttonmotionfcn', {@drag_update, par});
	
	
%---------------------------------------------
% DRAG_UPDATE
%---------------------------------------------

function drag_update(obj, eventdata, par)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6895 $
% $Date: 2006-10-04 01:16:04 -0400 (Wed, 04 Oct 2006) $
%--------------------------------

%--
% check that we are within starting axes
%--

ax = gca; drag = get_env('DRAG_STRUCT');

% NOTE: this handles a rare callback sync error

if isempty(drag)
	return;
end

if (drag.axes ~= ax)
	return;
end
	
%--
% compute current end point
%--

point = get(par, 'currentpoint'); point = point(1, 1:2);

drag.end = point;

%--
% get drag length (note the reversal) and slider properties
%--

% NOTE: this exception handles drag ending in other figures

page_dur = diff(get(ax, 'xlim'));

fig_size = get(par, 'position'); fig_size = fig_size(3);

ax_size = get(ax, 'position'); ax_size = ax_size(3) * fig_size;

try
	dt = page_dur * (drag.start(1) - drag.end(1)) / ax_size;
catch
	return;
end

%--
% update time slider
%--

set_time_slider(par, 'value', drag.start_time + dt);

%--
% slide browser
%--

browser_time_slide(par);


%---------------------------------------------
% DRAG_END
%---------------------------------------------

function drag_end(obj, eventdata, par)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6895 $
% $Date: 2006-10-04 01:16:04 -0400 (Wed, 04 Oct 2006) $
%--------------------------------

%--
% update pointer and button motion function
%--

setptr(par, 'hand');

set(par, 'windowbuttonmotionfcn', []);

%--
% discard drag environment variable
%--

rm_env('DRAG_STRUCT', 0);

%--
% perform required display for the case of no motion
%--

% NOTE: we remove the big time display and refresh the events, this is fast

delete(big_centered_text(par));

browser_display(par, 'events');

%--
% start timer
%--

if strcmp(get(scrolling_daemon, 'running'), 'off')
	start(scrolling_daemon);
end
