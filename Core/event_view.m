function g = event_view(mode, par, m, ix, ax, data, light_flag)

% event_view - display event in sound and log browser 
% ---------------------------------------------------
%
% g = event_view('sound', par, m, ix, ax, data)
%
%   = event_view('log', par, m, ix, ax, data)
%
% Input:
% ------
%  par - handle to parent figure
%  m - log index
%  ix - event indices
%  ax - handles to axes available for display
%  data - figure userdata
%
% Output:
% -------
%  g - handles to event display objects

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

% TODO: make possible the display of deleted 

%---------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------
		
%--
% set default light_flag
%--

if (nargin < 7) || isempty(light_flag)
	light_flag = 0;
end

%--
% get userdata if needed
%--

if (nargin < 6) || isempty(data)
	data = get(par, 'userdata');
end 

%--
% get display axes if needed
%--

if nargin < 5
	ax = data.browser.axes;
end

%--
% get parent userdata in case of log browser display
%--

if strcmp(mode, 'log')
	data = get(data.browser.parent, 'userdata');
end 

%---------------------------------------------------
% SETUP
%---------------------------------------------------

%--
% copy browser state elements for convenience
%--

gopt = data.browser.grid;

sound = data.browser.sound;

ANNOT_VIEW = data.browser.annotation.view;

MEAS_VIEW = data.browser.measurement.view;

%--
% compute kHz flag
%--

khz_flag = strcmp(gopt.freq.labels, 'kHz');

%--
% other convenience variables
%--

% log index string

mstr = int2str(m);

% extracted channels array

ch = get_channels(data.browser.channels);

%--
% get events parent log
%--

if ischar(m)

	if ~strcmp('__ACTIVE_DETECTION__', m)
		g = []; return;
	end
	
	log = data.browser.active_detection_log;
	
	active_flag = 1;

else
	
	log = data.browser.log(m);
	
	active_flag = 0;
	
end 

% THESE QUICK RETURN TESTS NEED IMPROVEMENT

if (log.length < 1)
	g = []; return;
end

if (min(ix) < 0) || (max(ix) > log.length)	
	g = []; return;
end
	
%---------------------------
% DISPLAY EVENTS
%---------------------------

if numel(light_flag) == 1
	light_flag = repmat(light_flag, 1, numel(ix));
end

if numel(light_flag) ~= numel(ix)
	error('ghost indicator must exist for all or no events');
end

