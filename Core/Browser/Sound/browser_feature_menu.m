function out = browser_feature_menu(par, str)

% browser_feature_menu - create menus for features extensions
% ---------------------------------------------------------
%
% out = browser_feature_menu(par, str)
%
% Input:
% ------
%  par - browser handle
%  str - command string
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

%--------------------------------------------
% SETUP
%--------------------------------------------

% NOTE: consider returning if there are no features at all

%--
% get and sort able signal features 
%--

SOUND_FEATURE = get_able_extensions('sound_features');

if ~isempty(SOUND_FEATURE)
	
	SOUND_FEATURE_NAME = {SOUND_FEATURE.name}';

	category = get_extension_categories(SOUND_FEATURE);
	
	SOUND_CATEGORY = {category.name}';
	
	SOUND_CATEGORY_FEATURE = {category.children}';
	
else
	
	SOUND_FEATURE_NAME = cell(0);
	
	SOUND_CATEGORY = cell(0); SOUND_CATEGORY_FEATURE = cell(0);
	
end

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set default command string
%--

if nargin < 2
	str = 'Initialize';
end

% NOTE: set command as default output

out = str;

%--
% set default parent figure
%--

if nargin < 1
	par = get_active_browser;
end

%--
% get parent state
%--

data = get_browser(par);

%----------------------------------------------------------------------
% COMMAND SWITCH
%----------------------------------------------------------------------

switch str

%------------------------------------------------
% INITIALIZE
%------------------------------------------------

case 'Initialize'

	%--
	% check for existing feature menu
	%--
	
	if get_menu(par, 'Feature')
		return;
	end
	
	%-------------------------
	% Feature
	%-------------------------
		
	L = { ... 
		'Feature', ...
		'Active' ...
	};
	
	n = length(L); 
	
	S = bin2str(zeros(1, n));
	
	g = menu_group(par, 'browser_feature_menu', L, S);

	%--
	% position top menu and disable header
	%--
	
	% NOTE: the top menu is used in later parts of code
	
	g1 = g(1);
	
	set(g1, 'position', 6); 
	
	%-------------------------
	% Active
	%-------------------------
		
	%--
	% Signal
	%--
	
	if ~isempty(SOUND_FEATURE)
		
		SOUND_FEATURE_ACTIVE = SOUND_FEATURE_NAME;
		
		L = {'No Feature', SOUND_FEATURE_ACTIVE{:}}; n = length(L); 
		
		S = bin2str(zeros(1,n)); S{2} = 'on';
		
		temp = menu_group(get_menu(g, 'Active'), 'browser_feature_menu', L, S);
		
		set(get_menu(temp, 'No Feature'), 'check', 'on');
		
		set(temp, 'tag', 'sound_feature');
		
	else
		
		temp = get_menu(g, 'Active'); g = setdiff(g, temp); delete(temp);
				
	end

	%-------------------------
	% Features
	%-------------------------
	
	if ~isempty(SOUND_FEATURE)
						
		%--
		% create feature category menus
		%--
		
		% NOTE: the logic here is correct but quirky
		
		if (length(SOUND_CATEGORY) > 1) && isempty(SOUND_CATEGORY{1})
			ki = 2;
		else
			ki = 1;
		end
			
		for k = ki:length(SOUND_CATEGORY)
			
			%--
			% create extension category menu
			%--
	
			if isempty(SOUND_CATEGORY{k})
				temp = uimenu(g1, 'label', 'Other');
			else
				temp = uimenu(g1, 'label', SOUND_CATEGORY{k});
			end
			
			%--
			% add category features menu
			%--
			
			temp2 = menu_group(temp, 'browser_feature_menu', strcat(SOUND_CATEGORY_FEATURE{k}, ' ...'));
		
			set(temp2, 'tag', 'sound_feature');
			
		end
				
		%--
		% create 'Other' category menu
		%--
		
		if (ki == 2)
			
			temp = uimenu(g1, 'label', 'Other');
		
			temp2 = menu_group(temp, 'browser_feature_menu', strcat(SOUND_CATEGORY_FEATURE{1}, ' ...'));
			
			set(temp2, 'tag', 'sound_feature');
			
		end
		
	end
	
	%--
	% create feature extension registry
	%--
	
	% NOTE: initialized extensions contain default parameters given context
	
	context.sound = data.browser.sound; 
	
	data.browser.sound_feature.ext = extension_initialize(SOUND_FEATURE, context);
	
	%--
	% update state
	%--
	
	set(par, 'userdata', data);

