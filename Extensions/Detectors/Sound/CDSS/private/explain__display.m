function handles = explain__display(par, data, parameter, context)

% CDSS - explain__display

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

handles = [];

%-----------------------------------
% SETUP
%-----------------------------------

%--
% unpack parts of context
%--

ext = context.ext; page = context.page;

color = cdss_display_colors;

%-----------------------------------
% DISPLAY
%-----------------------------------

for k = 1:length(page.channels)
	
	%-----------------------------------
	% AMPLITUDE
	%-----------------------------------

	%--
	% find container axes
	%--
	
	ax = get_channel_tagged_axes(par, page.channels(k), 'amplitude');
	
	if isempty(ax)
		continue;
	end
	
	%--
	% set axes properties
	%--
	
	ylim = 1.1 * max(data.signal_amplitude(:)) * [0, 1];
	
	set(ax, 'ylim', ylim);
	
	%--
	% compute time grid
	%--

	% NOTE: this is precise
	
	time = data.time(1) + data.dt*[0:length(data.signal_amplitude)-1];

	%--
	% display signal amplitude
	%--

	handles(end + 1) = line( ...
		'parent', ax, ...
		'color', color.signal, ...
		'linestyle', '-', ...
		'visible', 'on', ...
		'xdata', time, ...
		'ydata', data.signal_amplitude ...
	);

	%--
	% display component amplitude
	%--
	
	handles(end + 1) = line( ...
		'parent', ax, ...
		'color', color.component, ...
		'linestyle', '-', ...
		'visible', 'on', ...
		'xdata', time, ...
		'ydata', data.component_amplitude ...
	);

	%-----------------------------------
	% COMPONENT
	%-----------------------------------

	%--
	% find container axes
	%--

	ax = get_channel_tagged_axes(par, page.channels(k), 'component');
	
	if isempty(ax)
		continue;
	end

	%--
	% set axes properties
	%--
	
	ylim = get(ax,'ylim'); ylim(2) = get_sound_rate(context.sound) / (2 * 1000);
	
	set(ax,'ylim',ylim);
	
	%--
	% display spectrogram
	%--
	
	handles(end + 1) = display_spectrogram(ax, data.spectrogram, data);
	
	%--
	% display events and components
	%--
	
	for j = 1:length(data.event)

		%--
		% get event and component
		%--
		
		event = data.event(j); component = data.component(j);
	
		%--
		% display event
		%--
		
		event.freq = event.freq / 1000;
		
		[vertex, control] = get_event_display_points(event);
		
		x = data.time(1) + vertex.x;
		
		y = vertex.y;
		
		control(:,1) = data.time(1) + control(:,1);
		
		handles(end + 1) = patch( ...
			'parent', ax, ...
			'hittest', 'off', ...
			'edgecolor', color.dark_gray, ...
			'facecolor', 'none', ...
			'xdata', x, ...
			'ydata', y, ...
			'linewidth', 1 ...
		);
	
	
		active_patch = patch( ...
			'parent', ax, ...
			'hittest', 'on', ...
			'buttondownfcn', {@toggle_event_callback, j, event, component, context}, ...
			'edgecolor', color.white, ...
			'facecolor', 'none', ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle', 'none', ...
			'linewidth', 1 ...
		);
	
		handles(end + 1) = active_patch;
		
% 		toggle_marker = line( ...
% 			'parent', ax, ...
% 			'xdata', control(4, 1), ...
% 			'ydata', control(4, 2), ...
% 			'marker', 'o', ...
% 			'markersize', 8, ...
% 			'linestyle', 'none', ...
% 			'linewidth', 1 ...
% 		);
% 	
% 		handles(end + 1) = toggle_marker;
% 		
% 		set(active_patch, 'userdata', toggle_marker);
		
		%--
		% display component lines
		%--

		x = data.time(1) + event.time(1) + (0:length(component.line)-1) * data.dt;
		
		y = event.freq(1) + (component.line * data.df / 1000);
		
		handles(end + 1) = line( ...
			'parent', ax, ...
			'hittest', 'off' , ...
			'color', color.component, ...
			'linestyle', '-', ...
			'linewidth', 2, ...
			'visible', 'on', ...
			'xdata', x, ...
			'ydata', y ...
		);
		
	end
	
	%--
	% store explain in cloud axes
	%--
	
	set(ax, 'userdata', data);
	
	%-----------------------------------
	% MODEL AND SYNTHESIS
	%-----------------------------------
	
	%--
	% find container axes
	%--
	
	ax = get_channel_tagged_axes(par, page.channels(k), 'synthesis');
	
	if isempty(ax)
		continue;
	end

