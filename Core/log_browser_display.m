function varargout = log_browser_display(mode,varargin)

% log_browser_display - create or update log browser display
% ----------------------------------------------------------
%
% [ax,im,sli] = log_browser_display('create',log,ix,dil,row,col)
%
%        flag = log_browser_display('update',ix,dil)
%        flag = log_browser_display('events')
%
% Input:
% ------
%  log - name of log to display
%  ix - start index
%  row - number of rows
%  col - number of columns
%  dil - dilation factor for events
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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1130 $
% $Date: 2005-06-20 09:48:30 -0400 (Mon, 20 Jun 2005) $
%--------------------------------

%--
% set pointer to watch
%--

set(gcf,'pointer','watch');

%--
% set mode
%--

if nargin < 1
	mode = 'update';
end

%--
% get current figure set pointer and get userdata
%--

h = gcf;

data = get(h,'userdata');

%--
% handle input
%--

switch mode
	
	case 'create'
		
		%--
		% require all inputs for the create mode
		%--
		
		log = varargin{1};
		
		ix = varargin{2};
		
		dil = varargin{3};
		
		row = varargin{4};
		
		col = varargin{5};
		
	case 'update'
		
		%--
		% handle variable input for the update mode
		%--
				
		log = data.browser.log;
				
		if length(varargin) < 1 || isempty(varargin{1})
			ix = data.browser.index;
		else
			ix = varargin{1};
		end
		
		if length(varargin) < 2 || isempty(varargin{2})
			dil = data.browser.dilation;
		else
			dil = varargin{2};
		end
		
		row = data.browser.row;
		
		col = data.browser.column;
		
	case 'events'
		
		log = data.browser.log;
		
		ix = data.browser.index;
		
		dil = data.browser.dilation;
		
		row = data.browser.row; 
		
		col = data.browser.column;
		
end

%--
% get log index from parent
%--

parent = get(data.browser.parent,'userdata');

LOGS = file_ext(struct_field(parent.browser.log,'file'));

m = find(strcmp(LOGS,log));

if isempty(m)
	flag = 0; return;
end

%--
% compute maximum event duration and dilated event duration
%--

d = struct_field(parent.browser.log(m).event,'duration');

d = max(d);

d = d * dil;

%--
% create copies of relevant parent userdata fields
%--

r = get_sound_rate(data.browser.sound);

gopt = data.browser.grid;

%--
% check for colorbar
%--

if ~isempty(findobj(h,'type','axes','tag','Colorbar'))
	flag = 1; array_colorbar(h);
else
	flag = 0;
end

%--
% compute depending on mode
%--

