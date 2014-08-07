function out = browser_view_menu(h, str, data)

% browser_view_menu - browser sound view options menu
% ---------------------------------------------------
%
% browser_view_menu(h, str, data)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  data - figure userdata
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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
% $Revision: 2273 $
%--------------------------------

out = [];

%-------------------------------------------
% SETUP
%-------------------------------------------

%--
% create variable tables
%--

% NOTE: the various tables should be persistent in their original functions

[COLOR, COLOR_SEP] = color_to_rgb;

[LINESTYLE, LINESTYLE_SEP] = linestyle_to_str('', 'strict');

[WINDOW, WINDOW_SEP] = window_to_fun;

[COLORMAP, COLORMAP_SEP] = colormap_to_fun;

LOWER_COLORMAP = lower(COLORMAP);

%-------------------------------------------
% HANDLE INPUT
%-------------------------------------------

%--
% get browser state
%--

if (nargin < 3) 
	data = get_browser(h);
end

%--
% set default command string
%--

if (nargin < 2)
	str = 'Initialize';
end

if ~nargout
	clear('out');
end

%--
% perform command sequence
%--

if iscell(str)
	
	for k = 1:length(str)
		browser_view_menu(h, str{k}); 
	end
	
	return;	
	
end

%--
% get parameter from command string
%--

% TODO: this is not currrently used implement better way of doing this

[str, param] = strtok(str,'::');

if ~isempty(param)
    param = param(3:end);
end

%-------------------------------------------
% COMMAND SWITCH
%-------------------------------------------

% NOTE: create a way of passing parameters to the commands in the command line

switch (str)

%-------------------------------------------
% CREATE MENU
%-------------------------------------------

%-------------------------------------------
% Initialize
%-------------------------------------------

