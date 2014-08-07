function out = log_browser_palettes(h,str)

% log_browser_palettes - create browser palettes
% ------------------------------------------
%
% PAL = log_browser_palettes
%
% g = log_browser_palettes(h,str)
%
% Input:
% ------
%  h - browser figure handle
%  str - toy name
%
% Output:
% -------
%  PAL - names of browser palettes
%  g - toy figure handle

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% create list of available toys (palettes)
%--

% 'Navigate Log', ... % this palette is not implemented yet
	
PAL = { ...
};

% PAL = { ...
% 	'Colormap', ...
% 	'Grid', ...
% 	'Navigate', ...
% 	'Page', ...
% 	'Sound', ...
% 	'Spectrogram' ...
% };

%--
% output palette names
%--

if ~nargin
	out = PAL;
	return;
end

%--
% set command string
%--

if nargin < 2
	str = 'Show';
end

%--
% set figure
%--

if nargin < 1
	h = gcf;
end

%--
% check for existing palette and bring to front and center
%--

out = get_palette(h,str);

if (~isempty(out))
	
	%--
	% bring to front
	%--

	figure(out);
	
	%--
	% center in parent
	%--
	
	%--
	% get parent and palette positions
	%--
	
	par = get(h,'position');
	pal = get(out,'position');
	
	%--
	% compute and set palette position
	%--
	
	pal(1) = par(1) + (par(3) / 2) - (pal(3) / 2);
	pal(2) = par(2) + ((3 * par(4)) / 4) - pal(4);
	
	set(out,'position',pal);
	
	%--
	% return
	%--
	
	return;
	
end

%--
% get parent userdata
%--

data = get(h,'userdata');
		
%--
% show palettes
%--

