function varargout = browser_display(par, mode, data)

% browser_display - create or update sound browser display
% --------------------------------------------------------
%
% [ax, im, sli] = browser_display(par, 'create', data)
%
%          flag = browser_display(par, 'update', data)
%
%          flag = browser_display(par, 'events', data)
%
% Input:
% ------
%  par - display figure handle (def: gcf)
%  data - browser state structure
%
% Output:
% -------
%  ax - handles to axes
%  im - handles to images
%  sli - handle to slider
%  flag - execution success flag

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

% TODO: access to the browser state is not uniform

% NOTE: parent objects should often be used 'page.duration' instead of 'duration'

% TODO: many things to factor out of this function

%--
% suspend double click observer during display
%--

double_click('off');

%-------------------------------------------
% HANDLE INPUT
%-------------------------------------------

%--
% check parent input
%--

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

%--
% set mode
%--

if (nargin < 2) || isempty(mode)
	mode = 'update';
end

%--
% get userdata if needed
%--

if (nargin < 3) || isempty(data)
	data = get_browser(par);
end

%-------------------------------------------
% SETUP
%-------------------------------------------

%--
% setup update performance computation
%--

% TODO: make performance measures 'profile' based

persistent START_TIME SCREEN_SIZE;

status = 1;

if ~strcmp(mode, 'events') && status
	START_TIME = clock;	
end

%--
% copy relevant parts of parent state
%--

%--
% sound
%--

sound = get_browser(par, 'sound', data);

rate = get_sound_rate(sound);

%--
% page parameters
%--

time = get_browser(par, 'time', data);

duration = get_browser(par, 'page duration', data);

ch = get_channels(get_browser(par, 'channels', data));

%--
% other relevant browser fields
%--

nch = length(ch);

page = get_browser(par, 'page', data);

grid_opt = get_browser(par, 'grid', data);

specgram_opt = get_browser(par, 'specgram', data);

%--
% get active filters
%--

active = get_active_filters(par, data);

%-------------------------------------------
% DISPLAY
%-------------------------------------------

% TODO: evaluate state used to develop extensible display interface

