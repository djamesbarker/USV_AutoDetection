function browser_log_menu(h,str,flag)

% browser_log_menu - browser log functions menu
% ---------------------------------------------
%
% browser_log_menu(h,str,flag)
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
% $Revision: 1672 $
% $Date: 2005-08-25 10:08:49 -0400 (Thu, 25 Aug 2005) $
%--------------------------------

% TODO: remove duplicate code to update log properties here and in 'browser_controls'

%--
% enable some performace display
%--

PROFILE = get_env('xbat_profile');

if isempty(PROFILE)
	set_env('xbat_profile',0);
	PROFILE = 0;
end

if PROFILE
	tic;
end

%--
% enable flag option
%--

if nargin == 3	
	if get_menu(h,'Log')
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
			browser_log_menu(h,str{k}); 
		catch
			disp(' '); 
			warning(['Unable to execute command ''' str{k} '''.']);
		end
	end
	return;
end

%--
% set handle and get userdata
%--

if (nargin < 1)
	h = gcf;
end

data = get(h,'userdata');

%--
% set parameter value arrays
%--

COLOR = color_to_rgb;

LINESTYLE = linestyle_to_str;

%--
% get open log names
%--

if length(data.browser.log)
	LOGS = file_ext(struct_field(data.browser.log,'file'));
else
	LOGS = {};
end

%--------------------------------------------------------------
% COMMAND SWITCH
%--------------------------------------------------------------

switch (str)

%-----------------------------------------------
% Initialize
%-----------------------------------------------

case ('Initialize')
	
	%--
	% check for existing menu
	%--
	
	if (get_menu(h,'Log'))
		return;
	end
	
	%--
	% Log
	%--
	
	L = { ...
		'Log', ...
		'Active', ...
		'Display', ...
		'Browse', ...
		'Workspace', ...
		'Export', ...
		'Strip' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{5} = 'on';
	
	mg = menu_group(h,'browser_log_menu',L,S);
	
	data.browser.log_menu.log = mg;
	
	% set position of log menu
	
	set(mg(1),'position',8);
	
	%--
	% Active, Display and Browse and Copy to Workspace
	%--
	
	if (~isempty(LOGS))
		
		L = LOGS;
		
		% active
		
		tmp = menu_group(mg(2),'browser_log_menu',L);
		data.browser.log_menu.active = tmp;
		
		set(mg(data.browser.log_active),'check','on');
		
		% display
		
		tmp = menu_group(mg(3),'browser_log_menu',L);
		data.browser.log_menu.display = tmp;
		
% 		set(mg(data.browser.log_active),'check','on');

		% browse
		
		tmp = menu_group(mg(4),'browser_log_menu',L);
		data.browser.log_menu.browse = tmp;
		
		% copy to workspace
		
		tmp = menu_group(mg(5),'browser_log_menu',L);
		data.browser.log_menu.copy_to_workspace = tmp;
		
		% export
		
		tmp = menu_group(mg(6),'browser_log_menu',L);
		data.browser.log_menu.export = tmp;
		
		% strip
		
		tmp = menu_group(mg(7),'browser_log_menu',L);
		data.browser.log_menu.strip = tmp;
		
	else
		
		L = {'(No Open Logs)'};
		
		% active 
		
		tmp = menu_group(mg(2),'',L);
		data.browser.log_menu.active = tmp;
		
		set(tmp,'enable','off');
		
		% display
		
		tmp = menu_group(mg(3),'',L);
		data.browser.log_menu.display = tmp;
		
		set(tmp,'enable','off');
		
		% browse
		
		tmp = menu_group(mg(4),'',L);
		data.browser.log_menu.browse = tmp;
		
		set(tmp,'enable','off');
		
% 		set(mg(2:5),'enable','off');

		% workspace
		
		tmp = menu_group(mg(5),'',L);
		data.browser.log_menu.copy_to_workspace = tmp;
		
		set(tmp,'enable','off');

		% export
		
		tmp = menu_group(mg(6),'',L);
		data.browser.log_menu.export = tmp;
		
		set(tmp,'enable','off');
		
		% strip
		
		tmp = menu_group(mg(7),'',L);
		data.browser.log_menu.strip = tmp;
		
		set(tmp,'enable','off');
		
	end
	
	%--
	% save userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% open 'Measure' menu and update window menus
	%--
	
	browser_window_menu;
	
%-----------------------------------------------
% Active, Display, Browse, and Copy to Workspace
%-----------------------------------------------

case (LOGS)
	
	%--
	% get log index
	%--
	
	m = find(strcmp(LOGS,str));
	
	%--
	% set mode depending on parent
	%--
	
	mode = get(get(gcbo,'parent'),'label');

	switch (mode)
	
		%--
		% update active log
		%--
		
		case ('Active')
			
			%--
			% update active log
			%--
			
			data.browser.log_active = m;
			set(h,'userdata',data);
			
			%--
			% update active and log selection to menu
			%--
			
			tmp = data.browser.log_menu.active;
			
			set(tmp,'check','off'); 
			set(get_menu(tmp,str),'check','on');
			
			tmp = data.browser.edit_menu.log_to;
			
			set(tmp,'check','off'); 
			set(get_menu(tmp,str),'check','on');
			
			%--
			% update control
			%--
			
			control_update(h,'Log','Active',str,data);
			
		%--
		% update visibility of log
		%--
		
		case ('Display')
			
			%--
			% update visibility of log
			%--
				
			state = double(~data.browser.log(m).visible);
			data.browser.log(m).visible = state;
			
			set(h,'userdata',data);
				
			%--
			% update menu
			%--
			
			if (data.browser.log(m).visible)
				set(gcbo,'check','on');
			else
				set(gcbo,'check','off');
			end
			
			%--
			% update display
			%--
			
			browser_display(h,'events',data);
			
			%--
			% update control
			%--
			
			tmp = struct_field(data.browser.log,'file','visible');
			
			file = file_ext(tmp.file);
			ix = find(tmp.visible);
						
			control_update(h,'Log','Display',file(ix),data);
			
		%--
		% open log in log browser
		%--
		
		case 'Browse'
			
			%--
			% get log browser display extent
			%--
			
% 			[ix,dil,row,col] = log_extent_dialog(data.browser.log(m));
			
			%--
			% open log browser
			%--
			
			file = file_ext(data.browser.log(m).file);
			
			log_browser(h,file);
			
		%--
		% copy log variable to workspace
		%--
		
		case ('Workspace')
			
			%--
			% create variable name
			%--
			
			name = ['Log_' file_ext(data.browser.log(m).file)];
			
			%--
			% create variable in workspace
			%--
			
			try
					
				msg = [' XBAT log variable ''' name ''' created in workspace. '];
				sep = char(45 * ones(1,length(msg)));
				
				disp(' ');
				disp(sep);
				disp(msg);
				disp(sep);
				disp(' ');
				
				assignin('base',name,data.browser.log(m));
				clear ans
				
			catch
				
				msg = [' Failed to copy XBAT log variable ''' name '''. '];
				sep = char(45 * ones(1,length(msg)));
				
				disp(' ');
				disp(sep);
				disp([' Failed to copy XBAT log variable ''' name '''. ']);
				disp(sep);
				disp(' ');
				
			end
			
		%--
		% export log data to file
		%--
		
		case ('Export')
		
			%--
			% export log data
			%--
			
			uiwait(warn_dialog(['Command ''' mode ''' not implemented yet.'],'','modal'));
			
% 			export_log(data.browser.log(m))
		
		%--
		% strip metadata from log file
		%--
		
		case ('Strip');
			
			%--
			% strip log and update userdata and log file if needed
			%--
			
			data.browser.log(m) = log_strip(data.browser.log(m));
			
			set(h,'userdata',data);
			
			if (data.browser.log(m).autosave)
				log_save(data.browser.log(m));
			end
			
			%--
			% udpate display of logs
			%--
			
			browser_display(h,'events',data);

	end
	
%-----------------------------------------------
% No Display
%-----------------------------------------------

case ('No Display')
	
	%--
	% make all logs invisible
	%--
		
	for k = 1:length(data.browser.log)
		data.browser.log(k).visible = 0;
	end
	
	set(h,'userdata',data);
		
	%--
	% update menu
	%--
	
	set(data.browser.log_menu.display,'check','off');
		
	%--
	% update log palette
	%--
	
	% note that control update is not effective in setting the value of the
	% control to empty. in this case it is not hard to do this directly
	
	g = control_update(h,'Log','Display',[],data);
	
	g = findobj(g,'flat','style','listbox');
	
	set(g,'value',[]);
	
	%--
	% update display
	%--
	
	browser_display(h,'events',data);
	
%-----------------------------------------------
% Display All
%-----------------------------------------------

case ('Display All')
	
	%--
	% make all logs visible
	%--
		
	for k = 1:length(data.browser.log)
		data.browser.log(k).visible = 1;
	end
	
	set(h,'userdata',data);
		
	%--
	% update menu
	%--
	
	set(data.browser.log_menu.display(2:end - 1),'check','on');
		
	%--
	% update log palette
	%--
	
	tmp = 1:length(data.browser.log);
	
	control_update(h,'Log','Display',tmp,data);
	
	%--
	% update display
	%--
	
	browser_display(h,'events',data);
	
%-----------------------------------------------
% Browse Log ...
%-----------------------------------------------

case 'Browse Log ...'
	
	%--
	% get log name and index
	%--
	
	file = file_ext(get(gcbo,'tag'));
	
	m = find(strcmp(file_ext(struct_field(data.browser.log,'file')),file));
	
	%--
	% get log display extent and open log browser
	%--
	
% 	[ix,dil,row,col] = log_extent_dialog(data.browser.log(m));
	
	log_browser(h,file);
	
%-----------------------------------------------
% Copy to Workspace
%-----------------------------------------------

case ('Copy to Workspace')
	
	%--
	% get log name and index
	%--
	
	file = file_ext(get(gcbo,'tag'));
	
	m = find(strcmp(file_ext(struct_field(data.browser.log,'file')),file));
	
	%--
	% create variable name
	%--
	
	name = ['Log_' file];
	
	%--
	% create variable in workspace
	%--
	
	try
			
		msg = [' XBAT log variable ''' name ''' created in workspace. '];
		sep = char(45 * ones(1,length(msg)));
		
		disp(' ');
		disp(sep);
		disp(msg);
		disp(sep);
		disp(' ');
		
		assignin('base',name,data.browser.log(m));
		clear ans
		
	catch
		
		msg = [' Failed to copy XBAT log variable ''' name '''. '];
		sep = char(45 * ones(1,length(msg)));
		
		disp(' ');
		disp(sep);
		disp([' Failed to copy XBAT log variable ''' name '''. ']);
		disp(sep);
		disp(' ');
		
	end

%-----------------------------------------------
% Color
%-----------------------------------------------

case (COLOR)
	
	%--
	% get index of log to update
	%--

	file = get(gcbo,'tag');
	m = find(strcmp(LOGS,file));
	
	%--
	% get log color from string
	%--
	
	rgb = color_to_rgb(str);
	
	%--
	% update menu and display
	%--
	
	set(get(get(gcbo,'parent'),'children'),'check','off');
	set(gcbo,'check','on');

	%--
	% get log display objects using tag and other properties
	%--
	
	color = data.browser.log(m).color;
	
	% consider opengl correction in selecting
	
	width = data.browser.log(m).linewidth;
	if (strcmp(get(gcbf,'Renderer'),'OpenGL'))
		if (width == 2)
			width = 1.5;
		end
	end
	
	style = data.browser.log(m).linestyle;
	
	% lines
	
	tmp = findobj(h, ...
		'type','line', ...
		'color',color, ...
		'linewidth',width, ...
		'linestyle',style ...
	);
	
	tag = get(tmp,'tag');
	ix = strncmp(tag,[num2str(m) '.'],2);
	
	set(tmp(ix),'color',rgb);
	
	% text
	
	tmp = findobj(h, ...
		'type','text', ...
		'color',color ...
	);
	
	tag = get(tmp,'tag');
	ix = strncmp(tag,[num2str(m) '.'],2);
	
	set(tmp(ix),'color',rgb);
	
	refresh;
	
	% patches if needed
	
	if (data.browser.log(m).patch > 0)
		
		tmp = findobj(h, ...
			'type','patch', ...
			'facecolor',color ...
		);
		
		tag = get(tmp,'tag');
		ix = strncmp(tag,[num2str(m) '.'],2);
		
		set(tmp(ix),'facecolor',rgb);
		
	end
	
	%--
	% update log in browser
	%--

	data.browser.log(m).color = rgb;
	
	set(h,'userdata',data);
	
% 	%--
% 	% update log in file
% 	%--
% 	
% 	tmp = get(get_menu(data.browser.log_menu.log,[file ' Options']),'children');
% 	tmp = get_menu(tmp,'Save Log');
% 	
% 	if (data.browser.log(m).autosave)
% 		log_save(data.browser.log(m));
% 		set(tmp,'enable','off');	
% 	else
% 		set(tmp,'enable','on');
% 	end

	%--
	% update control if needed
	%--
	
	[tmp,tmp_value] = control_update(h,'Log','Log',[],data);
		
	if (~isempty(tmp) & strcmp(tmp_value,file))
		control_update(h,'Log','Color',str,data);
	end
	
%-----------------------------------------------
% Line Style
%-----------------------------------------------

case (LINESTYLE)
	
	%--
	% get index of log to update
	%--
	
	file = get(gcbo,'tag');
	m = find(strcmp(LOGS,file));
	
	%--
	% get linestyle from string
	%--
	
	new_style = linestyle_to_str(str);
	
	%--
	% update menu
	%--
	
	set(get(get(gcbo,'parent'),'children'),'check','off');
	set(gcbo,'check','on');

	%--
	% get log display objects using tag and other properties
	%--
	
	color = data.browser.log(m).color;
	
	% consider opengl correction in selecting
	
	width = data.browser.log(m).linewidth;
	
	if (strcmp(get(gcbf,'Renderer'),'OpenGL'))
		if (width == 2)
			width = 1.5;
		end
	end
	
	style = data.browser.log(m).linestyle;
	
	% lines
	
	tmp = findobj(h, ...
		'type','line', ...
		'color',color, ...
		'linewidth',width, ...
		'linestyle',style ...
	);
	
	tag = get(tmp,'tag');
	ix = strncmp(tag,[num2str(m) '.'],2);
	
	set(tmp(ix),'linestyle',new_style);
	
	refresh;
	
	%--
	% update log in browser
	%--
	
	data.browser.log(m).linestyle = new_style;
	set(gcf,'userdata',data);
	
% 	%--
% 	% update log in file
% 	%--
% 	
% 	tmp = get(get_menu(data.browser.log_menu.log,[file ' Options']),'children');
% 	tmp = get_menu(tmp,'Save Log');
% 	
% 	if (data.browser.log(m).autosave)
% 		log_save(data.browser.log(m));
% 		set(tmp,'enable','off');	
% 	else
% 		set(tmp,'enable','on');
% 	end
	
	%--
	% update control if needed
	%--
	
	[tmp,tmp_value] = control_update(h,'Log','Log',[],data);
		
	if (~isempty(tmp) & strcmp(tmp_value,file))
		control_update(h,'Log','Line Style',str,data);
	end
	
%-----------------------------------------------
% Line Width
%-----------------------------------------------

case ({'1 pt','2 pt','3 pt','4 pt'})
		
	%--
	% get index of log to update
	%--
	
	file = get(gcbo,'tag');
	m = find(strcmp(LOGS,file));
	
	%--
	% get linewidth from string
	%--
	
	new_width = str2num(strtok(str,' '));
	
	% opengl correction in display
	
	if (strcmp(get(gcbf,'Renderer'),'OpenGL'))
		if (new_width == 2)
			new_width = 1.5;
		end
	end
	
	%--
	% update menu 
	%--
	
	set(get(get(gcbo,'parent'),'children'),'check','off');
	set(gcbo,'check','on');
	
	%--
	% get log display objects using tag and other properties
	%--
	
	color = data.browser.log(m).color;
	
	% consider opengl correction in selecting
	
	width = data.browser.log(m).linewidth;
	if (strcmp(get(gcbf,'Renderer'),'OpenGL'))
		if (width == 2)
			width = 1.5;
		end
	end
	
	style = data.browser.log(m).linestyle;
	
	% lines
	
	tmp = findobj(h, ...
		'type','line', ...
		'color',color, ...
		'linewidth',width, ...
		'linestyle',style ...
	);
	
	tag = get(tmp,'tag');
	ix = strncmp(tag,[num2str(m) '.'],2);
	
	set(tmp(ix),'linewidth',new_width);
	
	refresh;
	
	%--
	% update log in browser
	%--
	
	data.browser.log(m).linewidth = new_width;
	set(h,'userdata',data);
	
% 	%--
% 	% update log in file
% 	%--
% 	
% 	tmp = get(get_menu(data.browser.log_menu.log,[file ' Options']),'children');
% 	tmp = get_menu(tmp,'Save Log');
% 	
% 	if (data.browser.log(m).autosave)
% 		log_save(data.browser.log(m));
% 		set(tmp,'enable','off');	
% 	else
% 		set(tmp,'enable','on');
% 	end
	
	%--
	% update control if needed
	%--
	
	[tmp,tmp_value] = control_update(h,'Log','Log',[],data);
		
	if (~isempty(tmp) & strcmp(tmp_value,file))
		control_update(h,'Log','Line Width',new_width,data);
	end
	
%-----------------------------------------------
% Opacity
%-----------------------------------------------

case ({'Transparent','1/8 Alpha','1/4 Alpha','1/2 Alpha','3/4 Alpha','Opaque'})
	
	%--
	% get index of log to update
	%--
	
	file = get(gcbo,'tag');
	m = find(strcmp(LOGS,file));
	
	%--
	% get patch value from string
	%--
	
	switch (str)
		
	case ('Transparent')
		tmp = 0;
		
	case ('Opaque')
		tmp = 1;
		
	otherwise
		tmp = eval(strtok(str,' '));
		
	end

	%--
	% update menu
	%--
	
	set(get(get(gcbo,'parent'),'children'),'check','off');
	set(gcbo,'check','on');
	
	%--
	% update log in browser
	%--
	
	data.browser.log(m).patch = tmp;
	set(gcf,'userdata',data);
	
	%--
	% update renderer and display
	%--
	
	update_renderer(h,'OpenGL',data);
	
	browser_display(h,'events',data);

% 	%--
% 	% update log in file
% 	%--
% 	
% 	tmp = get(get_menu(data.browser.log_menu.log,[file ' Options']),'children');
% 	tmp = get_menu(tmp,'Save Log');
% 	
% 	if (data.browser.log(m).autosave)
% 		log_save(data.browser.log(m));
% 		set(tmp,'enable','off');	
% 	else
% 		set(tmp,'enable','on');
% 	end
	
%-----------------------------------------------
% Auto Save Log
%-----------------------------------------------

case ('Auto Save Log')
	
	%--
	% get index of log to update
	%--
	
	file = get(gcbo,'tag');
	m = find(strcmp(LOGS,file));
	
	%--
	% update autosave state
	%--
	
	state = ~data.browser.log(m).autosave;
	data.browser.log(m).autosave = state;
	
	set(h,'userdata',data);
	
	%--
	% update menus and save log if needed
	%--
	
	if (state)
		set(gcbo,'check','on');
	else
		set(gcbo,'check','off');
	end
	
	%--
	% update log in file
	%--
	
	tmp = get(get_menu(data.browser.log_menu.log,[file ' Options']),'children');
	tmp = get_menu(tmp,'Save Log');
	
	if (data.browser.log(m).autosave)
		log_save(data.browser.log(m));
		set(tmp,'enable','off');	
	else
		set(tmp,'enable','on');
	end
	
%-----------------------------------------------
% Save Log
%-----------------------------------------------

case ('Save Log')
	
	%--
	% get index of log to save
	%--
	
	file = get(gcbo,'tag');
	m = find(strcmp(LOGS,file));
	
	%--
	% update log in file
	%--
	
	tmp = get(get_menu(data.browser.log_menu.log,[file ' Options']),'children');
	tmp = get_menu(tmp,'Save Log');

	log_save(data.browser.log(m));
	set(tmp,'enable','off');	
	
%-----------------------------------------------
% Backup Log
%-----------------------------------------------

case ('Backup Log')
	
	%--
	% get index of log to backup
	%--
	
	file = get(gcbo,'tag');
	m = find(strcmp(LOGS,file));
	
	%--
	% backup log by appending name and saving
	%--
	
	% create date string and append to log filename
	
	str = datestr(now);
	str = str(1:end - 3);
	str = strrep(str,':','');
	str = strrep(str,' ','_');
	str = strrep(str,'-','_');
	
	file = file_ext(data.browser.log(m).file);
	
	data.browser.log(m).file = [file '_BKP_' str '.mat'];
	
	[file '_BKP-' str '.mat']
	
	% update open state of log and set read only flag
	
	data.browser.log(m).open = 0;
	data.browser.log(m).readonly = 1;
	
	%--
	% save backup log
	%--
	
	log_save(data.browser.log(m));

%-----------------------------------------------
% Close
%-----------------------------------------------

case ('Close')

	%--
	% get log file to close
	%--
	
	file = get(gcbo,'tag');
	
	%--
	% close log file
	%--
	
	flag = log_close(h,file);
	
%--
% Log display toggle and View Options
%--

otherwise
	
	
end
	
%--
% display performance information
%--

if (PROFILE)
	
	t = toc;
	tmp = strrep(get(h,'name'),'  ',' ');
	tmp = tmp(2:end);
	sep = char(45*ones(1,length(tmp)));
	
	disp(tmp);
	disp(sep);
	disp([mfilename ' : ' str ' (time = ' num2str(t) ')']);
	disp(' ');
	disp(' ');
	
end

	