%------------------------------------------------
% ACTIVE FEATURE
%------------------------------------------------

%--
% turn off active feature
%--

case ({ ...
	'No Feature' ...
})
	
	%--
	% turn off active feature
	%--
	
	type = 'sound_feature';
	
	data.browser.(type).active = '';
		
	set(par, 'userdata', data);
	
	%--
	% update active detection menu
	%--
		
	% TODO: move this code to update active controls, menus are controls
	
	g = findobj(par, ...
		'type', 'uimenu', 'label', 'Feature', 'parent', par ...
	);
	
	% NOTE: we are using the label variable to get the menus that need updating
	
	g =  get(get_menu(g, strtok(title_caps(type),' ')), 'children');	
	
	set(g, 'check', 'off');
	
	set(get_menu(g, 'No Feature'), 'check', 'on');
	
	%--
	% update active detection controls in available palettes
	%--
	
	update_active_controls(par, type, data.browser.(type).active, data);

	%--
	% update display
	%--
	
	browser_display(par, 'update', data);
			
%--
% make feature active
%--

case ({ ...
	SOUND_FEATURE_NAME{:} ...
})

	%--
	% set active feature state
	%--

	type = 'sound_feature';
	
	% TODO: allow for these menus to turn off features
	
	active = cell_union(data.browser.(type).active, str);
	
	data.browser.(type).active = active;
	
	set(par, 'userdata', data);
	
	%--
	% update active feature menu
	%--
			
	g = findobj(par, ...
		'type', 'uimenu', 'label', 'Feature', 'parent', par ...
	);
	
	% NOTE: we are using the label variable to get the menus that need updating
	
	g =  get(get_menu(g, 'Active'), 'children');
	
	set(g, 'check', 'off');
	
	for k = 1:length(active)
		set(get_menu(g, active{k}), 'check', 'on');
	end
	
	%--
	% update active detection controls in available palettes
	%--
	
	update_active_controls(par, type, active, data);
	
	%--
	% update display
	%--
	
	browser_display(par, 'update', data);
	
%------------------------------------------------
% FEATURE ...
%------------------------------------------------

% NOTE: open feature control palette and return palette handle