case ('Initialize')
	
	%--
	% check for existing menu
	%--
	
	if get_menu(h, 'View')
		return;
	end
	
	%---------------------------
	% View
	%---------------------------

	L = { ...
		'View', ...
		'Selection ', ...
		'Selection Zoom', ...
		'Selection Options', ...
		'Navigate', ...
		'Navigate Options', ...
		'Channels', ...
		'Signal', ...
		'Signal Options', ...
		'Spectrogram', ... 		
		'Spectrogram Options', ...
		'Colorbar', ...
		'Colormap', ... 	
		'Colormap Options', ...
		'Time Grid', ...
		'Freq Grid', ...	
		'Grid Options' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{5} = 'on';
	S{8} = 'on';
	S{10} = 'on';
	S{12} = 'on';
	S{15} = 'on';
	
	mg = menu_group(h,'browser_view_menu', L, S);	
	
	data.browser.view_menu.sound = mg;
	
	if data.browser.selection.on
		set(get_menu(mg,'Selection '), 'check', 'on'); 
	end
	
	if data.browser.selection.zoom
		set(get_menu(mg,'Selection Zoom'),'check','on');
	end
	
	if data.browser.specgram.on
		set(get_menu(mg,'Spectrogram'),'check','on');
	end
	
	if data.browser.grid.time.on
		set(get_menu(mg,'Time Grid'),'check','on');
	end
	
	if data.browser.grid.freq.on
		set(get_menu(mg,'Freq Grid'),'check','on');
	end
	
	% NOTE: turn off currently unavailable commands, maybe discard
	
	set(get_menu(mg,'Signal'),'enable','off');
	
	set(get_menu(mg,'Signal Options'),'enable','off');
	
	set(get_menu(mg,'Spectrogram'),'enable','off');
	
	set(mg(1),'position',3);
	
	%---------------------------
	% Selection Options
	%---------------------------
	
	L = { ...
		'Grid', ...
		'Labels', ...
		'Control Points', ...
		'Color', ...
		'Line Style', ...
		'Line Width', ...
		'Opacity' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{4} = 'on';
	
	mg = menu_group(get_menu(h,'Selection Options'),'browser_view_menu;',L,S);
	
	data.browser.view_menu.selection_options = mg;
	
	if data.browser.selection.grid
		set(get_menu(mg,'Grid'),'check','on');
	end
	
	if data.browser.selection.label
		set(get_menu(mg,'Grid'),'check','on');
	end
	
	if data.browser.selection.control
		set(get_menu(mg,'Control Points'),'check','on');
	end
	
	%--
	% Selection Options: Color
	%--
	
	tmp = menu_group(get_menu(mg,'Color'),'browser_view_menu;',COLOR,COLOR_SEP);
	
	data.browser.view_menu.selection_color = tmp;
	
	color_name = rgb_to_color(data.browser.selection.color);
	if (~isempty(color_name))
		set(get_menu(tmp,color_name),'check','on');
	end
	
	%--
	% Selection Options: Line Style
	%--
	
	tmp = menu_group(get_menu(mg,'Line Style'),'browser_view_menu;',LINESTYLE,LINESTYLE_SEP);
	
	data.browser.view_menu.selection_linestyle = tmp;
	
	%--
	% Selection Options: Line Width
	%--
	
	L = {'1 pt','2 pt','3 pt','4 pt'};
	
	tmp = menu_group(get_menu(mg,'Line Width'),'browser_view_menu;',L);
	
	data.browser.view_menu.selection_linewidth = tmp;
		
	ix = find(data.browser.selection.linewidth == [1,2,3,4]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Selection Options: Opacity
	%--
	
	L = { ...
		'Transparent', ...
		'1/8 Alpha', ...
		'1/4 Alpha', ...
		'1/2 Alpha', ...
		'3/4 Alpha', ...
		'Opaque' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
	
	tmp = menu_group(get_menu(mg,'Opacity'),'browser_view_menu;',L,S);
	
	data.browser.view_menu.selection_patch = tmp;
		
	ix = find(data.browser.selection.patch == [0, 0.125, 0.25, 0.5, 0.75, 1]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%---------------------------
	% Navigate Options
	%---------------------------
		
	L = { ...
		'Page Duration', ...
		'Page Overlap', ...
		'Freq Range ...', ...
		'Edit All ...' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{end} = 'on';
	
	data.browser.view_menu.page_options = ...
		menu_group(get_menu(h, 'Navigate Options'), 'browser_view_menu;', L, S);
	
	%--
	% Page Duration
	%--
	
	L = { ...
		'1 sec/Page', ...
		'2 sec/Page', ...
		'3 sec/Page', ...
		'4 sec/Page', ...
		'10 sec/Page', ...
		'20 sec/Page', ...
		'30 sec/Page', ...
		'60 sec/Page', ...
		'Other Page Duration ...' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{5} = 'on';
	S{end} = 'on';

	data.browser.view_menu.page_duration = ...
		menu_group(get_menu(h,'Page Duration'),'browser_view_menu;',L,S);
			
	ix = find(data.browser.page.duration == [1,2,3,4,10,15,30,60]);
	if (~isempty(ix))
		set(data.browser.view_menu.page_duration(ix),'check','on');
	else
		set(data.browser.view_menu.page_duration(end),'check','on');
	end
	
	%--
	% Page Overlap
	%--
	
	L = { ...
		'No Page Overlap', ...
		'1/2 Page', ...
		'1/4 Page', ...
		'1/8 Page', ...
		'Other Page Overlap ...' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';

	data.browser.view_menu.page_overlap = ...
		menu_group(get_menu(h,'Page Overlap'),'browser_view_menu;',L,S);
	
	ix = find(data.browser.page.overlap == [0,1/2,1/4,1/8]);
	if (~isempty(ix))
		set(data.browser.view_menu.page_overlap(ix),'check','on');
	else
		set(data.browser.view_menu.page_overlap(end),'check','on');
	end
	
	%---------------------------
	% Navigate
	%---------------------------

	% setup navigation menu for single file sounds
	
	[ignore, type] = is_sound_type(data.browser.sound.type);
	
	if strcmp(type,'file') || strcmp(type,'variable') || strcmp(type,'synthetic')
		
		L = { ...
			'Previous View', ...
			'Next View', ...
			'First Page', ...	
			'Previous Page', ...
			'Next Page', ...	
			'Last Page', ... 			
			'Go To Page ...' ...
		};
	
		n = length(L);
		S = bin2str(zeros(1,n));	
		S{3} = 'on';
		A = cell(1,n);
		
		data.browser.view_menu.page = ...
			menu_group(get_menu(h,'Navigate'),'browser_view_menu;',L,S,A);
	
	% setup navigation menus for multiple file sounds
	
	else
		
		L = { ...
			'Previous View', ...
			'Next View', ...
			'First Page', ...	
			'Previous Page', ...	
			'Next Page', ...	
			'Last Page', ... 			
			'Go To Page ...' ...	
			'File', ...
			'Previous File', ...
			'Next File', ...
			'Go To File ...' ...
		};
	
		n = length(L);
		S = bin2str(zeros(1,n));	
		S{3} = 'on';
		S{8} = 'on';
		A = cell(1,n);
		
		mg = menu_group(get_menu(h,'Navigate'),'browser_view_menu;',L,S,A);
		
		data.browser.view_menu.page = mg;
		
		L = data.browser.sound.file;
		menu_group(get_menu(mg,'File'),'browser_view_menu;',L);
	
	end
	
	%---------------------------
	% Channels
	%---------------------------

	nch = data.browser.sound.channels;
	
	if (nch > 1)
		
		ax = data.browser.axes;
		
		L = cell(0);
		for k = 1:nch
			L{k} = ['Channel ' num2str(k)];
		end
		L{nch + 1} = 'Display All';
		
		S = bin2str(zeros(1,nch + 1));
		S{nch + 1} = 'on';
					
		mg = menu_group(get_menu(data.browser.view_menu.sound,'Channels'),'browser_view_menu;',L,S);
		data.browser.view_menu.channels = mg;

		for k = 1:length(ax)
			set(get_menu(mg,['Channel ' get(ax(k),'tag')],2),'check','on');
		end
		
		pch = data.browser.play.channel;
		
	else
		
		delete(get_menu(h,'Channels Displayed'));
		
	end
	
	%---------------------------
	% Spectrogram Options
	%---------------------------
	
	L = { ...
		'FFT Size', ...	
		'FFT Advance', ... 	
		'Window ...', ...
		'Edit All ...' ...
	};
		
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{end} = 'on';
	
	mg = menu_group(get_menu(h,'Spectrogram Options'),'browser_view_menu;',L,S);
	
	data.browser.view_menu.specgram = mg;
	
	%--
	% FFT Size
	%--
	
	L = { ...
		'128 samples', ...
		'256 samples', ...
		'512 samples', ...
		'1024 samples', ... 
		'Other FFT Size ...' ... % 5 - sep
	};
		
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{end} = 'on';
			
	mg = menu_group(get_menu(h,'FFT Size'),'browser_view_menu;',L,S);
	
	data.browser.view_menu.fft_length = mg;
	
	ix = find(data.browser.specgram.fft == [128,256,512,1024]);
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		set(mg(end),'check','on');
	end
	
	%--
	% FFT Advance
	%--
	
	L = { ...
		'FFT Size', ...
		'3/4 FFT Size', ...
		'1/2 FFT Size', ...		
		'1/4 FFT Size', ... 		
		'1/8 FFT Size', ... 	
		'Other FFT Advance ...' ... % 5 - sep
	};
		
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';

	mg = menu_group(get_menu(h,'FFT Advance'),'browser_view_menu;',L,S);
	
	data.browser.view_menu.hop_length = mg;
	
	set(mg,'tag','hop');
	ix = find(data.browser.specgram.hop == [1,0.75,0.5,0.25,0.125]);
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		set(mg(end),'check','on');
	end 
	
	%---------------------------
	% Colormap
	%---------------------------

	L = COLORMAP; S = COLORMAP_SEP;
			
	mg = menu_group(get_menu(h,'Colormap'),'browser_view_menu;',L,S);
	
	data.browser.view_menu.colormap = mg;
	
	ix = find(strcmpi(data.browser.colormap.name,COLORMAP));
	
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		warning('Unrecognized colormap.');
	end

	%---------------------------
	% Colormap Options
	%---------------------------
	
	L = { ...
		'Invert', ...
		'Auto Scale', ...
		'Contrast ...' ...
	};
	
	n = length(L);

	S = bin2str(zeros(1,n));
	S{end} = 'on';
	
	mg = menu_group(get_menu(h,'Colormap Options'),'browser_view_menu;',L,S);
	
	data.browser.view_menu.colormap_options = mg;
	
	if (data.browser.colormap.invert)
		cmap_invert;
		set(get_menu(mg,'Invert'),'check','on');
	end
	
	if (data.browser.colormap.auto_scale)
		cmap_scale([],data.browser.images);
		set(get_menu(mg,'Auto Scale'),'check','on');
	end
		
	%---------------------------
	% Grid Options
	%---------------------------
		
	L = { ...
		'Color', ... 
		'Time Spacing', ... 	
		'Time Labels ', ...
		'Freq Spacing', ...
		'Freq Labels ', ...
		'File Grid' ...
	};

	n = length(L);

	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{4} = 'on';
	S{end} = 'on'; 

	mg = menu_group(get_menu(h,'Grid Options'),'browser_view_menu;',L,S);
	
	data.browser.view_menu.grid_options = mg;
	
	if (data.browser.grid.file.on)
		set(get_menu(mg,'File Grid'),'check','on');
	end
	
	%--
	% remove file boundaries menu for single files
	%--
	
	[ignore,type] = is_sound_type(data.browser.sound.type);
	
	if (strcmp(type,'file'))
		
		tmp = get_menu(mg,'File Grid');	
		mg = setdiff(mg,tmp);
		data.browser.view_menu.grid_options = mg;	
		delete(tmp);
		
		tmp = get_menu(mg,'Date and Time');
		set(tmp,'separator','on');
		
	end
		
	%--
	% Color
	%--
	
	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Color'), ...
		'browser_view_menu;',COLOR,COLOR_SEP);
	
	data.browser.view_menu.color = mg;
	
	ix = find(strcmp(rgb_to_color(data.browser.grid.color),COLOR));
	if (~isempty(ix))
		set(mg(ix),'check','on');
	end
	
	%--
	% Time Grid Spacing
	%--
	
	L = { ...
		'Auto', ...
		' 1 sec/Tick', ...
		' 2 sec/Tick', ...
		' 5 sec/Tick', ...
		'10 sec/Tick', ...
		'1/2 sec/Tick', ...
		'1/4 sec/Tick', ...
		'1/10 sec/Tick', ...
		'Other Time Spacing ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{6} = 'on';
	S{end} = 'on';
		
	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Time Spacing'), ...
		'browser_view_menu;',L,S);
	data.browser.view_menu.time_spacing = mg;
	
	if (isempty(data.browser.grid.time.spacing))
		set(mg(1),'check','on');
	else
		ix = find(data.browser.grid.time.spacing == [0, 1, 2, 5, 10, 0.5, 0.25, 0.1]);
		if (~isempty(ix))
			set(mg(ix),'check','on');
		else
			set(mg(end),'check','on');
		end
	end
	
	%--
	% Time Labels 
	%--
	
	L = { ...
		'Seconds', ...
		'Clock', ...
		'Date and Time', ...	
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{end} = 'on';
	
	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Time Labels '), ...
		'browser_view_menu;',L,S);
	data.browser.view_menu.time_labels = mg;
	
	ix = find(strcmp(L,data.browser.grid.time.labels));
	set(mg(ix),'check','on');
	
	if (isempty(data.browser.sound.realtime))
		set(get_menu(mg,'Date and Time'),'enable','off');
	end 
	
	%--
	% Freq Grid Spacing
	%--
	
	L = { ...
		'Auto', ...
		' 25 Hz/Tick', ...
		'100 Hz/Tick', ...
		'500 Hz/Tick', ...
		' 1 kHz/Tick', ... % 2 - sep
		' 2 kHz/Tick', ...
		' 5 kHz/Tick', ...
		'10 kHz/Tick', ...
		'Other Freq Spacing ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{5} = 'on';
	S{end} = 'on';

	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Freq Spacing'), ...
		'browser_view_menu;',L,S);
	data.browser.view_menu.freq_spacing = mg;
	
	if (isempty(data.browser.grid.freq.spacing))
		set(mg(1),'check','on');
	else
		ix = find(data.browser.grid.freq.spacing == [0, 25, 100, 500, 1000, 2000, 5000, 10000]);
		if (~isempty(ix))
			set(mg(ix),'check','on');
		else
			set(mg(end),'check','on');
		end
	end
	
	%--
	% Freq Labels 
	%--
	
	L = { ...
		'Hz', ...
		'kHz' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));

	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Freq Labels '), ...
		'browser_view_menu;',L,S);
	data.browser.view_menu.freq_labels = mg;
	
	if (strcmp(data.browser.grid.freq.labels,'Hz'))
		set(mg(1),'check','on');
	else
		set(mg(2),'check','on');
	end

	%--
	% update userdata to include sound menu
	%--
	
	set(h,'userdata',data);
	
	%---------------------------
	% other initializations
	%---------------------------
	
	%--
	% disable selection menu
	%--
	
	if (isempty(data.browser.parent))
		
		set(get_menu(h,'Select',2),'enable','off');
		
		if (~isempty(get_menu(h,'Log')))
			set(get_menu(data.browser.log_menu.log,'Log Selection ...'),'enable','off');
			set(get_menu(data.browser.log_menu.log,'Quick Log Selection'),'enable','off');
		end
		
	end
	
	%--
	% enable and disable view menus
	%--
	
	if (data.browser.view.position < data.browser.view.length)
		set(get_menu(h,'Next View',2),'enable','on');
	else
		set(get_menu(h,'Next View',2),'enable','off');
	end
	
	if (data.browser.view.position == 1)
		set(get_menu(h,'Previous View',2),'enable','off');
	end
	
	%--
	% enable and disable navigation menus
	%--
	
	if isempty(data.browser.parent)
		browser_navigation_update(h, data);
	end
	
	%--
	% set colormap
	%--
	
	browser_view_menu(h, data.browser.colormap.name, data);
	
	%--
	% set renderer
	%--
	
	update_renderer(h, [], data);
	
	%--
	% redisplay grid to update color
	%--
	
	tmp = rgb_to_color(data.browser.grid.color);
	
	if ~isempty(tmp)
		browser_view_menu(h,tmp);
	end

%----------------------------------------------------------------------
% MENU COMMANDS
%----------------------------------------------------------------------

%------------------------------------------------
% Selection
%------------------------------------------------

case ('Selection ')
	
	%--
	% toggle selection
	%--
	
	state = ~data.browser.selection.on;
	
	data.browser.selection.on = state;
	
	%--
	% update menu
	%--
	
	tmp = data.browser.view_menu.sound;
	
	if (state)
		set(get_menu(tmp,'Selection '),'check','on');
	else
		set(get_menu(tmp,'Selection '),'check','off');
	end
	
	%--
	% update display
	%--
	
	% NOTE: remove selection and update edit menus
	
	if (~state)
		
		%--
		% delete selection display
		%--
		
		if (all(ishandle(data.browser.selection.handle)))
			delete(data.browser.selection.handle);
		end
		
		refresh(h);
		
		%--
		% set empty selection
		%--
		
% 		data.browser.selection.event = event_create;
% 		data.browser.selection.handle = [];
		
		%--
		% disable selection options in edit menu
		%--
	
		tmp = data.browser.edit_menu.edit;
		set(tmp(2:end),'enable','off');
		
	else
		
		if (~isempty(data.browser.selection.copy))
			tmp = data.browser.edit_menu.edit;
			set(get_menu(tmp,'Paste Selection'),'enable','on');
		end
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%------------------------------------------------
% Selection Zoom
%------------------------------------------------

case ('Selection Zoom')
	
	%--
	% update userdata
	%--
		
	state = double(~data.browser.selection.zoom);
	
	data.browser.selection.zoom = state;
	
	set(h,'userdata',data);
	
	%--
	% update selection zoom menu and palette control
	%--
	
	% NOTE: we use the numeric state, then convert to a string state
	
	control_update(h,'Selection','selection_zoom',state,data);
	
	set(get_menu(h,'Selection Zoom'),'check',bin2str(state));
	
%------------------------------------------------
% Selection Options
%------------------------------------------------

case ({'Time','Time-Frequency'})
	
	%--
	% update mode variable
	%--
	
	switch (str)

		case ('Time')

			data.browser.selection.mode = 1;

			tmp = data.browser.view_menu.selection_options;
			set(tmp(1:2),'check','off');
			set(get_menu(tmp,str),'check','on');


		case ('Time-Frequency')

			data.browser.selection.mode = 2;

			tmp = data.browser.view_menu.selection_options;
			set(tmp(1:2),'check','off');
			set(get_menu(tmp,str),'check','on');

	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%------------------------------------------------
% Selection Options > Line Style
%------------------------------------------------

case (LINESTYLE)
	
	%--
	% update linestyle variable
	%--
	
	value = linestyle_to_str(str,'strict');
	
	data.browser.selection.linestyle = value;

	%--
	% update display
	%--
	
	% NOTE: selection display object handles are stored and tagged
	
	g = findobj(h,'type','line','tag','selection');
	
	% NOTE: this step removed the gridlines from consideration
	
	g = setdiff(g,findobj(g,'linewidth',0.5));
	
	set(g,'linestyle',value);
	
	refresh(h);
	
	%--
	% update menu
	%--
	
	g = data.browser.view_menu.selection_linestyle;
	
	set(g,'check','off');
	
	set(get_menu(g,str),'check','on');
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update controls
	%--
	
	control_update(h,'Selection','selection_linestyle',str,data);
	
%------------------------------------------------
% Selection Options > Line Width
%------------------------------------------------

case ({'1 pt','2 pt','3 pt','4 pt'})
	
	%--
	% update linestyle variable
	%--
	
	value = eval(strtok(str,' '));
	
	data.browser.selection.linewidth = value;

	%--
	% update display
	%--
	
	g = findobj(h,'type','line','tag','selection');
	
	g = setdiff(g,findobj(g,'linewidth',0.5));
	
	set(g,'linewidth',value);
	
	refresh(h);
	
	%--
	% update menu
	%--
	
	g = data.browser.view_menu.selection_linewidth;
	set(g,'check','off');
	
	set(get_menu(g,str),'check','on');
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update controls
	%--
	
	control_update(h,'Selection','selection_linewidth',value,data);
	
%------------------------------------------------
% Selection Options > Opacity
%------------------------------------------------

case ({'Transparent','1/8 Alpha','1/4 Alpha','1/2 Alpha','3/4 Alpha','Opaque'})
	
	%--
	% update selection alpha
	%--
	
	switch (str)
		
		case ('Transparent')
			value = 0;
			
		case ('Opaque')
			value = 1;
			
		otherwise
			value = eval(strtok(str,' '));
			
	end

	data.browser.selection.patch = value;
	
	%--
	% update menu and display
	%--
	
	% NOTE: the menu should be adressed directly, not through callback object
	
	set(get(get(gcbo,'parent'),'children'),'check','off');
	
	set(gcbo,'check','on');
	
	%--
	% update display of selection patch
	%--
	
	if (~isempty(data.browser.selection.handle))
		
		if (data.browser.selection.patch > 0)
			
			set(data.browser.selection.handle(2), ...
				'FaceColor',data.browser.selection.color, ...
				'FaceAlpha',data.browser.selection.patch ...
			);
		
		else
			
			set(data.browser.selection.handle(2), ...
				'FaceColor','none', ...
				'FaceAlpha',0 ...
			);
		
		end 
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update renderer and display
	%--
	
	update_renderer(h,[],data);
	
	%--
	% update controls
	%--
	
	control_update(h,'Selection','selection_opacity',value,data);
	
%------------------------------------------------
% Selection Options > Grid
%------------------------------------------------

case ('Grid')
	
	%--
	% toggle display and update userdata
	%--
	
	state = ~data.browser.selection.grid;
	
	data.browser.selection.grid = state;
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--

	% get handles to menus and selection grid lines
	
	tmp = data.browser.view_menu.selection_options;
	
	g1 = findobj(h,'tag','selection','type','line','linewidth',0.5);
	g2 = findobj(h,'tag','selection','type','text');
	
	%--
	% update menus and visibility of selection grid
	%--
	
	if (state)
		
		set(get_menu(tmp,'Grid'),'check','on');
		set(g1,'visible','on');
		if (data.browser.selection.label)
			set(g2,'visible','on');
		end
		
	else
		
		set(get_menu(tmp,'Grid'),'check','off');
		set(g1,'visible','off');
		set(g2,'visible','off');
		
	end
	
	refresh(h);
	
	%--
	% update controls
	%--
	
	control_update(h,'Selection','selection_grid',double(state),data);

%------------------------------------------------
% Selection Options > Labels
%------------------------------------------------

case ('Labels')
	
	%--
	% toggle state and update userdata
	%--
	
	state = ~data.browser.selection.label;
	
	data.browser.selection.label = state;
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--

	% get handles to menus and selection labels
	
	tmp = data.browser.view_menu.selection_options;
	
	g = findobj(h,'tag','selection','type','text');
	
	%--
	% update menus and visibility of selection labels
	%--
	
	if (state)
		
		set(get_menu(tmp,'Labels'),'check','on');
		if (data.browser.selection.grid)
			set(g,'visible','on');
		end
		
	else
		
		set(get_menu(tmp,'Labels'),'check','off');
		set(g,'visible','off');
		
	end
	
	refresh(h);
	
	%--
	% update controls
	%--
	
	control_update(h,'Selection','selection_labels',double(state),data);
	
	
%------------------------------------------------
% Selection Options > Control Points
%------------------------------------------------

case ('Control Points')
		
	%--
	% toggle state and update userdata
	%--
			
	state = ~data.browser.selection.control;
	
	data.browser.selection.control = state;
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--

	% get handles to menus and selection control points
	
	tmp = data.browser.view_menu.selection_options;
	
	g = findobj(h,'tag','selection','type','line','markersize',4);
	
	%--
	% update menus and visibility of selection labels
	%--
	
	if (state & data.browser.selection.on)
		
		set(get_menu(tmp,'Control Points'),'check','on');
		set(g, ...
			'visible','on', ...
			'hittest','on' ...
		);
	
	else
		
		set(get_menu(tmp,'Control Points'),'check','off');
		set(g, ...
			'visible','off', ...
			'hittest','off' ...
		);
	
	end
	
	refresh(h);
	
	%--
	% update controls
	%--
	
	control_update(h,'Selection','control_points',double(state),data);
	
%------------------------------------------------
% Navigate Options > Page Duration
%------------------------------------------------

case ({ ...
	'1 sec/Page', ...
	'2 sec/Page', ...
	'3 sec/Page', ...
	'4 sec/Page', ...
	'10 sec/Page', ...
	'20 sec/Page', ...
	'30 sec/Page', ...
	'60 sec/Page' ...
})
	
	%--
	% update userdata
	%--
	
	tmp = eval(strtok(str,' '));
	
	data.browser.page.duration = tmp;
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.view_menu.page_duration,'check','off');
	
	ix = find(tmp == [1,2,3,4,10,15,30,60]);
	
	set(data.browser.view_menu.page_duration(ix),'check','on');
	
	%--
	% update control
	%--
	
	control_update(h,'Page','Duration',tmp,data)
	
	%--
	% update display
	%--
	
	browser_display(h,'update',data);
	
%------------------------------------------------
% Navigate Options > Other Page Duration ...
%------------------------------------------------

case ('Other Page Duration ...')
	
	% SHORTCUT TO PALETTE
	
	pal = browser_palettes(h,'Page');
	
	% TODO: here we get the browser state again, palette opening has
	% updated state, this is probably a symptom of some yet undiagnosed
	% disease
	
	data = get(h,'userdata');
	
	palette_toggle(h,'Page','Channels','close',data);
	
	palette_toggle(h,'Page','Time','open',data);
	
	palette_toggle(h,'Page','Frequency','close',data);
		
%------------------------------------------------
% Navigate Options > Page Overlap
%------------------------------------------------

case ('No Page Overlap')
	
	%--
	% update userdata
	%--
	
	data.browser.page.overlap = 0;
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.view_menu.page_overlap,'check','off');
	set(data.browser.view_menu.page_overlap(1),'check','on');
	
	%--
	% update control
	%--
	
	control_update(h,'Page','Overlap',0,data);
	
case ({'1/2 Page','1/4 Page','1/8 Page'})

	%--
	% update userdata
	%--
	
	tmp = eval(strtok(str,' '));
	
	data.browser.page.overlap = tmp;
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.view_menu.page_overlap,'check','off');
	
	ix = find(tmp == [0,1/2,1/4,1/8]);
	set(data.browser.view_menu.page_overlap(ix),'check','on');
	
	%--
	% update control
	%--
	
	control_update(h,'Page','Overlap',tmp,data);
	
case ('Other Page Overlap ...')
	
	%--
	% setup palette
	%--
	
	browser_palettes(h,'Page');

	data = get(h,'userdata');
	
	palette_toggle(h,'Page','Channels','close',data);
	
	palette_toggle(h,'Page','Time','open',data);
	
	palette_toggle(h,'Page','Frequency','close',data);
	
%------------------------------------------------
% Freq Range ...
%------------------------------------------------

case ('Freq Range ...')

	%--
	% setup palette
	%--
	
	browser_palettes(h,'Page');
	
	data = get(h,'userdata');
	
	palette_toggle(h,'Page','Channels','close',data);
	
	palette_toggle(h,'Page','Time','close',data);
	
	palette_toggle(h,'Page','Frequency','open',data);
	
%------------------------------------------------
% Navigate > Previous View
%------------------------------------------------

% FIXME: this is currently broken, users want this 

case ('Previous View')

	%--
	% update view variables
	%--
		
	pos = data.browser.view.position;
	
	if (pos > 1)
		pos = pos - 1;
	else
		return;
	end
	
	data.browser.view.position = pos;
	
	%--
	% update display variables in figure data
	%--
		
	% get state variables
	
	state = data.browser.view.state(pos);
	
	% copy state variables to userdata
	
	data.browser.time = state.time;
	
	data.browser.page = state.page;
	
	data.browser.play.channel = state.play.channel;
	
	data.browser.specgram = state.specgram;
	
	data.browser.selection.event = [];
	
	% update userdata
	
	set(h,'userdata',data);
	
	%--
	% consider possible channel change in display update
	%--
	
	if isequal(data.browser.channels,state.channels)
		
		%--
		% simple browser update
		%--
		
		browser_display(h,'update',data);
					
	else

		%--
		% update channels
		%--
		
		ch = state.channels;
		nch = data.browser.sound.channels;
		pch = data.browser.play.channel;
		
		data.browser.channels = ch;
		
		%--
		% update display paying attention to colorbar
		%--
		
		if ~isempty(data.browser.colorbar)
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
			t = array_colorbar;
			data.browser.colorbar = t;
		end
		
		%--
		% get new slider handle
		%--
		
		data.browser.slider = findobj(h,'type','uicontrol','style','slider');
		
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
		
		browser_resizefcn(h,data);
		
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
		
	end
	
	%--
	% enable and disable view menus
	%--
	
	set(get_menu(h,'Next View',2),'enable','on');
	control_update(h,'Navigate','Next View','__ENABLE__',data);
	
	if (data.browser.view.position == 1)
		set(get_menu(h,'Previous View',2),'enable','off');
		control_update(h,'Navigate','Previous View','__DISABLE__',data);
	end
	
	%--
	% enable and disable navigation menus
	%--
	
	browser_navigation_update(h,data);
	
	%--
	% update related menus
	%--
	
	% page duration and overlap
	
	% channels (browser display may take care of these?)
	
	% play channels (browser display may take care of these?)
	
	%--
	% update controls
	%--
	
	view_control_update(h,data);
	
%------------------------------------------------
% Navigate > Next View
%------------------------------------------------

case ('Next View')
	
	%--
	% update view variables
	%--
		
	pos = data.browser.view.position;
	
	if (pos < data.browser.view.length)
		pos = pos + 1;
	else
		return;
	end
	
	data.browser.view.position = pos;
	
	%--
	% update display variables
	%--
	
	% get state variables
	
	state = data.browser.view.state(pos);
	
	% copy state variables to userdata
	
	data.browser.time = state.time;
	
	data.browser.page = state.page;
	
	data.browser.play.channel = state.play.channel;
	
	data.browser.specgram = state.specgram;
	
	data.browser.selection.event = [];
	
	% update userdata
	
	set(h,'userdata',data);
	
	%--
	% consider possible channel change in diaplay update
	%--
			
	if (isequal(data.browser.channels,state.channels))
		
		%--
		% simple browser update
		%--
		
		browser_display(h,'update',data);
			
	else

		%--
		% update channels
		%--
		
		ch = state.channels;
		nch = data.browser.sound.channels;
		pch = data.browser.play.channel;
		
		data.browser.channels = ch;
		
		%--
		% update display paying attention to colorbar
		%--
		
		if (~isempty(data.browser.colorbar))
			array_colorbar;
			cb_flag = 1;
		else
			cb_flag = 0;
		end

		data.browser.channels = ch;
		
		[ha,hi] = browser_display(h,'create',data);
			
		data.browser.axes = ha;
		data.browser.images = hi;
		
		if (cb_flag)
			t = array_colorbar;
			data.browser.colorbar = t;
		end
		
		%--
		% get new slider handle
		%--
		
		data.browser.slider = findobj(h,'type','uicontrol','style','slider');
		
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
		
		browser_resizefcn(h,data);
		
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
		
% 		if (nch > 1)
% 			set(get_menu(h,'Select Channels ...',2),'enable','on');
% 			if ((nch == 2) & diff(pch))
% 				set(get_menu(h,'Select Channels ...',2),'enable','off');
% 				test = test + 1;
% 			end
% 		else
% 			set(get_menu(h,'Select Channels ...',2),'enable','off');
% 			test = test + 1;
% 		end
		
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
		
	end
	
	%--
	% enable and disable view menus and controls
	%--
	
	% check if we are in the latest view and set next view controls state
	
	if (data.browser.view.position < data.browser.view.length)			
		set(get_menu(h,'Next View',2),'enable','on');
		control_update(h,'Navigate','Next View','__ENABLE__',data);
	else		
		set(get_menu(h,'Next View',2),'enable','off');
		control_update(h,'Navigate','Next View','__DISABLE__',data);
	end
	
	% check if we are in the first view and set previous view controls state
	
	if (data.browser.view.position == 1)
		set(get_menu(h,'Previous View',2),'enable','off');
		control_update(h,'Navigate','Previous View','__DISABLE__',data);
	else	
		set(get_menu(h,'Previous View',2),'enable','on');
		control_update(h,'Navigate','Previous View','__ENABLE__',data);	
	end
	
	%--
	% enable and disable navigation menus
	%--
	
	browser_navigation_update(h,data);
	
	%--
	% update related menus
	%--
	
	% page duration and overlap
	
	% channels (browser display may take care of these?)
	
	% play channels (browser display may take care of these?)	

	%--
	% update controls
	%--
	
	view_control_update(h, data);
	
%------------------------------------------------
% Navigate > First Page
%------------------------------------------------

case 'First Page'
	
	%--
	% update slider value
	%--
	
	slider = get_time_slider(h);
	
	set_time_slider(h, 'value', slider.min); 
	
	return;

%------------------------------------------------
% Navigate > Last Page
%------------------------------------------------

case 'Last Page'
	
	%--
	% update slider value
	%--
	
	slider = get_time_slider(h);
	
	set_time_slider(h,'value',slider.max); 
	
	return;
	
%------------------------------------------------
% Navigate > Go To Page ...
%------------------------------------------------

case 'Go To Page ...'
	
	%--
	% setup palette
	%--
	
	[out, c] = browser_palettes(h, 'Navigate');

	data = get(h, 'userdata');
	
	palette_toggle(h, 'Navigate', 'Time', 'open', data);
	
	palette_toggle(h, 'Navigate', 'File', 'close', data);
	
%------------------------------------------------
% Navigate > Previous Page
%------------------------------------------------

case 'Previous Page'
	
	%--
	% compute new time for page
	%--
	
	slider = get_time_slider(h); 
	
	time = slider.value; page = data.browser.page;

	%--
	% update slider value
	%--
	
	set_time_slider(h, ...
		'value', time - ((1 - page.overlap) * page.duration) ...
	);	

	return;
		
%------------------------------------------------
% Navigate > Next Page
%------------------------------------------------

case 'Next Page'
	
	%--
	% compute new time for page
	%--
	
	slider = get_time_slider(h); 
	
	time = slider.value; page = data.browser.page;

	%--
	% update slider value
	%--
	
	set_time_slider(h, ...
		'value', time + ((1 - page.overlap) * page.duration) ...
	);	

	return;
	
%------------------------------------------------
% Scrollbar
%------------------------------------------------

% NOTE: this branch supports a variety of time navigation functions. simply
% update the slider position and call this function

case {'Scrollbar', 'scrollbar'}
	
	browser_refresh(h, data); return;
	
%--
% Navigate Options ...
%--

case 'Navigate Options ...'

	%--
	% open page controls
	%--
	
	browser_window_menu(h, 'Page');
	
%------------------------------------------------
% Navigate > Previous File
%------------------------------------------------

case {'Previous File', 'Next File'}
	
	%--
	% get relevant parent state
	%--
	
	sound = data.browser.sound; time = data.browser.time;
	
	%--
	% get file based on command string
	%--
	
	% NOTE: we select command by parsing string
	
	switch lower(strtok(str, ' '))

		case ('previous'), file = get_previous_file(sound, time);

		case ('next'), file = get_next_file(sound, time);

	end

	%--
	% move to file
	%--
	
	goto_file(h, file, sound);

%------------------------------------------------
% Navigate > Go To File ...
%------------------------------------------------

case 'Go To File ...'
	
	%--
	% return if we get here by mistake
	%--
	
	[ignore, type] = is_sound_type(sound.type);
	
	if strcmp(type, 'file')
		return;
	end
		
	%--
	% setup navigate palette
	%--
	
	browser_palettes(h, 'Navigate');
	
	% NOTE: make sure file navigation section shows
	
	palette_toggle(h, 'Navigate', 'File', 'open');
	
%------------------------------------------------
% Display All
%------------------------------------------------

case ('Display All')
	
	%--
	% set all channels to display (note that this preserves the order)
	%--
	
	data.browser.channels = channel_matrix_update(data.browser.channels, 'display', 1:data.browser.sound.channels);
			
	set(h, 'userdata', data);

	%--
	% update display
	%--

	browser_view_menu(h, 'Update Channels');

	return;
	
%--
% 'Update Channels'
%--

case ('Update Channels')
	
	stop(scrolling_daemon);

	figure(h);
	
	%--
	% update play channels based on channel display
	%--
	
	% play channels will be reassigned upon the channel update. these may
	% be later reassigned, but the default behavior should be the typical
	% use for playback
	
	% note that the update to zero channel display will be disallowed by
	% the control and in other places
	
	% make sure that the relevant menus are also updated after updating the
	% play channels
	
	C = data.browser.channels;
	
	ix = find(C(:,2));
	
	if (length(ix) == 1)
		data.browser.play.channel = C(ix,1) * ones(1,2);
	else
		data.browser.play.channel = [C(ix(1),1), C(ix(2),1)];
	end
	
	%--
	% update display
	%--
	
	if (~isempty(data.browser.colorbar))
		array_colorbar;
		cb_flag = 1;
	else
		cb_flag = 0;
	end
	
	[ha,hi] = browser_display(h,'create',data);
	
	data.browser.axes = ha;
	data.browser.images = hi;
	
	data.browser.channels = C;
		
	if (cb_flag)
		
		t = array_colorbar;
		data.browser.colorbar = t;
		
		tmp = data.browser.grid.color;
		set(t,'XColor',tmp,'YColor',tmp);
		set(get(t,'title'),'color',tmp);
				
	end
	
	%--
	% get new slider handle
	%--
	
	data.browser.slider = findobj(h,'type','uicontrol','style','slider');

	%--
	% update view state array
	%--
	
	data.browser.view = browser_view_update(h,data);
	
	%--
	% perform active detection if needed
	%--
	
	if ~isempty(data.browser.sound_detector.active)
		data.browser.active_detection_log = active_detection(h,data);
	end
	
	data.browser.selection.event = event_create;
	data.browser.selection.handle = [];
	
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
	
	browser_resizefcn(h,data);
	
	%--
	% update menus
	%--
	
	channel_menu_update(h,data);
	
	% update colormap to make sure we retain proper scaling
	
	browser_view_menu(h,data.browser.colormap.name,data);
	
	% remove current selection
	
	browser_edit_menu(h,'Delete Selection');
	
	%--
	% update channel display control
	%--

	g = get_palette(h, 'Page', data);

	if ~isempty(g)

		handles = get_control(g, 'channels_cancel', 'handles');

		browser_controls(h, 'Cancel Channels', handles.uicontrol.pushbutton);

	end
		
	%--
	% update event palette
	%--
	
	update_find_events(h);
	
	start(scrolling_daemon);

%------------------------------------------------
% Spectrogram Options > FFT Size
%------------------------------------------------

case ({ ...
	'64 samples', ...
	'128 samples', ...
	'256 samples', ...
	'384 samples', ...
	'512 samples', ...
	'768 samples', ...
	'1024 samples', ...
	'2048 samples' ...
})
	
	%--
	% set fft length and update userdata
	%--
	
	n = str2num(strtok(str,' '));
	
	data.browser.specgram.fft = n;
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.view_menu.fft_length,'check','off');
	set(get_menu(h,str),'check','on');
	
	%--
	% update control
	%--
	
	control_update(h,'Spectrogram','Size',n,data);

	%--
	% update display
	%--
	
	if (isempty(data.browser.parent))	
		browser_display(h,'update',data);
	else	
		log_display;	
	end
	
case ('Other FFT Size ...')
	
	%--
	% setup palette
	%--
	
	browser_palettes(h,'Spectrogram');

	data = get(h,'userdata');
	
	palette_toggle(h,'Spectrogram','FFT','open',data);
	
	palette_toggle(h,'Spectrogram','Window','close',data);
	
%------------------------------------------------
% Spectrogram Options > Window Length
%------------------------------------------------

case ({ ...
	'FFT Size', ...
	'3/4 FFT Size', ...
	'1/2 FFT Size', ...
	'1/4 FFT Size', ...
	'1/8 FFT Size' ...
})
	
	%--
	% parse string to get value
	%--
	
	ix = findstr(str,' ');
	
	if (length(ix) == 2)
		tmp = eval(strtok(str,' '));
	else
		tmp = 1;
	end
	
	%--
	% get tag of callback object to differentiate hop and window length
	%--

	switch (get(gcbo,'tag'))
		
	case ('hop')
		
		%--
		% update parameter
		%--
		
		data.browser.specgram.hop = tmp;
		
		%--
		% update menu
		%--
		
		set(data.browser.view_menu.hop_length,'check','off');
		set(get_menu(data.browser.view_menu.hop_length,str),'check','on');
		
		%--
		% update control
		%--
		
		control_update(h,'Spectrogram','Advance',tmp,data);
		
	case ('win')
		
		%--
		% update parameter
		%--
		
		data.browser.specgram.win_length = tmp;
			
		%--
		% update menu
		%--
		
		set(data.browser.view_menu.window_length,'check','off');
		set(get_menu(data.browser.view_menu.window_length,str),'check','on');
		
		%--
		% update control
		%--
		
		control_update(h,'Spectrogram','Window Length',tmp,data);
		
	end
	
	data.browser.sound.specgram = data.browser.specgram;
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	if (isempty(data.browser.parent))
		browser_display(h,'update',data);
	else
		log_display;
	end
	
%------------------------------------------------
% Spectrogram Options > FFT Size > Other FFT Advance ...
%------------------------------------------------

case ('Other FFT Advance ...')
	
	%--
	% setup palette
	%--
	
	browser_palettes(h,'Spectrogram');
	
	data = get(h,'userdata');
	
	palette_toggle(h,'Spectrogram','FFT','open',data);
	
	palette_toggle(h,'Spectrogram','Window','close',data);
	
%------------------------------------------------
% Spectrogram Options > Window ...
%------------------------------------------------

case ('Window ...')
	
% case ('Other Window Length ...')
	
	% SHORTCUT TO PALETTE
	
	browser_palettes(h,'Spectrogram');

	data = get(h,'userdata');
	
	palette_toggle(h,'Spectrogram','FFT','close',data);
	
	palette_toggle(h,'Spectrogram','Window','open',data);
	
%------------------------------------------------
% Spectrogram Options > Window Type
%------------------------------------------------

case (WINDOW)
	
	%--
	% update userdata
	%--
	
	data.browser.specgram.win_type = str;
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.view_menu.window_type,'check','off');
	set(get_menu(data.browser.view_menu.window_type,str),'check','on');

	%--
	% update control
	%--
	
	control_update(h,'Spectrogram','Window Type',str,data);
	
	%--
	% update display
	%--
	
	if (isempty(data.browser.parent))
		browser_display(h,'update',data);
	else
		log_display;
	end