switch mode

	%--
	% update browser display
	%--
	
	case 'update'

		%--
		% compute views
		%--
		
		B = long_specgram(sound, time, duration, ch, specgram_opt, active);
		
		% NOTE: this happens only for the slider interrupt
		
		if isempty(B)
			return;
		end
		
		%--
		% select channels
		%--
		
		if (nch == sound.channels) && (nch > 1)	
			B = {B{ch}};
		end
		
		%--
		% select frequencies
		%--

		if isempty(page.freq)
			
			% NOTE: this option with 'natural' bounds may disappear
			
			page.freq = [0, rate / 2];
			
		end				
		
		norm_freq = page.freq/(rate / 2);
		
		freq_ix = round((size(B{1}, 1) - 1) * norm_freq) + 1;
			
		for k = 1:nch
			B{k} = B{k}([freq_ix(1):freq_ix(2)],:);	
		end
		
		%--
		% filter spectrogram
		%--

		% NOTE: this transformation is used for 'power' values
		
		db_flag = 1;
		
        %%% Modified SCK 
        if (~isempty(active.image_filter) && strcmp(active.image_filter.name,'Spectrogram Smoothing')) || (isfield(data.browser.specgram,'smoothing') && data.browser.specgram.smoothing)
            
            % this will put smoothed image over the normal spectrogram
            % if the smoothing filter isn't on but it's checked in the spectrogram pallete,
            % just pretend we have the image filter on
            % kind of a hack...
            
            meta = struct();    % this struct will pass parms to apply_image_filter.m
            win_size = get(gcf,'Position');
            sides = 165; edges = 150;  % spg image with colomap on side is 165 pixels
            meta.pixel_width = win_size(3) - sides;
            meta.pixel_height = win_size(4) - edges;
            meta.nyquist = sound.samplerate / 2;
            meta.freq = page.freq;
            meta.total_height =  round((meta.pixel_height / (page.freq(2) - page.freq(1))) * meta.nyquist);
            active.image_filter.control.meta = meta;
            active.image_filter.name = 'Spectrogram Smoothing';
            B = apply_image_filter(B, active.image_filter);
            
            if not(data.browser.specgram.smoothing)
                % only set this if the image filter is on
                db_flag = active.image_filter.estimate;
            end
        elseif ~isempty(active.image_filter)
            
            % If not spectrogram smoothing filter, follow normal procedure
            B = apply_image_filter(B, active.image_filter);
            db_flag = active.image_filter.estimate;
        end
        %%% end SCK
		
		% TODO: tie the 'dB' to a state variable
		
		pal = get_palette(par, 'Colormap');
		
		if ~isempty(pal)
			db_flag = get_control(pal, 'dB', 'value');
		end
		
		%---------------------------
		% compute decibel scaling
		%---------------------------

		% TODO: enable use of calibration values

		%--
		% compute range and decibel map for each channel independently
		%--
		
		for k = 1:nch
			
			%--
			% compute range of power image
			%--

			cl(k,:) = fast_min_max(B{k});

			%--
			% compute decibel map and decibel range
			%--

			if db_flag
				B{k} = lut_dB(B{k}, cl(k, :)); cl(k, :) = decibel(cl(k, :));
			end

		end

		%--
		% set common color limits for all channels
		%--

		% TODO: there should be an option to turn this on and off

		cl = [min(cl(:, 1)), max(cl(:, 2))];
			
		%-------------------------------------------
		% UPDATE DISPLAY
		%-------------------------------------------

		%--
		% get axes and image handles
		%--

		% NOTE: this will be extended to handle extensible displays

		ax = data.browser.axes; im = data.browser.images;
		
		%--
		% update time limits
		%--

		xl = [time, time + duration];  
		
		set(im, 'xdata', xl); set(ax, 'xlim', xl);
		
		%--
		% update frequency limits
		%--

		yl = [page.freq(1), page.freq(2)];
		
		if ~strcmp(grid_opt.freq.labels, 'Hz')
			yl = yl / 1000;
		end
		
		set(im, 'ydata', yl); 
		
		set(ax, 'ylim', yl);
		
		%------------------------------
		% UPDATE IMAGE DISPLAY
		%------------------------------			
			
		for k = 1:nch

			%--
			% update spectrogram image display
			%--

			set(im(k), 'cdata', B{k}); 

			% NOTE: update color display limits if reasonable

			if diff(cl) > sqrt(eps)
				
				% HACK: this helps the scaling when cmap_scale is on
				
				cl(1) = max(cl(1), -151);
				
				set(ax(k), 'clim', cl);
				
			end

		end
				
		%--
		% set time and vertical grids
		%--

		% NOTE: time grids are shared by views

		set_time_grid(ax, grid_opt, xl, sound.realtime, sound);

		% NOTE: each view provides its units and grid for the non-time axis
		
		set_freq_grid(ax, grid_opt, yl);

		%--
		% update slider time properties
		%--
		
		slider = update_time_slider(par,data);

		%--
		% update slider color for light grid color
		%--

		tmp = grid_opt.color;

		if (sum(tmp) >= 0.8) || (max(tmp) >= 0.8)
			set(slider.handle,'backgroundcolor', 0.15 * ones(1,3) + 0.1);
		else
			set(slider.handle,'backgroundcolor', get(0,'DefaultFigureColor') - 0.1);
		end 
			
		%--
		% compute active features
		%--
		
		[feature, ignore, context] = get_active_extension('sound_feature', par, data);
		
		context.active = active;
		
		if ~isempty(feature)
			
			page.start = time; page.duration = duration; page.channels = ch;
			
			% NOTE: this resolves a strange bug, this is not the final solution
			
			feature.control.active = 1;
			
			compute_features(feature, sound, page, context);
			
		end
		
		%--
		% display events if available
		%--
		
		browser_display(par, 'events', data);
		
		%--
		% update navigate palette
		%--
		
		update_navigate_palette(par, data);
		
		%--
		% update selection related menus
		%--
		
		% TODO: this does not belong here, and should be handled by selection code
		
		tmp = data.browser.edit_menu.edit; 
		
		set(get_menu(tmp, 'Cut Selection'), 'enable', 'off');
		
		set(get_menu(tmp, 'Copy Selection'), 'enable', 'off');
		
		set(get_menu(tmp, 'Delete Selection'), 'enable', 'off');
		
		set(get_menu(tmp, 'Log Selection ...'), 'enable', 'off');
		
		%--
		% output flag
		%--
		
		varargout{1} = 1;
			
		figure(par); 
		
	%-------------------------------------------
	% CREATE SOUND BROWSER DISPLAY
	%-------------------------------------------
	
	case 'create'
				
		%-------------------------------------------
		% LAYOUT BROWSER
		%-------------------------------------------
		
		data = layout_browser(par, data);
		