case ( ...
	strcat(SOUND_FEATURE_NAME,' ...') ...
)
	
	% NOTE: remove trailing space and periods from command string

	str = str(1:end - 4); 

	%---------------------------
	% CHECK FOR PALETTE
	%---------------------------
	
	%--
	% check for existing palette
	%--
	
	out = get_palette(par, str, data);

	% NOTE: position and return if palette exists
	
	if ~isempty(out)
		position_palette(out, par, 'center'); return;
	end
	
	%---------------------------
	% GET FEATURE EXTENSION
	%---------------------------
	
	%--
	% get feature from browser registry
	%--
	
	type = 'sound_feature';
	
	[ext, ignore, context] = get_browser_extension(type, par, str, data);
	
	%--------------------------------------------------
	% CREATE FEATURE PALETTE
	%--------------------------------------------------
	
	control = empty(control_create);

	%---------------------
	% FEATURE
	%---------------------
	
	control(end + 1) = control_create( ...
		'style', 'separator', ...
		'type', 'header', ...
		'string', 'Feature' ...
	);
	
	%--
	% active feature
	%--
	
	active = data.browser.(type).active; 
	
	if ischar(active)
		active = {active};
	end
	
	active_state = ismember(str, active);
	
	control(end + 1) = control_create( ...
		'name', 'active', ...
		'alias', 'On', ...
		'style', 'checkbox', ...
		'value', active_state, ...
		'callback', {@feature_dispatch, ext}, ...
		'tooltip', ['Make feature active'] ...
	);
	
	%--
	% developer controls
	%--
	
	if xbat_developer
		
		offset = 0.5 * 0.75;
		
		control(end + 1) = control_create( ...
			'style', 'separator', ...
			'space', 1 + offset ...
		);
	
		control(end + 1) = control_create( ...
			'name', 'debug', ...
			'alias', 'DEBUG', ...
			'style', 'checkbox' ...
		);
	
		control(end).space = -(1 + offset);
		
		control(end + 1) = control_create( ...
			'name', 'refresh', ...
			'alias', 'REFRESH', ...
			'style', 'buttongroup', ...
			'align', 'right', ...
			'lines', 1.75, ...
			'width', 0.5, ...
			'callback', {@feature_dispatch, ext} ...
		);

	end

	%---------------------
	% PARAMETERS
	%---------------------
	
	%--
	% get feature controls
	%--
	
	ext_controls = empty(control_create);
	
	if ~isempty(ext.fun.parameter.control.create)
		
		try
			ext_controls = ext.fun.parameter.control.create(ext.parameter, context);
		catch
			extension_warning(ext, 'Parameter control creation failed.', lasterror);
		end
		
	end
	
	%--
	% append feature specific controls to controls array
	%--
	
	if ~isempty(ext_controls)
	
		control(end + 1) = control_create( ...
			'style', 'separator', ...
			'type', 'header', ...
			'string', 'Parameters' ...
		);

		control(end) = adjust_control_space(control(end), ext_controls(1));

		%--
		% set feature control callbacks
		%--
		
		% NOTE: this routes the feature-specific callbacks through our own
		
		for k = 1:length(ext_controls)
			ext_controls(k).callback = {@feature_dispatch, ext, ext_controls(k).callback};
		end
		
		%--
		% concatenate common controls and specific controls
		%--

		control = [control, ext_controls];
		
	end
	
	%--------------------------------------------------
	% FEATURE PALETTE OPTIONS
	%--------------------------------------------------
	
	if ~isempty(ext.fun.parameter.control.options)
		
		opt = ext.fun.parameter.control.options(context);

		opt = struct_update(control_group, opt);

	else
		
		%--
		% get and set control group options
		%--

		opt = control_group;

		opt.left = 1;

		opt.right = 1;

		opt.width = 9; % helps to display feature name

		opt.top = 0; % header starts palette

		opt.bottom = 0; % feature controls determine bottom margin

		opt.handle_to_callback = 1;

	end
	
	opt.header_color = get_extension_color(ext);
	
	%--------------------------------------------------
	% CREATE FEATURE PALETTE
	%--------------------------------------------------
	
	%--
	% create control group
	%--
	
	pal = control_group(par, '', str, control, opt);
	
	%--
	% set palette tag, key press, and close request function
	%--
	
	% NOTE: control values are updated in parent as part of close request function
	
	% NOTE: the type of feature in palette tag has not been tested
	
	set(pal, ...
		'visible','off', ...
		'keypressfcn', {@browser_keypress_callback, par}, ...
		'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');'] ...
	);
	
	%--
	% register palette with parent and set parent windowbuttondown function
	%--
	
	n = length(data.browser.palettes);
	
	data.browser.palettes(n + 1) = pal;
	
	set(par, ...
		'userdata', data, ...
		'buttondown', 'browser_palettes(gcf,''Show'');' ...
	);
	
	%--------------------------------------------------
	% POSITION FEATURE PALETTE
	%--------------------------------------------------
	
	%--
	% update state of palette if available
	%--
	
	% TODO: package this into a function
	
	if ~isempty(data.browser.palette_states)
		
		names = struct_field(data.browser.palette_states, 'name');
		
		ix = find(strcmp(names, str));
		
		if ~isempty(ix)
			
			%--
			% reload saved palette state
			%--
									
			set_palette_state(pal,data.browser.palette_states(ix),1);
			
		else
			
			%--
			% set default state for detector palettes
			%--
			
			position_palette(pal,par,'center');
			
			palette_toggle(par,str,'Presets','close',data);
			
		end
		
	else
		
		%--
		% set default state for detector palettes
		%--
		
		position_palette(pal,par,'center');
		
		palette_toggle(par,str,'Presets','close',data);
		
	end
	
	set(pal,'visible','on');
	
	%--
	% output palette handle
	%--
	
	out = pal;
	
end


%-------------------------------------------------------------------------
% TOGGLE_MENU
%-------------------------------------------------------------------------

function toggle_menu(pal, ext, active)

% return;

if active
	label = '(ON)';
else
	label = '(OFF)';
end

