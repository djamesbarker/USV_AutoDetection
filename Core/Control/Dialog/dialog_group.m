function out = dialog_group(name, control, opt, fun, par)

% dialog_group - create a group of buttons in figure
% --------------------------------------------------
% 
% opt = dialog_group
%
% out = dialog_group(name, control, opt, fun, par)
%
% Input:
% ------
%  name - name for dialog group
%  control - array of control structures
%  opt - dialog group options
%  fun - control callbacks
%  par - dialog parent figure
%
% Output:
% -------
%  opt - dialog group options
%  out - dialog result data
%
% See Also:
% ---------
%  control_create, control_group

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
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

% TODO: develop a variety of template dialogs based on this framework

%-----------------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------------

%--
% set default parent and control callback
%--

if (nargin < 5)
	par = [];
end 

if (nargin < 4)
	fun = [];
end

%--
% set and possibly output default options
%--
	
if (nargin < 3) || isempty(opt)
	
	%--
	% get and set control group options
	%--
		
	% NOTE: get default 'control_group' options and edit

	opt = control_group; 
	
	opt.top = 0; 
	
	opt.width = 16; 
	
	opt.bottom = 1;
	
	opt.text_menu = 0;
	
	%--
	% add dialog specific options
	%--
		
	% NOTE: button names are used for 'custom' dialogs

	[types, ix] = dialog_types; 
	
	opt.dialog_type = types{ix};
			
	opt.button_names = cell(0);
		
	%--
	% output options if needed
	%--
	
	if ~nargin
		out = opt; return;
	end
	
end

%-----------------------------------------------------------
% CREATE DIALOG BUTTONS
%-----------------------------------------------------------

%--
% create type specific button group attributes
%--

switch opt.dialog_type
	
	case 'ok'
		
		buttons = {'OK'}; width = 0.35;

	case 'ok_cancel'
		
		buttons = {'OK', 'Cancel'};
		
		if (((opt.width - (opt.left + opt.right)) * 0.6) >= 6)
			width = 0.67;
		else
			width = 1;
		end

	case 'ok_cancel_apply'
		
		buttons = {'OK', 'Cancel', 'Apply'}; width = 1;

	case ('custom')
		
		% NOTE: put any type of buttons in this dialog, a cancel is useful
		
		error(['Custom dialogs are not implemented yet.']);
		
end

%-- 
% put together callbacks
%--

% NOTE: the dialog id is used for data persistence

id = ['DIALOG_', int2str(rand(1) * 10^6)]; 

callback = {@dialog_action_callback, id};

callbacks = cell(size(buttons));

for k = 1:length(buttons)
	callbacks{k} = callback;
end

%--
% create button group control
%--

% BUG: problem with hidden header if there is a real header that collapses

% NOTE: hidden header ends tab context if there are tabs in dialog

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'hidden_header' ...
);

control(end + 1) = control_create( ...
	'name', buttons, ...
	'style', 'buttongroup', ...
	'callback', callbacks, ...
	'tooltip', buttons, ...
	'align', 'right', ...
	'space', 0, ...
	'width', width, ...
	'lines', 1.75 ...
);

%-----------------------------------------------------------
% CREATE DIALOG
%-----------------------------------------------------------

%--
% set control callbacks directly
%--

% NOTE: we set the callbacks directly so they are not modified

for k = 1:(length(control) - 1)
	
	%--
	% non-button controls
	%--
	
	if ~strcmp(control(k).style, 'buttongroup')
		control(k).callback = {@callback_router, fun}; continue;
	end
	
	%--
	% single button
	%--
		
	if ischar(control(k).name)
		control(k).callback = fun; continue;
	end
	
	%--
	% buttongroup
	%--
	
	callback = cell(size(control(k).name));
	
	for kk = 1:length(callback)
		
		% NOTE: this should work but doesn't
		
		% callback{kk} = {@callback_router, fun};
		
		callback{kk} = fun;
	end
	
	control(k).callback = callback;
		
end

%--
% create and position palette
%--

% NOTE: pass parent so palette will have a parent

pal = control_group(par, [], name, control, opt);

if opt.text_menu
	text_menu(pal);
end 

position_palette(pal, 0);

%--
% set figure dialog properties
%--

figure(pal);

% NOTE: dialogs should contain 'DIALOG', but we only update if tag is empty

% NOTE: the tag requirements are so that we pass and 'is_palette' test

if isempty(get(pal, 'tag'))
	set(pal, 'tag', 'MODAL_DIALOG');
end

set(pal, 'closerequestfcn', fun);

% NOTE: the modality anhilates the menu display, so we must remain in normal dialog

has_menus = ~isempty(findobj(pal, 'type', 'uimenu', 'parent', pal));

if xbat_developer || has_menus
	set(pal, 'windowstyle', 'normal');
else
	set(pal, 'windowstyle', 'modal');
end

uiwait(pal); 


%-----------------------------------------------------------
% GET DIALOG OUTPUT
%-----------------------------------------------------------

out = get_env(id); 

% NOTE: clean up environment 

rm_env(id, 0);


%-----------------------------------------------------------
% DIALOG_TYPES
%-----------------------------------------------------------

function [types, ix] = dialog_types

% dialog_types - dialog type strings
% ----------------------------------
%
% [types,ix] = dialog_types
%
% Output:
% -------
%  types - cell of type strings
%  ix - default value index

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

% NOTE: this is one way of indicating default value

types = {'ok', 'ok_cancel', 'ok_cancel_apply', 'custom'};

ix = 2;


%-----------------------------------------------------------
% DIALOG_ACTION_CALLBACK
%-----------------------------------------------------------

function dialog_action_callback(obj, eventdata, id)

% dialog_action_callback - button action callback for dialog groups
% ----------------------------------------------------------
%
% dialog_action_callback(obj, eventdata, id)
%
% Input:
% ------
%  obj - callback object
%  eventdata - not used at the moment
%  id - dialog id string

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% get action from callback object
%--

if strcmp(get(obj, 'type'), 'figure')
	out.action = 'abort';
else
	out.action = lower(get(obj, 'string'));
end

%--
% get dialog handle
%--

pal = ancestor(obj, 'figure');

%----------------------------------
% PERFORM ACTION
%----------------------------------

%--
% handle values based on action
%--

switch out.action
	
	case {'abort', 'cancel'}, out.values = [];	
		
	otherwise, out.values = get_control_values(pal);
		
end

set_env(id, out);

%----------------------------------
% CLOSE DIALOG
%----------------------------------

delete(pal);


%-----------------------------------------------------------
% CALLBACK_ROUTER
%-----------------------------------------------------------

function callback_router(obj, eventdata, fun)

% callback_router - route callbacks
% ---------------------------------
%
% callback_router(obj, eventdata, fun)
%
% Input:
% ------
%  obj - callback object
%  eventdata - not used at the moment
%  fun - callback

%--
% prevent triggering callback if control has already been deleted
%--

if ~ishandle(obj)
	return;
end

switch class(fun)

	%--
	% function handle callback
	%--
	
	case 'function_handle', fun(obj, eventdata);
	
	%--
	% cell callback
	%--
	
	case 'cell'
		
		if ~isa(fun{1}, 'function_handle')
			error('Cell callback must have a function handle in the first position.');
		end
		
		args = fun(2:end); fun = fun{1};
	
		fun(obj, eventdata, args{:});
		
end


