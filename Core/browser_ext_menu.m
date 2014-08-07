function out = browser_ext_menu(par, type, label, opt)

% browser_ext_menu - generate extension access menus
% --------------------------------------------------
%
% browser_ext_menu(par, type, label, opt)
%
% opt = browser_ext_menu
%
% Input:
% ------
%  par - parent handle
%  type - extension type
%  label - menu label
%  opt - creation options
%
% Output:
% -------
%  opt - default creation options

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

% NOTE: this code does not make much sense, it is an amalgam of code that
% seemed relevant that has to be evaluated, made congruent, factored, etc.

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set and possibly output options
%--

if (nargin < 4) || isempty(opt)
	
	opt.active = 0; opt.open = 1; 
	
	if ~nargin
		out = opt; return;
	end 
	
end

%--
% set default label
%--

% NOTE: we normalize type, this also checks for proper type

type = type_norm(type);

% NOTE: consider replacing the space with a hyphen

if (nargin < 3) || isempty(label)
	label = title_caps(type);
end

%---------------------------------
% SETUP
%---------------------------------

%--
% get extensions of given type
%--

ext = get_extensions(type);

if isempty(ext)
	return;
end

%--
% create parent menu if needed
%--

if ~ishandle(par)
	return;
end

switch get(par, 'type')
	
	case 'figure', g = uimenu(par, 'label', label);
		
	case 'uimenu', g = par;
		
	case 'uicontextmenu', g = par;
		
	otherwise, error('Handle input needs to allow menu children.');
		
end

%--
% get parent figure
%--

par = ancestor(par, 'figure');

%---------------------------------
% CREATE MENUS
%---------------------------------

%--
% get extension category organization
%--

category = get_extension_categories(ext);

%--
% create active toggle menus
%--

if opt.active
	
	% TODO: consider active flag in extension

	act = uimenu(g, 'label', 'Active');

	% NOTE: here we use a flat organization, use all category

	for k = 1:length(category(1).children)

		name = category(1).children{k};

		uimenu(act, ...
			'label', name, ...
			'callback', {@ext_dispatch, par, type, name, 'active'} ...
		);

	end

end 

%--
% create category based open extension menus
%--

if opt.open
	
	for k = 1:length(category)

		%--
		% create category menus
		%--

		cat = uimenu(g, 'label', category(k).name);

		% NOTE: this separates the active menu from the category menus

		if opt.active && (k < 2)
			set(cat, 'separator', 'on');
		end

		%--
		% create children extension menus
		%--

		for j = 1:length(category(k).children)

			name = category(k).children{j};

			uimenu(cat, ...
				'label', [name, ' ...'], ...
				'callback', {@ext_dispatch, par, type, name, 'open'} ...
			);

		end

	end
	
end

%---------------------------------
% UPDATE EXTENSION REGISTRY
%---------------------------------

% NOTE: this will happen regardless of menu creation

%--
% get parent figure data
%--

data = get(par, 'userdata');

%--
% add list of active extensions, extension names, and actual extensions
%--

% NOTE: the extension struct storage can be leaner

data.browser.extensions.(type).active = {};

data.browser.extensions.(type).name = {ext.name}';

data.browser.extensions.(type).ext = ext;
	
%---------------------------------
% CREATE PALETTE REGISTRY
%---------------------------------

%--
% add palette list if needed
%--

handle = get_field(data.browser, 'palette.handle', []);

if isempty(handle)
	
	data.browser.palette.handle = [];
	
	data.browser.palette.state = [];
	
end

%--
% update parent data
%--

set(par, 'userdata', data);


%------------------------------------------------------------
% EXT_DISPATCH
%------------------------------------------------------------

function ext_dispatch(obj, event, par, type, name, str)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

%--
% get parent data
%--

data = get(par, 'userdata');

%--
% dispatch command
%--
	
% NOTE: dispatch switch consumes the command string

try
	
	switch (str)
		
		case 'active', ext_active(par, type, name, data);
			
		case 'open', ext_open(par, type, name, data); 
			
		otherwise, error('Unrecognized extension interface command.');
			
	end
	
catch
	
	xml_disp(lasterror);

end


%------------------------------------------------------------
% EXT_ACTIVE
%------------------------------------------------------------

function ext_active(par, type, name, data)


%------------------------------------------------------------
% EXT_OPEN
%------------------------------------------------------------

function ext_open(par, type, name, data)

%---------------------------------
% SETUP
%---------------------------------

%--
% check for open extension palette
%--

pal = get_palette(par, name, data);

if ~isempty(pal)
	position_palette(pal, par, 'center'); return;
end

%--
% get extension by name
%--

ext = get_extensions(type, 'name', name);

if isempty(ext)
	return;
end

%--
% get registry copy of extension
%--

ix = find(strcmp(name, data.browser.extensions.(type).name));

if isempty(ix)
	return;
end

%--
% get preset names
%--

% TODO: develop efficient 'get_preset_names'

% ALSO: consider duplicate preset name storage

presets = get_presets(ext);

if ~isempty(presets)
	presets = {presets.name}';