% 		browser_time_slide(par,[],data);
			
		%-------------------------------------------
		% COMPUTE SPECTROGRAMS
		%-------------------------------------------

		%--
		% compute long spectrogram
		%--
		
		B = long_specgram(sound, time, duration, ch, specgram_opt, active);

		if (nch == sound.channels) && (nch > 1)	
			B = {B{ch}};
		end		
		
		%--
		% compute decibel scaling
		%--
		
		% NOTE: after computing the decibel scaling the calibration offsets could
		% be used to adjust the display of multiple channels
		
		% TODO: can we also compute a calibration estimate ???
		
		if (nch > 1)
			
			for k = 1:nch	
				cl(k,:) = fast_min_max(B{k});
				B{k} = lut_dB(B{k}, cl(k,:));	
				cl(k,:) = decibel(cl(k,:));
			end
			
			cl = [min(cl(:,1)), max(cl(:,2))];
						 
		else
		
			cl = fast_min_max(B{1});
			B{1} = lut_dB(B{1}, cl);	
			cl = decibel(cl);
	
		end
		
		%--
		% display spectrograms and tag axes
		%--
	
		ax = data.browser.axes;
		
		for k = 1:nch
					
			%--
			% display images in axes
			%--
			
			im(k) = image( ...
				'parent', ax(k), ...
				'cdatamapping', 'scaled', ...
				'cdata', B{k} ...
			);
		
			if diff(cl) > sqrt(eps)
				
				% HACK: this helps the scaling when cmap_scale is on
				
				cl(1) = max(cl(1), -151);
				
				set(ax(k), 'clim', cl);
				
			end
			
			%--
			% tag and set other axes properties
			%--
	
			% TODO: these tags are insufficient to support more view complexity
			
			str = int2str(ch(k));
			
			% NOTE: the layer property is important for proper grid display
			
			set(ax(k), ...
				'layer', 'top', ...
				'tag', str ...
			);
			
		end
		
		%--
		% store handles in state for convenience
		%--
		
		% NOTE: we are probably moving to a tagged objects framework within browsers
		
		data.browser.images = im;
		
		%--
		% update spectrogram axes labels to display play information
		%--
			
		pch = data.browser.play.channel;
		
		set_channel_labels(data);
		
		%----------------------------------------------------------
		% SOUND > PLAY OPTIONS > (LEFT CHANNEL, RIGHT CHANNEL)
		%----------------------------------------------------------
		
		%--
		% rebuild left and right channel menus in sound menu
		%--
		
		if isfield(data.browser, 'sound_menu')
			
			%--
			% remove channels from left and right channel menus
			%--
			
			tmp = data.browser.sound_menu.play_options;
			
			tmp_left = get_menu(tmp, 'Left Channel');
			
			delete(get(tmp_left, 'children'));
			
			tmp_right = get_menu(tmp, 'Right Channel');
			
			delete(get(tmp_right, 'children'));
	
			%--
			% create new left and right channel menus
			%--
			
			% NOTE: this displays channels in current display order
		
			L = strcat( ...
				{'Channel '}, int_to_str(ch(:)) ... 
			);
	
			tmp_left = menu_group(tmp_left, 'browser_sound_menu', L);
			
			tmp_right = menu_group(tmp_right, 'browser_sound_menu', L);
			
			%--
			% check play channels in left and right
			%--
	
			ix = find(ch == pch(1));
			
			if ~isempty(ix)
				set(tmp_left(ix), 'check', 'on');
			end
	
			ix = find(ch == pch(2));
			
			if ~isempty(ix)
				set(tmp_right(ix), 'check', 'on');
			end
			
		end
		
		%--
		% set time limits
		%--
	
		xl = [time, time + duration];	
		
		set(im, 'xdata', xl);
		
		set(ax, 'xlim', xl);
		
		%--
		% set frequency limits
		%--
	
		if ~isempty(page.freq)
			
			if strcmp(grid_opt.freq.labels, 'Hz')
				
				yl = [0, rate / 2];
				set(im, 'ydata', yl);
				set(ax, 'ylim', page.freq);
				
			else
				
				yl = [0,rate / (2*1000)];
				set(im,'ydata',yl);
				set(ax,'ylim',page.freq / 1000);
				
			end
			
		else
	
			if (strcmp(grid_opt.freq.labels,'Hz'))
				yl = [0,rate / 2];
			else
				yl = [0,rate / (2*1000)];
			end
				
			set(im,'ydata',yl);
			
			set(ax,'ylim',yl);
				
		end
	
		%--
		% set time and frequency grids
		%--
		
		set_time_grid(ax, grid_opt, xl, sound.realtime, sound);
		
		yl = get(ax(1),'ylim');
		
		set_freq_grid(ax, grid_opt, yl);

		%--
		% enable channel selection
		%--
	
		set(im,'buttondownfcn','browser_bdfun;');
		
		%--
		% set hold on
		%--
		
		% NOTE: this is equivalent to 'hold on' but faster
		
		set(ax,'nextplot','add'); set(par,'nextplot','add');

		%--
		% update slider color for light grid color
		%--

		slider = get_time_slider(par); sli = slider.handle(1);
		
		tmp = grid_opt.color;

		if ((sum(tmp) >= 0.8) || (max(tmp) >= 0.8))
			set(slider.handle,'backgroundcolor', 0.15 * ones(1,3) + 0.1);
		else
			set(slider.handle,'backgroundcolor', get(0,'DefaultFigureColor') - 0.1);
		end 
		
		%--
		% output handles
		%--		
		
		varargout{1} = ax; varargout{2} = im; varargout{3} = sli;
				
	%--
	% update browser event display
	%--
	
	case 'events'
		
		ax = data.browser.axes;		
		
		%--
		% display events
		%--
		
		display_events(par, time, duration, data, 0);

		%--
		% display file boundaries 
		%--

		[times, files] = get_file_boundaries(sound, time, duration);

		display_file_boundaries(ax, times, files, data);

		%--
		% display session boundaries
		%--
		
		[times, start] = get_session_boundaries(sound, time, duration);

		display_session_boundaries(ax, times, start, [], data);
			
		%--
		% output flag
		%--

		varargout{1} = 1;
		