%--
% Spectrogram Options ...
%--

case ('Spectrogram Options ...')
	
	%--
	% get spectrogram controls palette
	%--
	
	browser_window_menu(h,'Spectrogram');
		
%------------------------------------------------
% Colormap
%------------------------------------------------

% NOTE: this uses a simple API for colormap functions, the number of colors is input.

% TODO: more intelligent colormaps are needed

% NOTE: auto-scaling would be single special case of a range of contrast
% transformations
		
case ({COLORMAP{:}, LOWER_COLORMAP{:}})
	
	%--
	% get parent state
	%--

	if (nargin < 3) || isempty(data)
		data = get_browser(h);
	end
	
	if ~isempty(data.browser.parent)
		par_flag = 1; data = get_browser(data.browser.parent);
	else
		par_flag = 0;
	end
	
	%--
	% consider colormap name
	%--
	
	switch (str)
		
		%--
		% label colormap
		%--
		
		case ('label')
			
			cmap_label;
			
		%--
		% contrast and scale maps
		%--
		
		otherwise
	
			map = data.browser.colormap;

			if map.auto_scale

				%--
				% create base map
				%--

				C = feval(colormap_to_fun(str), 256);

				if map.invert
					C = flipud(C);
				end

				%--
				% set map
				%--

				set(h, 'colormap', C);

				%--
				% automatically scale map
				%--

				% NOTE: this should happen before not after set the colormap currently this is the way we pass the data

				cmap_scale([], data.browser.images);

			else

				C = cmap_brightcont( ...
					colormap_to_fun(str), map.brightness, map.contrast, map.invert, 256 ...
					);

				set(h, 'colormap', C);

			end
			
	end
	
	%--
	% update userdata
	%--
	
	data.browser.colormap.name = str;
		
	set(h, 'userdata', data);
	
	%--
	% update menu
	%--
	
	if (~par_flag)
		
		set(data.browser.view_menu.colormap,'check','off');
		
		set(get_menu(data.browser.view_menu.colormap,str),'check','on');
		
	end

	%--
	% update controls
	%--
	
	control_update(h,'Colormap','Colormap',str,data);
	
	g = get_palette(h,'Colormap',data);

	if (~isempty(g))
		set(g,'colormap',feval(colormap_to_fun(str),256));
	end
	
