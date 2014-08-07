function handles = selection_event_display(event, dax, data, log_ix, event_ix) 

% selection_event_display - draw selection lines, patch, and control points
% -------------------------------------------------------------------------
%
% handles = selection_event_display(event, dax, data, log_ix, event_ix)
%
% Input:
% ------
%  event - event
%  dax - display axes
%  data - parent browser state
%  log_ix - log index of this event
%  event_ix - event index in log
%
% Output:
% -------
%  handles - graphics object handles

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

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% set map according to logged state of selection
%--

map = 1;

% NOTE: non-logged selections do not require time mapping

if nargin < 5 || isempty(event_ix)
	event_ix = []; map = 0;
end

if nargin < 4 || isempty(log_ix)
	log_ix = []; map = 0;
end

%--
% get axes if needed
%--

if isempty(dax)
	dax = findobj(data.browser.axes, 'type', 'axes', 'tag', int2str(event.channel));
end

% NOTE: we have no canvas to express ourselves

if isempty(dax) 
	handles = []; return;
end

%--
% get out if the event is out-of-page
%--

page = get_browser_page([], data);

if ~event_in_page(event, page, data.browser.sound)
	handles = []; return;
end

%-------------------------
% DISPLAY SELECTION
%-------------------------

%--
% compute axis-level coordinates for event and control points
%--

[x, y, ctrl] = axes_coordinates(event, data.browser.sound, strcmp(data.browser.grid.freq.labels, 'kHz'), map);

%--
% display selection using line and patch
%--

width = max(min(data.browser.selection.linewidth / 2, 2), 1/2);

% opengl correction in display

if strcmp(get(gcbf, 'Renderer'), 'OpenGL')
	
	switch width
		
		case 1
			width = 0.5;
			
		case 2
			width = 1.5;
			
	end 
	
end

handles(1) = line( ...
	'parent', dax, ...
	'xdata', x, ...
	'ydata', y, ... 
	'LineStyle', data.browser.selection.linestyle, ...
	'Color', data.browser.selection.color, ...
	'LineWidth', data.browser.selection.linewidth, ...
	'EraseMode', 'normal', ...
	'UserData', 1 ...
);

if isempty(event.id)
	
	if data.browser.selection.patch > 0
		handles(2) = patch( ...
			'parent', dax, ...
			'xdata', x, ...
			'ydata', y, ...
			'EdgeColor', 'none', ...
			'FaceColor', data.browser.selection.color, ...
			'FaceAlpha', data.browser.selection.patch, ...
			'UserData', 2 ...
		);
	else
		handles(2) = patch( ...
			'parent', dax, ...
			'xdata', x, ...
			'ydata', y, ...
			'EdgeColor', 'none', ...
			'FaceColor', 'none', ...
			'UserData', 2 ...
		);
	end
	
	%--
	% play selection on double click
	%--
	
	set(handles(2), 'buttondownfcn', @double_click_play);
	
else
	
	handles(2) = handles(1);
	
end

%--
% display grid lines
%--

xl = get(dax, 'xlim');
yl = get(dax, 'ylim');

yl = [yl(1) y(1) nan y(3) yl(2)];
xl = [xl(1) x(1) nan x(2) xl(2)];

rgb = data.browser.grid.color;

% time grid 

handles(3) = line( ...
	'parent',dax, ...
	'xdata', x(1)*ones(1,5), ...
	'ydata', yl, ...
	'linestyle', ':', ...
	'Color', rgb, ...
	'Linewidth', 0.5, ...
	'UserData', 3 ...
);

handles(4) = line( ...
	'parent', dax, ...
	'xdata', x(2)*ones(1,5), ...
	'ydata', yl, ...
	'linestyle', ':', ...
	'Color', rgb, ...
	'Linewidth', 0.5, ...
	'UserData', 4 ...
);

% frequency grid

handles(5) = line( ...
	'parent', dax, ...
	'xdata', xl, ...
	'ydata', y(1)*ones(1,5), ...
	'linestyle', ':', ...
	'Color', rgb, ...
	'Linewidth', 0.5, ...
	'UserData', 5 ...
);

handles(6) = line( ...
	'parent', dax, ...
	'xdata', xl, ...
	'ydata', y(3)*ones(1,5), ...
	'linestyle', ':', ...
	'Color', rgb, ...
	'Linewidth', 0.5, ...
	'UserData', 6 ...
);

% set visibility of grid lines