end

%------------------------------------------------------
% TYPE CONTROLS
%------------------------------------------------------

%--
% get extension type controls
%--

% TODO: produce common type controls as well as specific type controls

% ALSO: specific controls include compute and display controls

try
	control = feval([type, '_controls'], ext, presets);
catch
	xml_disp(lasterror);
end


% control = set_callback(control,{@ext_control_callback, ext});

% TODO: separate common control generation to separate function


%------------------------------------------------------
% EXTENSION CONTROLS
%------------------------------------------------------

% TODO: encapsulate this pattern

%--
% get extension compute parameters
%--

context = [];

parameter = [];

if ~isempty(ext.fun.parameter.create)
	
	try
		parameter = ext.fun.parameter.create(context);
	catch
		extension_warning(ext, 'Failed to create parameters.', lasterror);
	end
	
end

%--
% get extension compute controls
%--

ext_controls = [];

if ~isempty(ext.fun.parameter.control.create)
	
	try
		ext_controls = ext.fun.parameter.control.create(parameter, context);
	catch
		extension_warning(ext, 'Failed to create parameter controls.', lasterror);
	end
	
end

%--
% remove preset controls if the extension has no controls
%--

% NOTE: remove all controls under preset header


% NOTE: at the moment we remove a header, a listbox, and a button

if isempty(ext_controls)
	control = control(4:end);
end

%--
% append extension specific controls to controls array
%--

if ~isempty(ext_controls)

	%-----------------------------------
	% PARAMETERS
	%-----------------------------------

	control(end + 1) = control_create( ...
		'string', 'Parameters', ...
		'style', 'separator', ...
		'type', 'header' ...
	);

	%--
	% adjust space after parameter header based on following control
	%--

	switch (ext_controls(1).style)

		case ('separator') 
			
			if (~isempty(ext_controls(1).string))
				control(end).space = 1.25;
			end

		case ('tabs'), control(end).space = 0.12;

		case ('popup'), control(end).space = 0.5;

	end

	%--
	% set extension control callbacks
	%--

	% NOTE: route extension specific callbacks through dispatch

	for k = 1:length(ext_controls)

		if (isempty(ext_controls(k).callback))
			ext_controls(k).callback = {@ext_control_callback,ext};
		end

	end

	%--
	% concatenate common controls and specific controls
	%--

	control = [control, ext_controls];

end

%--------------------------------------------------
% COLOR CODE PALETTE SEPARATORS
%--------------------------------------------------

%--
% get extension highlight color
%--

color = get_extension_color(ext);

%--
% add highlight to separators
%--

ix = find(strcmp(struct_field(control,'style'),'separator'));

for k = 1:length(ix)
	
	if (~isempty(control(ix(k)).string))
		control(ix(k)).color = color;
	end
	
end

%--------------------------------------------------
% CREATE PALETTE
%--------------------------------------------------

%--
% configure palette construction
%--

opt = control_group;

opt.width = 8; % NOTE: may need to be larger to display name

opt.left = 1; opt.right = 1; % NOTE: one tile margins

opt.top = 0; opt.bottom = 0; % NOTE: header starts and extension sets bottom

%--
% create and register palette
%--

pal = control_group(par,'',name,control,opt);

if (isempty(pal))
	return;
end

register_palette(par,pal);

%--
% set tag and palette close request
%--

set(pal, ...
	'tag', ['XBAT_PALETTE::', upper(type), '::', name] ...
);

% TODO: add update of extension state in parent as part of close

set(pal, ...
	'closerequestfcn',@unregister_palette ...
);

%--
% set parent close request if default value
%--

if (isequal(get(par,'closerequestfcn'),'closereq'))
	set(par, ...
		'closerequestfcn',@close_palettes ...
	); 
end 


