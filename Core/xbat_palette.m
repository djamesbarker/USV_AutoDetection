function pal = xbat_palette(str)

% xbat_palette - main palette to provide access to files
% ------------------------------------------------------
%
% pal = xbat_palette
%
%     = xbat_palette(str)
%
% Input:
% ------
%  str - command string
%
% Output:
% -------
%  pal - palette handle
% 
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6852 $
% $Date: 2006-09-28 16:56:19 -0400 (Thu, 28 Sep 2006) $
%--------------------------------

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

%--------------------------------------------------------------
% CHECK FOR PALETTE
%--------------------------------------------------------------

pal = get_palette(0, 'XBAT');

%--
% position palette and possibly perform command
%--

if ~isempty(pal)

% 	if ~nargout
% 		position_palette(pal, 0, 'top right');
% 	end
	
	if nargin
		control_callback([], pal, str);
	end
		
	return;
	
end

if nargout
	return;
end

%--------------------------------------------------------------
% CREATE PALETTE
%--------------------------------------------------------------

%--
% get user
%--

user = get_active_user;

%--
% create palette controls
%--

control = xbat_palette_controls(user);

%--
% configure palette controls
%--

opt = control_group;

opt.width = 14;

opt.top = 0;

opt.bottom = 1.25;

opt.header_color = get_extension_color('root');

% NOTE: this is probably some hack

[positions, tile] = compile_positions(control, opt);

%--------------------------------------------------------------
% RENDER PALETTE
%--------------------------------------------------------------

%--
% create palette
%--

pal = control_group([], @xbat_controls_callback, 'XBAT', control, opt);

xbat_menu(pal);

user_menu(pal);

session_menu(pal, user);

text_menu(pal);

%--
% tag and position palette
%--

set(pal, 'tag', 'XBAT_PALETTE::XBAT');

position_palette(pal, 0, 'top right');


% NOTE: this would close the 'Logs' header on open

% headers = get_palette_headers(pal);
% 
% ix = find(strcmp({headers.label}, 'Logs'));
% 
% if ~isempty(ix)
% 	palette_toggle(pal, headers(ix).handles.toggle, 'close');
% end

%--------------------------------------------------------------
% ADD CONTEXT MENUS
%--------------------------------------------------------------

% NOTE: the context menus contain many important commands, document this

% ALSO: in particular these should lead to a variety of batch operation interfaces

%--------------------
% Sounds
%--------------------

%--
% main context menu
%--

g = findobj(pal,'tag','Sounds','style','listbox');

% NOTE: this two step process is cumbersome, create shortcut

temp = uicontextmenu('parent',pal); set(g,'uicontextmenu',temp);