switch mode

	%--
	% update log browser display
	%--
	
	case 'update'

		%--
		% get axes and image handles
		%--
		
		ax = data.browser.axes';
		im = data.browser.images';		
		
		%--
		% compute dilated event times and get event samples from sound
		%--
	
		j = 1;
		
		for k = ix:min(ix + (row * col) - 1, parent.browser.log(m).length)
			
			%--
			% get event
			%--
			
			event(j) = parent.browser.log(m).event(k);
			
			%--
			% compute start time of dilated event
			%--
			
			t(j) = [(sum(event(j).time) / 2) - (d / 2)];
			
			if (t(j) < 0)
				t(j) = 0;
			end
			
			if (t(j) + d > parent.browser.sound.duration)
				t(j) = parent.browser.sound.duration - d;
			end
			
			%--
			% get sound samples
			%--
			
			X{j} = sound_read(parent.browser.sound,'time',t(j),d,event(j).channel);
			
			set(ax(j), 'tag', [int2str(m), '.', int2str(k)]);
			
			j = j + 1;
			
		end
		
		%--
		% compute spectrograms
		%--
	
		for k = 1:length(X)
			B{k} = fast_specgram(X{k},r,'power',data.browser.specgram);
		end
	
		%--
		% compute decibel scaling
		%--

		for k = 1:length(X)
			cl(k,:) = fast_min_max(B{k});
			B{k} = lut_dB(B{k},cl(k,:));	
			cl(k,:) = decibel(cl(k,:));
		end
		
		cl = [min(cl(:,1)), max(cl(:,2))];
		
		%--
		% compute time offset if needed
		%--
		
		if strcmp(gopt.time.labels,'clock')
			
			if gopt.time.realtime && ~isempty(parent.browser.sound.realtime)
				
				offset = datevec(data.browser.sound.realtime);
				offset = offset(4:6) * [3600; 60; 1];
				str_type = 1;
				
			else
				str_type = 2;
			end
			
		else
			str_type = 3;
		end
		
		%--
		% update image display of events
		%--
		
		for k = 1:length(X)
			
			%--
			% update spectrogram image data
			%--
		
			set(im(k),'cdata',B{k});
			set(ax(k),'clim',cl);
			
			%--
			% update time limits
			%--
			
			xl = [t(k), t(k) + d];
			
			set(im(k),'xdata',xl);
			set(ax(k),'xlim',xl);
			
			%--
			% set title
			%--
			
			% create time string
			
			switch (str_type)
				
			case (1)
				str = sec_to_clock(event(k).time(1) + offset);
				
			case (2)
				str = sec_to_clock(event(k).time(1));
				
			case (3)
				str = [num2str(event(k).time(1)) ' sec'];
				
			end 
			
			% display title
			
			tmp = title(ax(k), {['# ' int2str(event(k).id)],['t = ' str]});
			
			set(tmp,'color',gopt.color);
			
		end
		
		%--
		% update frequency limits
		%--
		
		if ~isempty(data.browser.page.freq)
			
			if strcmp(gopt.freq.labels,'Hz')
				yl = [0,r / 2];
				set(im,'ydata',yl);
				set(ax,'ylim',data.browser.page.freq);
			else
				yl = [0,r / (2*1000)];
				set(im,'ydata',yl);
				set(ax,'ylim',data.browser.page.freq / 1000);
			end
			
		else
	
			if strcmp(gopt.freq.labels,'Hz')
				yl = [0,r / 2];
				set(im,'ydata',yl);
				set(ax,'ylim',yl);
			else
				yl = [0,r / (2*1000)];
				set(im,'ydata',yl);
				set(ax,'ylim',yl);
			end
			
		end
		
		%--
		% set freqency grid
		%--
		
		yl = get(ax(1),'ylim');
		
		if (~isempty(gopt.freq.spacing))
			
			n = yl / gopt.freq.spacing;
			ix = (ceil(n(1)):floor(n(2))) * gopt.freq.spacing;
			
			if (strcmp(gopt.freq.labels,'Hz'))
				set(ax,'ytick',ix);
			else
				set(ax,'ytick',ix / 1000);
			end
			
		else
			
		end
		
		%--
		% update slider
		%--
	
		sli = data.browser.slider;
		
		mx = parent.browser.log(m).length - (row * col) + 1;	
		step = [(row * col) / mx, 0.1];
	
		set(sli, ...
			'value',ix, ...
			'max', mx, ... 
			'sliderstep', step ...
		);
		
		%--
		% update slider color for light grid color
		%--
	
		tmp = gopt.color;
		
		if ((sum(tmp) >= 0.8) | (max(tmp) >= 0.8))
			set(sli,'backgroundcolor',0.15 * ones(1,3) + 0.1);
		else
			set(sli,'backgroundcolor',get(0,'DefaultFigureColor') - 0.1);
		end 
		
		%--
		% display events
		%--
		
		log_browser_display('events')
		
		%--
		% output flag
		%--
		
		varargout{1} = 1;
		
	%--
	% create browser display
	%--
	
	case 'create'

		%--
		% compute dilated event times and get event samples from sound
		%--
	
		j = 1;
		
		% NOTE: this is a set of event indices to display
		
		ixe = ix:min(ix + (row * col) - 1, parent.browser.log(m).length);
		
		for k = ixe
			
			%--
			% get event
			%--
			
			event(j) = parent.browser.log(m).event(k);
			
			%--
			% compute start time of dilated event
			%--
			
			t(j) = [(sum(event(j).time) / 2) - (d / 2)];
			
			if t(j) < 0
				t(j) = 0;
			end
			
			if t(j) + d > parent.browser.sound.duration
				t(j) = parent.browser.sound.duration - d;
			end

			%--
			% get sound samples
			%--
			
			X{j} = sound_read(parent.browser.sound,'time',t(j),d,event(j).channel);
			
			j = j + 1;
			
		end
		
		nx = length(X);
		
		%--
		% compute spectrograms
		%--
	
		if data.browser.specgram.diff
			
			for k = 1:nx
				X{k} = diff(X{k},1,1);
			end
			
		end
	
		for k = 1:nx
			B{k} = fast_specgram(X{k},r,'power',data.browser.specgram);
		end
	
		%--
		% compute decibel scaling
		%--

		for k = 1:nx
			cl(k,:) = fast_min_max(B{k});
			B{k} = lut_dB(B{k},cl(k,:));	
			cl(k,:) = decibel(cl(k,:));
		end
		
		cl = [min(cl(:,1)), max(cl(:,2))];
		
		%--
		% delete previous axes array
		%--
		
		ax = data.browser.axes;
	
		delete(ax(find(ishandle(ax))));
		
		delete(findobj(gcf,'type','axes','tag','support'));
		
		%--
		% delete slider
		%--
		
		sli = findobj(gcf,'type','uicontrol','style','slider');
		
		if ~isempty(sli)
			delete(sli);
		end
		
		%--
		% create new axes
		%--
	
		opt = axes_array;
		opt.xspace = 0.025;
		opt.yspace = 0.05;
				
		[ax,axs] = axes_array(row,col,opt,[]);
		
		ax = ax';
		im = zeros(size(ax));
		
		%--
		% compute time offset if needed
		%--
		
		if strcmp(gopt.time.labels,'clock')
			
			if gopt.time.realtime & ~isempty(parent.browser.sound.realtime)
				
				offset = datevec(data.browser.sound.realtime);
				offset = offset(4:6) * [3600; 60; 1];
				str_type = 1;
				
			else
				str_type = 2;
			end
			
		else
			str_type = 3;
		end
		
		%--
		% display spectrograms and tag axes using channel numbers
		%--

		for k = 1:nx
			
			%--
			% display spectrogram
			%--
			
			axes(ax(k));
			
			im(k) = imagesc(B{k},cl);

			%--
			% set time limits
			%--
		
			xl = [t(k), t(k) + d];	
			
			set(im(k),'xdata',xl);
			
			set(ax(k),'xlim',xl);
			
			%--
			% set title
			%--
			
			% create time string
			
			switch (str_type)
				
			case (1)
				str = sec_to_clock(event(k).time(1) + offset);
				
			case (2)
				str = sec_to_clock(event(k).time(1));
				
			case (3)
				str = [num2str(event(k).time(1)) ' sec'];
				
			end 
			
			% display title
			
			tmp = title({['# ' int2str(event(k).id)],['t = ' str]});
			
			set(tmp,'color',gopt.color);
			
		end
		
		%--
		% set axes tags
		%--
		
		for k = 1:nx
			set(ax(k),'tag',[int2str(m) '.' int2str(ix + k - 1)]);
		end
		
		%--
		% set generic properties for axes
		%--
		
		set(ax,'box','on');
		set(ax,'ydir','normal');
		
		set(ax,'xticklabel',[]);
		
		tmp = ax';
		set(tmp(:,2:end),'yticklabel',[]);
		
		%--
		% set frequency limits
		%--
	
		if ~isempty(data.browser.page.freq)
			
			if strcmp(gopt.freq.labels,'Hz')
				yl = [0,r / 2];
				set(im(1:nx),'ydata',yl);
				set(ax,'ylim',data.browser.page.freq);
			else
				yl = [0,r / (2*1000)];
				set(im(1:nx),'ydata',yl);
				set(ax,'ylim',data.browser.page.freq / 1000);
			end
			
		else
	
			if strcmp(gopt.freq.labels,'Hz')
				yl = [0,r / 2];
				set(im(1:nx),'ydata',yl);
				set(ax,'ylim',yl);
			else
				yl = [0,r / (2*1000)];
				set(im(1:nx),'ydata',yl);
				set(ax,'ylim',yl);
			end
			
		end
		
		%--
		% set freqency grid
		%--
		
		yl = get(ax(1),'ylim');
		
		if ~isempty(gopt.freq.spacing)
			
			n = yl / gopt.freq.spacing;
			ix = (ceil(n(1)):floor(n(2))) * gopt.freq.spacing;
			
			if (strcmp(gopt.freq.labels,'Hz'))
				set(ax,'ytick',ix);
			else
				set(ax,'ytick',ix / 1000);
			end
	
		end
		
		if (gopt.on & gopt.freq.on)
			set(ax,'ygrid','on');		
		end
		
		set(ax,'ycolor',gopt.color);
		set(ax,'xcolor',gopt.color);

		%--
		% set hold on (this code is equivalent to 'hold on' but faster)
		%--
		
		set(ax,'nextplot','add');
		set(gcf,'nextplot','add');
		
		%--
		% create time position slider
		%--
	
		pos = get(axs,'position');
		pos = [pos(1), pos(2) - 0.075, pos(3), 0.03];
	
		mx = parent.browser.log(m).length - (row * col) + 1;
		step = [(row * col) / mx, 0.1];
		
		sli = uicontrol( ...
			'style', 'slider',...
			'units', 'normalized', ...
			'position', pos, ...
			'callback', ['log_view_menu(' num2str(gcf) ',''Scrollbar'');'], ...
			'min', 1, ...
			'max', mx, ...
			'sliderstep', step, ...
			'value', ix ...
		);
		
		%--
		% atach navigation contextual menu to slider
		%--
		
		c = uicontextmenu;
		set(sli,'uicontextmenu',c);
		
