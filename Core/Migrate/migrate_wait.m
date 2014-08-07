function [pal, result] = migrate_wait(type, ticks, message)

% migrate_wait - wait for migration to complete
% ---------------------------------------------
% pal = migrate_wait(type, ticks, message)
%
% Input:
% ------
%  type - migration type 
%  ticks - number of ticks
%  message - message to display on header
%
% Output:
% -------
%  pal - handle to figure

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
% Singleton
%--

name = ['Migrating ...'];

pal = find_waitbar(name);

result = '';

if ~nargin
	return;
end

if isstr(type) && strcmp(type, 'finish')
	migrate_wait_finish; return;
end

%--
% handle input
%--

if nargin < 3 || isempty(message)
	message = '';
end

if nargin < 2
	ticks = [];
end
	
%--
% update waitbar if it already exists
%--

if ~isempty(pal)
	
	try
		out = migrate_wait_update(pal, type, ticks, message); 
	catch
		result = 'cancel'; return;
	end
		
	switch out
			
		case 1, result = 'skip';
			
		case 2, result = 'cancel';
			
		otherwise
		
	end
	
	return;

end

%------------------------------
% CREATE WAITBARS
%------------------------------

%--
% create controls
%--

control = empty(control_create);

control(end + 1) = control_create( ...
	'name', 'PROGRESS', ...
	'style', 'waitbar', ...
	'lines', 1, ...
	'align', 'center', ...
	'confirm', 1, ...
	'space', 2 ...
);

control(end + 1) = control_create( ...
	'name', 'close_after_completion', ... 
	'style', 'checkbox', ...
	'space', -1, ...
	'value', 0 ...
);

control(end + 1) = control_create( ...
	'style', 'buttongroup', ...
	'name', {'skip', 'cancel'}, ...
	'lines', 1.25, ...
	'width', 1/2, ...
	'align', 'right' ...
);

control(end + 1) = control_create( ...
	'name', 'details', ...
	'style', 'separator', ...
	'type', 'header', ...
	'string', 'Details' ...
);

control(end + 1) = control_create( ...
	'name', 'action', ...
	'style', 'listbox', ...
	'lines', 4 ...
);

control(end + 1) = control_create( ...
	'name', 'Events', ...
	'style', 'waitbar', ...
	'lines', 0.75, ...
	'align', 'center', ...
	'update_rate', 1, ...
	'confirm', 1, ...
	'space', 2 ...
);
	

%--
% render waitbar
%--

opt = waitbar_group; opt.show_after = 0; opt.bottom = 0; opt.update_rate = 0.25;

pal = waitbar_group(name, control, [], [], opt);

%--
% initialize progress
%--

migrate_wait_update(pal, 'PROGRESS', 0);

%--
% set button callbacks
%--

handles = get_control(pal, 'skip', 'handles');

set(handles.uicontrol.pushbutton, 'callback', @post_button_semaphore);

handles = get_control(pal, 'cancel', 'handles');

set(handles.uicontrol.pushbutton, 'callback', @post_button_semaphore);


%-----------------------------------------------------------
% MIGRATE_WAIT_UPDATE
%-----------------------------------------------------------

function result = migrate_wait_update(pal, type, ticks, message)

if nargin < 4 || isempty(message)
	message = '';
end

result = 0;

%--
% reset waitbar
%--

if ~isempty(ticks)	
	reset_bar(pal, type, ticks, message); return;
end	

%--
% check button semaphores
%--

result = check_button_semaphore(pal);

%--
% update waitbar(s)
%--

update_bar(pal, type, message);

if strcmpi(type, 'events')
	waitbar_update(pal, 'PROGRESS', 'value', []); return;
end

str = ['Migrating ', string_singular(type), ' "', message, '" '];

update_bar(pal, 'PROGRESS', str);

%--
% update listbox
%--

handles = get_control(pal, 'action', 'handles');

if isempty(handles)
	return;