switch (str)
	
	%-----------------------------------
	% Colormap Palette
	%-----------------------------------
	
	case ('Colormap')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		%--
		% Colormap
		%--
				
		tmp = colormap_to_fun;
		ix = find(strcmp(tmp,data.browser.colormap.name));
		if (isempty(ix))
			ix = 1;
		end
	
		control(1) = control_create( ...
			'name','Colormap', ...
			'tooltip','Colormap of image display', ...
			'style','popup', ...
			'space',1.5, ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
	
		%--
		% Separator
		%--
		
		control(2) = control_create( ...
			'style','separator' ...
		);
	
		%--
		% Brightness
		%--
		
		control(3) = control_create( ...
			'name','Brightness', ...
			'tooltip','Center of dynamic range', ...
			'style','slider', ...
			'value',data.browser.colormap.brightness ...
		);
	
		%--
		% Contrast
		%--
		
		control(4) = control_create( ...
			'name','Contrast', ...
			'tooltip','Width of dynamic range', ...
			'style','slider', ...
			'value',data.browser.colormap.contrast ...
		);
	
		%--
		% Auto Scale
		%--
		
		control(5) = control_create( ...
			'name','Auto Scale', ...
			'tooltip','Toggle automatic scaling of colormap (A)', ...
			'style','checkbox', ...
			'space',1, ...
			'lines',0, ...
			'value',data.browser.colormap.auto_scale ...
		);
	
		%--
		% Separator
		%--
		
		control(6) = control_create( ...
			'style','separator' ...
		);

		%--
		% Invert
		%--
		
		control(7) = control_create( ...
			'name','Invert', ...
			'tooltip','Toggle inversion of colormap (I)', ...
			'style','checkbox', ...
			'space',0.75, ...
			'lines',0, ...
			'value',data.browser.colormap.invert ...
		);
	
		%--
		% Colorbar
		%--
		
		tmp = ~isempty(findobj(h,'tag','Colorbar','type','axes'));
		
		control(8) = control_create( ...
			'name','Colorbar', ...
			'tooltip','Toggle display of colorbar (C)', ...
			'style','checkbox', ...
			'space',0.75, ... 
			'lines',0, ...
			'value',tmp ...
		);
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0.5;
		opt.bottom = 1;
		
		out = control_group(h,'log_browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		set(out, ...
			'tag',['XBAT_PALETTE::' str], ...
			'keypressfcn',['palette_kpfun(' num2str(h) ');'] ...
		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','log_browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%--
		% update controls state
		%--
		
		if (data.browser.colormap.auto_scale)
			control_update(h,'Colormap','Brightness','__DISABLE__');
			control_update(h,'Colormap','Contrast','__DISABLE__');
		end
		
		if (data.browser.colormap.contrast == 0)
			control_update(h,'Colormap','Brightness','__DISABLE__');
		end
		
	%-----------------------------------
	% Grid Palette
	%-----------------------------------
	
	case ('Grid')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
		
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'space',0.5, ...
			'string','Color' ...
		);
	
		%--
		% Color
		%--
		
		tmp = color_to_rgb;
		ix = find(strcmp(tmp,rgb_to_color(data.browser.grid.color)));
		if (isempty(ix))
			ix = 1;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Color', ...
			'tooltip','Color used to display axes, grids, and associated text', ...
			'style','popup', ...
			'space',1.5, ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
	
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Time' ...
		);
	
		%--
		% Time Spacing
		%--
		
		dt = data.browser.grid.time.spacing;
		if (isempty(dt))
			dt = 0;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Time Spacing', ...
			'tooltip','Spacing between time ticks in seconds', ...
			'style','slider', ...
			'min',0.05, ...
			'max',120, ...
			'value',dt ...
		);
	
		%--
		% Time Labels
		%--
		
		tmp = {'Seconds','Clock','Date and Time'};
		ix = find(strcmp(lower(tmp),data.browser.grid.time.labels));
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Time Labels', ...
			'tooltip','Format of displayed times', ...
			'style','popup', ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
		
		%--
		% Time Grid
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Time Grid', ...
			'tooltip','Toggle display of time grid ('';'')', ...
			'style','checkbox', ...
			'lines',0, ...
			'value',data.browser.grid.time.on ...
		);
	
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Frequency' ...
		);
	
		%--
		% Freq Spacing
		%--
		
		r = data.browser.sound.samplerate;
		df = data.browser.grid.freq.spacing;
		
		if (isempty(df))
			df = 0;
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Freq Spacing', ...
			'tooltip','Spacing between frequency ticks in Hz', ...
			'style','slider', ...
			'min',0, ...
			'max',(r / 2), ...
			'value',df ...
		);
		
		%--
		% Freq Labels
		%--
				
		tmp = {'Hz','kHz'};
		ix = find(strcmp(tmp,data.browser.grid.freq.labels));
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Freq Labels', ...
			'tooltip','Format of displayed frequencies', ...
			'style','popup', ...
			'lines',1, ...
			'string',tmp, ...
			'value',ix ...
		);
		
		%--
		% Freq Grid
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Freq Grid', ...
			'tooltip','Toggle display of frequency grid', ...
			'style','checkbox', ...
			'lines',0, ...
			'value',data.browser.grid.freq.on ...
		);
		
		%--
		% add file grid control only when the sound is not a single file
		%--
		
		if (~strcmp(data.browser.sound.type,'File'))
			
			%--
			% Separator
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'string','File' ...
			);
		
			%--
			% File Grid
			%--
				
			j = j + 1;
			control(j) = control_create( ...
				'name','File Grid', ...
				'tooltip','Toggle display of file boundaries grid ('':'')', ...
				'style','checkbox', ...
				'lines',0, ...
				'value',data.browser.grid.file.on ...
			);
		
		end
	
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		%--
		% create control group in new figure
		%--
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1;
		
		out = control_group(h,'log_browser_controls',str,control,opt);
		
		%--
		% set palette figure tag and key press function
		%--
		
		set(out, ...
			'tag',['XBAT_PALETTE::' str], ...
			'keypressfcn',['palette_kpfun(' num2str(h) ');'] ...
		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','log_browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
		%--
		% update controls state
		%--
		
		if (data.browser.colormap.auto_scale)
			control_update(h,'Colormap','Brightness','__DISABLE__');
			control_update(h,'Colormap','Contrast','__DISABLE__');
		end
	
	%-----------------------------------
	% Navigate
	%-----------------------------------
	
	case ('Navigate')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		type = data.browser.sound.type;
		
		if (strcmp(type,'File'))

			j = 0;
			
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'string','Time' ...
			);
		
			%--
			% Time
			%--
			
			% get slider properties from browser slider
			
			tmp = get(data.browser.slider);
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Time', ...
				'tooltip','Start time of page in current time format', ...
				'style','slider', ...
				'string',0.45, ...
				'type','time', ...
				'min',tmp.Min, ...
				'max',tmp.Max, ...
				'sliderstep',tmp.SliderStep, ...
				'value',tmp.Value ...
			);
		
			%--
			% Previous-Next Page
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name',{'Previous Page','Next Page'}, ...
				'tooltip',{'Go to previous page (''Left Arrow'' or B)','Go to next page (''Right Arrow'' or N)'}, ...
				'style','buttongroup', ...
				'lines',1.75 ...
			);
		
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'string','View' ...
			);
		
			%--
			% View
			%--
			
			tmp = data.browser.view;
			
			j = j + 1;
			control(j) = control_create( ...
				'name','View', ...
				'tooltip','Move to saved previous view', ...
				'style','slider', ...
				'string',0.45, ...
				'type','integer', ...
				'min',1, ...
				'max',tmp.max, ...
				'sliderstep',[1,5] / (tmp.max - 1), ...
				'value',tmp.position ...
			);
			
			%--
			% Previous-Next View
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name',{'Previous View','Next View'}, ...
				'tooltip',{'Go to previous view (''<'')','Go to next view (''>'')'}, ...
				'style','buttongroup', ...
				'lines',1.75 ...
			);
		