% 		if (strcmp(parent.browser.sound.type,'File'))
			
			L = { ...
				'Previous View', ...
				'Next View', ...
				'First Page', ...
				'Previous Page', ...
				'Next Page', ...
				'Last Page', ... 			
				'Go To Page ...', ...
				'Navigate Options ...' ...
			};
		
			n = length(L);
			S = bin2str(zeros(1,n));	
			S{3} = 'on';
			S{end} = 'on';
			
			mg = menu_group(c,'log_view_menu',L,S);
			
			set(get_menu(mg,'Previous View'),'enable','off');
			set(get_menu(mg,'Next View'),'enable','off');
		
% 		else
% 			
% 			L = { ...
% 				'Previous View', ...
% 				'Next View', ...
% 				'First Page', ...
% 				'Previous Page', ...
% 				'Next Page', ...	
% 				'Last Page', ... 			
% 				'Go To Page ...' ...
% 				'File', ...
% 				'Previous File', ...
% 				'Next File', ...
% 				'Go To File ...', ...
% 				'Navigate Options ...' ...
% 			};
% 		
% 			n = length(L);
% 			S = bin2str(zeros(1,n));	
% 			S{3} = 'on';
% 			S{8} = 'on';
% 			S{end} = 'on';
% 			
% 			mg = menu_group(c,'log_view_menu',L,S);
% 			
% 			L = parent.browser.sound.file;
% 			menu_group(get_menu(mg,'File'),'log_view_menu',L);
% 		
% 		end
		
		%--
		% update slider color for light grid color
		%--
	
		tmp = gopt.color;
		
		if ((sum(tmp) >= 0.8) | (max(tmp) >= 0.8))
			tmp = 0.15 * ones(1,3);
			set(gcf,'color',tmp);
			set(sli,'backgroundcolor',tmp + 0.1);
		else
			tmp = get(0,'DefaultFigureColor');
			set(gcf,'color',tmp);
			set(sli,'backgroundcolor',tmp - 0.1);
		end 
		
		%--
		% display events
		%--

		tmp = min(ix + (row * col) - 1);
		ix = ix:tmp;
		event_view('log',h,m,ix,ax,data);
		
		%--
		% output handles
		%--
		
		varargout{1} = ax'; 
		varargout{2} = im'; 
		varargout{3} = sli;
		
		
	case 'events'
		
		%--
		% get indices of events displayed from axes tags
		%--
		
		ax = data.browser.axes;
		
		tag = get(ax,'tag');
		
		for k = 1:length(tag)
			[tmp,str] = strtok(tag{k},'.'); 
			ix(k) = eval(str(2:end));
		end
		
		m = eval(tmp);
		
		%--
		% delete previous event display objects
		%--

		type = {'uimenu','uicontextmenu','line','patch'};
		
		for k = 1:length(type)
			delete(findall(ax,'type',type{k}));
		end

		% make sure that we do not remove axes titles
		
		txt = findall(ax,'type','text');
		tit = cell2mat(get(ax,'title'));
		
		delete(setdiff(txt,tit));
		
		%--
		% delete selection display objects
		%--

		delete(findall(gcf,'tag','selection'));
		
		%--
		% display events
		%--

		event_view('log',h,m,ix,ax,data);
		
end

%--
% recreate colorbar if needed
%--

if (flag)
		
	array_colorbar;
	
	ax = findobj(h,'type','axes','tag','Colorbar');
	tmp = data.browser.grid.color;
	set(ax,'XColor',tmp,'YColor',tmp);
	set(get(ax,'title'),'color',tmp);
			
end

%--
% update colorbar if needed
%--

tmp = findobj(gcf,'type','axes','tag','Colorbar');
	
if (~isempty(tmp) & exist('cl'))
	set(tmp,'ylim',cl);
	set(findobj(gcf,'tag','TMW_COLORBAR'),'ydata',cl);
end 

%--
% reset colormap if needed
%--

log_view_menu(gcf,data.browser.colormap.name);

%--
% refresh figure
%--

refresh(gcf);

set(gcf,'pointer','arrow');