end

%--
% update colorbar if needed
%--

if ~isempty(data.browser.colorbar) && exist('cl', 'var')
	
	if (abs(diff(cl)) > eps)
		
		try
			set(data.browser.colorbar,'ylim',cl);
			set(get(data.browser.colorbar,'children'),'ydata',cl);
		end
		
	end
	
end 

%--
% reset colormap if needed
%--

% NOTE: use of 'gcf' in the call to 'browser_view_menu' created many problems!

% NOTE: where to call 'selection_update' is something that we should figure out

if (data.browser.colormap.auto_scale || strcmp(data.browser.colormap.name,'label')) && strcmp(mode,'update')
	
	browser_view_menu(par, data.browser.colormap.name, data);

else
	
	% NOTE: updating selection while axes are being destroyed causes problems
	
	if strcmp(mode, 'update')
		selection_update(par, data);
	end
	
end

%----------------------------------------------------------
% CHANNEL CONTEXTUAL MENUS
%----------------------------------------------------------
		
% TODO: this needs to be factored, as well as the corresponding callbacks
% from 'browser_view_menu'

%--
% restore channel contextual menu in spectrogram axes
%--

% the channel context menu should include information that is relevant
% event in the single channel case
	
if strcmp(mode, 'create')
	
	%--
	% create labels for main contextual menu
	%--
	
	L = { ...
		'Channel *', ...
		'Hide Channel', ...
		'Channels', ...
		'Left Channel', ...
		'Right Channel' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1, n)); S{2} = 'on'; S{4} = 'on';
		
	%--
	% create labels for channel select menus
	%--
	
	nch = sound.channels;
	
	LC = channel_strings(data.browser.channels);
	
	LC{nch + 1} = 'Display All';
	
	SC = bin2str(zeros(1,nch + 1));
	
	SC{nch + 1} = 'on';
			
	%--
	% attach channel contextual menus to axes
	%--
		
	for k = 1:length(ax)
					
		%--
		% create contextual menu and attach to current image
		%--
		
		c = uicontextmenu('parent',par);
		
		set(im(k),'uicontextmenu',c);
		
		%--
		% get index of channel displayed in this axes
		%--
		
		tag = get(ax(k),'tag');
		
		%--
		% create main channel contextual menu 
		%--
		
		L{1} = ['Channel  ' tag];
		
		mg = menu_group(c, 'browser_view_menu;', L, S);
		
		%--
		% tag menu items with channel index
		%--
		
		set(mg,'tag',tag);
		
		%--
		% set checks of play channels
		%--
		
		ix = str2num(tag);
		
		if (ix == pch(1))
			set(get_menu(mg,'Left Channel'),'check','on');
		end
		
		if (ix == pch(2))
			set(get_menu(mg,'Right Channel'),'check','on');
		end
		
		%--
		% create channel selection menu
		%--
		
		if (nch > 1)
			
			%--
			% list of channels and all channels selection
			%--
	
			mg = menu_group(get_menu(mg, 'Channels'), 'browser_view_menu;', LC, SC);
			
			%--
			% check visible channels
			%--
			
			for k = 1:length(ax)
				set(get_menu(mg,['Channel ' get(ax(k),'tag')]),'check','on');
			end
			
			%--
			% turn off all channels selection if we are already viewing all channels
			%--
			
			test = 0;
			
			if (length(ch) == nch)
				test = test + 1;
			end
			
			%--
			% turn off channels selection if there are no channels to toggle
			%--
			
			if (nch > 1)
				
				if ((nch == 2) && diff(pch))
					test = test + 1;
				end
				
			else
				
				test = test + 1;
				
			end
			
			%--
			% there are no enabled menus in the channels submenu disable channels
			%--
			
			if (test == 2)
				
				try
					tmp = data.browser.view_menu.channels;
					tmp = get(get_menu(tmp,'Display All'),'parent');
				catch
					tmp = get(get_menu(par,'Display All',2),'parent');
				end
				
				if (iscell(tmp))
					set(cell2mat(tmp),'enable','off');
				else
					set(tmp,'enable','off');
				end
				
			else
				
				try
					tmp = data.browser.view_menu.channels;
					tmp = get(get_menu(tmp,'Display All'),'parent');
				catch
					tmp = get(get_menu(par,'Display All',2),'parent');
				end
				
				if (iscell(tmp))
					set(cell2mat(tmp),'enable','on');
				else
					set(tmp,'enable','on');
				end
				
			end
			
		else
			
			try
				tmp = data.browser.view_menu.channels;
				set(get_menu(tmp,'Channels'),'enable','off');
			end
			
		end
		
	end