handle = uimenu(pal, ...
	'label', label, 'tag', ext.subtype, 'callback', @toggle_menu_callback ...
);


%-------------------------------------------------------------------------
% TOGGLE_MENU_CALLBACK
%-------------------------------------------------------------------------

function toggle_menu_callback(obj, eventdata)

state = get(obj, 'label'); state = lower(state(2:end - 1));

pal = get(obj, 'parent'); par = get_palette_parent(pal);

switch state
	
	case 'on', browser_feature_menu(par, 'No Feature'); 
		
	case 'off', browser_feature_menu(par, get(pal, 'name'));
		
end


%-------------------------------------------------------------------------
% FEATURE_DISPATCH
%-------------------------------------------------------------------------

function feature_dispatch(obj, eventdata, feature, control_callback)

% feature_dispatch - callback dispatch for feature extensions
% ------------------------------------------------------------
%
% feature_dispatch(obj, eventdata, feature, control_callback)
%
% Input:
% ------
%  obj - callback object handle
%  eventdata - reserved by matlab, mostly unused at the moment
%  feature - feature extension, contains general feature callback
%  control_callback - control specific callback, typically empty

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2173 $
% $Date: 2005-11-22 00:26:27 +0100 (Tue, 22 Nov 2005) $
%--------------------------------

%----------------------------
% SETUP
%----------------------------

%--
% get callback context from handle
%--

callback = get_callback_context(obj,'pack'); 

%--
% get fresh extension
%--

sound = get_browser(callback.par.handle, 'sound');

context.ext = feature; context.sound = sound;

%--
% set default result
%--

result = [];

%----------------------------
% CALLBACKS
%----------------------------

switch callback.control.name
		
	%----------------------
	% REFRESH
	%----------------------
	
	case 'refresh'
		
		refresh_extension(callback, context);
		
	%----------------------
	% PRESET
	%----------------------
	
	case 'preset'
				
		% TODO: make robust and output status
				
		load_preset(obj ,eventdata); return;
	
	case 'new_preset'
		
		% TODO: consider using new modal dialog framework
		
		show_new_preset(obj, eventdata); return;
		
	%----------------------
	% FEATURE
	%----------------------
	
	case 'opacity'
		
		slider_sync(obj, callback.control.handles);

		control_flash(callback.control, callback.pal);
	
	case 'active'

		% TODO: this implements exclusive features, change this
		
		%--
		% update active feature state
		%--
		
		% NOTE: we compute command string from control value
		
		if get(obj,'value') == 1
			str = callback.pal.name; 
		else
			str = 'No Feature'; 
		end
				
		browser_feature_menu(callback.par.handle, str);
		
	%----------------------
	% EXTENSION
	%----------------------
		
	otherwise
		
		%--
		% sync slider if needed
		%--
		
		if has_slider(callback.control.handles)
			slider_sync(obj, callback.control.handles);
		end
		
		%--
		% flash control to indicate callback
		%--
		
		% NOTE: consider hover fade behavior here
		
		control_flash(callback.control, callback.pal);

		%--
		% yield to extension callback function
		%--
		
		% TODO: handle control specific callback
		
		fun = feature.fun.parameter.control.callback;
		
		if ~isempty(fun)
			result = fun(callback, context);
		end
	
end

%--
% consider callback result
%--

% NOTE: the empty result is a default option

if ~isempty(result)
		
	% NOTE: return if results indicate no need for update
	
	if isfield(result, 'update') && ~result.update
		return;
	end
	
end

%--
% update display considering results
%--

update_parent_display(callback.pal.handle);


%-------------------------------------------------------------------------
% LOAD_PRESET
%-------------------------------------------------------------------------

function load_preset(obj, eventdata)

% load_preset - load preset parameters from file and update palette
% -----------------------------------------------------------------
%
% load_preset(obj, eventdata)
%
% Input:
% ------
%  obj - handle of callback object
%  eventdata - currently not used

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2173 $
% $Date: 2005-11-22 00:26:27 +0100 (Tue, 22 Nov 2005) $
%--------------------------------

%--
% get context
%--

[control, pal, par] = get_callback_context(obj);

%--
% get preset name
%--

[ignore, name] = control_update([], pal.handle, 'preset'); 

name = name{1};

% NOTE: return on special value, hard coded here and in palette creation

