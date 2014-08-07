function daemon = sound_player(sound, mode, x, dx, ch, speed, filter, tax, opt)

% sound_player - create sound player daemon
% -----------------------------------------
%
% daemon = sound_player(sound, 'time', t, dt, ch, speed, filter, tax, opt)
%
%        = sound_player(sound, 'samples', ix, n, ch, speed, filter, tax, opt)
%
% Input:
% ------
%  sound - sound structure
%  t - channel start times
%  dt - duration
%  ch - channels
%  speed - play rate as related to natural rate
%  filter - signal filter
%  tax - start times and display axes handles
%  opt - display options
%
% Output:
% -------
%  daemon - player daemon

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

% TODO: pack all display options into a single struct

% TODO: hide read mode option and always read on time

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set and possibly output display options
%--

if (nargin < 9) || isempty(opt)
	
	%--
	% default display options
	%--
	
	opt.color = [0, 0.2, 0.8];	% line color
	
	opt.linestyle = '-';	% linestyle for line
	
	opt.marker = 's';		% marker to display at line end points
	
	opt.label = 'time';		% set to 'time' for text time display
	
	%--
	% output display options
	%--
	
	if ~nargin
		daemon = opt; return;	
	end
	
end

%--
% set default filter
%--

if (nargin < 7)
	filter = [];
end

%--
% set default play speed
%--

if (nargin < 6) || isempty(speed)
	speed = 1; 
end

%--
% handle remaining arguments using helper
%--

% NOTE: actual default value computations are contained in 'get_sound_extent'

if (nargin < 5)
	ch = [];
end

if (nargin < 4)
	dx = [];
end

if (nargin < 3)
	x = [];
end

if (nargin < 2)
	mode = [];
end

[ix, n, ch] = get_sound_extent(sound, mode, x, dx, ch);

%--------------------------------------------
% CREATE PLAYER AND DISPLAY TIMER
%--------------------------------------------

%--
% create player
%--

player = buffered_player(sound, ix, n, ch, speed, filter);

%--
% set time and axes for display
%--

% NOTE: separate start times and display axes for convenience

% NOTE: this overwrites 't' consider changing this

if (nargin < 7)
	t = []; ax = []; top = []; 
else
	t = tax(:,1); ax = tax(:,2); top = tax(:,3);
end

%--
% create timer to handle display
%--

% NOTE: consider the name and tag redundancy

daemon = timer('name', 'PLAY_TIMER');

set(daemon, ...
	'tag', 'PLAY_TIMER', ...
	'startfcn', {@daemon_start, player, t, ax, top, opt}, ...
	'timerfcn', {@daemon_update, player}, ...
	'stopfcn', @daemon_stop, ...
	'executionmode', 'fixedRate', ...
	'busymode', 'drop', ...
	'period', 0.02 ...
);


%--------------------------------------------
% DAEMON_START
%--------------------------------------------

function daemon_start(obj, eventdata, player, t, ax, top, opt)

% daemon_start - initialize interactive play
% ---------------------------------------
% 
% daemon_start(obj, eventdata, player, t, ax, top, opt)
%
% Input:
% ------
%  obj - calling player timer
%  eventdata - not used at the moment
%  player - buffered player
%  t - start times for display axes
%  ax - display axes handles
%  opt - display options

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1953 $
% $Date: 2005-10-19 20:22:46 -0400 (Wed, 19 Oct 2005) $
%--------------------------------

%----------------------------
% INITIALIZE DISPLAY
%----------------------------

if ~isempty(t)
	
	%----------------------------
	% CLEAN UP DISPLAY
	%----------------------------

	% NOTE: search and destroy orphaned objects in all axes parents
	
	n = length(ax); 

	for k = 1:n
		par(k) = get(ax(k),'parent');
	end
	
	par = unique(par);
	
	for k = 1:length(par)
		delete(findobj(par(k), 'tag', 'PLAY_DISPLAY'));
	end

	%----------------------------
	% CREATE LINES
	%----------------------------

	%--
	% create line for all axes using start time and vertical limits
	%--

	g = zeros(n,1);
	
	for k = 1:n
		
		ylim = get(ax(k), 'ylim'); yrange = diff(ylim);
		
		g(k) = line( ...
			[t(k), t(k)], ylim + yrange * [0.01, -0.01], ...
			'parent', ax(k) ...
		);
	
		uistack(g(k),'top');
		
	end
	
	%--
	% set other line properties
	%--

	% TODO: allow separate display options for the axes
	
	% NOTE: a single display for various lines provides visual consistency
	
	set(g, ...
		'color', opt.color, ...
		'clipping', 'on', ...
		'linestyle', opt.linestyle, ...
		'marker', opt.marker, ...
		'markersize', 5, ...
		'tag', 'PLAY_DISPLAY' ...
	);

	%----------------------------
	% CREATE TEXT
	%----------------------------

	% NOTE: 'time' display is the only label option supported for now
	
	if strcmp(opt.label, 'time')
				
		%--
		% create text for all axes using start time and vertical limits
		%--
	
		% TODO: provide time label display for multiple channels
		
		% TODO: consider grid time display
		
		tx = [];

		for k = 1:length(ax)
			
			%--
			% skip axes not on top
			%--
			
			% NOTE: text does not display well in this case
			
			if ~top(k)
				continue;
			end 
			
			%--
			% compute frequency position padding
			%--
			
			%--
			% get height of axes in normalized units
			%--

			uni = get(ax(k), 'units'); set(ax(k), 'units', 'normalized');

			p1 = get(ax(k), 'position'); p1 = p1(4);

			set(ax(k), 'units', uni);

			%--
			% get height of parent figure in pixels
			%--

			tmp = get(ax(k), 'parent');

			uni = get(tmp, 'units'); set(tmp, 'units', 'pixels');

			p2 = get(tmp, 'position'); p2 = p2(4);

			set(tmp, 'units', uni);

			ylim = get(ax(k), 'ylim');
			
			PAD = (4 / (p1 * p2)) * (diff(ylim));
		
			%--
			% set axes and create text
			%--
						
			tx(end + 1) = text( ...
				t(k), ylim(2) + PAD, sec_to_clock(t(k)), ...	
				'parent', ax(k) ...	
			);
			
			uistack(tx(end), 'top');
			
		end
		
		%--
		% set other text properties
		%--

		set(tx, ...
			'clipping', 'off', ...
			'verticalalignment', 'bottom', ...
			'tag', 'PLAY_DISPLAY' ...
		);

		text_highlight(tx);
		
	else
		
		tx = [];
		
	end
		
	%--
	% flush the display queue
	%--
	
	drawnow;
	
