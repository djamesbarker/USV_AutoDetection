function play_model_callback(obj, eventdata, store, context)

% NOTE: we use double click trigger for this callback

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

if ~double_click(obj, 0.25)
	return;
end 
 
%---------------------------
% INDICATE PLAY
%---------------------------

%--
% setup
%--

tint = [0.8, 0.9, 1];

%--
% get handles of objects to flash
%--

par = get(obj, 'parent'); 

ax = findobj(par, 'type','axes', 'color', [1 1 1]);

%--
% get base and flash colormap
%--

map0 = get(par, 'colormap');

map1 = 0.7 * map0 + 0.3 * ones(size(map0,1),1) * tint;

%--
% color flash
%--

set(par, 'colormap', map1);

set(ax, 'color', map1(1,:));

drawnow;

%---------------------------
% PLAY
%---------------------------

try

	%--
	% get explain data, this contains events and components
	%--

	data = get(store, 'userdata');

	%--
	% create and play model signal
	%--

	[signal, rate] = get_model_signal(data, context);
	
	%--
	% create temporary file and sound
	%--

	temp = [tempname, '.wav'];

	wavwrite(signal, rate, 16, temp);

	sound = sound_create('file', temp);

	%--
	% get play axes
	%--

	[ax, top] = get_play_axes(context.par);

	xlim = get(obj,'xlim'); time = xlim(1);

	tax = [time * ones(length(ax), 1), ax(:), top(:)];

	%--
	% set player display options
	%--

	% NOTE: set marker and label to 'none' for performance

	% 	opt.color = data.browser.selection.color;

	color = cdss_display_colors;

	opt.color = color.model;

	opt.linestyle = '-';

	opt.marker = 's';

	opt.label = 'time'; 

	%--
	% get active filters so we can pass signal filter to player
	%--

	% TODO: reconsider the store for these filters

	data = get_browser(context.par);

	active = get_active_filters(context.par, data);

	%--
	% create sound player
	%--

	p = sound_player( ...
		sound, 'time', ...
		0, ...
		sound.duration, ...
		1, ...
		data.browser.play.speed, ...
		active.signal, ...
		tax, opt ...
	);

	%--
	% restore colors, end flash
	%--

	set(par, 'colormap', map0);
	
	set(ax, 'color', [1 1 1]);
	
	%--
	% start play display timer
	%--

	% NOTE: this display timer starts the audioplayer
	
	start(p);
	
catch
	
	%--
	% restore colors, end flash
	%--

	set(par, 'colormap', map0);
	
	set(ax, 'color', [1 1 1]);
	
end