for k = 1:length(ix)

	%--
	% get event
	%--

	event = log.event(ix(k));

	%--
	% compute event coordinates in axes
	%--

	[x, y] = axes_coordinates(event, sound, khz_flag);

	%--
	% get display axes
	%--
	
	if strcmp(mode, 'sound')
		dax = data.browser.axes(find(ch == event.channel));
	else
		dax = findobj(ax, 'flat', 'tag', [mstr '.' int2str(ix(k))]);
	end

	if isempty(dax)
		continue;
	end
	
	%---------------------------------------------------
	% DISPLAY EVENT BOX
	%---------------------------------------------------

	%--
	% create event display objects
	%--

	style = log.linestyle; width = log.linewidth;

	%----------------------------
	% ACTIVE DETECTION DISPLAY
	%----------------------------
	
	if active_flag

		%----------------------------
		% SOUND BROWSER DISPLAY
		%----------------------------

		active_colors = 'ants';

		switch active_colors

			case ('candy') 	
				C1 = [1 0 0]; 
				C2 = [1 1 1];

			case ('fire')
				C1 = [1 0 0];
				C2 = [1 1 0];

			case ('ants')
				C1 = [0 0 0]; 
				C2 = [1 1 1];

			case ('blue-yellow')
				C1 = [1 1 0]; 
				C2 = [0 0 1];

			case ('red-green')
				C1 = [1 0 0]; 
				C2 = [0 1 0];

		end

		color = [0 0 0];
		
		width = data.browser.selection.linewidth;

		g(k,1) = line( ...
			'parent',dax, ...
			'xdata',x, ...
			'ydata',y, ...
			'linestyle','-', ...
			'linewidth',width, ...
			'color',C1 ...
		);

		g(k,2) = line( ...
			'parent',dax, ...
			'xdata',x, ...
			'ydata',y, ...
			'linestyle',':', ...
			'linewidth',width, ...
			'color',C2 ...
		);

		% display patch to enable selection

		g(k,3) = patch( ...
			'parent',dax, ...
			'xdata',x, ...
			'ydata',y, ...
			'EdgeColor','none', ...
			'FaceColor','none', ...
			'Erasemode','none' ...
		);

		tag = ['ACTIVE_DETECTION.' int2str(ix(k))];

		set(g(k,:),'tag',tag);

	%----------------------------
	% LOG DISPLAY
	%----------------------------

	else

		color = log.color;
		
		if light_flag
			color = (0.5 + 0.25 * color);
		end

		alpha = log.patch;

		%----------------------------
		% SOUND BROWSER DISPLAY
		%----------------------------

		if light_flag(k)
			hit_test = 'off';
		else
			hit_test = 'on';
		end
		
		if strcmp(mode, 'sound')

			if (alpha > 0) && ~light_flag(k)
				g(k,1) = patch( ...
					'parent',dax, ...
					'xdata',x, ...
					'ydata',y, ...
					'linestyle',style, ...
					'linewidth',width, ...
					'hittest', hit_test, ...
					'EdgeColor',color, ...
					'FaceColor',color, ...
					'FaceAlpha',alpha ...
				);	
			else
				g(k,1) = patch( ...
					'parent',dax, ...
					'xdata',x, ...
					'ydata',y, ...
					'linestyle',style, ...
					'linewidth',width, ...
					'hittest', hit_test, ...
					'EdgeColor',color, ...
					'FaceColor','none', ...
					'Erasemode','none' ...
				);
			end

			%--
			% display event id text
			%--

			if log.event_id

				xlim = get(dax, 'xlim'); ylim = get(dax, 'ylim');
				
				size = get_size_in(dax, 'pixels');
				
				pos = [x(1), y(3), 0];
				
				if pos(1) < xlim(1)
					pos(1) = xlim(1) + 20 * (data.browser.page.duration / size(3));
				end
	
				g(k,2) = text( ...
					'parent',dax, ...
					'position',pos, ...
					'string',['#' int2str(event.id)], ...
					'clipping','on', ...
					'color',color, ...
					'edgecolor',color, ...
					'linestyle','-', ...
					'margin',2, ...
					'HorizontalAlignment','right', ...
					'VerticalAlignment','bottom', ...
					'fontweight','bold', ...
					'rotation',0 ...
				);

				% NOTE: this is the same color used in 'text_highlight'
				
				if ~light_flag(k)
					text_highlight(g(k,2));
				end

			end

			tag = [mstr, '.', int2str(ix(k))];

			set(g(k,:), 'tag', tag);

		%----------------------------
		% LOG BROWSER DISPLAY
		%----------------------------

		else

			g(k,1) = line( ...
				'parent',dax, ...
				'xdata',x, ...
				'ydata',y, ...
				'linestyle',style, ...
				'linewidth',width, ...
				'color',color ...
			);

			if (alpha > 0)
				g(k,2) = patch( ...
					'parent',dax, ...
					'xdata',x, ...
					'ydata',y, ...
					'EdgeColor','none', ...
					'FaceColor',color, ...
					'FaceAlpha',alpha ...
				);	
			else
				g(k,2) = patch( ...
					'parent',dax, ...
					'xdata',x, ...
					'ydata',y, ...
					'EdgeColor','none', ...
					'FaceColor','none', ...
					'Erasemode','none' ...
				);
			end

			tag = [mstr '.' int2str(ix(k))];

			set(g(k,:), 'tag', tag);
			
			set(g(k,:), 'hittest', 'off');

			hi = findobj(dax, 'type', 'image');

			set(hi, 'tag', tag);

		end

	end
	
	%---------------------------------------------------
	% EARLY EXIT FOR LIGHTWEIGHT MODE
	%---------------------------------------------------
	
	if light_flag(k)
		continue;
	end	
	
	%---------------------------------------------------
	% DISPLAY LABEL (FROM TAGS)
	%---------------------------------------------------
	
	handles = display_label( ...
		dax, event, data.browser.sound, data.browser.grid, color, active_flag ...
	);
	
	set(handles, 'tag', tag);

	%---------------------------------------------------
	% DISPLAY EVENT MEASUREMENTS
	%---------------------------------------------------

	% TODO: exceptions must be handled here and extension warning produced
	
	measurement_display(par, m, ix(k), data);

	%---------------------------------------------------
	% ATTACH CONTEXT MENU ACTION
	%---------------------------------------------------	

	%--
	% attach event menu to patch context menu
	%--

	if active_flag
		
		set(g(k,3), ...
			'buttondownfcn', {@active_bdfun, par, khz_flag} ...
		);	
	
		continue;
		
	end

	if strcmp(mode, 'sound')

		if ~ishandle(g(k, 1))
			continue;
		end
		
		set(g(k,1), ...
			'buttondownfcn', {@event_menu_bdfun, 'sound', par, m, ix(k)} ...
		); 

	else

		log = data.browser.log(m); event = log.event(ix(k));
		
		set(hi, ...
			'buttondownfcn', {@callback_wrapper, @goto_event, get_active_browser, log_name(log), event.id} ...
		);
	
	
	end


end

%---------------------------
% HANDLE MARCHING ANTS
%---------------------------

if active_flag
	
	%--
	% get or create daemon
	%--
	
	daemon = marching_ants_daemon(g);
	
	%--
	% start marching ants on the lines given by handles
	%--
	
	if strcmp(get(daemon, 'running'), 'off')
		start(daemon);
	end
			
end


%--------------------------------------------------------
% ACTIVE_BDFUN
%--------------------------------------------------------

function active_bdfun(obj, eventdata, par, khz)

%--
% get event information from display
%--

ch = eval(get(get(obj,'parent'),'tag'));

time = fast_min_max(get(obj,'xdata'));

freq = fast_min_max(get(obj,'ydata'));