end 

%--
% refresh figure
%--

% TODO: figure out how much time refresh is taking

refresh(par);

%--
% resume handling of double clicks
%--

double_click('on');

%--
% reset figure pointer
%--

% NOTE: if the watch pointer is enabled again, this must be uncommented

% set(par,'pointer',ptr);

%----------------------------------------------------------
% DISPLAY UPDATE PERFORMANCE
%----------------------------------------------------------

% NOTE: status displays should have a state available from a context menu

if ~strcmp(mode,'events')
	
	%-----------------------------
	% UPDATE HISTORY
	%-----------------------------
	
	%--
	% get status information to compute elapsed time
	%--
	
	% NOTE: pass images in case we choose to not store these in state
	
	[str, info] = get_status_string(data, START_TIME, im);
	
	%--
	% update history
	%--
	
	set_browser_history(par, info.elapsed);
	
	if ~status
		return;
	end
	
	%-----------------------------
	% UPDATE STATUS
	%-----------------------------
	
	%--
	% get status text handle
	%--
	
	% NOTE: this function is highly underused
	
	txt = status_update(par, 'left', 'message', str);
	
	%--
	% indicate large image size
	%--
	
	% NOTE: we compare image display with screen size and use warning color
	
	if isempty(SCREEN_SIZE)
		SCREEN_SIZE = get(0, 'screensize'); 
	end
	
	if (((info.view_rows * info.stack) > SCREEN_SIZE(4)) || (info.col > SCREEN_SIZE(3)))
		set(txt,'color',color_to_rgb('Bright Red'));
	else
		set(txt,'color',color_to_rgb('Dark Gray'));
	end
	
