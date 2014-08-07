function log_view_menu(h,str,flag)

% log_view_menu - log browser view options menu
% ---------------------------------------------
%
% log_view_menu(h,str,flag)
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
% $Date: 2005-06-20 09:48:30 -0400 (Mon, 20 Jun 2005) $
% $Revision: 1130 $
%--------------------------------

%--
% enable enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'View'))
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
			log_view_menu(h,str{k}); 
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
% create variable tables
%--

[COLOR,COLOR_SEP] = color_to_rgb;

[LINESTYLE,LINESTYLE_SEP] = linestyle_to_str('','strict');

[WINDOW,WINDOW_SEP] = window_to_fun;

[COLORMAP,COLORMAP_SEP] = colormap_to_fun;

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
	
	if (get_menu(h,'View'))
		return;
	end

	%--
	% get userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% View
	%--

	L = { ...
		'View', ...
		'Selection ', ...
		'Selection Options', ...
		'Navigate', ...
		'Navigate Options', ...
		'Spectrogram', ... 		
		'Spectrogram Options', ...
		'Colorbar', ...
		'Colormap', ... 	
		'Colormap Options', ...
		'Grid', ...	
		'Grid Options', ...
		'Renderer Options' ...
		'Refresh', ...
		'Actual Size', ...
		'Half Size' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{6} = 'on';
	S{8} = 'on';
	S{11} = 'on';
	S{13} = 'on';
	S{end - 1} = 'on';
	
	mg = menu_group(h,'log_view_menu',L,S);	
	data.browser.view_menu.sound = mg;
	
	if (data.browser.selection.on)
		set(get_menu(mg,'Selection '),'check','on'); 
	end
	
	if (data.browser.specgram.on)
		set(get_menu(mg,'Spectrogram'),'check','on');
	end
	
	if (data.browser.grid.on)
		set(get_menu(mg,'Grid'),'check','on');
	end
	
% 	set(mg(1),'position',3);
	
	%--
	% Selection Options
	%--
	
	L = { ...
		'Color', ...
		'Line Style', ...
		'Line Width', ...
		'Opacity', ...
		'Selection Grid', ...
		'Selection Labels', ...
		'Control Points' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{5} = 'on';
	S{end} = 'on';
	
	mg = menu_group(get_menu(h,'Selection Options'),'log_view_menu',L,S);
	data.browser.view_menu.selection_options = mg;
	
	if (data.browser.selection.grid)
		set(get_menu(mg,'Selection Grid'),'check','on');
	end
	
	if (data.browser.selection.label)
		set(get_menu(mg,'Selection Labels'),'check','on');
	end
	
	if (data.browser.selection.control)
		set(get_menu(mg,'Control Points'),'check','on');
	end
	
	%--
	% Selection Options: Color
	%--
	
	tmp = menu_group(get_menu(mg,'Color'),'log_view_menu',COLOR,COLOR_SEP);
	data.browser.view_menu.selection_color = tmp;
	
	color_name = rgb_to_color(data.browser.selection.color);
	if (~isempty(color_name))
		set(get_menu(tmp,color_name),'check','on');
	end
	
	%--
	% Selection Options: Line Style
	%--
	
	tmp = menu_group(get_menu(mg,'Line Style'),'log_view_menu',LINESTYLE,LINESTYLE_SEP);
	data.browser.view_menu.selection_linestyle = tmp;
	
	%--
	% Selection Options: Line Width
	%--
	
	L = {'1 pt','2 pt','3 pt','4 pt'};
	
	tmp = menu_group(get_menu(mg,'Line Width'),'log_view_menu',L);
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
	
	tmp = menu_group(get_menu(mg,'Opacity'),'log_view_menu',L,S);
	data.browser.view_menu.selection_patch = tmp;
		
	ix = find(data.browser.selection.patch == [-1, 0.125, 0.25, 0.5, 0.75, 1]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Navigate Options
	%--
		
	L = { ...
		'Page Size', ...
		'Event Dilation', ...
		'Frequency Bounds ...', ...
		'Edit All ...' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{end} = 'on';
	
	data.browser.view_menu.page_options = menu_group(get_menu(h,'Navigate Options'),'log_view_menu',L,S);
	
	%--
	% Page Size
	%--
	
	L = { ...
		'2 x 2', ...
		'2 x 3', ...
		'2 x 4', ...
		'3 x 2', ...
		'3 x 3', ...
		'3 x 4', ...
		'4 x 2', ...
		'4 x 3', ...
		'4 x 4', ...
		'Other Page Size ...',
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{7} = 'on';
	S{end} = 'on';

	data.browser.view_menu.page_size = ...
		menu_group(get_menu(h,'Page Size'),'log_view_menu',L,S);
			
	tmp1 = [ ...
		2, 2; 2, 3; 2, 4; ...
		3, 2; 3, 3; 3, 4; ...
		4, 2; 4, 3; 4, 4 ...
	];
	tmp2 = repmat([data.browser.row, data.browser.column],[length(tmp1), 1]);
	
	ix = find(sum(tmp1 == tmp2,2) == 2);
	if (~isempty(ix))
		set(data.browser.view_menu.page_size(ix),'check','on');
	else
		set(data.browser.view_menu.page_size(end),'check','on');
	end
	
	%--
	% Event Dilation
	%--
	
	L = { ...
		'2x', ...
		'3x', ...
		'4x', ...
		'5x', ...
		'Other Event Dilation ...' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{end} = 'on';
	
	data.browser.view_menu.event_dilation = ...
		menu_group(get_menu(h,'Event Dilation'),'log_view_menu',L,S);
	
	ix = find(data.browser.dilation == [2,3,4,5]);
	
	if (~isempty(ix))
		set(data.browser.view_menu.event_dilation(ix),'check','on');
	else
		set(data.browser.view_menu.event_dilation(end),'check','on');
	end
	
	%--
	% Navigate
	%--

	% setup navigation menu for single file sounds
	
% 	if (strcmp(data.browser.sound.type,'File'))
		
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
			menu_group(get_menu(h,'Navigate'),'log_view_menu',L,S,A);
		
		tmp = data.browser.view_menu.page;
		
		set(get_menu(tmp,'Previous View'),'enable','off');
		set(get_menu(tmp,'Next View'),'enable','off');
	
% 	% setup navigation menus for multiple file sounds
% 	
% 	else
% 		
% 		L = { ...
% 			'Previous View', ...
% 			'Next View', ...
% 			'First Page', ...	
% 			'Previous Page', ...	
% 			'Next Page', ...	
% 			'Last Page', ... 			
% 			'Go To Page ...' ...	
% 			'File', ...
% 			'Previous File', ...
% 			'Next File', ...
% 			'Go To File ...' ...
% 		};
% 	
% 		n = length(L);
% 		S = bin2str(zeros(1,n));	
% 		S{3} = 'on';
% 		S{8} = 'on';
% 		A = cell(1,n);
% 		
% 		mg = menu_group(get_menu(h,'Navigate'),'log_view_menu',L,S,A);
% 		data.browser.view_menu.page = mg;
% 		
% 		L = data.browser.sound.file;
% 		menu_group(get_menu(mg,'File'),'log_view_menu',L);
% 	
% 	end
	
% 	%--
% 	% Channels
% 	%--
% 
% 	nch = data.browser.sound.channels;
% 	
% 	if (nch > 1)
% 		
% 		ax = data.browser.axes;
% 		
% 		L = cell(0);
% 		for k = 1:nch
% 			L{k} = ['Channel ' num2str(k)];
% 		end
% 		L{nch + 1} = 'All Channels';
% 		L{nch + 2} = 'Select Channels ...';
% 		
% 		S = bin2str(zeros(1,nch + 2));
% 		S{nch + 1} = 'on';
% 					
% 		mg = menu_group(get_menu(data.browser.view_menu.sound,'Channels'),'log_view_menu',L,S);
% 		data.browser.view_menu.channels = mg;
% 
% 		for k = 1:length(ax)
% 			set(get_menu(mg,['Channel ' get(ax(k),'tag')],2),'check','on');
% 		end
% 		
% 		pch = data.browser.play.channel;
% 		set(get_menu(mg,['Channel ' num2str(pch(1))],2),'enable','off');
% 		set(get_menu(mg,['Channel ' num2str(pch(2))],2),'enable','off');
% 		
% 	else
% 		
% 		delete(get_menu(h,'Channels Displayed'));
% 		
% 	end
	
	%--
	% Spectrogram Options
	%--
	
	L = { ...
		'Difference Signal', ...
		'FFT Length', ...	
		'Hop Length', ... 	
		'Window Type', ...
		'Window Length', ...
		'Edit All ...' ...
	};
		
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{4} = 'on';
	S{end} = 'on';
	
	mg = menu_group(get_menu(h,'Spectrogram Options'),'log_view_menu',L,S);
	data.browser.view_menu.specgram = mg;
	
	if (data.browser.specgram.diff)
		set(mg(1),'check','on');
	end
	
	%--
	% FFT Length
	%--
	
	L = { ...
		'128 samples', ...
		'256 samples', ...
		'512 samples', ...
		'1024 samples', ... 
		'Other FFT Length ...' ... % 5 - sep
	};
		
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{end} = 'on';
			
	mg = menu_group(get_menu(h,'FFT Length'),'log_view_menu',L,S);
	data.browser.view_menu.fft_length = mg;
	
	ix = find(data.browser.specgram.fft == [128,256,512,1024]);
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		set(mg(end),'check','on');
	end
	
	%--
	% Hop Length
	%--
	
	L = { ...
		'FFT Length', ...
		'3/4 FFT Length', ...
		'1/2 FFT Length', ...		
		'1/4 FFT Length', ... 		
		'1/8 FFT Length', ... 	
		'Other Hop Length ...' ... % 5 - sep
	};
		
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';

	mg = menu_group(get_menu(h,'Hop Length'),'log_view_menu',L,S);
	data.browser.view_menu.hop_length = mg;
	
	set(mg,'tag','hop');
	ix = find(data.browser.specgram.hop == [1,0.75,0.5,0.25,0.125]);
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		set(mg(end),'check','on');
	end 
	
	%--
	% Window
	%--
			
	mg = menu_group(get_menu(h,'Window Type'),'log_view_menu',WINDOW,WINDOW_SEP);
	data.browser.view_menu.window_type = mg;
	
	ix = find(strcmp(data.browser.specgram.win_type,WINDOW));
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		disp(' ');
		warning('Unrecognized window type.');
	end
	
	%--
	% Window Length
	%--
	
	L = { ...
		'FFT Length', ...
		'3/4 FFT Length', ...
		'1/2 FFT Length', ...		
		'1/4 FFT Length', ... 		
		'1/8 FFT Length', ... 	
		'Other Window Length ...' ... % 5 - sep
	};
		
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';

	mg = menu_group(get_menu(h,'Window Length'),'log_view_menu',L,S);
	data.browser.view_menu.window_length = mg;
	
	set(mg,'tag','win');
	
	ix = find(data.browser.specgram.win_length == [1,0.75,0.5,0.25,0.125]);
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		set(mg(end),'check','on');
	end
	
	%--
	% Colormap
	%--

	L = COLORMAP;
	S = COLORMAP_SEP;
			
	mg = menu_group(get_menu(h,'Colormap'),'log_view_menu',L,S);
	data.browser.view_menu.colormap = mg;
	
	ix = find(strcmp(data.browser.colormap.name,COLORMAP));
	if (~isempty(ix))
		set(mg(ix),'check','on');
	else
		disp(' ');
		warning('Unrecognized colormap.');
	end

	%--
	% Colormap Options
	%--
	
	L = { ...
		'Invert', ...
		'Auto Scale', ...
		'Auto Scale Options' ...
	};
	
	n = length(L);

	S = bin2str(zeros(1,n));
	S{2} = 'on';
	
	mg = menu_group(get_menu(h,'Colormap Options'),'log_view_menu',L,S);
	data.browser.view_menu.colormap_options = mg;
	
	if (data.browser.colormap.invert)
		cmap_invert;
		set(get_menu(mg,'Invert'),'check','on');
	end
	
	if (data.browser.colormap.auto_scale)
		cmap_scale;
		set(get_menu(mg,'Auto Scale'),'check','on');
	end
	
	set(get_menu(mg,'Auto Scale Options'),'enable','off');
	
	%--
	% Grid Options
	%--
		
	L = { ...
		'Color', ... 
		'Time Grid', ... 				
		'Time Spacing', ... 	
		'Time Labels ', ...
		'Frequency Grid', ... 	
		'Frequency Spacing', ...
		'Frequency Labels ', ...
		'Edit All ...' ...
	};

	n = length(L);

	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{5} = 'on';
	S{end} = 'on'; 

	mg = menu_group(get_menu(h,'Grid Options'),'log_view_menu',L,S);
	data.browser.view_menu.grid_options = mg;
	
	if (data.browser.grid.time.on)
		set(get_menu(mg,'Time Grid'),'check','on');
	end
	if (data.browser.grid.freq.on)
		set(get_menu(mg,'Frequency Grid'),'check','on');
	end
	
	set(get_menu(mg,'Edit All ...'),'enable','off');
	
	%--
	% remove file boundaries menu for single files
	%--
	
% 	if (strcmp(data.browser.sound.type,'File'))
% 		
% 		tmp = get_menu(mg,'File Grid');	
% 		mg = setdiff(mg,tmp);
% 		data.browser.view_menu.grid_options = mg;	
% 		delete(tmp);
% 		
% 		tmp = get_menu(mg,'Date and Time');
% 		set(tmp,'separator','on');
% 		
% 	end
		
	%--
	% Color
	%--
	
	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Color'), ...
		'log_view_menu',COLOR,COLOR_SEP);
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
		'log_view_menu',L,S);
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
	S{2} = 'on';
	
	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Time Labels '), ...
		'log_view_menu',L,S);
	data.browser.view_menu.time_labels = mg;
	
	if (strcmp(data.browser.grid.time.labels,'seconds'))
		set(mg(1),'check','on');
	else
		set(mg(2),'check','on');
	end
	
	if (isempty(data.browser.sound.realtime))
		set(get_menu(mg,'Date and Time'),'enable','off');
	else
		if (data.browser.grid.time.realtime)
			set(mg,'check','off'); 
			set(get_menu(mg,'Date and Time'),'check','on');
		end
	end 
	
	%--
	% Frequency Grid Spacing
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
		'Other Frequency Spacing ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{5} = 'on';
	S{end} = 'on';

	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Frequency Spacing'), ...
		'log_view_menu',L,S);
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
	% Frequency Labels 
	%--
	
	L = { ...
		'Hz', ...
		'kHz' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));

	mg = menu_group(get_menu(data.browser.view_menu.grid_options,'Frequency Labels '), ...
		'log_view_menu',L,S);
	data.browser.view_menu.freq_labels = mg;
	
	if (strcmp(data.browser.grid.freq.labels,'Hz'))
		set(mg(1),'check','on');
	else
		set(mg(2),'check','on');
	end

	%--
	% Renderer Options
	%--
	
	L = { ...
		'Auto', ...
		'Painters', ...
		'ZBuffer', ...
		'OpenGL' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';

	tmp = menu_group(get_menu(data.browser.view_menu.sound,'Renderer Options'),'log_view_menu',L,S);
	data.browser.view_menu.renderer = tmp;
	
	ix = find(strcmp(data.browser.renderer,L));
	if (isempty(ix))
		set(tmp(ix),'check','on');
	end

	%--
	% update userdata to include sound menu
	%--
	
	set(h,'userdata',data);
	
	%--
	% other initializations
	%--
	
% 	%--
% 	% enable and disable view menus
% 	%--
% 	
% 	if (data.browser.view.position < data.browser.view.length)
% 		set(get_menu(h,'Next View',2),'enable','on');
% 	else
% 		set(get_menu(h,'Next View',2),'enable','off');
% 	end
% 	
% 	if (data.browser.view.position == 1)
% 		set(get_menu(h,'Previous View',2),'enable','off');
% 	end
	
	%--
	% enable and disable navigation menus
	%--
	
% 	log_navigation_update(h,data);
		
	%--
	% set colormap
	%--
	
	log_view_menu(h,data.browser.colormap.name);
	
	%--
	% set renderer
	%--
	
	if (strcmp(data.browser.renderer,'Auto'))
		log_view_menu(h,'Automatic');
	else
		log_view_menu(h,data.browser.renderer);
	end

%--
% Selection
%--

case ('Selection ')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
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
	
	% remove selection and update edit menus
	
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
		
		data.browser.selection.event = event_create;
		data.browser.selection.handle = [];
		
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
		
%--
% Line Style
%--

case (LINESTYLE)
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update linestyle variable
	%--
	
	tmp = linestyle_to_str(str,'strict');
	data.browser.selection.linestyle = tmp;

	%--
	% update display
	%--
	
	g = findobj(h,'type','line','tag','selection');
	g = setdiff(g,findobj(g,'linewidth',0.5));
	
	set(g,'linestyle',tmp);
	
	refresh(h);
	
	%--
	% update menu
	%--
	
	tmp = data.browser.view_menu.selection_linestyle;
	set(tmp,'check','off');
	set(get_menu(tmp,str),'check','on');
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Line Width
%--

case ({'1 pt','2 pt','3 pt','4 pt'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update linestyle variable
	%--
	
	tmp = eval(strtok(str,' '));
	data.browser.selection.linewidth = tmp;

	%--
	% update display
	%--
	
	g = findobj(h,'type','line','tag','selection');
	g = setdiff(g,findobj(g,'linewidth',0.5));
	
	set(g,'linewidth',tmp);
	
	refresh(h);
	
	%--
	% update menu
	%--
	
	tmp = data.browser.view_menu.selection_linewidth;
	set(tmp,'check','off');
	set(get_menu(tmp,str),'check','on');
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Selection Opacity
%--

case ({'Transparent','1/8 Alpha','1/4 Alpha','1/2 Alpha','3/4 Alpha','Opaque'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata'); 
	
	%--
	% update selection alpha
	%--
	
	switch (str)
		
		case ('Transparent')
			tmp = -1;
			
		case ('Opaque')
			tmp = 1;
			
		otherwise
			tmp = eval(strtok(str,' '));
			
	end

	data.browser.selection.patch = tmp;
	
	%--
	% update menu and display
	%--
	
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
	
	set(gcf,'userdata',data);
	
	%--
	% update renderer and display
	%--
	
	if (tmp > 0)
		log_view_menu(h,'OpenGL');
	else
		refresh(gcf);
	end
	
%--
% Selection Grid
%--

case ('Selection Grid')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update grid selection variable
	%--
	
	state = ~data.browser.selection.grid;
	data.browser.selection.grid = state;
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--

	% get handles to menus and selection grid lines
	
	tmp = data.browser.view_menu.selection_options;
	g1 = findobj(gcf,'tag','selection','type','line','linewidth',0.5);
	g2 = findobj(gcf,'tag','selection','type','text');
	
	% update menus and visibility of selection grid
	
	if (state)
		set(get_menu(tmp,'Selection Grid'),'check','on');
		set(g1,'visible','on');
		if (data.browser.selection.label)
			set(g2,'visible','on');
		end
	else
		set(get_menu(tmp,'Selection Grid'),'check','off');
		set(g1,'visible','off');
		set(g2,'visible','off');
	end
	
	refresh(h);

%--
% Selection Labels
%--

case ('Selection Labels')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update label selection variable
	%--
	
	state = ~data.browser.selection.label;
	data.browser.selection.label = state;
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--

	% get handles to menus and selection labels
	
	tmp = data.browser.view_menu.selection_options;
	g = findobj(gcf,'tag','selection','type','text');
	
	% update menus and visibility of selection labels
	
	if (state)
		set(get_menu(tmp,'Selection Labels'),'check','on');
		if (data.browser.selection.grid)
			set(g,'visible','on');
		end
	else
		set(get_menu(tmp,'Selection Labels'),'check','off');
		set(g,'visible','off');
	end
	
	refresh(h);
	
%--
% Control Points
%--

case ('Control Points')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update label selection variable
	%--
	
	state = ~data.browser.selection.control;
	data.browser.selection.control = state;
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--

	% get handles to menus and selection control points
	
	tmp = data.browser.view_menu.selection_options;
	g = findobj(gcf,'tag','selection','type','line','markersize',5);
	
	% update menus and visibility of selection labels
	
	if (state)
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
% Page Size
%--

case ({ ...
	'2 x 2','2 x 3','2 x 4', ...
	'3 x 2','3 x 3','3 x 4', ...
	'4 x 2','4 x 3','4 x 4' ...
})

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update userdata and menu
	%--
	
	[row,col] = strtok(str,'x');
	
	row = eval(row);
	col = eval(col(3:end));
	
	data.browser.row = row;
	data.browser.column = col;
	
	set(h,'userdata',data);
	
	set(data.browser.view_menu.page_size,'check','off');
	set(gcbo,'check','on');
	
	%--
	% update display 
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;

	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
case ('Other Page Size ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% setup input dialog
	%--
	
	ans = input_dialog( ...
		{'Page Rows','Page Columns'}, ...
		'Other Page Size ...', ...
		[1,40], ...
		{[data.browser.row,1,8,1/8,1/8,2],[data.browser.column, 1, 8, 1/8, 1/8, 2]}, ...
		{'Number of clip rows per page','Number of clip columns per page'} ...
	);

	%--
	% update userdata and menu if needed
	%--
	
	if (isempty(ans))
				
		return;
		
	else
		
		data.browser.row = ans{1};
		data.browser.column = ans{2};
		
		set(h,'userdata',data);
		
		tmp = [int2str(ans{1}) ' x ' int2str(ans{2})];
		
		ix = find(strcmp(get(data.browser.view_menu.page_size,'label'),tmp));
		
		set(data.browser.view_menu.page_size,'check','off');
		
		if (~isempty(ix))
			set(data.browser.view_menu.page_size(ix),'check','on');
		else
			set(data.browser.view_menu.page_size(end),'check','on');
		end
		
	end
	
	%--
	% update display 
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;

	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
%--
% Event Dilation
%--

case ({'2x','3x','4x','5x'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get dilation factor from string and update
	%--
	
	dil = eval(str(1));
	data.browser.dilation = dil;
	
	set(h,'userdata',data);
	
	%--
	% update display 
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;

	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
case ('Other Event Dilation ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% setup input dialog
	%--
	
	ans = input_dialog( ...
		{'Event Dilation'}, ...
		'Other Event Dilation ...', ...
		[1,40], ...
		{[data.browser.dilation,1.25,10,1/10,1/10,2]}, ...
		{'Dilation factor for event display using largest duration event in set'} ...
	);

	%--
	% update userdata and menu if needed
	%--
	
	if (isempty(ans))		
		return;
	else
		data.browser.dilation = ans{1};
		set(h,'userdata',data);
	end

	%--
	% update display 
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;

	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
%--
% Frequency Bounds ...
%--

case ('Frequency Bounds ...')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% setup input dialog
	%--
	
	ans = input_dialog( ...
		'Frequency Bounds', ...
		'Frequency Bounds ...', ...
		[1,32], ...
		{mat2str(data.browser.page.freq)}, ...
		{'Interval of displayed frequencies, in Hz'} ...
	);

	%--
	% update userdata and menu if needed
	%--
	
	if (~isempty(ans))				
		data.browser.page.freq = eval(ans{1});
		set(h,'userdata',data);		
	else		
		return;		
	end
	
	%--
	% update display
	%--
	
	% this expensive update is not needed right now, however this will
	% change
	
% 	log_browser_display;	
	
	if (~isempty(data.browser.page.freq))
% 			set(hi,'ydata',data.browser.page.freq);
		yl = [0,data.browser.sound.samplerate / 2];
		set(data.browser.images,'ydata',yl);
		set(data.browser.axes,'ylim',data.browser.page.freq);
	else
% 			yl = fast_min_max(F{k});
		yl = [0,data.browser.sound.samplerate / 2];
		set(data.browser.images,'ydata',yl);
		set(data.browser.axes,'ylim',yl);
	end
	
%--
% Page (Play Page)
%--

case ({'Page','Play Page'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set channel or stereo, first checking for selection
	%--
	
	flag_stereo = 0;

	if (isempty(data.browser.selection.handle))
		
		ch = data.browser.play.channel;
		
		if (ch(1) ~= ch(2))	
			ax(1) = findobj(data.browser.axes,'tag',num2str(ch(1)));
			ax(2) = findobj(data.browser.axes,'tag',num2str(ch(2)));	
			flag_stereo = 1;	
		else
			ch = ch(1);
			ax = findobj(h,'type','axes','tag',num2str(ch));	
		end
		
	else
		
		ch = data.browser.selection.event.channel;
		ax = findobj(h,'type','axes','tag',num2str(ch));
		
	end
		
	%--
	% get relevant data from userdata
	%--
	
	g = data.browser.sound;
	t = data.browser.time;
	page = data.browser.page;
	speed = data.browser.play.speed;

	%--
	% forward play
	%--
	
	if (speed > 0)	
		
		%--
		% play scaled sound
		%--

		tmp = sound_read(g,'time',t,page.duration,ch);
		
		% apply difference filter to played image as well
		
		if (data.browser.specgram.diff)
			tmp = diff(tmp,1);
		end
		
		soundsc(tmp,(speed * g.samplerate));
		
		%--
		% display play position
		%--
		
		if (flag_stereo)
						
			axes(ax(1));
			tmp_handle(1) = plot(t*ones(2,1),get(ax(1),'ylim')','b-');
			axes(ax(2));
			tmp_handle(2) = plot(t*ones(2,1),get(ax(2),'ylim')','b-');
			
			refresh(h);
			
			tmp = 0;
			while (tmp <= (page.duration / speed))
				tic;
				try
					set(tmp_handle,'xdata',(t + tmp * speed)*ones(2,1));
				end
				drawnow;
				refresh(h);
				tmp = tmp + toc;
			end
			
			try
				delete(tmp_handle);
			end
			
		else
			
			axes(ax);
			tmp_handle = plot(t*ones(2,1),get(ax,'ylim')','b-');
			
			refresh(h);
			
			tmp = 0;
			while (tmp <= (page.duration / speed))
				tic;
				set(tmp_handle,'xdata',(t + tmp * speed)*ones(2,1));
				drawnow;
				refresh(h);
				tmp = tmp + toc;
			end
			
			delete(tmp_handle);
			
		end
	
	%--
	% backward play
	%--
	
	elseif (speed < 0)	
		
		%--
		% play scaled sound
		%--
		
		tmp = sound_read(g,'time',t,page.duration,ch);
		
		% apply difference filter to played image as well
		
		if (data.browser.specgram.diff)
			tmp = diff(tmp,1);
		end
		
		soundsc(flipud(tmp),(-speed * g.samplerate));
		
		%--
		% display play position
		%--
		
		if (flag_stereo)
						
			axes(ax(1));
			tmp_handle(1) = plot(t*ones(2,1),get(ax(1),'ylim')','b-');
			axes(ax(2));
			tmp_handle(2) = plot(t*ones(2,1),get(ax(2),'ylim')','b-');
			
			refresh(h);
			
			tmp = 0;
			while (tmp <= (page.duration / -speed))
				tic;
				set(tmp_handle,'xdata',(t + page.duration + tmp * speed)*ones(2,1));
				drawnow;
				refresh(h);
				tmp = tmp + toc;
			end
			
			delete(tmp_handle);
			
		else
			
			axes(ax);
			tmp_handle = plot(t*ones(2,1),get(ax,'ylim')','b-');
			
			refresh(h);
			
			tmp = 0;
			while (tmp <= (page.duration / -speed))
				tic;
				set(tmp_handle,'xdata',(t + page.duration + tmp * speed)*ones(2,1));
				drawnow;
				refresh(h);
				tmp = tmp + toc;
			end
			
			delete(tmp_handle);
			
		end
	
	end
	
%--
% Play Selection, Selection (Play Selection)
%--

case ({'Selection','Play Selection'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%-
	% check for existing selection event
	%--
	
	if (isempty(data.browser.selection.handle))
		return;
	end
	
	%--
	% get relevant data from userdata
	%--
	
	g = data.browser.sound;
	event = data.browser.selection.event;
	speed = data.browser.play.speed;
	
% 	tag = get(data.browser.selection.handle,'tag');
% 	if (~iscell(tag))
% 		[m,ix] = strtok(tag,'.');
% 		line_color = data.browser.log(str2num(m)).color;
% 	else
% 		line_color = [0,0,1];
% 	end

	line_color = [0,0,1];

	%--
	% set active axes
	%--
	
	axes(findobj(data.browser.axes,'tag',num2str(event.channel)));
	
	%--
	% forward play
	%--
	
	if (speed > 0)	
		
		%--
		% play scaled sound
		%--
		
		soundsc( ...
			sound_read(g,'time',event.time(1),event.duration,event.channel), ...
			(speed * g.samplerate) ...
		);	
	
		%--
		% display play position
		%--
		
		tmp_handle = plot(event.time(1)*ones(2,1),get(gca,'ylim')','color',line_color);
		refresh(h);
		
		tmp = 0;
		while (tmp <= (event.duration / speed))
			tic;
			set(tmp_handle,'xdata',(event.time(1) + tmp * speed)*ones(2,1));
			drawnow;
			refresh(h);
			tmp = tmp + toc;
		end
		
		delete(tmp_handle);
	
	%--
	% backward play
	%--
	
	elseif (speed < 0)	
		
		%--
		% play scaled sound
		%--
		
		soundsc( ...
			flipud(sound_read(g,'time',event.time(1),event.duration,event.channel)), ...
			(-speed * g.samplerate) ...
		);
	
		%--
		% display play position
		%--
				
		tmp_handle = plot(event.time(2)*ones(2,1),get(gca,'ylim')','color',line_color);
		refresh(h);
		
		tmp = 0;
		while (tmp <= (event.duration / -speed))
			tic;
			set(tmp_handle,'xdata',(event.time(2) + tmp * speed)*ones(2,1));
			drawnow;
			refresh(h);
			tmp = tmp + toc;
		end
		
		delete(tmp_handle);
	
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
	
	set(data.browser.view_menu.play_speed,'check','off');
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
	
	set(data.browser.view_menu.play_speed,'check','off');
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
	
	set(data.browser.view_menu.play_speed,'check','off');
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
		
		set(data.browser.view_menu.play_speed,'check','off');
		set(get_menu(h,str),'check','on');
		
	end
	
%--
% Previous View
%--

case ('Previous View')

	%--
	% get userdata 
	%--
	
	data = get(h,'userdata');
		
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
	
	% update userdata
	
	set(h,'userdata',data);
	
	%--
	% consider possible channel change in display update
	%--
	
	if (isequal(data.browser.channels,state.channels))
		
		%--
		% simple browser update
		%--
		
		log_browser_display;
			
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
		
		if (~isempty(findobj(h,'type','axes','tag','Colorbar')))
			array_colorbar(h);
			flag = 1;
		else
			flag = 0;
		end
						
		[ha,hi] = log_browser_display('create', ...
			data.browser.time, ...
			data.browser.page.duration, ...
			ch ...
		);	
		
		data.browser.axes = ha;
		data.browser.images = hi;
		data.browser.channels = ch;
		
		if (flag)
			array_colorbar;
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
			log_browser_display('events');
		end
		
		%--
		% apply resize function
		%--
		
		log_resizefcn;
		
		%--
		% update menus
		%--
		
		% turn off all channels, we are already viewing all channels
				
		test = 0;
		if (length(ch) == nch)
			set(get_menu(h,'All Channels',2),'enable','off');
			test = test + 1;
		else
			set(get_menu(h,'All Channels',2),'enable','on');
		end
		
		% turn off select channels, there are no channels to toggle
		
		if (nch > 1)
			set(get_menu(h,'Select Channels ...',2),'enable','on');
			if ((nch == 2) & diff(pch))
				set(get_menu(h,'Select Channels ...',2),'enable','off');
				test = test + 1;
			end
		else
			set(get_menu(h,'Select Channels ...',2),'enable','off');
			test = test + 1;
		end
		
		% there are no enabled menus in the channels submenu disable channels
		
		if (test == 2)
			tmp = get(get_menu(h,'All Channels',2),'parent');
			if (iscell(tmp))
				set(cell2mat(tmp),'enable','off');
			else
				set(tmp,'enable','off');
			end
		else
			tmp = get(get_menu(h,'All Channels',2),'parent');
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
	
	if (data.browser.view.position == 1)
		set(get_menu(h,'Previous View',2),'enable','off');
	end
	
	%--
	% enable and disable navigation menus
	%--
	
	log_navigation_update(h,data);
	
	%--
	% update related menus
	%--
	
	% page duration and overlap
	
	% channels (browser display may take care of these?)
	
	% play channels (browser display may take care of these?)
	
%--
% Next View
%--

case ('Next View')
	
	%--
	% get userdata 
	%--
	
	data = get(h,'userdata');
		
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
	
	% update userdata
	
	set(h,'userdata',data);
	
	%--
	% consider possible channel change in diaplay update
	%--
			
	if (isequal(data.browser.channels,state.channels))
		
		%--
		% simple browser update
		%--
		
		log_browser_display;
			
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
		
		if (~isempty(findobj(h,'type','axes','tag','Colorbar')))
			array_colorbar;
			flag = 1;
		else
			flag = 0;
		end
						
		[ha,hi] = log_browser_display('create', ...
			data.browser.time, ...
			data.browser.page.duration, ...
			ch ...
		);	
		
		data.browser.axes = ha;
		data.browser.images = hi;
		data.browser.channels = ch;
		
		if (flag)
			array_colorbar;
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
			log_browser_display('events');
		end
		
		%--
		% apply resize function
		%--
		
		log_resizefcn;
		
		%--
		% update menus
		%--
		
		% turn off all channels, we are already viewing all channels
				
		test = 0;
		if (length(ch) == nch)
			set(get_menu(h,'All Channels',2),'enable','off');
			test = test + 1;
		else
			set(get_menu(h,'All Channels',2),'enable','on');
		end
		
		% turn off select channels, there are no channels to toggle
		
		if (nch > 1)
			set(get_menu(h,'Select Channels ...',2),'enable','on');
			if ((nch == 2) & diff(pch))
				set(get_menu(h,'Select Channels ...',2),'enable','off');
				test = test + 1;
			end
		else
			set(get_menu(h,'Select Channels ...',2),'enable','off');
			test = test + 1;
		end
		
		% there are no enabled menus in the channels submenu disable channels
		
		if (test == 2)
			tmp = get(get_menu(h,'All Channels',2),'parent');
			if (iscell(tmp))
				set(cell2mat(tmp),'enable','off');
			else
				set(tmp,'enable','off');
			end
		else
			tmp = get(get_menu(h,'All Channels',2),'parent');
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
	
	log_navigation_update(h,data);
	
	%--
	% update related menus
	%--
	
	% page duration and overlap
	
	% channels (browser display may take care of these?)
	
	% play channels (browser display may take care of these?)	
	
%--
% First Page
%--

case ('First Page')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% check that we are not at start of sound already
	%--
	
	if (data.browser.index == 1)
		return; 
	end
	
	%--
	% update log browser state
	%--
	
	data.browser.index = 1;
	
	set(h,'userdata',data);
	
	%--
	% update display 
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;

	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;

%--
% Last Page
%--

case ('Last Page')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get log length from parent
	%--
	
	parent = get(data.browser.parent,'userdata');
	
	LOGS = file_ext(struct_field(parent.browser.log,'file'));
	
	m = find(strcmp(LOGS,data.browser.log));
	
	if (isempty(m))
		flag = 0;
		return;
	end
	
	n = parent.browser.log(m).length;
	
	%--
	% check that we are not at start of sound already
	%--
	
	tmp = n - (data.browser.row * data.browser.column) + 1;
	
	if (data.browser.index == tmp)
		return; 
	end
	
	%--
	% update log browser state
	%--
	
	data.browser.index = tmp;
	
	set(h,'userdata',data);
	
	%--
	% update display 
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;
	
	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
%--
% Go To Page ...
%--

case ('Go To Page ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');

	%--
	% get log length from parent
	%--
	
	parent = get(data.browser.parent,'userdata');
	
	LOGS = file_ext(struct_field(parent.browser.log,'file'));
	
	m = find(strcmp(LOGS,data.browser.log));
	
	if (isempty(m))
		flag = 0;
		return;
	end
	
	n = parent.browser.log(m).length;
	
	%--
	% get event to jump to
	%--
		
	slider_vec = [data.browser.index, 1, n, 1/n, 1/n, 2];
	slider_tip = 'Event at start of page to display, index';

	ans = input_dialog( ...
		{'Start Event'}, ...
		'Go To Page ...', ... 
		[1,40], ...
		{slider_vec}, ...
		{slider_tip} ...
	);
	
	if (isempty(ans))
		
		return;
		
	else
		
		%--
		% consider length of log
		%--
	
		last = n - (data.browser.row * data.browser.column) + 1;
		jump = data.browser.row * data.browser.column;

		ix = min(ans{1},last - jump);
		
		%--
		% update start index of page
		%--
		
		data.browser.index = ix;

	end
	
	%--
	% update browser state
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;
	
	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
%--
% Previous Page
%--

case ('Previous Page')
	
	%--
	% get relevant data from userdata
	%--
	
	data = get(h,'userdata');

	%--
	% get log length from parent
	%--
	
	parent = get(data.browser.parent,'userdata');
	
	LOGS = file_ext(struct_field(parent.browser.log,'file'));
	
	m = find(strcmp(LOGS,data.browser.log));
	
	if (isempty(m))
		flag = 0;
		return;
	end
	
	n = parent.browser.log(m).length;
	
	%--
	% check if we are at start of sound already
	%--
	
	if (data.browser.index == 1)
		return;
	end
	
	%--
	% compute new starting index for page and update browser state
	%--
	
	data.browser.index = max(1,data.browser.index - (data.browser.row * data.browser.column));

	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;
	
	%--
	% enable and disable navigation menus
	%--
	
% 	log_navigation_update(h,data);
% 
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn; 
	
%--
% Next Page
%--

case ('Next Page')
	
	%--
	% get relevant data from userdata
	%--
	
	data = get(h,'userdata');

	%--
	% get log length from parent
	%--
	
	parent = get(data.browser.parent,'userdata');
	
	LOGS = file_ext(struct_field(parent.browser.log,'file'));
	
	m = find(strcmp(LOGS,data.browser.log));
	
	if (isempty(m))
		flag = 0;
		return;
	end
	
	n = parent.browser.log(m).length;
	
	%--
	% check if we are at end of sound already
	%--
	
	last = n - (data.browser.row * data.browser.column) + 1;
	jump = data.browser.row * data.browser.column;
	
	%--
	% compute new time for page
	%--
	
	ix = data.browser.index + jump;
	ix = min(ix,last);
	
	data.browser.index = ix;

	%--
	% update browser state
	%--

	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;
	
	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
%--
% Scrollbar
%--

case ('Scrollbar')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get scrollbar value and update browser state index
	%--

	data.browser.index = round(get(gcbo,'value'));
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
% 	log_browser_display;
	
	log_browser_display('update', ...
		data.browser.index, ...
		data.browser.dilation ...
	);

% 	data.browser.axes = ax;
% 	data.browser.images = im;
% 	data.browser.slider = sli;
	
	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
%--
% Navigate Options ...
%--

case ('Navigate Options ...')

	%--
	% get relevant data from userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get log index from parent
	%--
	
	parent = get(data.browser.parent,'userdata');
	
	LOGS = file_ext(struct_field(parent.browser.log,'file'));
	
	m = find(strcmp(LOGS,data.browser.log));
	
	if (isempty(m))
		flag = 0;
		return;
	end
	
	%--
	% get page parameters using log extent dialog
	%--
	
	[ix,dil,row,col] = log_extent_dialog( ...
		parent.browser.log(m), ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ...
		data.browser.column ...
	);
	
	%--
	% update page parameters if needed
	%--
	
	if (~isempty(ix))	
		
		data.browser.index = ix;
		data.browser.dilation = dil; 
		data.browser.row = row;
		data.browser.column = col;

		set(h,'userdata',data);			
		
	end
	
	%--
	% update display
	%--
	
% 	log_browser_display;
	
	[ax,im,sli] = log_browser_display('create', ...
		data.browser.log, ...
		data.browser.index, ...
		data.browser.dilation, ...
		data.browser.row, ... 
		data.browser.column ...
	);

	data.browser.axes = ax;
	data.browser.images = im;
	data.browser.slider = sli;
	
	%--
	% enable and disable navigation menus and update view array
	%--
	
% 	log_navigation_update(h,data);
% 	
% 	data.browser.view = log_view_update(h,data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	log_resizefcn;
	
%--
% Previous File
%--

case ('Previous File')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	t = data.browser.time;
	sound = data.browser.sound;
	
	%--
	% compute previous file index
	%--
	
	ft = [0; sound.cumulative / sound.samplerate];	
	ix = max(find(ft < t));
	
	%--
	% move to file according to moving to file command
	%--
	
	log_view_menu(h,sound.file(ix));
	
%--
% Next File
%--

case ('Next File')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	t = data.browser.time;
	dt = data.browser.page.duration;

	sound = data.browser.sound;
	
	%--
	% compute next file index
	%--
	
	ft = [0; sound.cumulative / sound.samplerate];	
	
	ix1 = min(find(ft > t));
	ix2 = min(find(ft > t + dt));
	ix = max(ix1,ix2);
	
	% nowhere to go after last file
	
	if (ix > length(sound.file))
		return; 
	end
	
	%--
	% move to file according to moving to file command
	%--
	
	log_view_menu(h,sound.file(ix));
	
%--
% Go To File ...
%--

case ('Go To File ...')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');

	sound = data.browser.sound;
	gopt = data.browser.grid;
	
	%--
	% return for files
	%--
	
	if (strcmp(sound.type,'File'))
		return;
	end
	
	%--
	% build strings to be used in input dialog, filenames and related times
	%--
	
	n = length(sound.file);
	
	c = [0; sound.cumulative];
	s = sound.samples;
	r = sound.samplerate;
	
	%--
	% clock display for all times
	%--
	
	if (strcmp(gopt.time.labels,'clock'))	
		
		%--
		% realtime display for start time
		%--
		
		if (gopt.time.realtime & ~isempty(data.browser.sound.realtime))	
			
			len = zeros(1,n);
			for k = 1:n
				tmp = datevec(data.browser.sound.realtime);
				tmp = (c(k)/r) + tmp(4:6)*[3600,60,1]';							
				tmp = sec_to_clock(tmp);
				tmp2 = sec_to_clock(s(k)/r);
				def{k} = [sound.file{k} '  (' tmp ' / ' tmp2 ')'];
				len(k) = length(def{k});
			end	
			
		%--
		% clock display for all times
		%--
		
		else	
			
			len = zeros(1,n);
			for k = 1:n
				tmp = sec_to_clock(c(k)/r);
				tmp2 = sec_to_clock(s(k)/r);
				def{k} = [sound.file{k} '  (' tmp ' / ' tmp2 ')'];
				len(k) = length(def{k});
			end
			
		end
		
	%--
	% seconds display for all times
	%--
	
	else
		
		len = zeros(1,n);
		for k = 1:n
			tmp = num2str(c(k)/r);
			tmp2 = num2str(s(k)/r);
			def{k} = [sound.file{k} '  (' tmp ' / ' tmp2 ')'];
			len(k) = length(def{k});
		end
		
	end	
	
	len = max(len) + 4;
	len = max(32,len);
	len = min(52,len);
	
	%--
	% get file to go to
	%--
	
	ans = input_dialog( ...
		{'File'}, ...
		'Go To File ...', ... 
		[1,len], ...
		{def}, ...
		{'File to go to, displayed times are start time and duration of file'} ...
	);
	
	if (isempty(ans))
		return;
	else
		
		%--
		% keep filename, remove time string
		%--
		
		str = ans{1};
		ix = findstr(str,'(');
		ix = ix(end) - 3;
		str = str(1:ix);
		
		%--
		% go to file
		%--
		
		log_view_menu(h,str);	
		
	end
	
%--
% All Channels
%--

case ('All Channels')
	

%--
% Spectrogram
%--

%--
% Difference Signal
%--

case ('Difference Signal')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% toggle difference signal and update menu
	%--
	
	data.browser.specgram.diff = ~data.browser.specgram.diff;
	
	if (data.browser.specgram.diff)
		set(get_menu(h,str),'check','on');
	else
		set(get_menu(h,str),'check','off');
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	log_browser_display;

%--
% FFT Length
%--

case ({'64 samples','128 samples','256 samples','384 samples', ...
		'512 samples','768 samples','1024 samples','2048 samples'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set fft length and update menu
	%--
	
	n = strtok(str,' ');
	data.browser.specgram.fft = str2num(n);

	set(data.browser.view_menu.fft_length,'check','off');
	set(get_menu(h,str),'check','on');
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	log_browser_display;

case ('Other FFT Length ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get fft length using input dialog
	%--
	
	ans = input_dialog( ...
		'FFT Length', ...
		'Other FFT Length ...', ...
		[1,40], ...
		{[data.browser.specgram.fft,32,2048,2]}, ...
		{'Length of FFT, in number of samples'} ...
	);

	%--
	% update fft length if needed
	%--
	
	if (~isempty(ans))

		data.browser.specgram.fft = ans{1};
		
		set(data.browser.view_menu.fft_length,'check','off');
		set(get_menu(h,str),'check','on');
	
	else
		return;
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	log_browser_display;

%--
% Hop Length and Window Length
%--

case ({'FFT Length','3/4 FFT Length','1/2 FFT Length','1/4 FFT Length','1/8 FFT Length'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
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
		set(h,'userdata',data);
		
		%--
		% update menu
		%--
		
		set(data.browser.view_menu.hop_length,'check','off');
		set(get_menu(data.browser.view_menu.hop_length,str),'check','on');
		
	case ('win')
		
		%--
		% update parameter
		%--
		
		data.browser.specgram.win_length = tmp;
		set(h,'userdata',data);
		
		%--
		% update menu
		%--
		
		set(data.browser.view_menu.window_length,'check','off');
		set(get_menu(data.browser.view_menu.window_length,str),'check','on');
		
	end
	
	%--
	% update display
	%--
	
	log_browser_display;
	log_resizefcn;
	
%--
% Other Hop Length ...
%--

case ('Other Hop Length ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get hop length using input dialog
	%--
	
	ans = input_dialog( ...
		'Hop Length', ...
		'Other Hop Length ...', ...
		[1,32], ...
		{[data.browser.specgram.hop,0,1]}, ...
		{'Length of hop, as fraction of FFT length'} ...
	);

	%--
	% update hop length if needed
	%--
	
	if (~isempty(ans))

		data.browser.specgram.hop = ans{1};
		
		set(data.browser.view_menu.hop_length,'check','off');
		
		ix = find(ans{1} == [1, 0.5, 0.25, 0.125]);
		
		if (~isempty(ix))
			set(data.browser.view_menu.hop_length(ix),'check','on');
		else
			set(get_menu(h,str),'check','on');
		end
	
	else
		return;
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	log_browser_display;
	log_resizefcn;

%--
% Other Window Length ...
%--

case ('Other Window Length ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get window length using input dialog
	%--
	
	ans = input_dialog( ...
		'Window Length', ...
		'Other Window Length ...', ...
		[1,32], ...
		{[data.browser.specgram.win_length,0,1]}, ...
		{'Length of hop, as fraction of FFT length'} ...
	);

	%--
	% update hop length if needed
	%--
	
	if (~isempty(ans))

		data.browser.specgram.win_length = ans{1};
		
		set(data.browser.view_menu.window_length,'check','off');
		
		ix = find(ans{1} == [1, 0.5, 0.25, 0.125]);
		
		if (~isempty(ix))
			set(data.browser.view_menu.window_length(ix),'check','on');
		else
			set(get_menu(h,str),'check','on');
		end
	
	else
		return;
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	log_browser_display;
	log_resizefcn;
	
%--
% Window
%--

case (WINDOW)
	
	%--
	% update userdata
	%--
	
	data = get(gcf,'userdata');
	data.browser.specgram.win_type = str;
	set(gcf,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.view_menu.window_type,'check','off');
	set(get_menu(data.browser.view_menu.window_type,str),'check','on');
	
	%--
	% update display
	%--
	
	log_browser_display;
	log_resizefcn;

%--
% Spectrogram Options ...
%--

case ('Spectrogram Options ...')
	
	%--
	% update spectrogram options
	%--
	
	opt = fast_specgram_dialog([],h);
	
	if (isempty(opt))
		return;
	end
	
	%--
	% update display
	%--
	
	data = get(h,'userdata');
	
	log_browser_display;
	log_resizefcn;
		
%--
% Colormap
%--

case (COLORMAP)

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');

	%--
	% set colormap
	%--
	
	colormap(feval(colormap_to_fun(str),256));
	
	%--
	% update userdata
	%--
	
	data.browser.colormap.name = str;
	set(h,'userdata',data);
	
	%--
	% update menu
	%--
	
	set(data.browser.view_menu.colormap,'check','off');
	set(get_menu(data.browser.view_menu.colormap,str),'check','on');
	
	%--
	% invert and scale colormap if needed
	%--
	
	if (data.browser.colormap.invert)
		set(h,'Colormap',flipud(get(h,'Colormap')));
	end
	
	if (data.browser.colormap.auto_scale)
		cmap_scale;
	end
	
%--
% Colorbar
%--

case ('Colorbar')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% toggle colorbar
	%--
	
	array_colorbar;
	
	%--
	% update menu
	%--
	
	ax = findobj(h,'type','axes','tag','Colorbar');
	
	if (isempty(ax))
		
		set(get_menu(data.browser.view_menu.sound,str),'check','off');
		log_resizefcn;
		
	else
		
		set(get_menu(data.browser.view_menu.sound,str),'check','on');
		log_resizefcn;
		
		tmp = data.browser.grid.color;
		set(ax,'XColor',tmp,'YColor',tmp);
		set(get(ax,'title'),'color',tmp);
	
	end
	
	axes(data.browser.axes(1));
	
%--
% Invert
%--

case ('Invert')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');	
	
	%--
	% toggle invert
	%--
	
	data.browser.colormap.invert = ~data.browser.colormap.invert;
	
	%--
	% update menu
	%--
	
	if (data.browser.colormap.invert)
		set(get_menu(data.browser.view_menu.colormap_options,str),'check','on');		
	else
		set(get_menu(data.browser.view_menu.colormap_options,str),'check','off');
	end

	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update colormap
	%--
	
	log_view_menu(h,data.browser.colormap.name);
	
%--
% Auto Scale
%--

case ('Auto Scale')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');

	%--
	% toggle autoscale
	%--
	
	data.browser.colormap.auto_scale = ~data.browser.colormap.auto_scale;
	
	%--
	% update menu
	%--
	
	if (data.browser.colormap.auto_scale)	
		set(get_menu(data.browser.view_menu.colormap_options,str),'check','on');	
	else		
		set(get_menu(data.browser.view_menu.colormap_options,str),'check','off');	
	end

	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update colormap
	%--
	
	log_view_menu(h,data.browser.colormap.name);
	
%--
% Brighten
%--

case ('Brighten')

	brighten(0.1);

%--
% Darken
%--

case ('Darken')

	brighten(-0.1);

%--
% Grid
%--

case ('Grid')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
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
	% update userdata
	%--
	
	set(h,'userdata',data);

%--
% Color
%--
	
case (COLOR)
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% check parent of command to determine action
	%--
	
	tmp = get(get(get(gcbo,'parent'),'parent'),'label');
	
	switch (tmp)
	
	%--
	% set selection color
	%--
	
	case ('Selection Options')
		
		%--
		% update selection color variable
		%--
		
		tmp = color_to_rgb(str);
		data.browser.selection.color = tmp;
		
		%--
		% udpate selection display
		%--
		
		g = findobj(h,'type','line','tag','selection');
		g = setdiff(g,findobj(g,'linewidth',0.5));
		set(g,'color',tmp);
		
		if (data.browser.selection.patch > 0)
			g = findobj(h,'type','patch','tag','selection');
			set(g,'facecolor',tmp);
		end
		
		%--
		% update menus and userdata
		%--
		
		tmp = data.browser.view_menu.selection_color;
		set(tmp,'check','off');
		set(get_menu(tmp,str),'check','on');
		
		set(h,'userdata',data);
		
	%--
	% set axes colors
	%--
	
	otherwise
		
% 	case ('Grid Options')
		
		tmp = color_to_rgb(str);
		
		% display axes
		
		set(data.browser.axes,'XColor',tmp,'YColor',tmp);
		set(cell2mat(get(data.browser.axes,'title')),'color',tmp);
				
		% colorbar axes
		
		ax = findobj(h,'type','axes','tag','Colorbar');	
		if (~isempty(ax))
			set(ax,'XColor',tmp,'YColor',tmp);
			set(get(ax,'title'),'color',tmp);
		end
		
		%--
		% set color of crosshairs and selection labels
		%--
		
		set(findobj(h,'tag','selection','linestyle',':','linewidth',0.5),'color',tmp);
		set(findobj(h,'tag','selection','type','text'),'color',tmp);
		
		%--
		% update userdata
		%--
		
		data.browser.grid.color = tmp;
		set(h,'userdata',data);
		
		%--
		% update menu
		%--
		
		set(data.browser.view_menu.color,'check','off');
		set(get_menu(data.browser.view_menu.color,str),'check','on');
		
		%--
		% update figure color for light grid color
		%--
	
		if ((sum(tmp) >= 0.8) | (max(tmp) >= 0.8))
			
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
		
	end
	
%--
% Time Grid
%--

case ('Time Grid')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
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
		set(get_menu(data.browser.view_menu.grid_options,str),'check','on');
	else
		if (gopt.on)
			set(ax,'xgrid','off');
		end
		set(get_menu(data.browser.view_menu.grid_options,str),'check','off');
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Auto (spacing for time and frequency, as well as renderer selection)
%--

case ('Auto')
		
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
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
		
	case ('Frequency Spacing')
		
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
% Time Spacing
%-- 

case ({' 1 sec/Tick',' 2 sec/Tick',' 5 sec/Tick', ...
		'10 sec/Tick', '1/2 sec/Tick', '1/4 sec/Tick', '1/5 sec/Tick', '1/10 sec/Tick'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get spacing from string and update time grid spacing
	%--
	
	t = eval(str(1:3));
	data.browser.grid.time.spacing = t;
	
	%--
	% update xtick
	%--
	
	ax = data.browser.axes; 
	xl = get(ax(1),'xlim');
	
	if (t ~= round(t))
		ix = 0:t:xl(2); 
		tmp = find(ix >= xl(1)); 
		ix = ix(tmp(1):end);
	else
		ix = floor(xl(1)):ceil(xl(2));
		if (t > 1)
			ix = ix(find(mod(ix,t) == 1)) - 1;
		end 
	end
	
	set(ax,'xtick',ix);
	
	set(data.browser.view_menu.time_spacing,'check','off');
	set(gcbo,'check','on');
	
	%%%%% TEST TEST %%%%%%%
		
	if (1)
		tmp = data.browser.axes(end);
		set(tmp,'xticklabel',sec_to_clock(get(tmp,'xtick')));
	else
		set(data.browser.axes,'xticklabelmode','auto');
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Other Time Spacing ...
%--

case ('Other Time Spacing ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get spacing using input dialog
	%--
	
	ans = input_dialog( ...
		'Time Spacing', ...
		'Other Time Spacing ...', ...
		[1,32], ...
		{num2str(data.browser.grid.time.spacing)}, ...
		{'Spacing of time grid, in seconds'} ...
	);

	%--
	% get spacing from string and update time grid spacing
	%--
	
	if (~isempty(ans))
		t = str2num(ans{1});
		data.browser.grid.time.spacing = t;
	else
		return;
	end
	
	%--
	% update xtick
	%--
	
	ax = data.browser.axes; 
	xl = get(ax(1),'xlim');

	if (t ~= round(t))
		ix = 0:t:xl(2); 
		tmp = find(ix >= xl(1)); 
		ix = ix(tmp(1):end);
	else
		ix = floor(xl(1)):ceil(xl(2));
		if (t > 1)
			ix = ix(find(mod(ix,t) == 1)) - 1;
		end 
	end
	
	set(ax,'xtick',ix);
	
	%%%%% TEST TEST %%%%%%%
		
	if (1)
		tmp = data.browser.axes(end);
		set(tmp,'xticklabel',sec_to_clock(get(tmp,'xtick')));
	else
		set(data.browser.axes,'xticklabelmode','auto');
	end
	
	%--
	% update check
	%--
	
	set(data.browser.view_menu.time_spacing,'check','off');
	set(gcbo,'check','on');
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Time Labels 
%--

case ({'Seconds','Clock','Date and Time'})

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update userdata and menus
	%--
	
	switch (str)
		
	case ('Seconds')
		
		data.browser.grid.time.labels = 'seconds'; 
		tmp = data.browser.view_menu.time_labels;
		set(tmp,'check','off');
		set(get_menu(tmp,'Seconds'),'check','on');
		
	case ('Clock')
		
		data.browser.grid.time.labels = 'clock';
		data.browser.grid.time.realtime = 0;
		tmp = data.browser.view_menu.time_labels;
		set(tmp,'check','off');
		set(get_menu(tmp,'Clock'),'check','on');
		
	case ('Date and Time')
		
		data.browser.grid.time.labels = 'clock';
		data.browser.grid.time.realtime = 1;
		tmp = data.browser.view_menu.time_labels;
		set(tmp,'check','off');
		set(get_menu(tmp,'Date and Time'),'check','on');
		
	end 

	set(h,'userdata',data);
	
	%--
	% update display
	%--
		
	log_browser_display;
	
%--
% Frequency Grid
%--

case ('Frequency Grid')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata'); 
	
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
		set(get_menu(data.browser.view_menu.grid_options,str),'check','on');
	else
		if (gopt.on)
			set(ax,'ygrid','off');
		end
		set(get_menu(data.browser.view_menu.grid_options,str),'check','off');
	end
	
	set(h,'userdata',data);
	
%--
% Frequency Spacing
%--

case ({'25 Hz/Tick','100 Hz/Tick','250 Hz/Tick','500 Hz/Tick', ...
		' 1 kHz/Tick',' 2 kHz/Tick',' 5 kHz/Tick','10 kHz/Tick'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
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
	
%--
% Other Frequency Spacing ...
%--

case ('Other Frequency Spacing ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get spacing using input dialog
	%--
	
	ans = input_dialog( ...
		'Frequency Spacing', ...
		'Other Frequency Spacing ...', ...
		[1,32], ...
		{num2str(data.browser.grid.freq.spacing)}, ...
		{'Spacing of frequency grid, in Hz'} ...
	);

	%--
	% get spacing from string and update time grid spacing
	%--
	
	if (~isempty(ans))
		t = str2num(ans{1});
		data.browser.grid.freq.spacing = t;
	else
		return;
	end
	
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
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Frequency Labels 
%--

case ({'Hz','kHz'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update frequency labels variable and menus
	%--
	
	data.browser.grid.freq.labels = str;
	set(h,'userdata',data);
	
	set(data.browser.view_menu.freq_labels,'check','off');
	set(get_menu(data.browser.view_menu.freq_labels,str),'check','on');
	
	%--
	% update display
	%--
	
	log_browser_display;
	
%--
% Edit All ...
%--

case ('Edit All ...')
	
	%--
	% get label of parent of callback object
	%--
		
	tmp = get(get(gcbo,'parent'),'label');
	
	switch (tmp)
		
	case ('Navigate Options')
		log_view_menu(h,'Navigate Options ...');
		
	case ('Spectrogram Options')
		log_view_menu(h,'Spectrogram Options ...');
		
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
% Half Size, Actual Size, Double Size
%--

case ({'Half Size','Actual Size','Double Size'})
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	im = data.browser.images;
	
	%--
	% get desired scaling
	%--
	
	str = strtok(str,' ');
	
	%--
	% compute according to desired scaling
	%--
	
	[m,n,d] = size(get(im(1),'cdata'));
	
	switch (str)
		
	case ('Half')
		for k = 1:4
			truesize(h,[m/2,n/2]);
		end
		
	case ('Actual')
		for k = 1:4
			truesize(h,[m,n]);
		end
		
	case ('Double')
		for k = 1:4
			truesize(h,[2*m,2*n]);
		end
			
	end

	%--
	% refresh figure and apply resize function
	%--
	
	refresh(gcf);
	
	log_resizefcn;
	
%--
% Refresh
%--

case ('Refresh')
	
	refresh(h);
	
%--
% Renderer Options
%--

case ({'Automatic','Painters','ZBuffer','OpenGL'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update renderer and renderer mode state
	%--
	
	switch (str)
		
	case ('Automatic')
		str = 'Auto';
		data.browser.renderer = str; 
		set(h,'RendererMode','auto');
		
	otherwise
		data.browser.renderer = str; 
		set(h,'RendererMode','manual');
		set(h,'Renderer',str);
	
	end
	
	refresh(h);
	
	%--
	% update userdata and menu
	%--
	
	set(h,'userdata',data);
	
	tmp = data.browser.view_menu.renderer;
	
	set(tmp,'check','off')
	set(get_menu(tmp,str),'check','on');
	
%--
% Miscellaneous Commands
%--

otherwise
		
	%--
	% unrecognized command
	%--
		
	disp(' ');
	warning(['Unrecognized ''log_view_menu'' option ''' str '''.']);
		
end
