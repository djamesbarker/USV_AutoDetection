function log_sound_menu(h,str,flag)

% log_sound_menu - log browser sound view and play options menu
% -------------------------------------------------------------
%
% log_sound_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag (def: '')

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
% $Date: 2005-04-20 02:22:39 -0400 (Wed, 20 Apr 2005) $
% $Revision: 950 $
%--------------------------------

%--
% enable enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Sound'))
		set(get_menu(h,str),'enable',flag);
	end	
	return;			
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% perform command sequence
%--

if (iscell(str))
	for k = 1:length(str)
		try
			log_sound_menu(h,str{k}); 
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
% main switch
%--

switch (str)

%--
% Initialize
%--

case ('Initialize')
	
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
		'Play Event', ...
		'Play Clip', ...
		'Rate', ...
		'Volume Control ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{7} = 'on';
	
	mg = menu_group(h,'log_sound_menu',L,S);	
	data.browser.sound_menu.sound = mg;

	set(mg(1),'position',4);
	%--
	% Attributes
	%--

	% date and time
	
	tmp = data.browser.sound.realtime;
	if (isempty(tmp))
		realtime = '(Not Available)';
	else
		realtime = '(Available)';
	end

	% calibration
	
	tmp = data.browser.sound.calibration;
	if (isempty(tmp))
		calibration = '(Not Available)';
	else
		calibration = '(Available)';
	end

	% geometry
	
	tmp = data.browser.sound.geometry;
	if (isempty(tmp))
		geometry = '(Not Available)';
	else
		geometry = '(Available)';
	end

	% speed of sound
	
	tmp = data.browser.sound.speed;
	if (isempty(tmp))
		speed = '(Not Available)';
	else
		speed = '(Available)';
	end
	
	%--
	% create menu for multiple file sounds
	%--
	
	type = data.browser.sound.type;
	
	if (~strcmp(type,'File'))
		
		files = ['Files:  (' num2str(length(data.browser.sound.file)) ' Files)'];

		L = { ...
			['Type:  ' type], ...
			['Path:  ' data.browser.sound.path], ...
			files, ...
			['Date and Time:  ' realtime], ...
			['Duration:  ' sec_to_clock(data.browser.sound.duration)], ...
			['Channels:  ' num2str(data.browser.sound.channels)], ...
			['Channel Calibration:  ' calibration], ...
			['Channel Geometry:  ' geometry], ...
			['Speed of Sound:  ' speed], ...
			['Sampling Rate:  ' num2str(data.browser.sound.samplerate) ' Hz'], ...
			['Bits Per Sample:  ' num2str(data.browser.sound.samplesize)] ...
		};
	
		n = length(L);
			
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		S{4} = 'on';
		S{6} = 'on';
		S{9} = 'on';
		S{10} = 'on';
		
		A = cell(1,n);
		
		mg = menu_group(get_menu(h,'Attributes'),'',L,S,A);
		
		data.browser.sound_menu.data = mg;
	
		%--
		% File
		%--
		
		L = data.browser.sound.file;
		
		data.browser.sound_menu.data_file =  ...
			menu_group(get_menu(mg,files),'',L);
			
	%--
	% create menu for single file sounds
	%--
	
	else

		L = { ...
			['Type:  ' type], ...
			['Path:  ' data.browser.sound.path], ...
			['File:  ' data.browser.sound.file], ...
			['Date and Time:  ' realtime], ...
			['Duration:  ' sec_to_clock(data.browser.sound.duration)], ...
			['Channels:  ' num2str(data.browser.sound.channels)], ...
			['Channel Calibration:  ' calibration], ...
			['Channel Geometry:  ' geometry], ...
			['Speed of Sound:  ' speed], ...
			['Sampling Rate:  ' num2str(data.browser.sound.samplerate) ' Hz'], ...
			['Bits Per Sample:  ' num2str(data.browser.sound.pcmbitwidth)], ...
		};
	
		n = length(L);
			
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		S{4} = 'on';
		S{6} = 'on';
		S{9} = 'on';
		S{10} = 'on';

		mg = menu_group(get_menu(h,'Attributes'),'',L,S);
		
		data.browser.sound_menu.data = mg;
		
	end
	
	nch = data.browser.sound.channels;
	
	%--
	% Date and Time
	%--

	if (strcmp(realtime,'(Not Available)'))
	
		L = { ...
			'Add Date and Time ...', ...
			'Load Date and Time ...' ...
		};
	
		S = bin2str([0 0]);
		
	else
		
		[tmp1,tmp2] = strtok(datestr(data.browser.sound.realtime),' ');
		tmp2 = tmp2(2:end);
		
		L = { ...
			['Date:  ' tmp1], ...
			['Time:  ' tmp2], ...
			'Edit Date and Time ...', ...
			'Load Date and Time ...' ...
		};
	
		S = bin2str([0 0 1 0]); 
		
	end

	data.browser.sound_menu.real_time = ...
		menu_group(mg(4),'log_sound_menu',L,S);
	
	%--
	% Calibration
	%--
	
	if (strcmp(calibration,'(Not Available)'))
	
		L = { ...
			'Add Calibration ...', ...
			'Load Calibration ...' ...
		};

		data.browser.sound_menu.calibration = ...
			menu_group(mg(7),'log_sound_menu',L);
		
	else
	
		tmp = data.browser.sound.calibration;
		
		L = cell(0);
		for k = 1:nch
			L{k} = ['Channel ' int2str(k) ':  ' num2str(tmp(k)) ' dB'];
		end
		
		L{nch + 1} = 'Edit Calibration ...'; 
		L{nch + 2} = 'Load Calibration ...';
		
		n = length(L);
	
		S = bin2str(zeros(1,n));
		S{nch + 1} = 'on';
		
		data.browser.sound_menu.calibration = ...
			menu_group(mg(7),'log_sound_menu',L,S);
		
		set(data.browser.sound_menu.calibration(1:end - 2),'callback','');
		
	end
	
	%--
	% Geometry
	%--
	
	if (strcmp(geometry,'(Not Available)'))
	
		L = { ...
			'Add Geometry ...', ...
			'Load Geometry ...' ...
		};
		
		data.browser.sound_menu.geometry = ...
			menu_group(mg(8),'log_sound_menu',L);
		
	else
	
		tmp = data.browser.sound.geometry;
		
		if (size(tmp,2) == 2)
			L = cell(0);
			for k = 1:nch
				L{k} = ...
					['Channel ' int2str(k) ':  [' int2str(k) ', ' num2str(tmp(k,1)) ', ' num2str(tmp(k,2)) '] m'];
			end
		else
			L = cell(0);
			for k = 1:nch
				L{k} = ...
					['Channel ' int2str(k) ':  [' num2str(tmp(k,1)) ', ' num2str(tmp(k,2)) ', ' num2str(tmp(k,3)) '] m'];
			end
		end
		
		L{nch + 1} = 'Edit Geometry ...'; 
		L{nch + 2} = 'Load Geometry ...';
		
		n = length(L);
	
		S = bin2str(zeros(1,n));
		S{nch + 1} = 'on';
		
		data.browser.sound_menu.geometry = ...
			menu_group(mg(8),'log_sound_menu',L,S);
		
		set(data.browser.sound_menu.geometry(1:end - 2),'callback','');

	end
 	
	%--
	% Speed of Sound
	%--

	if (strcmp(speed,'(Not Available)'))
		
		L = { ...
			'Add Speed of Sound ...', ...
			'Load Speed of Sound ...' ...
		};
	
		S = bin2str([0 0]);
		
	else
		
		tmp = data.browser.sound.speed;
		
		L = { ...
			['Speed :  ' num2str(tmp) ' m/sec'], ...
			'Edit Speed of Sound ...', ...
			'Load Speed of Sound ...' ...
		};
	
		S = bin2str([0 1 0]);
	
	end
	
	data.browser.sound_menu.speed_of_sound = ...
		menu_group(mg(9),'log_sound_menu',L,S);
			