% 
% %--------------------------------------------------
% % UPDATE PALETTE CONTROLS
% %--------------------------------------------------
% 
% % TODO: the logic of this code needs to be reviewed
% 
% %--
% % update palette controls to reflect current state of palette
% %--
% 
% % NOTE: we remove the value of active since things could have changed
% 
% values = ext.control;
% 
% preset_name = [];
% 
% if (~isempty(values))
% 
% 	if (isfield(values,'preset'))
% 
% 		preset_name = values.preset;
% 
% 		values = rmfield(values,{ ...
% 			'preset', ...
% 			'active' ...
% 		});
% 
% 	else
% 
% 		values = rmfield(values,{ ...
% 			'active' ...
% 		});
% 
% 	end
% 
% 	set_control_values(pal,values);
% 
% end
% 
% %--------------------------------------------------
% % PERFORM ONLOAD CALLBACK(S)
% %--------------------------------------------------
% 
% % TODO: factor this to use for all extensions and preset loaders
% 
% % TODO: order 'onload' callbacks by making value a position
% 
% %--
% % check for onload callbacks
% %--
% 
% if (~isempty(ext_controls))
% 
% 	onload = struct_field(ext_controls,'onload');
% 
% 	if (any(onload))
% 
% 		for k = 1:length(onload)
% 
% 			if (onload(k))
% 				control_callback([],pal,ext_controls(k).name);
% 			end
% 
% 		end
% 
% 	else
% 
% 		% NOTE: this is older code kept for backwards compatibility
% 
% 		% NOTE: previously the first callback success would set state
% 
% 		flag = 0;
% 
% 		for k = 1:length(ext_controls)
% 
% 			try	
% 				flag = control_callback([],pal,ext_controls(k).name);
% 			end
% 
% 			if (flag)
% 				break;
% 			end
% 
% 		end
% 
% 	end
% 
% end
% 
% %--
% % reset preset control
% %--
% 
% % NOTE: the stored value is typically cloberred by previous callback
% 
% if (~isempty(preset_name))
% 	control_update([],pal,'preset',preset_name);
% end
% 
% %--------------------------------------------------
% % POSITION FILTER PALETTE
% %--------------------------------------------------
% 
% %--
% % update palette state
% %--
% 
% set(pal,'visible','off');
% 
% %--
% % update state of palette if available
% %--
% 
% % TODO: package this into a function
% 
% if (~isempty(data.browser.palette_states))
% 
% 	names = struct_field(data.browser.palette_states,'name');
% 
% 	ix = find(strcmp(names,name));
% 
% 	if (~isempty(ix))
% 
% 		%--
% 		% reload saved palette state
% 		%--
% 
% 		set_palette_state(pal,data.browser.palette_states(ix));
% 
% 	else
% 
% 		%--
% 		% set default state for detector palettes
% 		%--
% 
% 		position_palette(pal,par,'center');
% 
% 		palette_toggle(par,name,'Presets','close',data);
% 
% 	end
% 
% else
% 
% 	%--
% 	% set default state for detector palettes
% 	%--
% 
% 	position_palette(pal,par,'center');
% 
% 	palette_toggle(par,name,'Presets','close',data);
% 
% end
% 
% set(pal,'visible','on');
% 
% %--
% % output palette handle
% %--
% 
% out = pal;
% 
% %--------------------------------------------------
% % ATTACH DEVELOPER MENU
% %--------------------------------------------------
% 
% % NOTE: this is causing some distortion in the size of the first header
% 
% % TODO: update open menu to include the various files
% 
% pal_menu(pal,[],ext.subtype); set(pal,'dockcontrols','off');


%-------------------------------------------------------------------------
% FILTER_DISPATCH
%-------------------------------------------------------------------------

function ext_control_callback(obj,eventdata,ext)

% ext_control_callback - extension callback
% -----------------------------------------------
%
% ext_control_callback(obj,eventdata,ext)
%
% Input:
% ------
%  obj - callback object handle
%  eventdata - unused at the moment
%  ext - extension

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2080 $
% $Date: 2005-11-07 19:05:34 -0500 (Mon, 07 Nov 2005) $
%--------------------------------

%--
% get callback context from handle
%--

[control,pal,par] = get_callback_context(obj); 
		
result = [];

%--
% compute callback based on control
%--

switch control.name
		
	%----------------------
	% PRESET
	%----------------------
	
	%--
	% Preset
	%--
	
	case 'preset'
				
		% TODO: make robust and output status
				
		load_preset(obj,eventdata); return;
	
	%--
	% New Preset
	%--
	
	case 'new_preset'
		
		% TODO: consider using new modal dialog framework
		
		show_new_preset(obj,eventdata); return;
		
	%----------------------
	% FILTER
	%----------------------
		
	%--
	% Opacity
	%--
	
	case 'opacity'
				
		%--
		% sync and flash to indicate update
		%--
		
		% NOTE: we could move flash to the sync level, flash could be moved elsewhere
		
		slider_sync(obj,control.handles);

		control_flash(control,pal);

	%--
	% Active
	%--
	
	% NOTE: toggle active state for extension
	
	case 'active'
				
		%--
		% handle control value
		%--
		
		% NOTE: set opacity state and command string
  		
		if (get(obj,'value') == 1)
			name = pal.name; 
		else
			name = 'No Filter'; 
		end
		
		%--
		% update active extension state
		%--
				
		browser_filter_menu(par.handle,name);
		
	%----------------------
	% EXTENSION
	%----------------------
		
	otherwise
		
		%--
		% flash controls to indicate update
		%--

		% NOTE: this is something that comes with callback routing
		
		control_flash(control,pal);

		%--
		% yield to extension callback function
		%--
		
		fun = ext.fun.parameter.control.callback;
				
		if ~isempty(fun)
			result = fun(obj,eventdata);
		end
				
		%--
		% update preset control
		%--

		% TODO: this model for preset 'documents' needs to be reconsidered

		% NOTE: this sets the preset control to display '(Manual)'
		
		control_update([],pal.handle,'preset',1);
	
end

%--
% consider callback result
%--

% NOTE: the empty result is a default option

if ~isempty(result)
		
	% NOTE: return if results indicate no need for update
	
	if ~result.update
		return;
	end
	
end

%--
% update display considering results
%--

% update_parent_display(pal.handle);