% 			%--
% 			% Separator/Header
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'style','separator', ...
% 				'string','Event' ...
% 			);
% 		
% 			%--
% 			% Previous-Next Event
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'name',{'Previous Event','Next Event'}, ...
% 				'tooltip',{'Go to previous event','Go to next event'}, ...
% 				'style','buttongroup', ...
% 				'string','Event', ...
% 				'lines',1.75 ...
% 			);
		
			%--
			% set palette figure options
			%--
			
			opt = control_group;
		
			opt.width = 7.5;
			opt.top = 0;
			opt.bottom = 0;
				
		else
		
			j = 0;
			
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'string','Time' ...
			);
		
			%--
			% Time
			%--
			
			% get slider properties from browser slider
			
			tmp = get(data.browser.slider);
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Time', ...
				'tooltip','Start time of page in current time format', ...
				'style','slider', ...
				'string',0.45, ...
				'type','time', ...
				'min',tmp.Min, ...
				'max',tmp.Max, ...
				'sliderstep',tmp.SliderStep, ...
				'value',tmp.Value ...
			);
		
			%--
			% Previous-Next Page
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name',{'Previous Page','Next Page'}, ...
				'tooltip',{'Go to previous page (''Left Arrow'' or B)','Go to next page (''Right Arrow'' or N)'}, ...
				'style','buttongroup', ...
				'lines',1.75 ...
			);
	
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'space',0.5, ...
				'string','File' ...
			);
		
			%--
			% File
			%--
			
			tmp = data.browser.sound.file;
			
			j = j + 1;
			control(j) = control_create( ...
				'name','File', ...
				'tooltip','Align page start with file start', ...
				'style','popup', ...
				'string',tmp, ...
				'value',1 ...
			);
		
			%--
			% Previous-Next File
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name',{'Previous File','Next File'}, ...
				'tooltip',{'Go to start of previous file (''['')','Go to start of next file ('']'')'}, ...
				'style','buttongroup', ...
				'lines',1.75 ...
			);
		
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'string','View' ...
			);
		
			%--
			% View
			%--
			
			tmp = data.browser.view;
			
			j = j + 1;
			control(j) = control_create( ...
				'name','View', ...
				'tooltip','Move to saved previous view', ...
				'style','slider', ...
				'string',0.45, ...
				'type','integer', ...
				'min',1, ...
				'max',tmp.max, ...
				'sliderstep',[1,5] / (tmp.max - 1), ...
				'value',tmp.position ...
			);
		
			%--
			% Previous-Next View
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'name',{'Previous View','Next View'}, ...
				'tooltip',{'Go to previous view (''<'')','Go to next view (''>'')'}, ...
				'style','buttongroup', ...
				'lines',1.75 ...
			);
		