end

%--
% trigger resize
%--

figure_resize(par);


%------------------------------------------------------------------------
% GET_CHANNEL_TAGGED_AXES
%------------------------------------------------------------------------

function ax = get_channel_tagged_axes(par, ch, tag)

% TODO: get by tag or channel and make complement second output 

%--
% build tag from channel and tag
%--

tag = [tag, ' ', int2str(ch)];

%--
% find tagged axes in parent
%--

ax = findobj(par, 'type', 'axes', 'tag', tag);


%------------------------------------------------------------------------
% TOGGLE_EVENT_CALLBACK
%------------------------------------------------------------------------

function toggle_event_callback(obj, eventdata, ix, event, component, context)

%---------------------
% SETUP
%---------------------

%--
% get parent figure, and axes
%--

par = ancestor(obj, 'figure');

store = get(obj, 'parent');

data = get(store, 'userdata');

%--
% create tags
%--

tag = get_event_tags(ix);

%---------------------
% TOGGLE
%---------------------

%--
% get and update inclusion state
%--

include = isequal(get(obj, 'linestyle'), ':');

include = ~include;

if include
	set(obj, 'linestyle', ':'); 
else
	set(obj, 'linestyle', 'none');
end

%---------------------
% OFF / DELETE
%---------------------

%--
% delete event from synthesis group
%--

if ~include
	
	%--
	% delete tagged display objects
	%--
	
	tags = struct2cell(tag);
	
	for k = 1:length(tags)
		delete(findobj(par, 'tag', tags{k}));
	end
	
	%--
	% update store and return
	%--
	
	data.component(ix).model = [];
	
	set(store,'userdata', data);
	
	%--
	% update display
	%--
	
	display_model(par, data, context);
	
	return;
	
end

%---------------------
% ON / ADD 
%---------------------

%--
% fit model to component and save in store
%--

setptr(par, 'watch'); drawnow;

% TODO: reveal knots as a parameter in some way

knots = 7; N = 100;

model = component_fit_spline(component, knots);

data.component(ix).model = model;
	
set(store,'userdata', data);

%--
% update display
%--

display_model(par, data, context);

setptr(par, 'arrow'); drawnow;


%------------------------------------------------------------------------
% DISPLAY_SPECTROGRAM
%------------------------------------------------------------------------

function handle = display_spectrogram(ax, spectrogram, data)

delete(findobj(ax, 'tag', 'SPECTROGRAM_IMAGE'));

%--
% display spectrogram image in axes
%--

hold(ax, 'on');

[rows, cols] = size(spectrogram); 

time = data.time(1) + (0:cols-1) * data.dt;

handle = imagesc( ...
	time, ...
	(0:rows-1) * data.df / 1000, ...
	lut_dB(spectrogram), ...
	'tag', 'SPECTROGRAM_IMAGE', ...
	'hittest', 'off', ...
	'parent', ax ...
);

%--
% set parent colormap
%--

par = get(ax, 'parent');

set(par, 'colormap', colormap(flipud(gray))); cmap_scale;


%------------------------------------------------------------------------
% DISPLAY_MODEL
%------------------------------------------------------------------------

function handles = display_model(par, data, context)

%------------------------------
% SETUP
%------------------------------

color = cdss_display_colors;

N = 100; handles = [];

%------------------------------
% DISPLAY SPECTROGRAM
%------------------------------

%--
% find synthesis axes
%--

ax = get_channel_tagged_axes(par, data.event(1).channel, 'synthesis');

if isempty(ax)
	return;
end

delete(get(ax, 'children'));

%--
% display synthetic spectrogram
%--

[ignore, ignore, X] = get_model_signal(data, context);

display_spectrogram(ax, X, data);

%------------------------------
% DISPLAY EVENTS
%------------------------------

for k = 1:length(data.component)

	%--
	% get component and model
	%--

	component = data.component(k);

	if isempty(component.model)
		continue;
	end
	
	event = data.event(k); event.freq = event.freq / 1000;
	
	tag = get_event_tags(k);
	
	%--
	% find synthesis axes
	%--

	ax = get_channel_tagged_axes(par, event.channel, 'synthesis');

	if isempty(ax)
		return;
	end
	
	%--
	% display event in synthesis axes
	%--

	vertex = get_event_display_points(event);

	x = data.time(1) + vertex.x;

	y = vertex.y;

	% TODO: tag adequately