set(handles(3:6), 'hittest', 'off');

if ~data.browser.selection.grid
	set(handles(3:6), 'visible', 'off'); 
end

%----------------------------------------------------------------
% CREATE GRID LABELS
%----------------------------------------------------------------

%--
% create selection label strings
%--

par = get_active_browser;

[time, freq] = selection_labels(par, event, data);

%--
% time labels
%--

handles(7) = text( ...
	'parent', dax, ...
	'position', [(x(1) - 0.0375), (0.975 * yl(end)), 0], ...
	'string', time{1}, ...
	'HorizontalAlignment', 'right', ...
	'VerticalAlignment', 'top', ...
	'UserData', 7 ...
);

handles(8) = text( ...
	'parent', dax, ...
	'position', [(x(2) + 0.0375), (0.975 * yl(end)), 0], ...
	'string', time{4}, ...
	'HorizontalAlignment', 'left', ...
	'VerticalAlignment', 'top', ...
	'UserData', 8 ...
);

%--
% frequency labels
%--

tt1 = event.time(1) - data.browser.time;

tt2 = (data.browser.time + data.browser.page.duration) - event.time(2);

tmp = (0.0375 * (yl(end) - yl(1))) / data.browser.page.duration;

if (tt1 <= tt2)

	handles(9) = text( ...
		'parent', dax, ...
		'position', [(xl(end) - 0.0375), (y(1) - tmp), 0], ...
		'string', freq{1}, ...
		'HorizontalAlignment', 'right', ...
		'VerticalAlignment', 'top', ...
		'UserData', 9 ...
	);

	handles(10) = text( ...
		'parent', dax, ...
		'position', [(xl(end) - 0.0375), (y(3) + tmp), 0], ...
		'string', freq{4}, ...
		'HorizontalAlignment', 'right', ...
		'VerticalAlignment', 'bottom', ...
		'UserData', 10 ...
	);
	
else

	handles(9) = text( ...
		'parent', dax, ...
		'position', [xl(1) + 0.0375, (y(1) - tmp), 0], ...
		'string', freq{1}, ...
		'HorizontalAlignment', 'left', ...
		'VerticalAlignment', 'top', ...
		'UserData', 9 ...
	);

	handles(10) = text( ...
		'parent', dax, ...
		'position', [xl(1) + 0.0375, (y(3) + tmp), 0], ...
		'string', freq{4}, ...
		'HorizontalAlignment', 'left', ...
		'VerticalAlignment', 'bottom', ...
		'UserData', 10 ...
	);
	
end

%--
% set visibility of grid labels
%--

set(handles(7:10), 'Color', rgb);

text_highlight(handles(7:10));

if ~data.browser.selection.grid || ~data.browser.selection.label
	set(handles(7:10), 'visible', 'off');
end

%----------------------------------------------------------------
% CREATE CONTROL POINTS
%----------------------------------------------------------------

%--
% create control points
%--

for k = 1:9
	
	if ~isempty(event_ix)
		fcn_str = ['selection_edit(''start'',' int2str(k) ',' int2str(log_ix) ',' int2str(event_ix) ')'];
	else
		fcn_str = ['selection_edit(''start'',' int2str(k) ')'];
	end
	
	tmp = line( ...
		'parent', dax, ...
		'xdata', ctrl(k,1), ...
		'ydata', ctrl(k,2), ...
		'marker', 's', ...
		'color', data.browser.selection.color, ...
		'linewidth', (width / 2) + eps, ...
		'markersize', 8, ... 
		'ButtonDownFcn', fcn_str, ...
		'UserData', 10 + k ...
	);

	handles(10 + k) = tmp;
	
end

%--
% change center control point marker
%--

set(tmp, 'marker', '+');

%--
% set visibility of control points
%--

if ~data.browser.selection.control
	set(handles(11:19), ...
		'visible', 'off', 'hittest', 'off' ...
	);
end

%--
% set selection object tags
%--

set(handles, 'tag', 'selection');

%--
% enable zoom to selection
%--

selection = data.browser.selection; selection.event = event;

if is_log_browser(par)
	return;
end

update_selection_buttons(par, selection);


%-------------------------------------------------------------
% DOUBLE_CLICK_PLAY
%-------------------------------------------------------------

function double_click_play(obj, eventdata)

% double_click_play - play selection on double click
% --------------------------------------------------

if double_click(obj)

	browser_sound_menu(ancestor(obj, 'figure'), 'Play Selection');

end