%------------------------------------------------
% Colorbar
%------------------------------------------------

case ('Colorbar')
	
	%--
	% toggle colorbar
	%--
		
	t = array_colorbar(h);
	
	%--
	% update menu
	%--
		
	if (isempty(t))
		
		set(get_menu(data.browser.view_menu.sound,str),'check','off');
		browser_resizefcn(h,data);
		
		%--
		% update control
		%--
	
		control_update(h,'Colormap','Colorbar',0,data);
		
	else
		
		set(get_menu(data.browser.view_menu.sound,str),'check','on');
		browser_resizefcn(h,data);
		
		%--
		% make colorbar axes colors match other axes
		%--
		
		tmp = data.browser.grid.color;
		
		set(t,'XColor',tmp,'YColor',tmp);
		set(get(t,'title'),'color',tmp);
		
		%--
		% update control
		%--
	
		control_update(h,'Colormap','Colorbar',1,data);
	
	end
	
	%--
	% update userdata
	%--
	
	data.browser.colorbar = t;
	set(h,'userdata',data);
	
%------------------------------------------------
% Colormap Options > Contrast ...
%------------------------------------------------

case ('Contrast ...')
	
	%--
	% setup palette
	%--
	
	pal = browser_palettes(h,'Colormap');
	
	data = get(h,'userdata');
	
	palette_toggle(h,'Colormap','Colormap','close',data);
	
	palette_toggle(h,'Colormap','Contrast','open',data);
		