if (strcmp(name,'(Manual)'))
	return;
end

%--
% get extension
%--

% NOTE: consider parsing palette tag to get extension type

ext = get_extensions([], 'name', pal.name);

if isempty(ext)
	return;
end 

%--
% get preset by name
%--

preset = get_presets(ext, 'name', name);

if isempty(preset)
	return;
end

%--
% set palette controls
%--

% NOTE: all control values are stored in preset, some are not loaded

values = preset.control;

values = rmfield(values,{ ...
	'preset', ...
	'active' ...
});

set_control_values(pal.handle, values);

%--
% check for onload callbacks
%--

controls = get_field(get(pal.handle, 'userdata'), 'control');

onload = struct_field(controls, 'onload');

if any(onload)

	% TODO: onload may store an integer to indicate order
	
	for k = 1:length(onload)

		if onload(k)
			control_callback([],pal.handle,controls(k).name);
		end

	end

else
		
	% NOTE: this code is for backwards compatibility, perhaps include a message
	
	% TODO: this control callback update fails in a number of cases

	fields = fieldnames(values);

	for k = length(fields):-1:1

		flag = control_callback([],pal.handle,fields{k});

		if (flag)
			break;
		end

	end
	
end
	
%--
% update preset control
%--

% NOTE: this value is typically clobbered by the previous callback

control_update([],pal.handle,'preset',name);

%--
% update parent display if feature is active
%--

update_parent_display(pal.handle);


%-------------------------------------------------------------------------
% SHOW_NEW_PRESET
%-------------------------------------------------------------------------

% TODO: this way of producing dialogs should be abstracted

function show_new_preset(obj,eventdata)

% show_new_preset - show make preset interface
% --------------------------------------------
%
% show_new_preset(obj,eventdata)
%
% Input:
% ------
%  obj - handle of callback object
%  eventdata - currently not used

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2173 $
% $Date: 2005-11-22 00:26:27 +0100 (Tue, 22 Nov 2005) $
%--------------------------------

%--
% get control information
%--

pal = get(obj,'parent');

opt = get_field(get(pal,'userdata'),'opt');

%--------------------------------
% CREATE EDIT BOX
%--------------------------------

%--
% get preset control handles
%--
		
g = control_update([],pal,'preset',[]);

%--
% get normalized position of active popup
%--

tmp = findobj(g,'style','popupmenu');

units = get(tmp,'units');

set(tmp,'units','normalized');

pos = get(tmp,'position');

set(tmp,'units',units);

%--
% compute edit box and cancel positions
%--

pos(1) = pos(1) + 1/3 * pos(3);

pos(2) = pos(2) + pos(4);

pos(3) = 2/3 * pos(3);

% position depends on the palette size due to the normalized units

fac = opt.width - (opt.left + opt.right);

fac = 1 * (3 / (2 * fac));

pos2 = pos;

pos2(1) = pos(1) + pos(3) - fac*pos(3);

pos2(3) = fac*pos(3);

% shorten edit box to accomodate confirm button

pos(3) = pos(3) - pos2(3);

%--
% get last loaded preset name from control
%--

[ignore,value] = control_update([],pal,'preset');

value = value{1};

%--
% create edit control 
%--

uicontrol(pal, ...
	'style','edit', ...
	'units','normalized', ...
	'tag','new_preset_edit', ...
	'background',[1 1 1], ...
	'position', pos, ...
	'horizontalalignment','left', ...
	'fontunits','pixels', ...
	'fontsize',get(tmp,'fontsize'), ...
	'string',value ... % 'string','New Preset' ...
);

%--
% create confirm edit control
%--

% get a toggle text handle to provide the toggle text fontname

tmp = findobj(pal,'tag','header_toggle'); 

tmp = tmp(1);

uicontrol(pal, ...
	'style','pushbutton', ...
	'units','normalized', ...
	'tag','new_preset_confirm', ...
	'background',get(pal,'color'), ...
	'position', pos2, ...
	'horizontalalignment','left', ...
	'fontunits','pixels', ...
	'fontname',get(tmp,'fontname'), ...
	'fontsize',get(tmp,'fontsize') - 1, ...
	'string','+', ...
	'callback',@handle_new_preset ...
);

%--
% update button states buttons while editing
%--

control_update([],pal,'new_preset','__DISABLE__'); 