end

%----------------------------
% STORE STATE DATA
%----------------------------

%--
% store display state in timer userdata
%--

data = get(obj, 'userdata');

data.times = [];

data.axes = [];

data.lines = [];

data.text = [];

if ~isempty(t)
	
	data.times = t; 
	
	data.axes = ax;
	
	data.lines = g;
	
	data.text = tx;
	
end

set(obj, 'userdata', data);
	
%--
% play state in environment variable
%--

set_env('PLAY_STATE', 1);

%----------------------------
% START PLAYER
%----------------------------

player_start(player);

%--
% update widgets
%--

update_widgets(get_active_browser, 'play__start');


%--------------------------------------------
% DAEMON_UPDATE
%--------------------------------------------

function daemon_update(obj, eventdata, player)

% daemon_update - update interactive play display
% ------------------------------------------------
% 
% daemon_update(obj, eventdata, player)
%
% Input:
% ------
%  obj - calling player timer
%  eventdata - not used at the moment
%  player - player

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1953 $
% $Date: 2005-10-19 20:22:46 -0400 (Wed, 19 Oct 2005) $
%--------------------------------

%----------------------------------
% HANDLE PLAYER STATE
%----------------------------------

% NOTE: evaluate the redundancy of play state computation

%--
% update widgets
%--

% TODO: get samples from player to feed to widget, as part of widget data 

update_widgets(get_active_browser, 'play__update');

%--
% pause play
%--

if (get_env('PLAY_STATE') == 0) && is_playing
	player_pause; return;
end

%--
% resume play 
%--

if (get_env('PLAY_STATE') == 1) && ~is_playing	
	player_resume;
end

%----------------------------------
% UPDATE DISPLAY
%----------------------------------

%--
% get elapsed time from player start
%--
	
elapsed = get_player_elapsed;

% NOTE: if we can't get a time stop the daemon!

if isempty(elapsed)
	stop(obj); return;
end

%--
% get display state from daemon
%--

data = get(obj, 'userdata');

%--
% update line positions based on play progress
%--

if isempty(data.axes)
	return;
end

%--
% update time for all lines
%--

for k = 1:length(data.lines)

	try
		set(data.lines(k), 'xdata', (data.times(k) + elapsed) * [1, 1]);
	catch
		stop(obj); return;
	end

end

%--
% update time and text for labels if needed
%--

% NOTE: we make sure to flush display queue in case we updated something

if isempty(data.text)
	drawnow; return;
end

for k = 1:length(data.text)

	% TODO: use the player.sound to get the right time to display
	
	%--
	% update position and string
	%--
	
	pos = get(data.text(k), 'position'); pos(1) = data.times(k) + elapsed;
	
	time = map_time(player.sound, 'real', 'slider', pos(1));
	
	set(data.text(k), ...
		'position', pos, 'string', sec_to_clock(time) ...
	);

	%--
	% update visibility through clipping based on position
	%--
	
	par = get(data.text(k), 'parent'); xlim = get(par, 'xlim');
	
	if (pos(1) < xlim(1)) || (pos(1) > xlim(2))
		clip = 'on';
	else
		clip = 'off';
	end
	
	set(data.text(k), 'clipping', clip);
	
end

drawnow;


%--------------------------------------------
% DAEMON_STOP
%--------------------------------------------

function daemon_stop(obj, eventdata)

% daemon_stop - stop interactive display daemon
% ---------------------------------------------
% 
% daemon_stop(obj, eventdata)
%
% Input:
% ------
%  obj - player daemon
%  eventdata - not used at the moment

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1953 $
% $Date: 2005-10-19 20:22:46 -0400 (Wed, 19 Oct 2005) $
%--------------------------------

%--
% stop player
%--

% NOTE: this clears the play buffer memory

player_stop;

%--
% update widgets
%--

update_widgets(get_active_browser, 'play__stop');

%--
% get display state from daemon
%--

data = get(obj, 'userdata');

%--
% delete display lines
%--

% NOTE: try deleting stored handles, if it fails search and destroy

try	

	if ~isempty(data.lines)
		delete(data.lines);
	end

	if ~isempty(data.text)
		delete(data.text);
	end
 
catch

	delete(findobj(gcf, 'tag', 'PLAY_DISPLAY'));
	
end

%--
% stop and delete daemon
%--

stop(obj); delete(obj);