%------------------------------------------------
% Colormap Options > Invert
%------------------------------------------------

case ('Invert')
	
	%--
	% toggle invert
	%--
	
	state = ~data.browser.colormap.invert;
	data.browser.colormap.invert = state;
	
	%--
	% update menu
	%--
	
	if (state)
		set(get_menu(data.browser.view_menu.colormap_options,str),'check','on');		
	else
		set(get_menu(data.browser.view_menu.colormap_options,str),'check','off');
	end

	%--
	% update control
	%--

	control_update(h,'Colormap','Invert',state,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update colormap
	%--
	
	% NOTE: is the previous data store required when we pass it onto the
	% colormap
	
	browser_view_menu(h,data.browser.colormap.name,data);
	
%------------------------------------------------
% Colormap Options > Auto Scale
%------------------------------------------------

case ('Auto Scale')
	
	%--
	% toggle autoscale
	%--
	
	state = ~data.browser.colormap.auto_scale;
	data.browser.colormap.auto_scale = state;
	
	%--
	% update menu
	%--
	
	if (state)	
		set(get_menu(data.browser.view_menu.colormap_options,str),'check','on');	
	else		
		set(get_menu(data.browser.view_menu.colormap_options,str),'check','off');	
	end
	
	%--
	% update controls
	%--
	
	control_update(h,'Colormap','Auto Scale',state,data);
	
	if (state)
		state = '__DISABLE__';
	else
		state = '__ENABLE__';
	end
	
	control_update(h,'Colormap','Brightness',state,data);
	control_update(h,'Colormap','Contrast',state,data);

	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update colormap
	%--
	
	browser_view_menu(h,data.browser.colormap.name,data);

%------------------------------------------------
% Grid
%------------------------------------------------

case ('Grid')
	
	%--
	% toggle grid state
	%--
	
	state = ~data.browser.grid.on;
	data.browser.grid.on = state;
	
	%--
	% update grid display and menu
	%--
	
	if (state)

		ax = data.browser.axes;
		gr = data.browser.grid;
		
		if (gr.time.on & gr.freq.on)
			set(ax,'xgrid','on','ygrid','on');
		elseif (gr.time.on)
			set(ax,'xgrid','on');
		elseif (gr.freq.on)
			set(ax,'xgrid','on');
		end			
		
		set(ax,'xcolor',gr.color,'ycolor',gr.color);
		
		tmp = data.browser.view_menu.sound;
		set(get_menu(tmp,'Grid'),'check','on');
% 		set(get_menu(tmp,'Grid Options'),'enable','on');
		
	else
		
		ax = data.browser.axes;	
		
		set(ax,'xgrid','off','ygrid','off');	
		
		tmp = data.browser.view_menu.sound;
		set(get_menu(tmp,'Grid'),'check','off');
% 		set(get_menu(tmp,'Grid Options'),'enable','off');
		
	end
	
	%--
	% update palette
	%--
	
	hp = get_palette(h,'Grid',data);
	
	if (~isempty(hp))
		
		if (data.browser.grid.on)
			
			set(get_button(hp,'Grid'),'fontweight','bold');
			
			set(get_button(hp,'Time Grid'),'enable','on');
			set(get_button(hp,'Frequency Grid'),'enable','on');
			
		else
			
			set(get_button(hp,'Grid'),'fontweight','normal');
			
			set(get_button(hp,'Time Grid'),'enable','off');
			set(get_button(hp,'Frequency Grid'),'enable','off');
			
		end
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);