L = { ...
	'Open', ...
	'Open in New Window', ...
	'Configure ...', ...
	'Actions', ...
	'Attributes', ...
	'Copy to Library', ...
	'Show Files ...', ...
	'Delete ...' ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{4} = 'on';
S{end - 1} = 'on';
S{end} = 'on';

temp = menu_group(temp, @xbat_controls_callback, L, S);

set(temp,'tag','Sounds');

%--
% add libraries to menu
%--

L = library_name_list(user);

tmp2 = menu_group( ...
	get_menu(temp,'Copy to Library'), ...
	@xbat_controls_callback, ...
	L ...
);

set(tmp2,'tag','Sounds');
	
%-------------------------
% Logs
%-------------------------

%--
% main
%--

g = findobj(pal,'tag','Logs','style','listbox');

tmp = uicontextmenu('parent',pal);

set(g,'uicontextmenu',tmp);

L = { ...
	'Open', ...
	'Open in New Window', ...
	'Actions', ...
	'Export Clips ...', ...
	'Show Files ...', ...
	'Delete ...' ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{3} = 'on';
S{end - 1} = 'on';
S{end} = 'on';

tmp = menu_group(tmp,@xbat_controls_callback,L,S);

set(tmp,'tag','Logs');

%--
% library
%--

% NOTE: should the copy to library function should be extended to logs?

% L = struct_field(user.library,'name');
% 
% tmp = menu_group(get_menu(tmp,'Copy to Library'),@xbat_controls_callback,L);
% 
% set(tmp,'tag','Sounds');

%--------------------
% Attach Actions
%--------------------

type = {'sound', 'log'};

for k = 1:length(type)

	%--
	% find parent action menu
	%--

	name = title_caps([type{k}, 's']);
		
	handles = get_control(pal, name, 'handles');

	par = findobj(get(handles.obj, 'uicontextmenu'), 'label', 'Actions');

	if isempty(par)
		continue;
	end

	%--
	% attach actions menu
	%--
	
	action_menu(par, type{k});
	
end

%--------------------------------------------------------------
% UPDATE PALETTE
%--------------------------------------------------------------

pal = xbat_palette('User');


%--------------------------------------------------------------
% XBAT PALETTE CALLBACK FUNCTION
%--------------------------------------------------------------

function xbat_controls_callback(obj, eventdata)

%--
% get context from object handle
%--

if strcmp(get(obj, 'type'), 'uimenu')
	
	%--
	% handle palette menus, typically contextual menus
	%--
	
	pal = xbat_palette; % palette figure handle
	
	tag = get(obj, 'tag'); % the callback is largely determined by the parent controls, its name is in the tag
	
	action = get(obj, 'label'); % this is the label on the menu item
	
else
	
	%--
	% handle other controls in palette
	%--
	
	pal = xbat_palette; % palette figure handle
	
	tag = get(obj, 'tag'); % this is the name of the control
	
	action = ''; % the action is typically provided by the control tag, no need for action
	
end

%--
% perform action
%--

switch tag
	
	%------------------------------------------------------------------
	% CHANGE USER
	%------------------------------------------------------------------
	
	case 'User', set_active_user(get_control(pal, 'User', 'value'));

	%------------------------------------------------------------------
	% ADD USER
	%------------------------------------------------------------------
	
	case 'add_user', set_active_user(new_user_dialog);

	%------------------------------------------------------------------
	% EDIT USER
	%------------------------------------------------------------------		
		
	case 'edit_user', set_active_user(new_user_dialog(get_active_user));
			
	%------------------------------------------------------------------
	% DELETE USER
	%------------------------------------------------------------------
	
	case 'Delete User', delete_user(get_active_user);
		
	%------------------------------------------------------------------
	% LOAD LIBRARY (SET ACTIVE LIBRARY)
	%------------------------------------------------------------------
	
	case 'Library'
		
% 		set_control(pal, 'edit_library', 'enable', 0);
		
		%--
		% get library from control
		%--
		
		name = get_control(pal, 'Library', 'value');
		
		lib = get_library_from_name(name);
		
		%--
		% Set Active Library
		%--
		
		set_active_library(lib);
		
		%--
		% Update Context Menus
		%--
		
		update_context_menus(pal);
	
	%------------------------------------------------------------------
	% NEW_LIBRARY
	%------------------------------------------------------------------
		
	case 'new_library', user_subscribe(new_library_dialog, get_active_user);
		
	case 'edit_library', edit_library_dialog;
				
	%------------------------------------------------------------------
	% SUBSCRIBE
	%------------------------------------------------------------------
		
	case 'subscribe_user', user_subscribe;
		
	%------------------------------------------------------------------
	% UNSUBSCRIBE
	%------------------------------------------------------------------
		
	case 'unsubscribe_user', user_unsubscribe(get_active_library, get_active_user);		
				
	%------------------------------------------------------------------
	% FIND SOUNDS
	%------------------------------------------------------------------
	
	case 'find_sounds'
		
		handles = get_control(pal, 'Sounds', 'handles');
		
		sound_names = sound_name(get_library_sounds);
		
		set(handles.uicontrol.listbox, 'string', sound_names);
		
		%--
		% filter available sounds
		%--
		
		listbox_search(pal, 'sound');
			
		%--
		% Update Log Search
		%--
		
		xbat_palette('find_logs');
		
		xbat_palette('Sounds');
		
		%--
		% Update Context Meuns
		%--
		
		update_context_menus(pal);
		
	%------------------------------------------------------------------
	% SOUNDS ACTIONS
	%------------------------------------------------------------------
	
	case 'Sounds'
			
		%--
		% perform action
		%--
		
		switch (action)
			
			%------------------------------------------------------------------
			% CONFIGURE
			%------------------------------------------------------------------
			
			% NOTE: configure source in generic and format specific ways
			
			case 'Configure ...'
				
				%--
				% edit configuration for selected sound
				%--
				
				edit_sound_config(get_selected_sound);				
			
% 			case 'Sources'
% 				
% 				%--
% 				% edit 'Source' extension configuration
% 				%--
% 				
% 				source_configure_dialog(get_selected_sound);
							
			%--------------------------------------------------------------
			% NEW LOG
			%--------------------------------------------------------------
				
			case 'New Log ...'
				
				new_log_dialog([], [], 'root');
				
			%--------------------------------------------------------------
			% OPEN AND OPEN IN NEW WINDOW
			%--------------------------------------------------------------
			
			% NOTE: one or many sounds may be opened at the same time
			
			case {'Open', 'Open in New Window'}
					
				%--
				% open sounds in browser
				%--
				
				sounds = get_selected_sound;
				
				% set open in new window option
				
				opt = ~strcmp(action, 'Open');
				
				for k = 1:length(sounds)
					open_library_sound(sound_name(sounds(k)), get_active_library, opt);
				end
								
			%--------------------------------------------------------------
			% SHOW FILES ...
			%--------------------------------------------------------------

			case 'Show Files ...'
				
				sounds = get_selected_sound;
				
				%--
				% match sound and open directory containing files
				%--
				
				for k = 1:length(sounds)
						
					if strcmpi(sounds(k).type, 'file')
						file = [sounds(k).path, sounds(k).file];
					else
						file = sounds(k).path;
					end

					show_file(file);
					
				end
			
			%------------------------------------------------------------------
			% DELETE ...
			%------------------------------------------------------------------
					
			case 'Delete ...'
				
				delete_sounds(pal);

			%------------------------------------------------------------------
			% SELECTION
			%------------------------------------------------------------------
			
			% selection updates the sound info control 
			
			otherwise				
				
				%--
				% update log list based on selection
				%--
				
				xbat_palette('find_logs');
				
				%--
				% get selected sounds in sounds control
				%--
								
				sounds = get_selected_sound;
				
				%--
				% disable edit button for multiple selection
				%--
				
				set_control(pal, 'edit_sound', 'enable', length(sounds) == 1);
							
				%--
				% open sound on double-click and single selection
				%--

				if double_click(obj) && length(sounds) == 1	
					open_library_sound(sound_name(sounds)); return;	
				end

				%--
				% update sound info
				%--
				
				if isempty(sounds)
					sounds = get_library_sounds;
				end
				
				if isempty(sounds)
					return;
				end
				
				S = sound_info_str(sounds);

				g = findobj(pal,'tag','sound_info','style','listbox');

				set(g, ...
					'string',S, ...
					'value',[], ...
					'listboxtop',1, ...
					'enable','on' ...
				);

				%-------------------------
				% UPDATE CONTEXT MENUS
				%-------------------------
				
				update_context_menus(pal);
				
		end	
		
	%------------------------------------------------------------------
	% NEW_SOUND
	%------------------------------------------------------------------
		
	case 'new_sound'
		
		new_sound_dialog;
		
	%------------------------------------------------------------------
	% NEW_SOUND
	%------------------------------------------------------------------	
	
	case 'edit_sound'
		
		edit_sound_config(get_selected_sound);
		
	%------------------------------------------------------------------
	% FIND LOGS
	%------------------------------------------------------------------
	
	case 'find_logs'
		
		%--
		% get filtered sounds
		%--
		
		handles = get_control(pal, 'Sounds', 'handles'); 
		
		filtered_sounds = get(handles.obj, 'string');
			
		selected_sounds = get_control(pal, 'Sounds', 'value');
		
		if ~isempty(selected_sounds);
			filtered_sounds = selected_sounds;
		end
		
		%--
		% generate unfiltered log list
		%--
		
		handles = get_control(pal, 'Logs', 'handles');
		
		set(handles.uicontrol.listbox, 'string', get_library_logs('info', [], filtered_sounds));
		
		%--
		% filter list based on search string
		%--
			
		listbox_search(pal, 'log');
		
		%--
		% update context menus
		%--
		
		update_context_menus(pal);
		
	%------------------------------------------------------------------
	% LOGS ACTIONS
	%------------------------------------------------------------------
	
	case ('Logs')
				
		switch (action)
			
			%------------------------------------------------------------------
			% OPEN
			%------------------------------------------------------------------
			
			% open checks for windows that may currently be browsing the
			% parent sound and opens the logs in these, otherwise a new
			% sound browser is opened that displays the sound at the point
			% where the log was last closed
			
			case {'Open', 'Open in New Window'}
								
				%--
				% get string value from associated control
				%--
				
				g = findobj(pal, 'tag', 'Logs', 'style', 'listbox');

				L = get(g, 'string'); ix = get(g, 'value'); 
				
				% return if there is no selection
				
				if isempty(ix)
					return;
				end
				
				if (length(ix) == 1)
					value = {L{ix}};
				else
					for k = 1:length(ix)
						value{k} = L{ix(k)};
					end
				end
								
				%--
				% open logs
				%--
				
				% set open in new window option
				
				if strcmp(action, 'Open')
					opt = 0;
				else
					opt = 1;
				end
				
				% open selected logs in proper mode
				
				for k = 1:length(value)
					open_log(value{k}, opt);
				end
				
			%------------------------------------------------------------------
			% DELETE
			%------------------------------------------------------------------
			
			case'Export Clips ...'
				
				%--
				% get logs to export from parent control value
				%--
				
				[ignore,value] = control_update([],pal,tag);
		
				%--
				% ask for output directory
				%--
				
				top_dir = uigetdir;

				if (~top_dir)
					return;
				end
				
				%--
				% build log file names
				%--
				
				lib_path = get_field(get_active_library,'path');
				
				for k = 1:length(value)		
					log_file{k} = [lib_path, strrep(value{k},filesep,[filesep 'Logs' filesep]), '.mat'];
				end
				
				%--
				% configure export log
				%--
				
				opt = export_log;
				
				opt.image.create = 1;
				
				%--
				% load logs and export
				%--
				
				% NOTE: consider using a waitbar display for the collection
				
				for k = 1:length(log_file)
					
					%--
					% load log from file
					%--
					
					% NOTE: the use of the structure fieldname is cumbersome
					
					tmp = load(log_file{k});
					
					name = fieldnames(tmp);
					
					log = tmp.(name{1});
					
					%--
					% export log
					%--
					
					export_log(log, opt, top_dir);
					
				end
						
			%------------------------------------------------------------------
			% DELETE
			%------------------------------------------------------------------
					
			case ('Delete ...')
				
				delete_logs(pal);
								
			%------------------------------------------------------------------
			% SHOW FILES ...
			%------------------------------------------------------------------
			
			% selection updates the sound info control as well as filters
			% the log control contents
			
			case ('Show Files ...')
				
				%--
				% get string value from associated control
				%--
				
				g = findobj(pal,'tag','Logs','style','listbox');

				L = get(g,'string');
				ix = get(g,'value'); 
				
				if (isempty(ix))
					return;
				end
				
				if (length(ix) == 1)
					value = {L{ix}};
				else
					for k = 1:length(ix)
						value{k} = L{ix(k)};
					end
				end
				
				%--
				% group same sound files into groups
				%--
				
				% this code assumes that the strings are ordered into groups
				
				tok = '';
								
				for k = length(value):-1:1
										
					new_tok = strtok(value{k}, filesep);
					
					if ~strcmp(new_tok, tok)
						tok = new_tok;
					else
						value(k) = [];
					end
					
				end
				
				%--
				% show files
				%--
				
				% check that we are in windows. find the unix alternative
				
				% the last file in each group is selected
				
				lib = get_active_library;
				
				for k = 1:length(value)
					
					file = [lib.path , strrep(value{k}, filesep, [filesep, 'Logs', filesep]), '.mat'];
					
					show_file(file);
					
				end
										
			%------------------------------------------------------------------
			% SELECTION
			%------------------------------------------------------------------
			
			% selection in the logs control updates the log info control
			
			otherwise
				
				%--
				% get selected logs in logs control
				%--
				
				value = get(obj,'string');
				
				ix = get(obj,'value');
				
				%--
				% set and check timer to trigger double click action
				%--
					
				flag = double_click(obj);
				
				%--
				% handle the update with multiple logs selected
				%--
				
				if (length(ix) > 1)
					
					%-------------------------
					% UPDATE LOGS
					%-------------------------
					
					%--
					% update log info
					%--
					
					g = findobj(pal,'tag','log_info','style','listbox');
					
					set(g, ...
						'string',[], ...
						'value',[], ...
						'listboxtop',1, ...
						'enable','off' ...
					);
					
					%-------------------------
					% UPDATE CONTEXT MENUS
					%-------------------------
					
					update_context_menus(pal);
					
					return;
					
				end
				
				%--
				% handle the update with single log selected
				%--
				
				value = value{ix};
				
				%--
				% open log file
				%--
				
				p = get_field(get_active_library,'path');
				
				str = [p strrep(value,filesep,[filesep 'Logs' filesep]) '.mat'];
				
% 				ptr = get(pal,'pointer'); % change pointer to indicate opening of file
% 				
% 				set(pal,'pointer','watch');
				
				f = open(str);
				
% 				set(pal,'pointer',ptr);
				
				name = fieldnames(f);
				
				f = f.(name{1});
					
				%-------------------------
				% UPDATE LOGS
				%-------------------------
								
				%--
				% create log info string 
				%--

				S = log_info_str(f);
						
				%--
				% update log info control
				%--
				
				g = findobj(pal,'tag','log_info','style','listbox');
				
				set(g, ...
					'string',S, ...
					'value',[], ...
					'listboxtop',1, ...
					'enable','on' ...
				);
				
				%--
				% open log based on double click
				%--
				
				if flag
					open_log(value); % this is equivalent to open log
				end
				
				%-------------------------
				% UPDATE CONTEXT MENUS
				%-------------------------
				
				update_context_menus(pal);
				
		end
				
end


%-------------------------------------------------------------------------
% OPEN_LOG
%-------------------------------------------------------------------------

function open_log(value, opt)

% open_log - handle opening logs from palette
% -------------------------------------------
%
% open_log(value, opt)
%
% Input:
% ------
%  value - string indicating log to open (from listbox)
%  opt - option to open in new window (def: 0)

%--
% set new window option
%--

if (nargin < 2) || isempty(opt)
	opt = 0;
end

%--
% convert the listbox naming convention
%--

value = strrep(value, filesep, [filesep, 'Logs', filesep]);

%--
% get log from file
%--

p = get_field(get_active_library, 'path');

log_file = [p, value, '.mat'];

tmp = open(log_file);

name = fieldnames(tmp);

log = tmp.(name{1});

%--
% check whether log is already open
%--

[g, h] = log_is_open(log);

if ~isempty(g)
	
	%--
	% bring figure to front
	%--
	
	% perhaps also make visible and redisplay or
	% something along those lines
	
	figure(g); return;
	
else
	
	%--
	% try to open log in an existing window
	%--
	
	if ~isempty(h) && ~opt
		
		%--
		% check whether parent sound is already open
		%--
				
		name = sound_name(log.sound);
	
		for k = 1:length(h)
			
			%--
			% get sound open information from figure tag
			%--
			
			info = parse_tag(get(h(k), 'tag'));
			
			%--
			% open log if sound names match
			%--
			
			if strcmp(name, info.sound)
				log_open(h(k), log_file); return;
			end
			
		end
		
	end
		
	%--
	% open log sound in browser
	%--
	
	% NOTE: the sound contains some state or session information
	
	% NOTE: get sound from library to protect from wandering logs
	
	par = open_library_sound(sound_name(log.sound));
	
	%--
	% open log in sound browser
	%--
	
    % NOTE: we do not produce a warning, in case 'open_library_sound' took care of this
	
	log_open(par, log_file, 0);
    
	%--
	% set browser pointer to arrow
	%--
	
	% NOTE: this may be vestigial and not needed, we'll just wait for the appendectomy
	
	set(par, 'pointer', 'arrow');
		
end


%---------------------------
% UPDATE_CONTEXT_MENUS
%---------------------------

function update_context_menus(pal)

%--
% update sounds
%--

g = findobj(pal,'tag','Sounds','style','listbox');
		
if isempty(get(g,'value'))
	state = 'off';
else
	state = 'on';
end

set(get(get(g,'uicontextmenu'),'children'),'enable',state);

%--
% update attributes menu
%--

par = findobj(get(g, 'uicontextmenu'), 'label', 'Attributes');

if ~isempty(par)
	attribute_menu(par);
end

%--
% Update 'Copy To Library' Menu
%--

g = findobj(get(get(g,'uicontextmenu'),'children'),'label','Copy to Library');

delete(get(g, 'children'));

user = get_active_user;

list = library_name_list(user); active_lib = list{user.active};

L = setdiff(list, active_lib);

if ~isempty(L)

	set(g, 'enable', 'on');
	menu_group(g, @copy_to_library, L);

else

	set(g, 'enable', 'off');

end

%--
% update logs
%--

g = findobj(pal,'tag','Logs','style','listbox');

if (isempty(get(g,'value')))
	state = 'off';
else
	state = 'on';
end

set(get(get(g,'uicontextmenu'),'children'),'enable',state);
		

%------------------------------------------------------------
% COPY TO LIBRARY
%------------------------------------------------------------

function copy_to_library(obj,eventdata)

%--
% get path of library to copy to
%--

[name, usr] = parse_libname(get(obj,'label'));

if isempty(usr)
	usr = get_active_user; usr = usr.name;
end

dest = get_libraries(get_users('name', usr),'name',name);

%--
% get active library and sounds to copy
%--

src = get_active_library;

g = findobj(gcf,'tag','Sounds','style','listbox');

sounds = get(g,'string');

sounds = sounds(get(g,'value'));

%--
% copy sound directories
%--

% add check for the existence of the sounds in the destination library and
% indicate that this is the case, thus there are two type of warnings
% issued

%--
% create waitbar
%--

%-------------------------------------------
% WAITBAR CODE
%-------------------------------------------
	
h = wait_bar(0);
	
set(h,'name','XBAT > Copy to Library');
	
n = length(sounds);

for k = 1:n
	
	%--
	% check that sound exists
	%--
	
	if (exist([dest.path sounds{k}],'dir'))
		flag(k) = 2;
	else
		flag(k) = copyfile([src.path sounds{k}],[dest.path sounds{k}]);
	end
		
	%--
	% display confirmation
	%--
	
	%-------------------------------------------
	% WAITBAR CODE
	%-------------------------------------------
	
	switch (flag(k))
		
		case (0)
			wait_bar(k/n,h,['Failed to copy ''' sounds{k} ''' to ''' name '.']);
			
		case (1)
			wait_bar(k/n,h,['''' sounds{k} ''' copied to ''' name '''']);
			
		case (2)
			wait_bar(k/n,h,['''' sounds{k} ''' already exists in ''' name '''']);
			
	end
	
	pause(0.1);
	
end

%--
% report results and delete waitbar
%--

%-------------------------------------------
% WAITBAR CODE
%-------------------------------------------

m = sum(flag == 1);

wait_bar(1,h,[int2str(m) ' sounds copied to ''' name ''' library']);

pause(1);

delete(h);

get_library_sounds(dest,'refresh');


% this code tests the idea of having a single button that serves as both
% cancel and confirm using the keypress function, in principle the user
% presses a key before pressing the button providing the button and the
% corresponding callback function some context information. the operation
% performed by the button upon pressing is indicated by the changing icon
% (in this case text) on the button 'X' for cancel and '+' for confirm


function xbat_palette_kpfun(obj,eventdata)

% %--
% % code to display codes available
% %--
% 
% disp('-----------------------');
% key = get(gcf,'currentkey')
% chr = get(gcf,'currentcharacter')
% code = double(chr)

% %--
% % code to toggle the button appearing during edit
% %--
% 
% % g = findobj(gcf,'tag','New User Cancel')
% % 
% % if (~isempty(g))
% % 	
% % 	if (strcmp(key,'shift'))	
% % 		set(g,'string','X','fontsize',7,'fontname','Comic Sans MS');	
% % 	else
% % 		set(g,'string','+','fontsize',10,'fontname','Courier New');
% % 	end
% % 	
% % end

%-------------------------------------------------------------------------
% DELETE_LOGS
%-------------------------------------------------------------------------

function delete_logs(pal)

% delete_logs - callback for delete logs
% ----------------------------------------
%
% delete_logs(pal)
%
% Input:
% ------
%  pal - XBAT palette figure handle

%-------------------------------------------
% get names of logs to delete
%-------------------------------------------

%--
% try to get string value from associated control
%--

g = findobj(pal,'tag','Logs','style','listbox');

L = get(g,'string');
ix = get(g,'value');

% return if there is no selection

if isempty(ix)
	return;
end

% make sure that value is in a cell array

if length(ix) == 1
	value = {L{ix}};
else
	for k = 1:length(ix)
		value{k} = L{ix(k)};
	end
end
								
%-------------------------------------------
% create waitbar
%-------------------------------------------

%--
% progress waitbar
%--

control = control_create( ...
	'name','PROGRESS', ...
	'alias','Deleting Logs ...', ...
	'style','waitbar', ...
	'confirm',1, ...
	'lines',1.15, ...
	'space',0.5 ...
);

name = ['Delete Logs ...'];

h = waitbar_group(name, control);

%-------------------------------------------
% delete logs
%-------------------------------------------

lib = get_active_library;

lib_path = get_field(lib,'path');
			
n = length(value);

for k = 1:n
	
	%--
	% load log from file
	%--
	
	log_file = [lib_path strrep(value{k},filesep,[filesep 'Logs' filesep]) '.mat'];
	
	log = load(log_file);
	field = fieldnames(log);
	
	log = log.(field{1});
	
	%--
	% check whether log is open
	%--
	
	test = log_is_open(log);
	
	%--
	% try to delete log file if not open
	%--
	
	if ~isempty(test)
		
		flag(k) = 2;
		
	else
		
		flag(k) = 1;
		
		% backup log and delete (the backup may not be needed since the log
		% is backed up when it's closed !!! leave on for the moment
		
		log_backup(log);
		
		delete(log_file);
		
	end
						
	%--
	% display confirmation
	%--
	
	%-------------------------------------------
	% WAITBAR CODE
	%-------------------------------------------

	switch flag(k)
		
		% log file removed (assume this does not fail)
		
		case (1)
			waitbar_update(h,'PROGRESS', ...
				'value',k/n, ...
				'message',['''' value{k} ''' was deleted'] ...
			);
			
		% log is open
		
		case (2)
			waitbar_update(h,'PROGRESS', ...
				'value',k/n, ...
				'message',['''' value{k} ''' is open and was not deleted'] ...
			);
			
	end
		
end

%--
% update library display
%--

% g = findobj(pal,'tag','find_sounds','style','listbox');

xbat_palette('find_sounds');

%--
% report results and delete waitbar
%--

%-------------------------------------------
% WAITBAR CODE
%-------------------------------------------

m = sum(flag == 1);

waitbar_update(h,'PROGRESS', ...
	'value', 1, ...
	'message', [int2str(m), ' logs deleted from ''', lib.name, ''' library'] ...
);

delete(h);

%--------------------------------------------
% DELETE SOUNDS
%--------------------------------------------

% TODO: factor deletion part to the same place as 'add_sounds'

function delete_sounds(pal)

% delete_sounds - callback for delete sounds
% ------------------------------------------
%
% delete_sounds(pal)
%
% Input:
% ------
%  pal - XBAT palette figure handle


%-------------------------------------------
% get names of sounds to delete
%-------------------------------------------

%--
% try to get string value from associated control
%--

g = findobj(pal,'tag','Sounds','style','listbox');

L = get(g,'string'); ix = get(g,'value');

%--
% return if there is no selection
%--

% this should not happen

if isempty(ix)
	return;
end

%--
% make sure that value is in a cell array
%--

if (length(ix) == 1)
	value = {L{ix}};
else
	for k = 1:length(ix)
		value{k} = L{ix(k)};
	end
end

%-------------------------------------------
% create waitbar
%-------------------------------------------

%--
% progress waitbar
%--

control = control_create( ...
	'name', 'PROGRESS', ...
	'alias', 'Deleting Sounds ...', ...
	'style', 'waitbar', ...
	'confirm', 1, ...
	'lines', 1.15, ...
	'space', 0.5 ...
);

name = ['Deleting Sounds ...'];

h = waitbar_group(name, control);

%-------------------------------------------
% delete sounds
%-------------------------------------------

lib = get_active_library;

lib_path = get_field(lib, 'path');

n = length(value);

for k = 1:n

	[is_open, par] = sound_is_open(value{k});
	
	if par
		close(par)
	end	
	
	%--
	% backup sound and remove
	%--
	
	sound_backup(lib, value{k});
	
	flag(k) = rmdir([lib_path, value{k}], 's'); % note that the 's' option removes non-empty directories
	
	%--
	% update waitbar
	%--

	if (flag(k) == 1)
		waitbar_update(h, 'PROGRESS', ...
			'value', k/n, ...
			'message', ['''' value{k} ''' removed from ''' lib.name ''''] ...
		);
	else
		waitbar_update(h,'PROGRESS', ...
			'value', k/n, ...
			'message', ['Failed to remove ''', value{k}, ''' from ''', lib.name, ''''] ...
		);
	end
		
end

%--
% update library cache
%--

get_library_sounds(lib, 'refresh');

%--
% update library display
%--

handles = get_control(pal, 'Library', 'handles');

xbat_controls_callback(handles.uicontrol.popupmenu, []);

%--
% update waitbar to report results and delete waitbar
%--

m = sum(flag == 1);

waitbar_update(h, 'PROGRESS', ...
	'value', 1, ...
	'message', [int2str(m), ' sounds deleted from ''', lib.name, ''' library'] ...
);

pause(0.5);

delete(h);

%-------------------------------------------
% xbat_menu
%-------------------------------------------

function xbat_menu(par)

%----------------------
% SETUP
%----------------------

%--
% clear former menu if needed
%--

top = findobj(par, 'type', 'uimenu', 'tag', 'TOP_XBAT_MENU');

if ~isempty(top)
	delete(allchild(top));
end

%----------------------
% CREATE MENUS
%----------------------

%--
% create top menu if needed
%--

if isempty(top)
	top = uimenu(par, 'label', 'File', 'tag', 'TOP_XBAT_MENU');
end 

%--
% migrate
%--

uimenu(top, ...
	'label', 'Migrate ...', ...
	'separator', 'off', ...
	'callback', @migrate_callback ...
);

%--------------------------------------
% MIGRATE_CALLBACK
%--------------------------------------

function migrate_callback(obj, eventdata)

migrate_xbat;