end

list = get(handles.uicontrol.listbox(1), 'string');

if isempty(list)
	list = {};
end

list(1:end-30) = [];

list = {list{:}, [str, ' ...']};

set(handles.uicontrol.listbox(1), 'string', list, 'value', numel(list));


%-----------------------------------------
% UPDATE_BAR
%-----------------------------------------

function update_bar(pal, name, message)

update_message = 1;

persistent previous;

if isempty(previous)
	previous = struct();
end

if isempty(message) || (isfield(previous, name) && strcmp(message, previous.(name)))
	update_message = 0; 
else
	previous.(name) = message;
end

%--
% get waitbar axes userdata
%--

handles = get_control(pal, name, 'handles');

if isempty(handles)
	return;
end

data = get(handles.axes, 'userdata');

if ~isfield(data, 'ticks') || ~isfield(data, 'tick')
	return;
end

%--
% update or reset userdata
%--

data.tick = min(data.tick + 1, data.ticks); 

set(handles.axes, 'userdata', data);

%--
% update waitbar
%--

if data.ticks
	value = data.tick / data.ticks;
else
	value = 0;
end
	
waitbar_update(pal, name, ...
	'value', value ...
);

if nargin < 2 || ~update_message || isempty(message)
	return;
end

% NOTE: a simple message will suffice for the main progress bar

waitbar_update(pal, name, ...
	'message', message ...
);


%-----------------------------------------
% RESET_BAR
%-----------------------------------------

function reset_bar(pal, name, ticks, message)

%--
% get waitbar axes userdata
%--

handles = get_control(pal, name, 'handles');

if isempty(handles)
	return;
end

data = get(handles.axes, 'userdata');

%--
% initialize 'tick' and 'ticks' fields
%--

data.ticks = ticks;

data.tick = 0;

%--
% update waitbar
%--

% message = [name, ': ', message];

waitbar_update(pal, name, ...
	'value', 0, ...
	'message', message ...
);

set(handles.axes, 'userdata', data);


%-----------------------------------------
% GET_WAIT_TYPE
%-----------------------------------------

function types = get_wait_types

types = {'Events', 'Sounds', 'Libraries', 'Users', 'PROGRESS'}; 


%-----------------------------------------
% MIGRATE_WAIT_FINISH
%-----------------------------------------

function migrate_wait_finish

%--
% set progress string to done
%--

out = check_button_semaphore(migrate_wait);

switch out
	case 1, done = 'Skipped!';
	case 2, done = 'Cancelled!';
	otherwise, done = 'Done!';
end

waitbar_update(migrate_wait, 'PROGRESS', 'value', 1, 'message', done);

list_handles = get_control(migrate_wait, 'action', 'handles');

str = get(list_handles.obj, 'string'); 

if isempty(str)
	str = {done};
else
	str = {str{:}, done};
end

set(list_handles.obj, 'string', str, 'value', numel(str));

if get_control(migrate_wait, 'close_after_completion', 'value');
	delete(migrate_wait);
end


%-----------------------------------------------------------
% POST_BUTTON_SEMAPHORE
%-----------------------------------------------------------

function post_button_semaphore(obj, eventdata)

set(obj, 'userdata', 1);


%-----------------------------------------------------------
% CHECK_BUTTON_SEMAPHORE
%-----------------------------------------------------------

function result = check_button_semaphore(pal)

result = 0;

handles = get_control(pal, 'skip', 'handles');

skip = get(handles.uicontrol.pushbutton, 'userdata');

set(handles.uicontrol.pushbutton, 'userdata', 0);

handles = get_control(pal, 'cancel', 'handles');

cancel = get(handles.uicontrol.pushbutton, 'userdata');

% set(handles.uicontrol.pushbutton, 'userdata', 0);

if ~isempty(skip) && (skip == 1)
	result = 1;
end

if ~isempty(cancel) && (cancel == 1)
	result = 2;
end