%------------------------------------------------
% Grid Options > Color
%------------------------------------------------

case (COLOR)
	
	%--
	% check parent of command to determine action
	%--
	
	try
		tmp = get(get(get(gcbo,'parent'),'parent'),'label');
	catch
		tmp = 'Grid Options';
	end

	% HACK: is this 'gray' versus 'gray '?
	
	if (isempty(tmp))
		return;
	end
	
	switch (tmp)
	
	%--
	% set selection color
	%--
	
	case ('Selection Options')
		
		%--
		% update selection color variable
		%--
		
		value = color_to_rgb(str);
		
		data.browser.selection.color = value;
		
		%--
		% udpate selection display
		%--
		
		g = findobj(h,'type','line','tag','selection');
		
		g = setdiff(g,findobj(g,'linewidth',0.5));
		
		set(g,'color',value);
		
		if (data.browser.selection.patch > 0)
			
			g = findobj(h,'type','patch','tag','selection');
			set(g,'facecolor',value);
			
		end
		
		%--
		% update menus and userdata
		%--
		
		g = data.browser.view_menu.selection_color;
		
		set(g,'check','off');
		set(get_menu(g,str),'check','on');
		
		set(h,'userdata',data);
		
		%--
		% update controls
		%--
		
		control_update(h,'Selection','selection_color',str,data);
		
	%--
	% set axes colors
	%--
	
	otherwise
		
% 	case ('Grid Options')
		
		value = color_to_rgb(str);
		
		% display axes
		
		set(data.browser.axes,'XColor',value,'YColor',value);
		set(get(data.browser.axes(1),'title'),'color',value);
		
		% colorbar axes
		
		ax = data.browser.colorbar;
		
		if (~isempty(ax))
			set(ax,'XColor',value,'YColor',value);
			set(get(ax,'title'),'color',value);
		end
		
		%--
		% set color of file boundary objects
		%--
		
		set(findobj(h,'tag','file_boundary'),'color',value);
		
		%--
		% set color of crosshairs and selection labels
		%--
		
		set(findobj(h,'tag','selection','linestyle',':','linewidth',0.5),'color',value);
		set(findobj(h,'tag','selection','type','text'),'color',value);
		
		%--
		% update userdata
		%--
		
		data.browser.grid.color = value;
		set(h,'userdata',data);
		
		%--
		% update menu
		%--
		
		set(data.browser.view_menu.color,'check','off');
		set(get_menu(data.browser.view_menu.color,str),'check','on');
		
		%--
		% update figure color for light grid color
		%--
	
		if ((sum(value) >= 0.8) | (max(value) >= 0.8))
			
			tmp = 0.15 * ones(1,3);
			
			if (get(h,'color') ~= tmp)
				set(h,'color',tmp);
				hs = findobj(h,'type','uicontrol');
				if (~isempty(hs))
					set(hs,'backgroundcolor',tmp + 0.1);
				end
			end
			
		else
			
			tmp = get(0,'DefaultFigureColor');
			
			if (get(h,'color') ~= get(0,'DefaultFigureColor'))
				set(h,'color',tmp);
				hs = findobj(h,'type','uicontrol');
				if (~isempty(hs))
					set(hs,'backgroundcolor',tmp - 0.1);
				end
			end
			
		end 
		
		% TEST: this is test code to solve the colorbar axes color problem
		
		set(findall(h,'type','axes'), ...
			'xcolor', value, ...
			'ycolor', value ...
		);
	
		%--
		% update control
		%--
		
		control_update(h,'Grid','Color',str,data);
		
	end
	
%------------------------------------------------
% Grid Options > Time Grid
%------------------------------------------------