% 	%--
% 	% Play
% 	%--
% 	
% 	if (isempty(data.browser.parent))
% 		
% 		L = { ...
% 			'Page', ...
% 			'Selection' ...
% 		};
% 	
% 		n = length(L);		
% 		S = bin2str(zeros(1,n));
% 
% 		data.browser.sound_menu.play = menu_group(get_menu(h,'Play'),'log_sound_menu',L,S);
% 		
% 	end
% 	
% 	%--
% 	% Play Options
% 	%--
% 	
% 	L = { ...
% 		'Rate', ...
% 		'Left Channel', ...
% 		'Right Channel', ...
% 	};
% 
% 	n = length(L);
% 	
% 	S = bin2str(zeros(1,n));
% 	S{2} = 'on';
% 
% 	data.browser.sound_menu.play_options = menu_group(get_menu(h,'Play Options'),'log_sound_menu',L,S);
	
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
	
	mg = menu_group(get_menu(h,'Rate'),'log_sound_menu',L,S,A);
	data.browser.sound_menu.play_speed = mg;
	
	ix = find(data.browser.play.speed == [1, 1/2, 1/4, 1/8, 1/16, 1/32, 2, 4, 8, 16, 32]);
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		set(mg(end),'check','on');
	end
	
% 	%--
% 	% Left Channel and Right Channel
% 	%--
% 	
% 	clear L;
% 	
% 	for k = 1:data.browser.sound.channels
% 		L{k} = ['Channel ' num2str(k)];
% 	end 
% 	
% 	mg = menu_group(get_menu(data.browser.sound_menu.play_options,'Left Channel'),'log_sound_menu',L);
% 	data.browser.sound_menu.left_channel = mg;
% 	set(mg(data.browser.play.channel(1)),'check','on');
% 	
% 	mg = menu_group(get_menu(data.browser.sound_menu.play_options,'Right Channel'),'log_sound_menu',L);
% 	data.browser.sound_menu.right_channel = mg;
% 	set(mg(data.browser.play.channel(2)),'check','on');

	%--
	% update userdata to include sound menu
	%--
	
	set(h,'userdata',data);
	
