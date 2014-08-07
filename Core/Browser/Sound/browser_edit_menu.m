function out = browser_edit_menu(h, str, flag)

% browser_edit_menu - browser edit function menu
% ----------------------------------------------
%
% out = browser_edit_menu(h, str, flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - info flag (def: 0)
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

%--
% set info output flag
%--

if (nargin < 3) || isempty(flag)
	flag = 0;
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

if iscell(str)
	
	for k = 1:length(str)
		try
			browser_edit_menu(h, str{k}); 
		catch
			warning(['Unable to execute command ''', str{k}, '''.']);
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
% get open log names
%--

if ~flag
	
	data = get_browser(h);
	
	if length(data.browser.log)
		LOGS = file_ext(struct_field(data.browser.log, 'file'));
	else
		LOGS = {};
	end

else
	
	LOGS = {}; % what exactly does this mean as a case variable ???
	
end

%--
% set default output
%--

out = [];

%----------------------------------------------------------------
% COMMAND SWITCH
%----------------------------------------------------------------

switch str

%-----------------------------------------------
% Initialize
%-----------------------------------------------

case 'Initialize'
	
	%--
	% File
	%--
	
	L = { ...
		'Edit', ...
		'Undo Edit', ...	
		'Redo Edit', ...
		'Log Selection To', ...
		'Cut Selection', ...
		'Copy Selection', ...
		'Paste Selection', ...
		'Delete Selection' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{5} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	A{2} = 'Z';
	A{3} = 'Y';
	A{5} = 'X';
	A{6} = 'C';
	A{7} = 'V';
	
	tmp = menu_group(h,'browser_edit_menu',L,S,A);
	data.browser.edit_menu.edit = tmp;
	
	set(tmp(2:end),'enable','off');
	
	set(tmp(1),'position',2);
	
	%--
	% add dummy to 'Log Selection To'
	%--
	
	L = {'(No Open Logs)'};
		
	tmp = menu_group(get_menu(tmp,'Log Selection To'),'',L);
	data.browser.edit_menu.log_to = tmp;
	
	set(tmp,'enable','off');
	
	%--
	% save userdata
	%--
	
	set(gcf,'userdata',data);
	
	%--
	% update renderer mode and menus
	%--
	
	if ( ...
		(data.browser.selection.patch > 0) & ...
		(~strcmp(data.browser.renderer,'OpenGL') | ~strcmp(get(h,'RendererMode'),'manual')) ...
	)
		
		data.browser.renderer = 'OpenGL';
		
		tmp = data.browser.view_menu.renderer;
		set(tmp,'check','off');
		set(get_menu(tmp,'OpenGL'),'check','on');
		
		set(h,'RendererMode','manual');
		set(h,'Renderer','OpenGL');
		
	end
	
%-----------------------------------------------
% Undo Edit
%-----------------------------------------------

case ('Undo Edit')
	
%-----------------------------------------------
% Redo Edit
%-----------------------------------------------

case ('Redo Edit')
	
	
%-----------------------------------------------
% Cut Selection
%-----------------------------------------------

case ('Cut Selection')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Edit'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% delete selection display
	%--
	
	if (all(ishandle(data.browser.selection.handle)))
		delete(data.browser.selection.handle);
	end
	
	refresh(h);
	
	%--
	% put cut selection event in selection copy
	%--
	
	data.browser.selection.copy = data.browser.selection.event;
	
	data.browser.selection.copy.id = [];
	data.browser.selection.copy.annotation = annotation_create;
	data.browser.selection.copy.measurement = measurement_create;
	
	%--
	% set empty selection
	%--
	
	data.browser.selection.event = event_create;
	data.browser.selection.handle = [];
	
	%--
	% disable and enable selection options in edit menu
	%--

	tmp = data.browser.edit_menu.edit;
	
	set(get_menu(tmp,'Cut Selection'),'enable','off');
	set(get_menu(tmp,'Copy Selection'),'enable','off'); 
	set(get_menu(tmp,'Delete Selection'),'enable','off'); 
	set(get_menu(tmp,'Log Selection To'),'enable','off');
	set(get_menu(tmp,'Paste Selection'),'enable','on');
	
	tmp = data.browser.sound_menu.play;
	
	set(get_menu(tmp,'Selection'),'enable','off');
	
	%--
	% update palette
	%--
	
% 	hp = get_palette(h,'Sound',data);
% 	
% 	if (~isempty(hp))
% 		set(get_button(hp,'Play Selection'),'enable','off');
% 	end
	
	control_update(h,'Sound','Selection','__DISABLE__',data);
	
	control_update(h,'Navigate','Previous Event','__DISABLE__',data);
	control_update(h,'Navigate','Next Event','__DISABLE__',data);
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%-----------------------------------------------
% Copy Selection
%-----------------------------------------------

case ('Copy Selection')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Edit'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% put copied selection event in selection copy
	%--
	
	data.browser.selection.copy = data.browser.selection.event;
	
	data.browser.selection.copy.id = [];
	
	data.browser.selection.copy.annotation = annotation_create;
	
	data.browser.selection.copy.measurement = measurement_create;
	
	%--
	% enable paste selection options in edit menu
	%--

	tmp = data.browser.edit_menu.edit;
	
	set(get_menu(tmp,'Paste Selection'),'enable','on');
	
	%--
	% update userdata
	%--
	
	set(h, 'userdata', data);
	
	%---------------------------------------------
	% INTERCEPT SELECTION COPY EVENT HANDLER
	%---------------------------------------------
	
	% TODO: abstract this code to implement a labelled observer
	%
	% the only requirement for such an observer is the implementation of an
	% update event (a callback in this case)
	
	% NOTE: this will develop into a selection event
	
	% NOTE: this code expects the extension palette named after the extension
	
	%--
	% check for palettes
	%--
	
	pal = get_xbat_figs('parent', h, 'type', 'palette');
	
	if isempty(pal)
		return;
	end
	
	%--
	% get extensions
	%--
	
	% NOTE: get other extensions eventually
	
	ext = get_extensions('sound_detector');

	if isempty(ext)
		return;
	end
	
	%--
	% look at the extension palette controls
	%--
	
	ext_name = struct_field(ext, 'name');
	
	pal_name = get(pal, 'name');
	
	for k = 1:length(ext_name)
		
		%--
		% check that palette is an extension palette
		%--
		
		ix = find(strcmp(ext_name{k}, pal_name));
		
		if ix
			
			%--
			% check whether palette has an intercept control
			%--
			
			% NOTE: code similar to this can intercept all selection behavior
			
			g = pal(ix);
			
			test = find(strcmp( ...
				get_control_values(g, 'names'), 'INTERCEPT_SELECTION_COPY' ...
			));
			
			%--
			% execute intercept callback
			%--
			
			if test
				control_callback([], g, 'INTERCEPT_SELECTION_COPY');
			end
			
		end
		
	end
	
%-----------------------------------------------
% Paste Selection
%-----------------------------------------------

case 'Paste Selection'
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Edit'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% get current axes, channel, and time
	%--
	
	ax = gca;
		
	ch = str2num(get(gca,'tag'));
	
	time = get(ax,'currentpoint');
	time = time(1,1);
	
	%--
	% create event to display
	%--
	
	event = data.browser.selection.copy;

	event.channel = ch;
	
	tmp = (event.duration / 2);
	event.time = [(time - tmp),(time + tmp)];
	
	%--
	% display event
	%--
	
	h = browser_bdfun(event);
	
%-----------------------------------------------
% Log Selection To
%-----------------------------------------------

case ('Log Selection To')
	
	% this is no longer a command !!!
	
	%-------
	% INFO
	%-------
	
	if flag
		return;
	end
	
	%--
	% log selection
	%--

	selection_log(h, data.browser.log_active, data);


%-----------------------------------------------
% Log Selection To (Log Names)
%-----------------------------------------------

case (LOGS)
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Edit'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% log selection
	%--
	
	% TODO: get browser index from name
	
	names = file_ext({data.browser.log.file});
	
	m = find(strcmp(str, names));
	
	selection_log(h, m, data);
	
%-----------------------------------------------
% Delete Selection
%-----------------------------------------------

% NOTE: consider reusing this command to get stop player

case 'Delete Selection'

	%-------
	% INFO
	%-------
	
	if flag
		
		info.name = str;
		info.category = 'Edit'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	% NOTE: delete selection does not update state when one is provided
	
	data = delete_selection(h, data);
	
	set(h, 'userdata', data);
	
%-----------------------------------------------
% Center Selection
%-----------------------------------------------

case 'Center Selection'
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Edit'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% reset display time if possible
	%--
	
	event = data.browser.selection.event;
	
	t = sum(event.time) / 2;
	
	if ( ...
		((t + (data.browser.page.duration / 2)) > data.browser.sound.duration) | ...
		((t - (data.browser.page.duration / 2)) < 0) | ...
		(abs(data.browser.time - t) < 10^-2) ...
	)
		
		return;
		
	else
		
		%--
		% update time
		%--
		
		data.browser.time = t - (data.browser.page.duration / 2);
	
		%--
		% enable and disable navigation menus
		%--
		
		browser_navigation_update(h,data);
		
		%--
		% update view state array
		%--
		
		data.browser.view = browser_view_update(h,data);
		
		set(h,'userdata',data);
		
		%--
		% update display
		%--
		
		browser_display(h,'update',data);
		
	end
	
	%--
	% update display of selection
	%--
	
	browser_bdfun(data.browser.selection.event);
	
end