case ('Time Grid')

	%--
	% toggle time grid state
	%--
	
	data.browser.grid.time.on = ~data.browser.grid.time.on;
	
	%--
	% get axes and grid options
	%--
	
	ax = data.browser.axes;
	gopt = data.browser.grid;
	
	%--
	% update grid and check
	%--
	
	if (gopt.time.on)
		if (gopt.on)
			set(ax,'xgrid','on');
			set(ax,'xcolor',gopt.color,'ycolor',gopt.color);
		end
		set(get_menu(data.browser.view_menu.sound,str),'check','on');
	else
		if (gopt.on)
			set(ax,'xgrid','off');
		end
		set(get_menu(data.browser.view_menu.sound,str),'check','off');
	end
	
	%--
	% update palette
	%--
	
	control_update(h,'Grid','Time Grid',gopt.time.on,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%------------------------------------------------
% Grid Options > (Time Spacing, Freq Spacing) > Auto
%------------------------------------------------

case ('Auto')
	
	%--
	% get label of parent menu to separate time and frequency options
	%--
	
	tmp = get(get(gcbo,'parent'),'label');
	
	if (isempty(tmp))
		tmp = 'Time Spacing';
	end
	
	%--
	% update xtickmode and check according to parent
	%--
	
	switch (tmp)
		
	case ('Time Spacing')
		
		data.browser.grid.time.spacing = [];
		
		set(data.browser.axes,'xtickmode','auto');
		
		set(data.browser.view_menu.time_spacing,'check','off');
		set(gcbo,'check','on');
		
		%%%%% TEST TEST %%%%%%%
		
		if (1)
			tmp = data.browser.axes(end);
			set(tmp,'xticklabel',sec_to_clock(get(tmp,'xtick')));
		else
			set(data.browser.axes,'xticklabelmode','auto');
		end
		
	case ('Freq Spacing')
		
		data.browser.grid.freq.spacing = [];
		
		set(data.browser.axes,'ytickmode','auto');
		
		set(data.browser.view_menu.freq_spacing,'check','off');
		set(gcbo,'check','on');
		
	case ('Renderer Options')
		
		data.browser.renderer = str; 

		set(h,'RendererMode','auto');	
		refresh(h);
	
		set(data.browser.view_menu.renderer,'check','off')
		set(gcbo,'check','on');

	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	browser_display(h,'update',data);

%------------------------------------------------
% Grid Options > Time Spacing
%------------------------------------------------

case ({ ...
	' 1 sec/Tick', ...
	' 2 sec/Tick', ...
	' 5 sec/Tick', ...
	'10 sec/Tick',
	'1/2 sec/Tick', ...
	'1/4 sec/Tick', ...
	'1/5 sec/Tick', ...
	'1/10 sec/Tick' ...
})
	
	%--
	% get spacing from string and update time grid spacing
	%--
	
	t = eval(str(1:3));
	data.browser.grid.time.spacing = t;
	
	%--
	% update menu
	%--

	set(data.browser.view_menu.time_spacing,'check','off');
	set(gcbo,'check','on');
	
	%--
	% update controls
	%--
	
	control_update(h,'Grid','Time Spacing',t,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	browser_display(h,'update',data);
	
%------------------------------------------------
% Grid Options > Time Spacing > Other Time Spacing ...
%------------------------------------------------

case ('Other Time Spacing ...')
	
	% SHORTCUT TO CONFIGURED PALETTE
	
	pal = browser_palettes(h,'Grid');
	
	data = get(h,'userdata');
	
	palette_toggle(h,'Grid','Grid','open',data);
	
	palette_toggle(h,'Grid','Color','close',data);

	tab_select([],pal,'Time');
	
%------------------------------------------------
% Grid Options > Time Labels 
%------------------------------------------------

case ({ ...
	'Seconds', ...
	'Clock', ...
	'Date and Time' ...
})

	%--
	% update userdata
	%--
	
	data.browser.grid.time.labels = lower(str); 
	set(h,'userdata',data);
	
	%--
	% update menus
	%--
	
	tmp = data.browser.view_menu.time_labels;
	set(tmp,'check','off');
	set(get_menu(tmp,str),'check','on');
		
	%--
	% update controls
	%--
	
	control_update(h,'Grid','Time Labels',str,data);
	
	%--
	% update event palette
	%--
		
	% NOTE: the state restoration works because the strings do not change
	
	pal = get_palette(h,'Event',data);
	
	if (~isempty(pal))
		
		%--
		% get control state before update
		%--
		
		[g,value] = control_update([],pal,'event_display');
		
		c = findobj(g,'style','listbox');
		
		ix = get(c,'value');
		top = get(c,'listboxtop');
		
		%--
		% perform find events callback to recompute listbox strings
		%--
		
		update_find_events(h,[],data);
		
		%--
		% restore control state
		%--
		
		set(c,'value',ix);
		set(c,'listboxtop',top);
		
		if (~isempty(value))			
			control_callback([],pal,'event_display');	
		end
		
	end
	
	%--
	% update display
	%--
		
	browser_display(h,'update',data);
	
%------------------------------------------------
% Grid Options > File Grid
%------------------------------------------------

case ({'File Grid','Session Grid'})
	
	%--
	% get mode from command string
	%--
	
	[mode,ignore] = strtok(str,' '); mode = lower(mode);

	%--
	% toggle and update display state
	%--
	
	state = ~data.browser.grid.(mode).on;
	
	data.browser.grid.(mode).on = state;

	set(h,'userdata',data);
	
	%--
	% update grid palette to reflect state
	%--
	
	control_update(h,'Grid',str,state,data);
	
	%--
	% turn off display and return quicklly if possible
	%--

	ax = data.browser.axes;
	
	if (~state)
		delete_labelled_lines(ax,[mode, '_boundaries']); return;
	end
	
	%--
	% display required boundaries
	%--
	
	sound = data.browser.sound; time = data.browser.time; duration = data.browser.page.duration;
	
	switch (mode)

		case ('file')

			[times,files] = get_file_boundaries(sound,time,duration);

			display_file_boundaries(ax,times,files,data);

		case ('session')

			[times,begin] = get_session_boundaries(sound,time,duration);

			display_session_boundaries(ax,times,begin,[],data);
			
	end
	
%------------------------------------------------
% Grid Options > Freq Grid
%------------------------------------------------

case ('Freq Grid')
	
	%--
	% toggle frequency grid state
	%--
	
	data.browser.grid.freq.on = ~data.browser.grid.freq.on;
	
	%--
	% get axes and grid options
	%--
	
	ax = data.browser.axes;
	gopt = data.browser.grid;
	
	%--
	% update grid state and check
	%--
	
	if (gopt.freq.on)
		if (gopt.on)
			set(ax,'ygrid','on');
			set(ax,'xcolor',gopt.color,'ycolor',gopt.color);
		end
		set(get_menu(data.browser.view_menu.sound,str),'check','on');
	else
		if (gopt.on)
			set(ax,'ygrid','off');
		end
		set(get_menu(data.browser.view_menu.sound,str),'check','off');
	end
	
	%--
	% update control
	%--
	
	control_update(h,'Grid','Freq Grid',gopt.freq.on,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%------------------------------------------------
% Grid Options > Freq Grid > Freq Spacing
%------------------------------------------------

case ({ ...
	'25 Hz/Tick', ...
	'100 Hz/Tick', ...
	'250 Hz/Tick', ...
	'500 Hz/Tick', ...
	' 1 kHz/Tick', ...
	' 2 kHz/Tick', ...
	' 5 kHz/Tick', ...
	'10 kHz/Tick' ...
})
	
	%--
	% get spacing from string and update frequency grid spacing
	%--
	
	% separate Hz and kHz strings
	
	if (~isempty(findstr(str,'kHz')))
		t = eval(str(1:2));
		t = t * 1000;
	else
		t = eval(str(1:3));
	end
	
	data.browser.grid.freq.spacing = t;
	
	%--
	% update ytick
	%--
	
	ax = data.browser.axes; 
	yl = get(ax(1),'ylim');
	
	if (t ~= round(t))
		ix = 0:t:yl(2); 
		tmp = find(ix >= yl(1)); 
		ix = ix(tmp(1):end);
	else
		ix = floor(yl(1)):ceil(yl(2));
		if (t > 1)
			ix = ix(find(mod(ix,t) == 1)) - 1;
		end
	end
	
	set(ax,'ytick',ix);
	
	%--
	% update check
	%--
	
	set(data.browser.view_menu.freq_spacing,'check','off');
	set(gcbo,'check','on');
	
	set(h,'userdata',data);
	
%------------------------------------------------
% Grid Options > Freq Grid > Other Freq Spacing ...
%------------------------------------------------

case ('Other Freq Spacing ...')
	
	%--
	% setup palette
	%--
	
	pal = browser_palettes(h,'Grid');

	data = get(h,'userdata');
	
	palette_toggle(h,'Grid','Grid','open',data);
	
	palette_toggle(h,'Grid','Color','close',data);
	
	tab_select([],pal,'Freq');
	
%------------------------------------------------
% Freq Labels 
%------------------------------------------------

case ({'Hz','kHz'})
	
	%--
	% update frequency labels variable and menus
	%--
	
	data.browser.grid.freq.labels = str;
	set(h,'userdata',data);
	
	set(data.browser.view_menu.freq_labels,'check','off');
	set(get_menu(data.browser.view_menu.freq_labels,str),'check','on');
	
	%--
	% update event palette
	%--
		
	% NOTE: only the event info control is updated in this case
	
	pal = get_palette(h, 'Event', data);
	
	if ~isempty(pal)

		[g,value] = control_update([], pal, 'event_display');
				
		if ~isempty(value)			
			control_callback([], pal, 'event_display');	
		end
		
	end
	
	%--
	% update display
	%--
	
	if isempty(data.browser.parent)
		browser_display(h, 'update', data);
	else
		log_display;
	end
	
%------------------------------------------------
% Edit All ...
%------------------------------------------------

case ('Edit All ...')
	
	%--
	% get label of parent of callback object
	%--
		
	tmp = get(get(gcbo,'parent'),'label');
	
	%--
	% setup palette
	%--
	
	switch (tmp)
		
		case ('Navigate Options')
			out = browser_window_menu(h,'Page');
			
		case ('Spectrogram Options')			
			out = browser_window_menu(h,'Spectrogram');
		
	end
	
	%--
	% maximize palette
	%--
	
	palette_minmax('max',out);
		
%------------------------------------------------
% Hide Channel
%------------------------------------------------

% TODO: this command needs to be disabled when there is only a single channel

case ('Hide Channel')
	
	%--
	% update channel matrix
	%--
	
	% get channel from menu tag
	
	chix = eval(get(gcbo,'tag'));
		
	data.browser.channels = channel_matrix_update(data.browser.channels, 'hide', chix);
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	browser_view_menu(h, 'Update Channels');
	
	return;
	
%------------------------------------------------
% Left Channel, Right Channel
%------------------------------------------------

case ({'Left Channel','Right Channel'})
	
	%--
	% get userdata and relevant fields
	%--
		
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
		
		set(get_menu(im(ix),'Hide Menu'),'enable','off');
		
		ix = find(strcmp(tag,num2str(pch(2))));
		tmp = ax(ix);
		axes(tmp);
		str = get(get(tmp,'ylabel'),'string');
		ylabel([str '  (R)']);	
		
		set(get_menu(im(ix),'Hide Menu'),'enable','off');
		
	else
		
		tag = get(ax,'tag');
		
		ix = find(strcmp(tag,num2str(pch(1))));
		tmp = ax(ix);
		axes(tmp);
		str = get(get(tmp,'ylabel'),'string');
		ylabel([str '  (LR)']);
		
		set(get_menu(im(ix),'Hide Menu'),'enable','off');
		
	end
		
	%--
	% update sound menu menus
	%--
	
	% enable all toggle menus
	
	set(data.browser.view_menu.channels,'enable','on');
	
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
	
	%--
	% update channel control strings
	%--
	
	channel_control_strings(h,data);
	
%------------------------------------------------
% Volume Control ...
%------------------------------------------------

case ('Volume Control ...')
	
	!sndvol32 &
	return;
	
%------------------------------------------------
% Sound Recorder ...
%------------------------------------------------

case ('Sound Recorder ...')
	
	!sndrec32 &
	return;

%------------------------------------------------
% Miscellaneous Commands
%------------------------------------------------

otherwise		

	%---------------------------------------
	% File Navigate
	%---------------------------------------
		
	%--
	% check if command string is filename
	%--
	
	sound = data.browser.sound;

	ix = find(strcmp(str,sound.file));
	
	if (~isempty(ix))
		goto_file(h,str,sound); return;		
	end
	
	%--------------------------------------------
	% Channels
	%--------------------------------------------
	
	% this is effectively a channel toggle
	
	if ((length(str) > 6) & strcmp(str(1:7),'Channel'))
				
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
			
			%--------------------------------------------
			% update channel display
			%--------------------------------------------
			
			case ({'Channels','Channels Displayed'})		
			
				%--------------------------------------------
				% determine channel selected for toggle
				%--------------------------------------------
				
				%--
				% get userdata and relevant fields
				%--
							
				% get displayed channels from channel matrix
				
				ch = get_channels(data.browser.channels);
				
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
					
					% CHANNEL ORDER
					
					% this is reasonable behavior when the channels are
					% index ordered not when they are custom ordered
					
% 					ch = sort([ch ix]);
					
% 					ch = [ch ix];
					
					data.browser.channels = ...
						channel_matrix_update(data.browser.channels,'show',ix);
					
				else
									
					% remove channel (protect play channels for the moment)
					
					if (any(ch(d) == pch))
						return;
					else
						data.browser.channels = ...
							channel_matrix_update(data.browser.channels,'hide',ix);
					end
					
				end

				set(h,'userdata',data);

				%--
				% update display
				%--

				browser_view_menu(h, 'Update Channels');
				
				return;
						
			%--------------------------------------------
			% update play channel
			%--------------------------------------------
			
			case ({'Left Channel','Right Channel'})
				
				%--
				% get channel number
				%--
				
				ix = str2num(str(9:end));
				
				%--
				% update play channels if needed
				%--
								
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
				
				%--
				% turn off checks for play channel contextual menus
				%--
					
				for k = 1:length(data.browser.images)
					tmp_left(k) = get_menu(get(data.browser.images(k),'uicontextmenu'),'Left Channel',2);
					tmp_right(k) = get_menu(get(data.browser.images(k),'uicontextmenu'),'Right Channel',2);
				end
	
				set(tmp_left,'check','off');
				set(tmp_right,'check','off');
					
				%--
				% update display of play channel axes
				%--
				
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
	
				tmp = get(get_menu(data.browser.view_menu.play_options,'Left Channel'),'children');
				
				set(tmp,'check','off');
				set(get_menu(tmp,['Channel ' num2str(pch(1))]),'check','on');
	
				tmp = get(get_menu(data.browser.view_menu.play_options,'Right Channel'),'children');
				
				set(tmp,'check','off');
				set(get_menu(tmp,['Channel ' num2str(pch(2))]),'check','on');
				
				%--
				% refresh figure
				%--
				
				refresh(h);
				
				%--
				% update channel controls
				%--
				
				channel_control_strings(h,data);
	
				return;
			
		end
		
	end
		
	%--
	% unrecognized command
	%--
		
	warning(['Unrecognized ''browser_view_menu'' option ''' str '''.']);
		
end

%--
% update selection display if needed
%--

selection_update(h,data);
		
%--
% update sound structure
%--

% this should not be needed if we only store view information in one place

% at the moment this would slow down every operation through this menu

% data.browser.sound = sound_update(data.browser.sound,data);


%----------------------------------------------------------------------
% SUB FUNCTIONS
%----------------------------------------------------------------------


%------------------------------------------------
% VIEW_CONTROL_UPDATE
%------------------------------------------------

function view_control_update(h,data)

% view_control_update - update view related controls
% --------------------------------------------------
%
% view_control_update(h,data)
%
% Input:
% ------
%  h - parent figure handle
%  data - figure userdata

%----------------------------
% UPDATE PALETTES
%----------------------------

%--
% NAVIGATE
%--

pal = get_palette(h,'Navigate');

if ~isempty(pal)
	control_update([],pal,'Time',data.browser.time);
end

%--
% PAGE
%--

% NOTE: duration update does not deal with the running off the edge of the sound

pal = get_palette(h,'Page',data);

if ~isempty(pal)
	
	%--
	% copy relevant state
	%--
	
	page = data.browser.page; sound = data.browser.sound;
	
	%--
	% update page controls
	%--
	
	% NOTE: control names with spaces are deprecated, these should change
	
	control_update([],pal,'Duration',page.duration);

	control_update([],pal,'Overlap',page.overlap);

	if (~isempty(data.browser.page.freq))
		
		control_update([],pal,'Min Freq',page.freq(1));
		
		control_update([],pal,'Max Freq',page.freq(2));
		
	else
		
		control_update([],pal,'Min Freq',0);
		
		control_update([],pal,'Max Freq',floor(get_sound_rate(sound) / 2));
		
	end

end

% NOTE: this function should have a different signature?

channel_control_strings(h,data)

%--
% SPECTROGRAM
%--

pal = get_palette(h,'Spectrogram',data);

if (~isempty(pal))
	
	%--
	% copy relevant state
	%--

	specgram = data.browser.specgram;

	%--
	% update controls
	%--

	% NOTE: control names with spaces are deprecated, these should change
	
	control_update([],pal,'FFT Size',specgram.fft);

	control_update([],pal,'FFT Advance',specgram.hop);

	control_update([],pal,'Window Type',specgram.win_type);

	control_update([],pal,'Window Length',specgram.win_length);

end


%------------------------------------------------
% CHANNEL_MENU_UPDATE
%------------------------------------------------

function channel_menu_update(h, data)

% channel_menu_update - update channel related menus
% --------------------------------------------------
%
% channel_menu_update(h, data)
%
% Input:
% ------
%  h - parent figure handle
%  data - figure userdata

%--------------------------------------------
% create auxiliary variables
%--------------------------------------------

ch = get_channels(data.browser.channels);

nch = data.browser.sound.channels;

pch = data.browser.play.channel;
				
%--------------------------------------------
% update menus
%--------------------------------------------

%--
% update check on channel menus
%--

% this is slower than the specialized updating for a single channel change,
% it is general however

% the get menu operation should be made more local to improve efficiency
% and accuracy

for k = 1:nch
	L{k} = ['Channel ', int2str(k)];
end

for k = 1:nch
	
	if isempty(find(k == ch))
		
		%--
		% view menu channel selection
		%--
		
		set(get_menu(data.browser.view_menu.channels,L{k},2),'check','off');
	
		%--
		% channel channel selection
		%--
		
		for j = 1:length(ch)
			tmp = get(data.browser.images(j),'uicontextmenu');
			tmp = findobj(tmp,'type','uimenu');
			set(get_menu(tmp,L{k}),'check','off');
		end
		
	else
		
		%--
		% view menu channel selection
		%--
		
		set(get_menu(data.browser.view_menu.channels,L{k},2),'check','on');
		
		%--
		% channel channel selection
		%--
		
		for j = 1:length(ch)
			tmp = get(data.browser.images(j),'uicontextmenu');
			tmp = findobj(tmp,'type','uimenu');
			set(get_menu(tmp,L{k}),'check','on');
		end
		
	end
	
end

%--
% turn off 'all channels' if we are already viewing all channels
%--

test = 0;
if (length(ch) == nch)
	set(get_menu(h,'Display All',2),'enable','off');
	test = test + 1;
else
	set(get_menu(h,'Display All',2),'enable','on');
end

%--
% if there are no enabled menus in the channels submenu disable channels
%--

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


%------------------------------------------------
% GOTO_FILE
%------------------------------------------------

function goto_file(par, file, sound)

% goto_file - move browser to start of file
% -----------------------------------------
%
% goto_file(par, file, sound)
%
% Input:
% ------
%  par - browser handle
%  file - file to move to
%  sound - browser sound

% TODO: make sound optional, since we have the parent

%--
% get file start time as real time
%--

time = get_file_times(sound, file);

%--
% move to file start
%--

set_browser_time(par, time, 'real');