%-------------------------------------------------------------------------
% HANDLE_NEW_PRESET
%-------------------------------------------------------------------------

function handle_new_preset(obj,eventdata)

% handle_new_preset - handle new preset control
% ---------------------------------------------
%
% handle_new_preset(obj,eventdata)
%
% Input:
% ------
%  obj - handle of callback object
%  eventdata - currently not used

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2173 $
% $Date: 2005-11-22 00:26:27 +0100 (Tue, 22 Nov 2005) $
%--------------------------------

%--
% get context
%--

[control,pal,par] = get_callback_context(obj);

%--
% get extension
%--

ext = get_extensions([],'name',pal.name);

if (isempty(ext))
	return;
end

%--
% get proposed preset name
%--

obj_edit = findobj(pal.handle,'tag','new_preset_edit');

if (isempty(obj_edit))
	return;
end

name = strtrim(get(obj_edit,'string'));

%--
% check for cancel
%--

if (strcmp(get(obj,'string'),'-'))
	name = '';
end

% NOTE: delete edit and confirm, and enable new preset button

if (isempty(name))	
	delete([obj, obj_edit]); control_update([],pal.handle,'new_preset','__ENABLE__');
end

%--
% check whether preset name is proper filename
%--

if (~proper_filename(name))
	return;
end
	
%--
% update sound store
%--

% NOTE: encapsulate, although this code will not be needed in the future

if (~isempty(par.handle))
	
	data = get(par.handle,'userdata');
	
	data.browser.sound = sound_update(data.browser.sound,data);

	set(par.handle,'userdata',data);

end

%--
% create preset filename
%--

root = preset_dir(ext);

preset_file = [root, filesep, name, '.mat'];
				
%--
% check whether a preset with this name already exists if needed
%--

preset_files = get_field(what_ext(root,'mat'),'mat');

if (~isempty(preset_files))

	ix = find(strcmp(preset_files,[name, '.mat']));

	if ~isempty(ix)
		out = quest_dialog(['Would you like to overwrite preset ''', name, '''.'])
	end

end
	
%--
% create preset structure
%--

preset = preset_compile(name, pal.handle);

%--
% save preset file
%--

save(preset_file, 'preset');

% NOTE: we wait on the save

while ~exist(preset_file, 'file')
	pause(0.1);
end
	
%--
% update preset control
%--

presets = get_presets(ext);

str = struct_field(presets, 'name');

str = {'(Manual)', str{:}};

ix = find(strcmp(str, name));

g = findobj(pal.handle, 'tag', 'preset', 'style', 'popupmenu');

set(g, 'string', str, 'value', ix);
			
%--
% clean up
%--

% NOTE: delete edit and confirm controls and enable new preset button

delete([obj, obj_edit]); control_update([], pal.handle, 'new_preset', '__ENABLE__');




function update_parent_display(pal)

% update_parent_display - update parent display on feature state change
% --------------------------------------------------------------------
%
% par = update_parent_display(pal)
%
% Input:
% ------
%  pal - feature extension palette
%
% Output:
% -------
%  par - updated parent

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1474 $
% $Date: 2005-08-05 20:29:15 -0400 (Fri, 05 Aug 2005) $
%--------------------------------

% TODO: update this to include active detection update

% NOTE: previously this was achieved with the 'Scrollbar' callback

%--
% set default palette handle
%--

% NOTE: since this is usually called after updating a palette control it makes sense

if (nargin < 1)
	pal = gcf;
end

%--
% check for parent
%--

par = get_xbat_figs('child', pal);

if isempty(par)
	return;
end

%--
% get parent userdata
%--

data = get(par, 'userdata');

%--
% get relevant feature state information
%--

% NOTE: get palette feature from name

feature_name = get(pal, 'name'); 

% NOTE: get active features from parent

sound_feature = data.browser.sound_feature.active;

%--
% update parent if needed
%--

if strcmp(sound_feature, feature_name)
		
	% NOTE: this does not clear the browser selection
	
	browser_display(par, 'update', data);

end


function C = cell_union(A, B)

if ischar(A)
	A = {A};
end

if ischar(B)
	B = {B};
end

C = union(A, B);

for k = length(C):-1:1
	if isempty(C{k})
		C(k) = [];
	end
end