% 			%--
% 			% Separator/Header
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'style','separator', ...
% 				'string','Event' ...
% 			);
% 		
% 			%--
% 			% Previous-Next Event
% 			%--
% 			
% 			j = j + 1;
% 			control(j) = control_create( ...
% 				'name',{'Previous Event','Next Event'}, ...
% 				'tooltip',{'Go to previous event','Go to next event'}, ...
% 				'style','buttongroup', ...
% 				'string','Event', ...
% 				'lines',1.75 ...
% 			);
		
			%--
			% set palette figure options
			%--
			
			opt = control_group;
		
			opt.width = 7.5;
			opt.top = 0;
			opt.bottom = 0;
		
		end
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		%--
		% create control figure
		%--
		
		out = control_group(h,'log_browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out, ...
			'tag',['XBAT_PALETTE::' str], ...
			'keypressfcn',['palette_kpfun(' num2str(h) ');'] ...
		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','log_browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);	
		
		%-----------------------------------
		% UPDATE CONTROLS
		%-----------------------------------
		
		% this updates most of the navigation controls
		
		browser_navigation_update(h,data);
		
	%-----------------------------------
	% Page Palette
	%-----------------------------------
	
	case ('Page')

		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
		
		% this control element is available only for multiple channel
		% signals
		
		if (data.browser.sound.channels > 1)
			
			%--
			% Separator/Header
			%--
			
			j = j + 1;
			control(j) = control_create( ...
				'style','separator', ...
				'space',0.5, ...
				'string','Channels' ...
			);
	
			%--
			% Channels
			%--
			
			% create channel name strings
			
			nch = data.browser.sound.channels;
			
			for k = 1:nch
				L{k} = ['Channel ' int2str(k)];
			end
			
			% add channel play information to strings
			
			chp = data.browser.play.channel;
			
			if (~diff(chp))
				L{chp(1)} = [L{chp(1)} '  (LR)'];
			else
				L{chp(1)} = [L{chp(1)} '  (L)'];
				L{chp(2)} = [L{chp(2)} '  (R)'];
			end
			
			% get currently displayed channels
			
			ch = data.browser.channels;
			
			j = j + 1;
			control(j) = control_create( ...
				'name','Channels', ...
				'tooltip','Channels displayed in page', ...
				'style','listbox', ...
				'min',0, ...
				'max',2, ...
				'lines',max(min(12,(0.75 * nch + 0.5)),1.1), ...
				'value',ch, ...
				'string',L, ...
				'confirm',1 ...
			);
		
		end
		
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Time' ...
		);
	
		%--
		% Duration
		%--
		
		r = data.browser.sound.samplerate;
		T = data.browser.sound.duration;
		
		% compute maximum page duration, 4000 spectrogram slices with fft of 512 and hop 0.25
		
		M = (4000 * 512 * 0.25) / r;
			
		j = j + 1;
		control(j) = control_create( ...
			'name','Duration', ...
			'tooltip','Displayed page duration in seconds', ...
			'style','slider', ...
			'min',1/4, ...
			'max',min(T,M), ...
			'value',data.browser.page.duration ...
		);
	
		%--
		% Overlap
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Overlap', ...
			'tooltip','Page overlap as fraction of page duration', ...
			'style','slider', ...
			'space',1.5, ...
			'min',0, ...
			'max',0.75, ...
			'value',data.browser.page.overlap ...
		);
		
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Frequency' ...
		);
	
		%--
		% Min Freq
		%--
		
		freq = data.browser.page.freq;
		
		if (isempty(freq))
			freq = [0, r / 2];
		end
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Min Freq', ...
			'tooltip','Minimum page displayed frequency in Hz', ...
			'style','slider', ...
			'type','integer', ...
			'min',0, ...
			'max',r / 2, ...
			'value',freq(1) ...
		);

		%--
		% Max Freq
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Max Freq', ...
			'tooltip','Maximum page displayed frequency in Hz', ...
			'style','slider', ...
			'space',1.5, ...
			'type','integer', ...
			'min',0, ...
			'max',floor(r / 2), ...
			'value',freq(2) ...
		);

		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		%--
		% create control figure
		%--
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1.5;
		
		out = control_group(h,'log_browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out, ...
			'tag',['XBAT_PALETTE::' str], ...
			'keypressfcn',['palette_kpfun(' num2str(h) ');'] ...
		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','log_browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);	
	
	%-----------------------------------
	% Sound Palette
	%-----------------------------------
	
	case ('Sound')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
			
		j = 0;
		
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Rate' ...
		);
	
		%--
		% Rate
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Rate', ...
			'tooltip','Play rate as multiple of natural (sampling) rate', ...
			'style','slider', ...
			'min',1/32, ...
			'max',16, ...
			'value',data.browser.play.speed ...
		);
	
		%--
		% Separator/Header
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Play', ...
			'space',0.5 ...
		);
	
		%--
		% Play
		%--
		
		% note that the name is a column cell array
		
		j = j + 1;
		control(j) = control_create( ...
			'string','Play', ...
			'name',{'Selection', 'Page'}, ... 
			'tooltip',{'Play selection (P)','Play page (Shift + P)'}, ... 
			'style','buttongroup', ...
			'lines',1.75, ...
			'space',1.5 ...
		);
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1;
		
		out = control_group(h,'log_browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out, ...
			'tag',['XBAT_PALETTE::' str], ...
			'keypressfcn',['palette_kpfun(' num2str(h) ');'] ...
		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','log_browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
		
	%-----------------------------------
	% Spectrogram Palette
	%-----------------------------------
	
	case ('Spectrogram')
		
		%-----------------------------------
		% DEFINE CONTROLS
		%-----------------------------------
		
		j = 0;
		
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','FFT' ...
		);
	
		%--
		% FFT Length
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','FFT Length', ...
			'tooltip','Size of FFT in number of samples', ...
			'style','slider', ...
			'type','integer', ...
			'min',16, ...
			'max',2048, ...
			'value',data.browser.specgram.fft ...
		);
	
		%--
		% Hop Length
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Hop Length', ...
			'tooltip','Size of data advance as fraction of FFT length', ...
			'style','slider', ...
			'space',1.5, ...
			'min',1/64, ...
			'max',1, ...
			'value',data.browser.specgram.hop ...
		);
		
		%--
		% Separator
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'style','separator', ...
			'string','Window' ...
		);
	
		%--
		% Window Type
		%--
		
		tmp = window_to_fun;
		ix = find(strcmp(data.browser.specgram.win_type,tmp));
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Window Type', ...
			'tooltip','Type of data window', ...
			'style','popup', ...
			'string',tmp, ...
			'value',ix ...
		);
		
		%--
		% Window Length
		%--
		
		j = j + 1;
		control(j) = control_create( ...
			'name','Window Length', ...
			'tooltip','Size of window as fraction of FFT length', ...
			'style','slider', ...
			'space',1.5, ...
			'min',1/64, ...
			'max',1, ...
			'value',data.browser.specgram.win_length ...
		);
		
		%-----------------------------------
		% CREATE PALETTE
		%-----------------------------------
		
		opt = control_group;
		
		opt.width = 7.5;
		opt.top = 0;
		opt.bottom = 1.5;
		
		out = control_group(h,'log_browser_controls',str,control,opt);
		
		%--
		% set figure tag
		%--
		
		set(out, ...
			'tag',['XBAT_PALETTE::' str], ...
			'keypressfcn',['palette_kpfun(' num2str(h) ');'] ...
		);
		
		%--
		% register palette and set parent windowbuttondown function
		%--
		
		n = length(data.browser.palettes);
		data.browser.palettes(n + 1) = out;
		
		set(h, ...
			'userdata',data, ...
			'buttondown','log_browser_palettes(gcf,''Show'');' ...
		);
	
		%--
		% set closerequestfcn of palette to unregister palette
		%--
		
		set(out,'closerequestfcn',['delete_palette(' num2str(h) ',''' str ''');']);
	
	%--
	% Show
	%--
	
	case ('Show')
		
		%--
		% hide palettes
		%--
		
		tmp = findobj(0,'type','figure');
		
		tag = get(tmp,'tag');
		ix = strmatch('XBAT_PALETTE',tag);
		
		set(tmp(ix),'visible','off');
		
		%--
		% make palettes visible and bring to the front
		%--
				
		flag = 0;
		
		for k = length(data.browser.palettes):-1:1
			
			tmp = data.browser.palettes(k);
			
			if (ishandle(tmp))
				set(tmp,'visible','on');
				figure(tmp);
			else
				data.browser.palettes(k) = [];
				flag = 1;
			end
			
		end
		
		%--
		% update userdata if needed
		%--
		
		if (flag)
			set(h,'userdata',data);
		end
		
		%--
		% output nothing
		%--
		
		out = [];

end

%--
% position palette
%--

if (~isempty(out))
	
	%--
	% get parent and palette positions
	%--
	
	par = get(h,'position');
	pal = get(out,'position');
	
	%--
	% compute and set palette position
	%--
	
	pal(1) = par(1) + (par(3) / 2) - (pal(3) / 2);
	pal(2) = par(2) + ((3 * par(4)) / 4) - pal(4);
	
	set(out,'position',pal);
	
end
