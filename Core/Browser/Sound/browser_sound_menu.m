function out = browser_sound_menu(h,str,flag)

% browser_sound_menu - browser sound view and play options menu
% -------------------------------------------------------------
%
% browser_sound_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - info flag (def: '')
%
% Output:
% -------
%  out - command dependent output

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

%----------------------------------------------------------------------
% SETUP
%----------------------------------------------------------------------

%--
% set info output flag
%--

if (nargin < 3) || isempty(flag)
	flag = 0;
end

%--
% set command string
%--

if nargin < 2
	str = 'Initialize';
end

%--
% perform command sequence
%--

if iscell(str)
	
	for k = 1:length(str)
		try
			browser_sound_menu(h,str{k}); 
		catch
			disp(' '); 
			warning(['Unable to execute command ''' str{k} '''.']);
		end
	end
	
	return;	
	
end

%--
% set handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% set default output
%--

out = [];

%--
% main switch
%--

switch (str)

%----------------------------------------------------------------------
% CREATE MENU
%----------------------------------------------------------------------

%------------------------------------------------
% Initialize
%------------------------------------------------

case ('Initialize')
	
	% add code ensure creation. create while menu does not exist
	
	% the existing code should be part of the above
	
	%--
	% check for existing menu
	%--
	
	if (get_menu(h,'Sound'))
		return;
	end

	%--
	% get userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% Sound
	%--

	L = { ...
		'Sound', ...
		'Attributes', ...
		'Show Files ...', ...
		'Play', ...
		'Play Options', ...
		'Volume Control ...', ...
		'Sound Recorder ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{6} = 'on';
	
	mg = menu_group(h,'browser_sound_menu',L,S);	
	data.browser.sound_menu.sound = mg;

	set(mg(1),'position',4);
	
	%--
	% update attributes menu
	%--

	attr_menu = findobj(mg, 'label', 'Attributes');

	if ~isempty(attr_menu)
		attribute_menu(attr_menu(1), get_active_library, data.browser.sound);
	end
	
% 	%--
% 	% Attributes
% 	%--
% 
% 	% date and time
% 	
% 	tmp = data.browser.sound.realtime;
% 	
% 	if (isempty(tmp))
% 		realtime = '(Not Available)';
% 	else
% 		realtime = datestr(tmp);
% 	end
% 
% 	% calibration
% 	
% 	tmp = data.browser.sound.calibration;
% 	
% 	if (isempty(tmp))
% 		calibration = '(Not Available)';
% 	else
% 		calibration = '';
% 	end
% 
% 	% geometry
% 	
% 	tmp = data.browser.sound.geometry;
% 	
% 	if (isempty(tmp))
% 		geometry = '(Not Available)';
% 	else
% 		geometry = '';
% 	end
% 
% 	% speed of sound
% 	
% 	tmp = data.browser.sound.speed;
% 	
% 	if (isempty(tmp))
% 		speed = '(Not Available)';
% 	else
% 		speed = [num2str(tmp), ' M/s'];
% 	end
% 	
% 	%--
% 	% create menu for multiple file sounds
% 	%--
% 		
% 	[ignore,type] = is_sound_type(data.browser.sound.type);
% 	
% 	if ~(strcmp(type,'file') || strcmp(type,'variable') || strcmp(type, 'synthetic'))
% 		
% 		%--
% 		% files menu
% 		%--
% 		
% 		files = ['Files:  (' num2str(length(data.browser.sound.file)) ' Files)'];
% 
% 		% NOTE: the 'pcmbitwidth' field has been renamed to 'samplesize'
% 		
% 		%--
% 		% get sample size
% 		%--
% 		
% % 		db_disp('samplesize is empty');
% 		
% 		if isfield(data.browser.sound, 'pcmbitwidth')
% 			sample_size = data.browser.sound.pcmbitwidth;
% 		else
% 			sample_size = data.browser.sound.samplesize;
% 		end
% 		
% 		%--
% 		% get samplerate string
% 		%--
% 	
% 		% TODO: make little functions for stuff like this
% 		
% 		temp = data.browser.sound;
% 		
% 		str_samplerate = [num2str(get_sound_rate(temp)), ' Hz'];
% 		
% 		if (temp.samplerate ~= get_sound_rate(temp))
% 			str_samplerate = [str_samplerate, ' (', num2str(temp.samplerate), ' Hz)'];
% 		end
% 			
% 		%--
% 		% create menu
% 		%--
% 		
% 		L = { ...
% 			['Type:  ' type], ...
% 			['Path:  ' data.browser.sound.path], ...
% 			files, ...
% 			['Date and Time:  ' realtime], ...
% 			['Duration:  ' sec_to_clock(data.browser.sound.duration)], ...
% 			['Channels:  ' num2str(data.browser.sound.channels)], ...
% 			['Channel Calibration:  ' calibration], ...
% 			['Channel Geometry:  ' geometry], ...
% 			['Speed of Sound:  ' speed], ...
% 			['Sampling Rate:  ' str_samplerate], ...
% 			['Bits Per Sample:  ' num2str(sample_size)] ...
% 		};
% 	
% 		n = length(L);
% 			
% 		S = bin2str(zeros(1,n));
% 		S{2} = 'on';
% 		S{4} = 'on';
% 		S{6} = 'on';
% 		S{9} = 'on';
% 		S{10} = 'on';
% 		
% 		A = cell(1,n);
% 		
% 		mg = menu_group(get_menu(h,'Attributes'),'',L,S,A);
% 		
% 		data.browser.sound_menu.data = mg;
% 	
% 		%--
% 		% File
% 		%--
% 		
% 		L = data.browser.sound.file;
% 		
% 		data.browser.sound_menu.data_file =  ...
% 			menu_group(get_menu(mg,files),'',L);
% 			
% 	%--
% 	% create menu for single file sounds
% 	%--
% 	
% 	else
% 
% 		% NOTE: the 'pcmbitwidth' field has been renamed to 'samplesize'
% 		
% 		if (isfield(data.browser.sound,'pcmbitwidth'))
% 			sample_size = data.browser.sound.pcmbitwidth;
% 		else
% 			sample_size = data.browser.sound.samplesize;
% 		end
% 		
% 		L = { ...
% 			['Type:  ' type], ...
% 			['Path:  ' data.browser.sound.path], ...
% 			['File:  ' data.browser.sound.file], ...
% 			['Date and Time:  ' realtime], ...
% 			['Duration:  ' sec_to_clock(data.browser.sound.duration)], ...
% 			['Channels:  ' num2str(data.browser.sound.channels)], ...
% 			['Channel Calibration:  ' calibration], ...
% 			['Channel Geometry:  ' geometry], ...
% 			['Speed of Sound:  ' speed], ...
% 			['Sampling Rate:  ' num2str(data.browser.sound.samplerate) ' Hz'], ...
% 			['Bits Per Sample:  ' num2str(sample_size)], ...
% 		};
% 	
% 		n = length(L);
% 			
% 		S = bin2str(zeros(1,n));
% 		S{2} = 'on';
% 		S{4} = 'on';
% 		S{6} = 'on';
% 		S{9} = 'on';
% 		S{10} = 'on';
% 
% 		mg = menu_group(get_menu(h,'Attributes'),'',L,S);
% 		
% 		data.browser.sound_menu.data = mg;
% 		
% 	end
	
	nch = data.browser.sound.channels;
	
	%--
	% Play
	%--
	
	if (isempty(data.browser.parent))
		
		L = { ...
			'Page', ...
			'Selection' ...
		};
	
		n = length(L);		
		S = bin2str(zeros(1,n));

		mg = menu_group(get_menu(h,'Play'),'browser_sound_menu',L,S);
		data.browser.sound_menu.play = mg;
		
		set(mg(2),'enable','off'); % turn off selection play since there is no selection
		
	end
	
	%--
	% Play Options
	%--
	
	L = { ...
		'Rate', ...
		'Left Channel', ...
		'Right Channel', ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';

	data.browser.sound_menu.play_options = menu_group(get_menu(h,'Play Options'),'browser_sound_menu',L,S);
	
	%--
	% Rate
	%--
	
	L = { ...
		'Normal Rate', ...
		'1/2 Rate', ...	
		'1/4 Rate', ...	
		'1/8 Rate', ... 
		'1/16 Rate', ...
		'1/32 Rate', ...
		'2x Rate' ...	
		'4x Rate', ...	
		'8x Rate', ...
		'16x Rate', ...
		'32x Rate', ...
		'Other Rate ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{7} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	mg = menu_group(get_menu(h,'Rate'),'browser_sound_menu',L,S,A);
	data.browser.sound_menu.play_speed = mg;
	
	ix = find(data.browser.play.speed == [1, 1/2, 1/4, 1/8, 1/16, 1/32, 2, 4, 8, 16, 32]);
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		set(mg(end),'check','on');
	end
	
	%--
	% Left Channel and Right Channel
	%--
	
	clear L;
	
	for k = 1:data.browser.sound.channels
		L{k} = ['Channel ' num2str(k)];
	end 
	
	mg = menu_group(get_menu(data.browser.sound_menu.play_options,'Left Channel'),'browser_sound_menu',L);
	data.browser.sound_menu.left_channel = mg;
	set(mg(data.browser.play.channel(1)),'check','on');
	
	mg = menu_group(get_menu(data.browser.sound_menu.play_options,'Right Channel'),'browser_sound_menu',L);
	data.browser.sound_menu.right_channel = mg;
	set(mg(data.browser.play.channel(2)),'check','on');

	%--
	% update userdata to include sound menu
	%--
	
	set(h,'userdata',data);
	
%------------------------------------------------
% Show Files ...
%------------------------------------------------

case ('Show Files ...')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% open folder containing files in explorer
	%--
	
	eval(['!explorer ' data.browser.sound.path ' &']);
	
%------------------------------------------------
% Page (Play Page)
%------------------------------------------------

case {'Page', 'Play Page'}
	
	%-------
	% INFO
	%-------
	
	if flag
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	%--
	% stop and delete previous player
	%--
	
	obj = timerfind('name', 'PLAY_TIMER'); 
	
	if ~isempty(obj)
		stop(obj); delete(obj);
	end
		
	%--
	% get parent state
	%--
	
	data = get_browser(h);
	
	%--
	% get play axes
	%--
	
	[ax, top] = get_play_axes(h, data);
	
	tax = [data.browser.time * ones(size(ax(:))), ax(:), top(:)];
	
	%--
	% set player display options
	%--
	
	opt = sound_player;
	
	% NOTE: set marker and label to 'none' for better performance
	
% 	opt.label = 'none'; 
	
	%--
	% get active filters so we can pass signal filter to player
	%--

	% TODO: reconsider the store for these filters
	
	active = get_active_filters(h, data);
	
	% NOTE: we add a page to the filter context
	
	if ~isempty(active.signal_filter)
		
		page.start = data.browser.time;

		page.duration = data.browser.page.duration;

		page.channels = data.browser.play.channel;

		active.signal_context.page = page;
		
	end
	
	%--
	% create sound player
	%--
	
	p = sound_player( ...
		data.browser.sound, 'time', ...
		data.browser.time, ...
		data.browser.page.duration, ...
		data.browser.play.channel, ...
		data.browser.play.speed, ...
		active, ...
		tax, opt ...
	);

	%--
	% start play display timer
	%--
		
	% NOTE: this display timer starts the audioplayer
	
	start(p);
			
	%--
	% reset focus on parent
	%--
	
	figure(h);
	
%------------------------------------------------
% Play Selection, Selection (Play Selection)
%------------------------------------------------

case {'Selection', 'Play Selection', 'Play Event'}
	
	%-------
	% INFO
	%-------
	
	if flag
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	%--
	% stop and delete previous play timers
	%--
	
	obj = timerfind('name','PLAY_TIMER'); 
	
	if ~isempty(obj)
		stop(obj); delete(obj);
	end
	
	%--
	% get parent state
	%--
	
	data = get_browser(h);
	
	play = data.browser.play;
	
	%--
	% get selection event if available
	%--
	
	if isempty(data.browser.selection.handle)
		return;
	end 
	
	event = data.browser.selection.event;
	
	%--
	% get play axes
	%--
	
	data.browser.play.channel(:) = event.channel;
	
	[ax, top] = get_play_axes(h, data);
	
	tax = [event.time(1) * ones(size(ax(:))), ax(:), top(:)];

	%--
	% set player display options
	%--
	
	opt = sound_player;

	% NOTE: set marker and label to 'none' for performance
	
% 	opt.label = 'none'; 
	
	%--
	% get active filter so that we can pass signal filter to player
	%--

	% NOTE: we need a page as part of any filter context
	
	page.start = data.browser.time;

	page.duration = data.browser.page.duration;
	
	page.channels = event.channel;
	
	active = get_active_filters(h, data);
	
	if ~isempty(active.signal_filter)
		
		active.signal_context.page = page;
		
	end
	
	% TODO: this is where we add the event band filter and amplification, changes in 'buffered_player'
	
	% NOTE: the active filter should always be first

	if play.band_filter
		
		% TODO: factor this as 'get_event_band_filter', empty when no event available
		
		[ext, ignore, context] = get_browser_extension('signal_filter', h, 'Bandpass', data);
		
		context.page = page;
		
		ext.parameter.min_freq = event.freq(1);
		
		ext.parameter.max_freq = event.freq(2);
		
% 		parameter.transition = 0.1 * nyq;
		
		try
			[ext.parameter, context] = ext.fun.parameter.compile(ext.parameter, context);
		catch
			extension_warning(ext, 'Parameter compilation failed.', lasterror);
		end
		
		if ~isempty(active.signal_filter)
			active.signal_filter(end + 1) = ext;
		else
			active.signal_filter = ext; 
			
			active.signal_context = context;
		end
		
	end
	
	%--
	% create sound player
	%--
	
	p = sound_player( ...
		data.browser.sound, 'time', ...
		event.time(1), ...
		event.duration, ...
		event.channel, ...
		data.browser.play.speed, ...
		active, ...
		tax, opt ...
	);

	%--
	% start play display timer
	%--
		
	% NOTE: this display timer starts the audioplayer
	
	start(p);
	
	%--
	% reset focus on parent
	%--
	
	figure(h);
	
%------------------------------------------------
% Rate
%------------------------------------------------

case 'Normal Rate'
	
	%-------
	% INFO
	%-------
	
	if flag
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	%--
	% update userdata
	%--
	
	data = get(h,'userdata');
	
	data.browser.play.speed = 1;
	
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.sound_menu.play_speed,'check','off');
	
	set(get_menu(h,str),'check','on');
	
case ({'1/2 Rate','1/4 Rate','1/8 Rate','1/16 Rate','1/32 Rate'})
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	%--
	% update userdata
	%--
	
	data = get(h,'userdata');
	
	data.browser.play.speed = eval(strtok(str,' '));
	
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.sound_menu.play_speed,'check','off');
	
	set(get_menu(h,str),'check','on');
	
case ({'2x Rate','4x Rate','8x Rate','16x Rate','32x Rate'})
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	%--
	% update userdata
	%--
	
	data = get(h,'userdata');
	
	data.browser.play.speed = eval(strtok(str,'x'));
	
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.sound_menu.play_speed,'check','off');
	
	set(get_menu(h,str),'check','on');
	
case ({'Other Rate ...','Rate ...'})
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	%--
	% setup palette
	%--
	
	pal = browser_palettes(h, 'Play');
	
	palette_toggle(h, 'Play', 'Rate', 'open');
	
	figure(pal); return;
	
%------------------------------------------------
% Left Channel, Right Channel
%------------------------------------------------

case {'Left Channel','Right Channel'}
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	ax = data.browser.axes;
	im = data.browser.images;
	
	ch = data.browser.channels;
	nch = data.browser.sound.channels;
	pch = data.browser.play.channel;
	
	%--
	% update play channels and left and right channel in contextual menu
	%--
	
	if (strcmp(str,'Left Channel'))
		
		ix = str2num(get(gcbo,'tag'));
		pch(1) = ix;
	
		set(get_menu(h,'Left Channel',2),'check','off');
		set(gcbo,'check','on');
		
	else
		
		ix = str2num(get(gcbo,'tag'));
		pch(2) = ix;

		set(get_menu(h,'Right Channel',2),'check','off');
		set(gcbo,'check','on');
		
	end
	
	data.browser.play.channel = pch;
	set(h,'userdata',data);
	
	%--
	% enable all image context menus
	%--
	
	for k = 1:length(im)
		
		tmp = get(get(im(k),'uicontextmenu'),'children');
		set(tmp,'enable','on');
		
		tmp = get(get_menu(tmp,'Channels'),'children');
		set(tmp,'enable','on');
		
	end
	
	ix = find(strcmp(get(ax,'tag'),num2str(pch(1))));
	tmp = get(get(im(ix),'uicontextmenu'),'children');
% 	set(get_menu(tmp,'Hide Channel'),'enable','off');
	
	ix = find(strcmp(get(ax,'tag'),num2str(pch(2))));
	tmp = get(get(im(ix),'uicontextmenu'),'children');
% 	set(get_menu(tmp,'Hide Channel'),'enable','off');
	
	%--
	% update display
	%--
		
	% update axes ylabels
		
	for k = 1:length(ax)
		axes(ax(k));
		tag = get(ax(k),'tag');
		ylabel(['Ch ' tag ]);
	end
	
	if (diff(pch))
		
		tag = get(ax,'tag');
		
		ix = find(strcmp(tag,num2str(pch(1))));
		tmp = ax(ix);
		axes(tmp);
		str = get(get(tmp,'ylabel'),'string');
		ylabel([str '  (L)']);
		
% 		set(get_menu(im(ix),'Hide Channel'),'enable','off');
		
		ix = find(strcmp(tag,num2str(pch(2))));
		tmp = ax(ix);
		axes(tmp);
		str = get(get(tmp,'ylabel'),'string');
		ylabel([str '  (R)']);	
		
% 		set(get_menu(im(ix),'Hide Channel'),'enable','off');
		
	else
		
		tag = get(ax,'tag');
		
		ix = find(strcmp(tag,num2str(pch(1))));
		tmp = ax(ix);
		axes(tmp);
		str = get(get(tmp,'ylabel'),'string');
		ylabel([str '  (LR)']);
		
% 		set(get_menu(im(ix),'Hide Channel'),'enable','off');
		
	end
		
	%--
	% update sound menu menus
	%--
	
	% enable all toggle menus
	
	set(data.browser.sound_menu.channels,'enable','on');
	
	% set left channel menu check and disable left channel toggle 
	
	tmp1 = get(get_menu(data.browser.sound_menu.play_options,'Left Channel'),'children');
	tmp1_str = ['Channel ' num2str(pch(1))];
	
	set(tmp1,'check','off');
	set(get_menu(tmp1,tmp1_str),'check','on');
	set(get_menu(h,tmp1_str,2),'enable','off');
	
	% set right channel menu check and disable right channel toggle 
	
	tmp2 = get(get_menu(data.browser.sound_menu.play_options,'Right Channel'),'children');
	tmp2_str = ['Channel ' num2str(pch(2))];
	
	set(tmp2,'check','off');
	set(get_menu(tmp2,tmp2_str),'check','on');
	set(get_menu(h,tmp2_str,2),'enable','off');
	
	% enable channel selection menus turned off along with channel toggle
	
	set(tmp1,'enable','on');
	set(tmp2,'enable','on');
	
	
	% turn off all channels, we are already viewing all channels
			
	test = 0;
	if (length(ch) == nch)
		set(get_menu(h,'Display All',2),'enable','off');
		test = test + 1;
	else
		set(get_menu(h,'Display All',2),'enable','on');
	end
	
	% turn off select channels, there are no channels to toggle
	
% 	if (nch > 1)
% 		set(get_menu(h,'Select Channels ...',2),'enable','on');
% 		if ((nch == 2) & diff(pch))
% 			set(get_menu(h,'Select Channels ...',2),'enable','off');
% 			test = test + 1;
% 		end
% 	else
% 		set(get_menu(h,'Select Channels ...',2),'enable','off');
% 		test = test + 1;
% 	end
	
	% there are no enabled menus in the channels submenu disable channels
	
	if (test == 2)
		tmp = get(get_menu(h,'Display All',2),'parent');
		if (iscell(tmp))
			set(cell2mat(tmp),'enable','off');
		else
			set(tmp,'enable','off');
		end
	else
		tmp = get(get_menu(h,'Display All',2),'parent');
		if (iscell(tmp))
			set(cell2mat(tmp),'enable','on');
		else
			set(tmp,'enable','on');
		end
	end
	
	%--
	% refresh figure
	%--
	
	refresh(h);
	
%------------------------------------------------
% Volume Control ...
%------------------------------------------------

case ('Volume Control ...')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	!sndvol32 &
	
%------------------------------------------------
% Sound Recorder ...
%------------------------------------------------

case ('Sound Recorder ...')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		out.name = str;
		out.category = 'Sound'; 
		out.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		return;
		
	end
	
	!sndrec32 &
	
%------------------------------------------------
% Miscellaneous Commands
%------------------------------------------------

otherwise
	
	% there is no info at the moment available for these commands

	%-------
	% INFO
	%-------
	
	if (flag)
		return;
	end
	
% 	if (flag)
% 		
% 		out.name = str;
% 		out.category = 'Sound'; 
% 		out.description = [ ...
% 			'Play currently displayed page. ' ...
% 			'When there is no designated left and right channels are played, ' ...
% 			'otherwise only the selection channel is played' ...
% 		];
% 		
% 		return;
% 		
% 	end
	
	%-------
	% INFO
	%-------
	
	if (flag)
		out = [];
		return;
	end
	
	%--
	% Channels
	%--
	
	if ((length(str) > 6) & (length(str) < 10) & strcmp(str(1:7),'Channel'))
				
		%--
		% get or set parent label
		%--
		
		if (~isempty(gcbo))
			try
				label = get(get(gcbo,'parent'),'label');
			catch
				label = 'Channels';
			end
		else
			label = 'Channels';
		end
				
		%--
		% change channel display setting or play channel setting
		%--
		
		switch (label)
			
		case ({'Channels','Channels Displayed'})		
		
			%--
			% get userdata and relevant fields
			%--
			
			data = get(h,'userdata'); 
			
			ch = data.browser.channels;
			nch = data.browser.sound.channels;
			pch = data.browser.play.channel;
			
			%--
			% get channel number and check whether it is currently displayed
			%--
			
			ix = str2num(str(9:end));
			d = find(ch == ix);
	
			%--
			% add or remove channel from list of displayed channels and toggle check
			%--
			
			if (isempty(d))		
				
				ch = sort([ch ix]);
				
			else
								
				% remove channel (protect play channels for the moment just
				% in case)
				
				if (any(ch(d) == pch))
					return;
				else
					ch(d) = [];
				end
				
			end
			
			%--
			% toggle display of selected channel
			%--
			
			if (~isempty(findobj(h,'type','axes','tag','Colorbar')))
				array_colorbar(h);
				flag = 1;
			else
				flag = 0;
			end
			
			data.browser.channels = ch;
			
			[ha,hi] = browser_display(h,'create',data);
				
			data.browser.axes = ha;
			data.browser.images = hi;
			
			if (flag)
				
				array_colorbar;
				
				ax = findobj(h,'type','axes','tag','Colorbar');
				tmp = data.browser.grid.color;
				set(ax,'XColor',tmp,'YColor',tmp);
				set(get(ax,'title'),'color',tmp);
				
			end
			
			%--
			% update menus
			%--
			
			if (isempty(d))
				set(get_menu(h,get(gcbo,'label'),2),'check','on');
			else
				set(get_menu(h,get(gcbo,'label'),2),'check','off');
			end
			
			%--
			% get new slider handle
			%--
			
			data.browser.slider = findobj(h,'type','uicontrol','style','slider');
			
			%--
			% get play channel menu handles
			%--
			
	% 		tmp = get(get(get_menu(data.browser.sound_menu.play_options,'Left Channel'),'children'),'label')
	% 		
	% 		data.browser.sound_menu.left_channel = ...
	% 			get(get_menu(data.browser.sound_menu.play_options,'Left Channel'),'children');
	% 		
	% 		data.browser.sound_menu.right_channel = ...
	% 			get(get_menu(data.browser.sound_menu.play_options,'Right Channel'),'children');
			
			%--
			% update view state array
			%--
			
			data.browser.view = browser_view_update(h,data);
			
			%--
			% update userdata
			%--
			
			set(h,'userdata',data);
			
			%--
			% display events if needed
			%--
			
			if (length(data.browser.log))
				browser_display(h,'events',data);
			end
			
			%--
			% apply resize function
			%--
			
			browser_resizefcn(h);
			
			%--
			% update menus
			%--
			
			% turn off all channels, we are already viewing all channels
					
			test = 0;
			if (length(ch) == nch)
				set(get_menu(h,'Display All',2),'enable','off');
				test = test + 1;
			else
				set(get_menu(h,'Display All',2),'enable','on');
			end
			
			% turn off select channels, there are no channels to toggle
			
% 			if (nch > 1)
% 				set(get_menu(h,'Select Channels ...',2),'enable','on');
% 				if ((nch == 2) & diff(pch))
% 					set(get_menu(h,'Select Channels ...',2),'enable','off');
% 					test = test + 1;
% 				end
% 			else
% 				set(get_menu(h,'Select Channels ...',2),'enable','off');
% 				test = test + 1;
% 			end
			
			% there are no enabled menus in the channels submenu disable channels
			
			if (test == 2)
				tmp = get(get_menu(h,'Display All',2),'parent');
				if (iscell(tmp))
					set(cell2mat(tmp),'enable','off');
				else
					set(tmp,'enable','off');
				end
			else
				tmp = get(get_menu(h,'Display All',2),'parent');
				if (iscell(tmp))
					set(cell2mat(tmp),'enable','on');
				else
					set(tmp,'enable','on');
				end
			end
			
			return;
						
		case ({'Left Channel','Right Channel'})
			
			%--
			% get channel number
			%--
			
			ix = str2num(str(9:end));
			
			%--
			% update play channels if needed
			%--
			
			data = get(h,'userdata');
			
			if (strcmp(label,'Left Channel'))
				data.browser.play.channel(1) = ix;
			else
				data.browser.play.channel(2) = ix;
			end
			
			set(h,'userdata',data);
			
			%--
			% update display
			%--
				
			ax = data.browser.axes;
			nax = length(ax);
			
			for k = 1:nax
				axes(ax(k));
				tag = get(ax(k),'tag');
				if (nax < 3)
					ylabel(['Ch ' tag ]);
				else
					ylabel(['Ch ' tag]);
				end
			end
			
			% turn off checks for play channel contextual menus
				
			for k = 1:length(data.browser.images)
				tmp_left(k) = get_menu(get(data.browser.images(k),'uicontextmenu'),'Left Channel',2);
				tmp_right(k) = get_menu(get(data.browser.images(k),'uicontextmenu'),'Right Channel',2);
			end

			set(tmp_left,'check','off');
			set(tmp_right,'check','off');
				
			% update display of play channel axes
			
			if (diff(data.browser.play.channel))
				
				% get axes channel tags 
				
				tag = get(data.browser.axes,'tag');
				
				% update display of left channel axes (ylabel and contexual menu)
				
				ix = find(strcmp(tag,num2str(data.browser.play.channel(1))));
				tmp = ax(ix);
				axes(tmp);
				str = get(get(tmp,'ylabel'),'string');
				ylabel([str '  (L)']);
				set(tmp_left(ix),'check','on');
				
				% update display of right channel axes (ylabel and contexual menu)
				
				ix = find(strcmp(tag,num2str(data.browser.play.channel(2))));
				tmp = ax(ix);
				axes(tmp);
				str = get(get(tmp,'ylabel'),'string');
				ylabel([str '  (R)']);
				set(tmp_right(ix),'check','on');
				
			else
				
				% get axes channel tags
				
				tag = get(data.browser.axes,'tag');
				
				% update display of play channel axes (ylabel and contexual menu)
				
				ix = find(strcmp(tag,num2str(data.browser.play.channel(1))));
				tmp = ax(ix);
				axes(tmp);
				str = get(get(tmp,'ylabel'),'string');
				ylabel([str '  (LR)']);
				set(tmp_left(ix),'check','on');
				set(tmp_right(ix),'check','on');
				
			end
			
			%--
			% update sound menu menus
			%--
			
			ch = data.browser.channels;
			pch = data.browser.play.channel;
			
		% 	tmp = data.browser.sound_menu.left_channel;
			tmp = get(get_menu(data.browser.sound_menu.play_options,'Left Channel'),'children');
			
			set(tmp,'check','off');
			set(get_menu(tmp,['Channel ' num2str(pch(1))]),'check','on');
			
		% 	tmp = data.browser.sound_menu.right_channel;
			tmp = get(get_menu(data.browser.sound_menu.play_options,'Right Channel'),'children');
			
			set(tmp,'check','off');
			set(get_menu(tmp,['Channel ' num2str(pch(2))]),'check','on');
			
			%--
			% refresh figure
			%--
			
			refresh(gcf);
			
			%--
			% update channel control strings
			%--
			
			channel_control_strings(h,data);
			
			return;
			
		end
		
	end
	
	%--
	% File Navigate
	%--
	
	data = get(h,'userdata'); 
	
	sound = data.browser.sound;
	
	%--
	% if the string corresponds to a filename then go to begining of file
	%--
	
	ix = find(strcmp(str,sound.file));
		
	if (length(ix))
		
		page = data.browser.page;
		
		%--
		% update browser state
		%--
		
		% set time
		
		data.browser.time = ...
			max(0,((sound.cumulative(ix) - sound.samples(ix)) / sound.samplerate) - page.duration / 1000);
		
		% set empty selection	
		
		data.browser.selection.event = event_create;
		data.browser.selection.handle = [];
		
		set(h,'userdata',data);
		
		%--
		% update display 
		%--
		
		browser_display(h,'update',data);
		
		%--
		% enable and disable navigation menus
		%--
		
		browser_navigation_update(h,data);
		
		%--
		% update view state array
		%--
		
		data.browser.view = browser_view_update(h,data);
		
		set(h,'userdata',data);
		
		return;
		
	end
		
	%--
	% unrecognized command
	%--
		
	warning(['Unrecognized ''browser_sound_menu'' option ''' str '''.']);
		
end