end


%----------------------------------------------------------
% GET_STATUS_STRING
%----------------------------------------------------------

function [str,info] = get_status_string(data,time,images)

%--
% get relevant status info
%--

info.elapsed = etime(clock,time);

info.row = size(get(images(1),'CData'),1);

info.col = size(get(images(1),'CData'),2);

info.stack = sum(data.browser.channels(:,2));

if (isempty(data.browser.page.freq))
	info.view_rows = info.row;
else
	info.view_rows = ...
		round(2 * info.row * diff(data.browser.page.freq) / get_sound_rate(data.browser.sound));
end

%--
% build status string
%--

row = int2str(info.row); col = int2str(info.col); stack = int2str(info.stack);

elapsed = [num2str(info.elapsed,4) ' sec'];

if (isempty(data.browser.page.freq))
	str = [row, ' x ', col, ' x ', stack, '   (', elapsed, ')'];
else
	str = ['(', int2str(info.view_rows), '/', row, ') x ', col, ' x ', stack, '   (', elapsed, ')'];
end


%----------------------------------------------------------
% SET_CHANNEL_LABELS
%----------------------------------------------------------

function set_channel_labels(data)

% set_channel_labels - label channel axes
% ---------------------------------------
%
% set_channel_labels(data)

%--
% get relevant fields from state
%--

play = data.browser.play;

ax = data.browser.axes;

ch = get_channels(data.browser.channels);

%--
% update ylabels
%--

for k = 1:length(ax)
	
	%--
	% build channel label
	%--
	
	% NOTE: the axes is tagged with the channel index
	
	ix = get(ax(k), 'tag');
	
	str = ['Ch ', ix];
	
	% NOTE: add suffix to indicate play channels
	
	suffix = '';
	
	if (ch(k) == play.channel(1))
		suffix = 'L';
	end
	
	if (ch(k) == play.channel(2))
		suffix = [suffix, 'R'];
	end
	
	if ~isempty(suffix)
		str = [str, '  (', suffix, ')'];
	end
	
	%--
	% set channel display ylabel
	%--
	
	% NOTE: check whether this is ever empty
	
	label = get(ax(k), 'ylabel');
	
	if isempty(label)
		ylabel(ax(k), str);
	else
		set(label, 'string', str);
	end
	