if (khz)
	freq = 1000 * freq;
end

%--
% create and set event as selection
%--

event = event_create( ...
	'channel', ch, ...
	'time', time, ...
	'freq', freq ...
);

figure(par);

% TODO: the pre-selection buttondown function should be different and provide for display of detection values

browser_bdfun(event);


%--------------------------------------------------------
% GET_ANT_TYPES
%--------------------------------------------------------

function types = get_ant_types

types = {'black', 'candy', 'fire'};


%--------------------------------------------------------
% GET_ANT_COLORS
%--------------------------------------------------------

function color = get_ant_colors(type)

%--
% check ant type
%--

types = get_ant_types;

if ~ismember(type, get_ant_types)
	type = types{1};
end

%--
% get ant colors using type
%--

switch type

	case 'black'
		color.one = [0 0 0]; color.two = [1 1 1];

	case 'candy'
		color.one = [1 0 0]; color.two = [1 1 1];

	case 'fire'
		color.one = [1 0 0]; color.two = [1 1 0];

end


%--------------------------------------------------------
% MARCHING_ANTS_DAEMON
%--------------------------------------------------------

function daemon = marching_ants_daemon(handles)

%--
% try to get daemon
%--

daemon = timerfind('name', 'XBAT Marching Ants');

%--
% create and configure daemon if needed
%--

if isempty(daemon)

	daemon = timer;

	% NOTE: timer speed is set for comfort and performance
	
	set(daemon, ...
		'name', 'XBAT Marching Ants', ...
		'timerfcn', @march_ants, ...
		'executionmode', 'fixedRate', ...
		'period', 0.5 ...
	);

end

%--
% set handles to march
%--

if nargin
	set(daemon, 'userdata', handles);
end


%--------------------------------------------------------
% MARCH_ANTS
%--------------------------------------------------------

function march_ants(obj, eventdata)

%--
% get handles to march
%--

handles = get(obj, 'userdata');

% NOTE: this is a temporary solution

if isempty(handles) || ~ishandle(handles(1,1))
	return;
end 

%--
% this code is very specific to this context
%--

par = get(get(handles(1), 'parent'), 'parent');

%--
% get and exchange line colors
%--

% NOTE: the first two columns contain the event boundary lines

c1 = get(handles(1,1), 'color');

c2 = get(handles(1,2), 'color');

set(handles(:,1), 'color', c2);

set(handles(:,2), 'color', c1);

% NOTE: move selection grid to back if needed

grid = findobj(par, 'tag', 'selection', 'type', 'line', 'linestyle', ':');

if ~isempty(grid)
	uistack(grid, 'bottom');
end

%--
% refresh figure
%--

% NOTE: this is a required costly step, consider 'drawnow'

refresh(par);

%--------------------------------------------------------
%  DISPLAY_LABEL
%--------------------------------------------------------

function handles = display_label(dax, event, sound, grid, color, active_flag)

% display_label - create graphical display of label tag
% -----------------------------------------------------

%---------------------------------------------
% INITIALIZATION
%---------------------------------------------

handles = [];

%--
% get label and rating
%--

label = get_label(event);

rating = event.rating;

if isempty(label) && isempty(event.rating)
	return;
end

%--
% build display string from label and rating
%--

str = {};

if ~isempty(label)
	str{end + 1} = label;
end

if ~isempty(event.rating) && event.rating
	str{end + 1} = strcat(str_line(rating, '*'), str_line(5 - rating, ' '));
end

%--
% compute text position using event
%--

axes_time = map_time(sound, 'slider', 'record', event.time);

x = sum(axes_time) / 2;

% TODO: text padding takes up half of the display time, make this faster

pad = get(dax, 'ylim'); 

pad = 0.0125 * pad(2);

if strcmp(grid.freq.labels, 'Hz')
	y = event.freq(2) + pad;
else
	y = (event.freq(2) / 1000) + pad;
end

%---------------------------------------------
% DISPLAY LABEL
%---------------------------------------------

if active_flag
	
	handles(end + 1) = text( ...
		'parent', dax, ...
		'position', [x, y, 0], ...
		'clipping', 'off', ...
		'string', str, ...
		'margin', 2, ...
		'edgecolor', [1 1 1], ...
		'linewidth', 1, ...
		'linestyle', '-', ...
		'color', color, ...
		'HorizontalAlignment', 'left', ...
		'VerticalAlignment', 'middle' ...
	);

else

	handles(end + 1) = text( ...
		'parent', dax, ...
		'position', [x, y, 0], ...
		'clipping', 'off', ...
		'string', str, ...
		'color', color, ...
		'HorizontalAlignment', 'left', ...
		'VerticalAlignment', 'middle' ...
	);

end

% TODO: make other modes available

mode = 'Diagonal';

switch mode
	
	case 'Horizontal'
		set(handles, 'rotation', 0);

	case 'Diagonal'
		set(handles, 'rotation', 45);
		
	case 'Vertical'
		set(handles, 'rotation', 90);

end

%--
% add highlight to display text
%--

opt = text_highlight; opt.initial_state = 0;

text_highlight(handles(1), '', opt);