% 	if isempty(component.model)
% 		
% 		patch( ...
% 			'parent', ax, ...
% 			'hittest', 'off', ...
% 			'tag', tag.block, ...
% 			'edgecolor', 0.5 * ones(1, 3), ...
% 			'facecolor', 'none', ...
% 			'xdata', x, ...
% 			'ydata', y, ...
% 			'linestyle', '-', ...
% 			'linewidth', 1 ...
% 		);
% 		
% 		patch( ...
% 			'parent', ax, ...
% 			'hittest', 'off', ...
% 			'tag', tag.block, ...
% 			'edgecolor', ones(1, 3), ...
% 			'facecolor', 'none', ...
% 			'xdata', x, ...
% 			'ydata', y, ...
% 			'linestyle', ':', ...
% 			'linewidth', 1 ...
% 		);
% 		
% 		return;
% 	
% 	else

		patch( ...
			'parent', ax, ...
			'hittest', 'off', ...
			'tag', tag.block, ...
			'edgecolor', color.dark_gray, ...
			'facecolor', 'none', ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle', '-', ...
			'linewidth', 1 ...
		);
	
		patch( ...
			'parent', ax, ...
			'hittest', 'on', ...
			'buttondownfcn', {@edit_model_callback, par, k, event, component, context}, ...
			'tag', tag.block, ...
			'edgecolor', color.white, ...
			'facecolor', 'none', ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle', ':', ...
			'linewidth', 1 ...
		);

% 	end

	%--
	% display component lines
	%--

	% NOTE: we probably don't do this now, redundancy and clutter
	
% 	x = data.time(1) + event.time(1) + (0:length(component.line) - 1) * data.dt;
% 
% 	y = event.freq(1) + (component.line * data.df / 1000);
% 
% 	line( ...
% 		'parent', ax, ...
% 		'hittest', 'off' , ...
% 		'tag', tag.line, ...
% 		'color', red, ...
% 		'linestyle', '-', ...
% 		'linewidth', 2, ...
% 		'visible', 'on', ...
% 		'xdata', x, ...
% 		'ydata', y ...
% 	);

	%--
	% display model
	%--
	
	[t, y] = spline_eval(component.model.y, component.model.t, N);
	
	x = data.time(1) + t;

	handles(end + 1) = line( ...
		'parent', ax, ...
		'hittest', 'off' , ...
		'tag', tag.model, ...
		'color', color.model, ...
		'linestyle', '-', ...
		'linewidth', 2, ...
		'visible', 'on', ...
		'xdata', x, ...
		'ydata', y ...
	);

	%--
	% find amplitude axes
	%--

	ax = get_channel_tagged_axes(par, event.channel, 'amplitude');

	if isempty(ax)
		return;
	end
	
	delete(findobj(ax, 'tag', tag.amplitude));

	%--
	% display component amplitude
	%--

	x = data.time(1) + event.time(1) + (0:length(component.amplitude) - 1) * data.dt;

% 	x = data.time(1) + linspace(component.model.t(2), component.model.t(end - 1), length(component.amplitude));
	
	y = component.amplitude;

	line( ...
		'parent', ax, ...
		'hittest', 'off' , ...
		'tag', tag.amplitude, ...
		'color', color.model, ...
		'linestyle', '-', ...
		'linewidth', 2, ...
		'visible', 'on', ...
		'xdata', x, ...
		'ydata', y ...
	);

end


%----------------------------------------------------------------------
% EDIT_MODEL_CALLBACK
%----------------------------------------------------------------------

function edit_model_callback(obj, eventdata, par, k, event, component, context)

%--
% open model editor
%--

result = edit_model_dialog(par, component, context);

if isempty(result.values)
	return;
end

%--
% update model in store
%--

ax = get_channel_tagged_axes(par, event.channel, 'component');

data = get(ax, 'userdata');

data.component(k).model = result.values.component.model;

data.component(k).amplitude = result.values.component.amplitude;

set(ax, 'userdata', data);

%--
% display edited model
%--

display_model(par, data, context);


%----------------------------------------------------------------------
% GET_EVENT_TAGS
%----------------------------------------------------------------------

function tag = get_event_tags(k)

% get_event_tags - get tags used in event displays as struct
% ----------------------------------------------------------
%
% tag = get_event_tags(k)
%
% Input:
% ------
%  k - event index
%
% Output:
% -------
%  tag - tags struct

tag.amplitude = ['amplitude #', int2str(k)];

tag.block = ['building_block #', int2str(k)];

tag.line = ['line #', int2str(k)];

tag.model = ['model #', int2str(k)];