%--
% Show Files ...
%--

case ('Show Files ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% open folder containing files in explorer
	%--
	
	eval(['!explorer ' data.browser.sound.path ' &']);
	
%--
% Add or Edit Date and Time ...
%--

case ({'Add Date and Time ...','Edit Date and Time ...'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% parse date or current date if empty
	%--
	
	if (isempty(data.browser.sound.realtime))
	
		[d,t] = strtok(datestr(now),' ');
		dd = d;
		tt = t;

	else
	
		[d,t] = strtok(datestr(data.browser.sound.realtime),' ');
		[dd,tt] = strtok(datestr(now),' ');
		
	end
			
	%--
	% edit real time for recording
	%--
		
	ans = input_dialog( ...
		{'Date','Time'}, ...
		'Edit Date and Time ...', ...
		[1,32], ...
		{d,t}, ...
		{['Date of recording formatted as ''' dd ''''],['Time of recording formatted as ''' tt(2:end) '''']} ...
	);
	
	%--
	% update userdata if needed
	%--
	
	if (~isempty(ans))
		
		%--
		% pack date and time into date string and verify correctness
		%--
		
		tmp = datestr([ans{1} ' ' ans{2}]);
			
		%--
		% update userdata and write to file
		%--
		
		data.browser.sound.realtime = datenum(tmp);
		
		set(h,'userdata',data);
		
		file_datetime('write',h,datenum(tmp));
		
		%--
		% update display
		%--
		
		log_browser_display;
		
	end
	
%--
% Load Date and Time ...
%--

case ('Load Date and Time ...')
	
	file_datetime('load',h);
	
%--
% Add or Edit Calibration ...
%--

case ({'Add Calibration ...','Edit Calibration ...'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set default calibration if empty
	%--
	
	nch = data.browser.sound.channels;
	
	if (isempty(data.browser.sound.calibration))
		c = zeros(nch,1);
	else
		c = data.browser.sound.calibration;
	end
			
	%--
	% edit calibration data for recording
	%--
	
	pro = cell(0);
	for k = 1:nch
		pro{k} = ['Channel ' int2str(k)];
	end
	
	def = cell(0);
	for k = 1:nch
		def{k} = num2str(c(k));
	end
	
	tip = cell(0);
	for k = 1:nch
		tip{k} = ['Channel ' int2str(k) ' calibration in dB'];
	end
	
	ans = input_dialog(pro, 'Edit Calibration ...', [1,32], def, tip);
	
	%--
	% update userdata if needed
	%--
	
	if (~isempty(ans))
		
		%--
		% convert values to numbers and perform error checking
		%--
		
		for k = 1:nch
			c(k) = str2num(ans{k});
		end

		%--
		% update userdata and write to file
		%--
		
		data.browser.sound.calibration = c;
		
		set(h,'userdata',data);

		file_calibration('write',h,c);
		
		%--
		% update display
		%--
		
% 		log_browser_display;
		
	end
	
%--
% Load Calibration ...
%--

case ('Load Calibration ...')
	
	file_calibration('load',h);
	
%--
% Add or Edit Geometry ...
%--

case ({'Add Geometry ...','Edit Geometry ...'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set default geometry if empty
	%--
	
	nch = data.browser.sound.channels;
	
	if (isempty(data.browser.sound.geometry))
		g = zeros(nch,3);
	else
		g = data.browser.sound.geometry;
	end
			
	%--
	% edit geometry data for recording
	%--
	
	pro = cell(0);
	for k = 1:nch
		pro{k} = ['Channel ' int2str(k)];
	end
	
	def = cell(0);
	for k = 1:nch
		def{k} = strrep(mat2str(g(k,:)),' ',', ');
	end
	
	tip = cell(0);
	for k = 1:nch
		tip{k} = ['Channel ' int2str(k) ' geometry in meters'];
	end
	
	ans = input_dialog(pro, 'Edit Geometry ...', [1,32], def, tip);
	
	%--
	% update userdata if needed
	%--
	
	if (~isempty(ans))
		
		%--
		% convert values to numbers and perform error checking
		%--
		
		for k = 1:nch
			g(k,:) = eval(ans{k});
		end

		%--
		% update userdata and write to file
		%--
		
		data.browser.sound.geometry = g;
		
		set(h,'userdata',data);

		file_geometry('write',h,g);
		
		%--
		% update display
		%--
		
% 		log_browser_display;
		
	end
	
%--
% Load Geometry ...
%--

case ('Load Geometry ...')
	
	file_geometry('load',h);
	
%--
% Add or Edit Speed of Sound ...
%--

case ({'Add Speed of Sound ...','Edit Speed of Sound ...'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set default speed of sound if empty
	%--

	if (isempty(data.browser.sound.speed))
		s = 331.45;
	else
		s = data.browser.sound.speed;
	end
			
	%--
	% edit speed of sound data for recording
	%--
	
	ans = input_dialog( ...
		{'Speed of Sound'}, ...
		'Edit Speed of Sound ...', ...
		[1,32], ...
		{[s,300,1500,0]}, ...
		{'Speed of sound in meters per second (m/sec)'} ...
	);
	
	%--
	% update userdata if needed
	%--
	
	if (~isempty(ans))
		
		%--
		% get speed of sound
		%--
		
		s = ans{1};

		%--
		% update userdata and write to file
		%--
		
		data.browser.sound.speed = s;
		
		set(h,'userdata',data);

		file_speed('write',h,s);
		
		%--
		% update display
		%--
		
% 		log_browser_display;
		
	end
	
%--
% Load Speed of Sound ...
%--

case ('Load Speed of Sound ...')
	
	file_speed('load',h);
	
%--
% Play Event and Play Clip
%--

case ({'Play Event','Play Clip'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	parent = get(data.browser.parent,'userdata');

	%--
	% get extent information based on type of play
	%--
	
	switch (str)
		
	case ('Play Event')
		
		event = data.browser.selection.event;
		
		try
			ax = get(data.browser.selection.handle(1),'parent');
		catch
			return;
		end
		
		t = event.time(1);
		dt = event.duration;
		ch = event.channel;
		
	case ('Play Clip')
		
		event = data.browser.selection.event;
		
		try
			ax = get(data.browser.selection.handle(1),'parent');
		catch
			return;
		end
		
		xl = get(ax,'xlim');
		
		t = xl(1);
		dt = diff(xl);
		ch = event.channel;
			
	end
			
	r = parent.browser.sound.samplerate;
	speed = data.browser.play.speed;

	%--
	% get clip or event samples
	%--

	tmp = sound_read(parent.browser.sound,'time',t,dt,ch);
	
	%--
	% filter clip or event if needed
	%--
	
	if (data.browser.specgram.diff)
		tmp = diff(tmp,1);
	end
		
	%--
	% forward play
	%--
	
	if (speed > 0)	
		
		%--
		% play scaled sound
		%--
		
		soundsc(tmp,(speed * r));
		
		%--
		% display play position
		%--

		axes(ax);
		tmp_handle = plot(t * ones(2,1),get(ax,'ylim')','-','color',data.browser.selection.color);

		refresh(h);
		tmp = 0;
		
		while (tmp <= (dt / speed))
			
			tic;
			try
				set(tmp_handle,'xdata',(t + tmp * speed) * ones(2,1));
				drawnow;
				refresh(h);
			end
			tmp = tmp + toc;
			
		end
		
		try
			delete(tmp_handle);
		end
	
	%--
	% backward play
	%--
	
	elseif (speed < 0)	

		%--
		% play scaled sound
		%--
		
		soundsc(flipud(tmp),-(speed * r));
		
		%--
		% display play position
		%--
			
		axes(ax);
		tmp_handle = plot(t * ones(2,1),get(ax,'ylim')','-','color',data.browser.selection.color);
		
		refresh(h);
		tmp = 0;
		
		while (tmp <= -(dt / speed))
		
			tic;			
			try
				set(tmp_handle,'xdata',(t + dt + tmp * speed) * ones(2,1));
				drawnow;
				refresh(h);
			end
			tmp = tmp + toc;

		end
		
		try
			delete(tmp_handle);
		end
			
	end
	
%--
% Rate
%--

case ('Normal Rate')
	
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
	
case ('Other Rate ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get play speed
	%--
	
	ans = input_dialog( ...
		'Rate', ...
		'Other Rate ...', ...
		[1,40], ...
		{[data.browser.play.speed,1/32,32]}, ...
		{'Play rate, as fraction of normal rate'} ...
	);	
	
	%--
	% update play speed if needed
	%--
	
	if (~isempty(ans))
		
		% update userdata
		
		data.browser.play.speed = ans{1};
		set(h,'userdata',data);
		
		% update menu
		
		set(data.browser.sound_menu.play_speed,'check','off');
		set(get_menu(h,str),'check','on');
		
	end
	
%--
% Volume Control ...
%--

case ('Volume Control ...')
	
	!sndvol32 &
	return;
	
%--
% Sound Recorder ...
%--

case ('Sound Recorder ...')
	
	%--
	% get userdata and relevant field
	%--
	
	data = get(h,'userdata');
	sound = data.browser.sound;
	
	%--
	% open file, or first sound in group using recorder
	%--
	
	if (strcmp(sound.type,'File'))	
		eval(['!sndrec32 ' sound.path filesep sound.file '&']);	
	else
		eval(['!sndrec32 ' sound.path filesep sound.file{1} '&']);	
	end
	
%--
% Miscellaneous Commands
%--

otherwise
		
	%--
	% unrecognized command
	%--
		
	disp(' ');
	warning(['Unrecognized ''log_sound_menu'' option ''' str '''.']);
		
end
