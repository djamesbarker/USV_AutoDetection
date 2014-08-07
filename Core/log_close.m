function flag = log_close(h,file)

% log_close - close open log in browser
% -------------------------------------
%
% flag = log(h,file)
% 
% Input:
% ------
%  h - handle to browser figure
%  file - filename of log to close

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
% $Revision: 1138 $
% $Date: 2005-06-24 10:29:35 -0400 (Fri, 24 Jun 2005) $
%--------------------------------

%--
% get parent userdata
%--

data = get(h,'userdata');

%--
% get log to close
%--

if ((nargin < 2) | isempty(file))
	
	%--
	% close active log
	%--
	
	m = data.browser.log_active;
	
	file = data.browser.log(m).file;
	
else
	
	%--
	% close named log
	%--
	
	if (length(data.browser.log) > 1)
		LOGS = file_ext(struct_field(data.browser.log,'file'));
	else
		LOGS = {file_ext(data.browser.log.file)}; % make sure string is in cell arrays
	end
	
	m = find(strcmp(LOGS,file));
	
end

%--
% return if there is no log to close
%--

if (isempty(m))
	flag = 0;
	return;
end

%--
% update open state of log and save
%--

% NOTE: the sequence of save and backup of log should be made more robust

% NOTE: the failure rate seems to be something like 1/500.

data.browser.log(m).open = 0;

data.browser.log(m).sound = sound_update(data.browser.sound,data);

log_save(data.browser.log(m));

%--
% create backup of log
%--

log_backup(data.browser.log(m));

%--
% update browser logs and active log
%--

% NOTE: this updating of the active log is not based on alphabetic ordering

data.browser.log(m) = [];

if (m > 1)
	
	data.browser.log_active = m - 1; % set the previous log to be the current ??
	
elseif (length(data.browser.log))
	
	data.browser.log_active = 1; % there is one remaining open log
	
else
	
	data.browser.log_active = 0; % there are no open logs
	
end

%--
% delete log specific menus
%--

delete(findobj(data.browser.log_menu.log,'type','uimenu','tag',file));

%--
% update 'Active', 'Display', 'Browse', 'Copy to Workspace', and 'Log Selection To' menu
%--

% TODO: consider replacing the store of all these menu handles may be replaced by computation

% delete(get(get_menu(data.browser.log_menu,'Active'),'children');

delete(data.browser.log_menu.active);

delete(data.browser.log_menu.display);

delete(data.browser.log_menu.browse);

delete(data.browser.log_menu.copy_to_workspace);

delete(data.browser.log_menu.export);

delete(data.browser.log_menu.strip);

delete(data.browser.edit_menu.log_to);

% remove log name from list

LOGS(m) = [];

%--
% update menus when there are open logs
%--

if (~isempty(LOGS))
	
	%--
	% sort logs by name before updating the menus
	%--
	
	[LOGS,ix] = sort(LOGS);
	
	ms = find(m == ix);
	
	if (length(data.browser.log) == 1)
		v = data.browser.log.visible;
	else
		v = struct_field(data.browser.log,'visible');
		v = v(ix);
	end
	
	%--
	% active
	%--
		
	mg = menu_group(data.browser.log_menu.log(2),'browser_log_menu',LOGS);
	data.browser.log_menu.active = mg;
	
	set(mg(ms),'check','on');
	
	%--
	% display
	%--
	
	S = bin2str(zeros(length(LOGS) + 2,1));
	S{2} = 'on';
	S{end} = 'on';
	
	mg = menu_group(data.browser.log_menu.log(3),'browser_log_menu',{'No Display',LOGS{:},'Display All'},S);
	data.browser.log_menu.display = mg;
		
	for k = 1:length(data.browser.log)
		if (v(k))
			set(mg(k + 1),'check','on');
		else
			set(mg(k + 1),'check','off');
		end
	end
	
	%--
	% browse
	%--
	
	mg = menu_group(data.browser.log_menu.log(4),'browser_log_menu',LOGS);
	data.browser.log_menu.browse = mg;
		
	%--
	% workspace
	%--
	
	mg = menu_group(data.browser.log_menu.log(5),'browser_log_menu',LOGS);
	data.browser.log_menu.copy_to_workspace = mg;
	
	%--
	% export
	%--
	
	mg = menu_group(data.browser.log_menu.log(6),'browser_log_menu',LOGS);
	data.browser.log_menu.export = mg;
	
	%--
	% strip
	%--
	
	mg = menu_group(data.browser.log_menu.log(7),'browser_log_menu',LOGS);
	data.browser.log_menu.strip = mg;
	
		
	%--
	% log selection to
	%--
	
	mg = menu_group(get_menu(data.browser.edit_menu.edit,'Log Selection To'),'browser_edit_menu',LOGS);
	data.browser.edit_menu.log_to = mg;
	
	set(mg(ms),'check','on');
	
else
	
	%--
	% active
	%--
	
	mg = menu_group(data.browser.log_menu.log(2),'',{'(No Open Logs)'});
	data.browser.log_menu.active = mg;
	
	set(mg,'enable','off');
	
% 	set(data.browser.log_menu.log(2),'enable','off');
	
	%--
	% display
	%--
	
	mg = menu_group(data.browser.log_menu.log(3),'',{'(No Open Logs)'});
	data.browser.log_menu.display = mg;
	
	set(mg,'enable','off');
	
% 	set(data.browser.log_menu.log(3),'enable','off');

	%--
	% browse
	%--
	
	mg = menu_group(data.browser.log_menu.log(4),'',{'(No Open Logs)'});
	data.browser.log_menu.browse = mg;
	
	set(mg,'enable','off');
	
	%--
	% workspace
	%--
	
	mg = menu_group(data.browser.log_menu.log(5),'',{'(No Open Logs)'});
	data.browser.log_menu.copy_to_workspace = mg;
	
	set(mg,'enable','off');
	
	%--
	% export
	%--
	
	mg = menu_group(data.browser.log_menu.log(6),'',{'(No Open Logs)'});
	data.browser.log_menu.export = mg;
	
	set(mg,'enable','off');
	
	%--
	% browse
	%--
	
	mg = menu_group(data.browser.log_menu.log(7),'',{'(No Open Logs)'});
	data.browser.log_menu.strip = mg;
	
	set(mg,'enable','off');
	
	%--
	% log selection to
	%--
	
	mg = menu_group(get_menu(data.browser.edit_menu.edit,'Log Selection To'),'',{'(No Open Logs)'});
	data.browser.edit_menu.log_to = mg;
	
	% this requires some other code updates to make sure that logging
	% behavior is not affected, some part of the code may check the state
	% of the parent menu
	
	set(mg,'enable','off');
	
    try
        lm = get_menu(data.browser.edit_menu,'Log Selection To');
        if ~isempty(lm)
            set(lm,'enable','off');
        end
    catch err
        % Nothing to do here. Somewhere the menu is deleted before we
        % attempt to disable.
    end
    
	%--
	% annotate
	%--
	
	set(data.browser.annotate_menu.annotate(4:end),'enable','off');
	
	%--
	% measure
	%--
	
	set(data.browser.measure_menu.measure(3:end),'enable','off');
	
end
	
%--
% update userdata
%--

set(h,'userdata',data);

flag = 1;

%--
% update display
%--

if (isempty(LOGS))
	browser_display(h,'update',data);
else
	browser_display(h,'events',data);
end

update_extension_palettes(h,data);

%--
% update renderer
%--

update_renderer(h,[],data);

%--
% update log palette
%--

update_log_palette(h,data);

%--
% close children figures related to log and update window menus
%--

% this needs to be implemented

% 	browser_window_menu;