end


%----------------------------------------------------------
% LAYOUT_BROWSER
%----------------------------------------------------------

function data = layout_browser(par, data)

%-------------------------------------------
% DELETE PREVIOUS DISPLAY
%-------------------------------------------

%--
% delete image context menus
%--

% NOTE: without this we used to leak memory, test if it still does

im = data.browser.images;

if ~isempty(im)

	context = get(im, 'uicontextmenu');

	if length(context) > 1
		context = cell2mat(context); menus = findobj(context, 'type', 'uimenu');
	else
		menus = findobj(context, 'type', 'uimenu');
	end

	delete(menus); delete(context);

end

%--
% delete axes array
%--

ax = data.browser.axes;

if ~isempty(ax)

	delete(ax(find(ishandle(ax))));

	delete(findobj(par, 'type', 'axes', 'tag', 'support'));

end

%--
% delete time slider
%--

slider = get_time_slider(par);

if ~isempty(slider)
	
	delete(slider.handle(1));

end

%--
% delete buttons
%--

delete(findobj(par, 'type', 'uicontrol', 'style', 'pushbutton'));

%-------------------------------------------
% LAYOUT BROWSER
%-------------------------------------------

%------------------------
% AXES ARRAY
%------------------------

N = length(get_channels(data.browser.channels));

[ax, axs] = axes_array(N, 1, [], par);

%--
% set generic properties for axes
%--

set(ax, ...
	'box', 'on', ...
	'ydir', 'normal' ...
);

set(ax(1:(end - 1)), 'xticklabel', []);

data.browser.axes = ax;

%------------------------
% TIME CONTROLS
%------------------------

%--
% time navigation slider
%--

sli = uicontrol( ...
	'parent', par, ...
	'style', 'slider',...
	'units', 'normalized', ...
	'tag', 'BROWSER_TIME_SLIDER' ...
);

% NOTE: set slider time properties

slider = update_time_slider(par, data);

%--
% time zoom buttons
%--

but = [];

but(end + 1) = uicontrol( ...
	'cdata', get_button_image('zoom-out-b.png'), ...
	'tooltip', 'Zoom Out', ...
	'string', '', ...
	'tag', 'BROWSER_ZOOM_OUT' ...
);

but(end + 1) = uicontrol( ...
	'cdata', get_button_image('zoom-in-b.png'), ...
	'tooltip', 'Zoom In', ...
	'string', '', ...
	'tag', 'BROWSER_ZOOM_IN' ...
);

but(end + 1) = uicontrol( ...
	'tooltip', 'Zoom to Selection', ...
	'string', char(1), ... % 'string', '', ...
	'fontunits', 'pixels', ...
	'fontsize', 18, ...
	'foregroundcolor', 0.5 * ones(1, 3), ...
	'enable', 'on', ...
	'tag', 'BROWSER_ZOOM_SEL' ...
);

% 'cdata', get_button_image('zoom-sel-b.png'), ...

set(but, ...
	'parent', par, ...
	'style', 'pushbutton', ...
	'units', 'normalized', ...
	'fontname', 'Courier', ...
	'callback', {@zoom_button_callback, par} ...
);

%--
% resize
%--

browser_resizefcn(par, data);


%------------------------------------
% ZOOM_BUTTON_CALLBACK
%------------------------------------

function zoom_button_callback(obj, eventdata, par)

switch get(obj, 'tag');
	
	case 'BROWSER_ZOOM_IN'		
		browser_zoom('in', par);

	case 'BROWSER_ZOOM_OUT'
		browser_zoom('out', par);
		
	case 'BROWSER_ZOOM_SEL'
		browser_zoom('sel', par);
		
end


