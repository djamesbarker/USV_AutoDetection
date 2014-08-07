function out = browser_detect_menu(par, str)

% browser_detect_menu - create menus for available detectors
% ----------------------------------------------------------
%
% out = browser_detect_menu(par, str)
%
% Input:
% ------
%  par - parent browser handle
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

%---------------------------------
% SETUP
%---------------------------------

%--
% set default output
%--

out = [];

%--
% get available detectors
%--

% NOTE: consider returning if there are no detectors

DET = get_extensions('sound_detector');

if ~isempty(DET)
	DET_NAME = {DET.name}';
end

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set command string
%--

if nargin < 2
	str = 'Initialize';
end

%--
% check parent
%--

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

%--
% get parent userdata
%--

data = get_browser(par);
	
%---------------------------------
% COMMAND SWITCH
%---------------------------------

switch str
	
%---------------------------------
% INITIALIZE
%---------------------------------

case 'Initialize'

	%--
	% check for existing detector menu
	%--
	
	if get_menu(par, 'Detect')
		return;
	end
		
	%---------------------------
	% DETECT
	%---------------------------
	
	%--
	% create detector menu labels
	%--
	
	detectors = strcat(DET_NAME(:), ' ...');
	
	if ischar(detectors)
		tmp = {detectors}; 
	end
	
	%--
	% create menu
	%--
	
	L = { ... 
		'Detect', ...
		'Active', ...
		detectors{:} ...
	};
	
	n = length(L); S = bin2str(zeros(1, n)); S{3} = 'on';
	
	menus = menu_group(par, 'browser_detect_menu', L, S);
	
	%--
	% set menu position
	%--
	
	set(menus(1), 'position', 7);
	
	%---------------------------
	% ACTIVE
	%---------------------------
	
	%--
	% select active detectors
	%--
	
	if (length(DET) > 1)
		ix = find(struct_field(DET, 'active'));
	else
		ix = DET.active;
	end
		
	DET_ACTIVE = DET_NAME(ix);
	
	%--
	% create menu
	%--
	
	L = { ...
		'No Detection', ...
		DET_ACTIVE{:} ...
	};

	n = length(L); S = bin2str(zeros(1, n)); S{2} = 'on';
	
	menus = menu_group(get_menu(menus, 'Active'), 'browser_detect_menu', L, S);
	
	set(get_menu(menus, 'No Detection'), 'check', 'on');
	
	%--
	% update detector store
	%--
	
	data = update_extension_store(data, 'sound_detector');
	
	%--
	% set browser state
	%--
	
	set(par, 'userdata', data);
	
%---------------------------------
% ACTIVE DETECTION
%---------------------------------

% NOTE: these menus have detector name labels

case {'No Detection', DET_NAME{:}}
	
	%--
	% set active detection state
	%--
	
	% NOTE: the active detection state is indicated by the detector name
	
	switch str
		
		case 'No Detection', data.browser.sound_detector.active = '';
		
		otherwise, data.browser.sound_detector.active = str;
			
	end
	
	%--
	% update active detection menu
	%--
			
	top = findobj(par, ...
		'type', 'uimenu', ...
		'label', 'Detect', ...
		'parent', par ...
	);
	
	child =  get(get_menu(top, 'Active'), 'children');
	
	set(child, 'check', 'off'); set(get_menu(child, str), 'check', 'on');
	
	%--
	% update browser state
	%--
	
	set(par, 'userdata', data);
	
	%--
	% update active detection controls in open detector palettes
	%--
	
	update_active_controls(par, 'sound_detector', data.browser.sound_detector.active, data);
	
	%-- 
	% stop marching ants daemon and close view
	%--
	
	% NOTE: this is a timing issue and this is not the correct way to handle this
	
	daemon = timerfind('name', 'XBAT Marching Ants');
	
	if ~isempty(daemon)
		stop(daemon); delete(daemon);
	end
		
	% TODO: this will require extension input
	
	close_view(par);
	
	%--
	% update display
	%--
	
	browser_view_menu(par, 'scrollbar');
	
%------------------------------------------------------------------
%------------------------------------------------------------------
% DETECTOR PALETTE
%------------------------------------------------------------------
%------------------------------------------------------------------

% NOTE: these menus have detector name and dots as labels

case strcat(DET_NAME, ' ...')
	
	%--
	% parse command string
	%--
	
	% NOTE: remove trailing space and periods from command string
	
	str = str(1:end - 4);
	
	%--
	% check for open palette and update position 
	%--
	
	% NOTE: output palette handle
	
	pal = get_palette(par, str, data);
	
	if ~isempty(pal)
		position_palette(pal, par, 'center'); return;
	end
	
	%--------------------------------------------------
	% GET EXTENSION
	%--------------------------------------------------
	
	%--
	% get detector extension
	%--
	
	ext = get_browser_extension('sound_detector', par, str, data);
	
	%--
	% get preset names
	%--
		
	% TODO: get preset names function so we don't have to load full preset
	
	presets = get_presets(ext);
	
	if ~isempty(presets)
		preset_names = struct_field(presets, 'name');
	else
		preset_names = [];
	end

	%--------------------------------------------------
	% COMMON CONTROLS
	%--------------------------------------------------

	%--
	% detection header and tabs
	%--
	
	control(1) = control_create( ...
		'style', 'separator', ...
		'type', 'header', ...
		'space', 0.11, ...
		'string', 'Detect' ...
	);
	
	tabs = { ...
		'Active', ...
		'Scan' ...
	};

	control(end + 1) = control_create( ...
		'style', 'tabs', ...
		'tab', tabs, ...
		'name', 'Scan Tabs' ...
	);

	
	%--
	% active
	%--
	
	if strcmp(data.browser.sound_detector.active, ext.name)
		active_state = 1;
	else
		active_state = 0;
	end
	
	control(end + 1) = control_create( ...
		'name', 'active', ...
		'alias', 'On', ...
		'tab', tabs{1}, ...
		'style', 'checkbox', ...
		'callback', '', ...
		'space', 1, ...
		'value', active_state, ...
		'tooltip', 'Enable detector as active detector' ...
	);

	%--
	% view
	%--
	
	if strcmp(data.browser.sound_detector.active, ext.name)
		value = 1;
	else
		value = 0;
	end

	if can_explain(ext)
		
		control(end + 1) = control_create( ...
			'name', 'explain', ...
			'tab', tabs{1}, ...
			'style', 'checkbox', ...
			'callback', '', ...
			'space', 1.25, ...
			'value', value, ...
			'tooltip', 'Display active detector view' ...
		);

	end

	if xbat_developer
		
		offset = 0.5 * 0.75;

		control(end + 1) = control_create( ...
			'style', 'separator', ...
			'tab', tabs{1}, ...
			'space', 1 + offset ...
		);
	
		control(end + 1) = control_create( ...
			'name', 'debug', ...
			'tab', tabs{1}, ...
			'alias', 'DEBUG', ...
			'style', 'checkbox' ...
		);
	
		control(end).space = -(1 + offset);
		
		control(end + 1) = control_create( ...
			'name', 'refresh', ...
			'tab', tabs{1}, ...
			'alias', 'REFRESH', ...
			'style', 'buttongroup', ...
			'align', 'right', ...
			'lines', 1.75, ...
			'width', 0.5, ...
			'callback', {@filter_dispatch, ext} ... % TODO: update this callback
		);

	end

	%--
	% get default meta-scan
	%--

	sound = data.browser.sound;
	
	scan = scan_create(0, get_sound_duration(sound), get_default_page_duration(sound));
	
	control(end + 1) = control_create( ...
		'name', 'scan_view', ...
		'alias', 'tiles', ...
		'style', 'listbox', ...
		'tab', tabs{2}, ...
		'lines', 1, ...
		'space', 0.1, ...
		'string', scan_info_str(scan), ...
		'value', 1 ...
	);

	control(end + 1) = control_create( ...
		'style', 'buttongroup', ...
		'tab', tabs{2}, ...
		'name', 'Edit ...', ...
		'lines', 1.5, ...
		'width', 0.4, ...
		'space', -0.25, ...
		'align', 'right' ...
	);

	%--
	% output log
	%--
	
	% TODO: this should be a function
	
	if isempty(data.browser.log)
				
		L = {'(No Open Logs)'};
		
		aix = 1;
		
	else
				
		[L, ix] = sort(file_ext(struct_field(data.browser.log, 'file'))); % logs are sorted as in other controls
				
		aix = find(ix == data.browser.log_active);
				
	end
	
	control(end + 1) = control_create( ...
		'name', 'output_log', ...
		'tab', tabs{2}, ...
		'layout', 'normal', ...
		'type', 'slider_length', ...
		'tooltip', 'Log to output detections to', ...
		'style', 'popup', ...
		'space', 1.5, ...
		'lines', 1, ...
		'string', L, ...
		'value', aix ...
	);

	%--
	% scan
	%--
	
	control(end + 1) = control_create( ...
		'name', 'scan', ...
		'alias', 'start', ...
		'tab', tabs{2}, ...
		'style', 'buttongroup', ...
		'width', 1, ...
		'align', 'right', ...
		'space', 1.5, ...
		'lines', 1.75, ...
		'tooltip', ['Begin persistent detection scan'] ...
	);

	%--------------------------------------
	% DETECTOR CONTROLS
	%--------------------------------------

	%--
	% get detector controls from extension
	%--
	
	if ~isempty(ext.fun.parameter.control.create)
		
		%--
		% compile context
		%--
		
		context.sound = data.browser.sound; context.ext = ext;
		
		%--
		% get extension parameters
		%--
		
		% NOTE: create parameters if needed before controls
		
		if isempty(ext.parameter) && ~isempty(ext.fun.parameter.create)
			
			try
				ext.parameter = ext.fun.parameter.create(context);
			catch 
				extension_warning(ext, 'Parameter creation failed.', lasterror);
			end
			
		end
		
		%--
		% create extension controls
		%--
		
		detector_controls = empty(control_create);
		
		try
			detector_controls = ext.fun.parameter.control.create(ext.parameter, context);
		catch
			extension_warning(ext, 'Parameter control creation failed.', lasterror);
		end
		
		%--
		% add detection controls if needed
		%--
		
		if ~isempty(detector_controls)
			
			%--
			% add header to detector controls section
			%--

			control(end + 1) = control_create( ...
				'string', 'Parameters', ...
				'style', 'separator', ...
				'type', 'header' ...
			);

			% NOTE: set spacing of header based on detector controls

			control(end) = adjust_control_space(control(end), detector_controls(1));

			%--
			% concatenate common controls and detector specific controls
			%--

			control = [control, detector_controls];
		
		end
		
	end

	%--------------------------------------------------
	% DETECTOR PALETTE OPTIONS
	%--------------------------------------------------
	
	if ~isempty(ext.fun.parameter.control.options)
		
		opt = control_group;
		
		try
			opt = struct_update(opt, ext.fun.parameter.control.options(context));
		catch
			extension_warning(ext, 'Parameter control options failed.', lasterror);
		end

	else

		%--
		% set control group options
		%--

		% provide a way for extensions to communicate these

		opt = control_group;

		opt.width = 12; % helps to display detector name

		opt.top = 0; % header starts palette

		opt.bottom = 0; % detector controls determine bottom margin

		opt.handle_to_callback = 1;

	end
	
	opt.ext = ext;
	
	opt.header_color = get_extension_color(ext);
	
	%--------------------------------------------------
	% DETECTOR PALETTE
	%--------------------------------------------------
	
	%--
	% create palette
	%--
	
	pal = control_group(par, @extension_dispatch, str, control, opt);
	
	%--
	% set palette properties
	%--
	
	% NOTE: set palette tag, key press, and close request function
	
	% control values are updated in parent as part of close request function
	
	set(pal, ...
		'keypressfcn', {@browser_keypress_callback, par}, ...
		'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');'] ...
	);
	
	%--
	% register palette with parent and set parent windowbuttondown function
	%--
		
	n = length(data.browser.palettes);
	
	data.browser.palettes(n + 1) = pal;
	
	set(par, ...
		'userdata',data, ...
		'buttondown','browser_palettes(gcf,''Show'');' ...
	);
	
	%--------------------------------------------------
	% UPDATE PALETTE CONTROLS
	%--------------------------------------------------
	
	%--
	% update palette controls to reflect previous state of palette
	%--
	
	% control values are part of saved state not tab selections or toggles
	
	values = ext.control;
	
	if ~isempty(values)
		set_control_values(pal, values);
	end
	
	%--
	% update enabled state of output log control
	%--
	
	if isempty(data.browser.log)
		
		control_update([], pal, 'output_log', '__DISABLE__'); 
		
		control_update([], pal, 'scan', '__DISABLE__');
		
	end
	
	%--
	% update enabled state of active detection control
	%--
	
	if ~ext.active
		control_update([], pal, 'active', '__DISABLE__');
	end
		
	%--
	% position palette
	%--
	
	position_browser_palette(par, pal, data);
	
end


%-------------------------------------------------------------------------
% EXTENSION_DISPATCH
%-------------------------------------------------------------------------

function extension_dispatch(obj, eventdata)

%--
% get callback context and default output
%--

callback = get_callback_context(obj, 'pack'); result = [];

%--
% get fresh extension
%--

[ext, ix, context] = get_browser_extension('sound_detector', callback.par.handle, callback.pal.name);

%----------------------------
% CALLBACKS
%----------------------------

switch callback.control.name
		
	%----------------------
	% COMMON CONTROLS
	%----------------------

	%----------------------
	% REFRESH
	%----------------------
	
	case 'refresh'
		
		disp('refresh'); return;
		
		% TODO:  get sufficient context, the dispatcher should get more
		% context
		
% 		refresh_extension(callback, context);
		
	%--
	% DETECTION
	%--
	
	case 'scan_view', result.update = 0;
		
	%--
	% toggle active detection
	%--
	
	case 'active'
		
		if get(callback.obj,'value') == 1
			str = callback.pal.name; 
		else
			str = 'No Detection'; 
		end
				
		browser_detect_menu(callback.par.handle, str);
	
	%--
	% toggle active view
	%--
	
	case 'view'
		
		if get(callback.obj, 'value') == 0
			close_view(callback.par.handle); result.update = 0;
		end
	
	%--
	% set output log for persistent scan
	%--
	
	case 'output_log'
	
		% NOTE: there is no real callback for this case at the moment
		
		result.update = 0;
		
	%--
	% perform persistent scan
	%--
	
	case 'scan'
		
		perform_detector_scan(callback, ext);
		
	%--
	% edit scan interval
	%--
		
	case 'Edit ...'
		
		%--
		% get sound and scan string
		%--
		
		sound = get_browser(callback.par.handle, 'sound');
		
		han = get_control(callback.pal.handle, 'scan_view', 'handles');
		
		scan_str = get(han.obj, 'string');
		
		%--
		% edit scan string
		%--
		
		scan = scan_edit_dialog(sound, parse_time_interval(scan_str));
		
		if isempty(scan)
			return;
		end
		
		str = scan_info_str(scan);
		
		set(han.obj, 'string', str, 'value', 1);
		
		
	%----------------------
	% EXTENSION CONTROLS
	%----------------------
		
	otherwise

		%--
		% yield to extension callback function
		%--
		
		fun = ext.fun.parameter.control.callback;
		
		if ~isempty(fun)	
			try
				result = fun(callback, context);
			catch
				extension_warning(ext, 'Parameter control callback failed.', lasterror);
			end
		end
		
end

%--
% skip update if detection is off
%--

if ~get_control(callback.pal.handle, 'active', 'value')
	return;
end

%--
% consider callback result
%--

% NOTE: the empty result is a default option

if ~isempty(result)
	
	%--
	% return if update is not required
	%--
	
	if isfield(result, 'update') && ~result.update
		return;
	end
	
end

%--
% update display 
%--

browser_view_menu(callback.par.handle, 'scrollbar');


%-------------------------------------------------------------------------
% CLOSE_EXPLAIN
%-------------------------------------------------------------------------

function close_view(par)

% TODO: add extension to input to handle multiple extensions viewing 
	
%--
% find and delete view figure with parent
%--

% TODO: get figure by tag and close, this requires a different signature

handle = get_xbat_figs( ...
	'parent', par, 'type', 'explain' ...
);

delete(handle);


%-------------------------------------------------------------------------
% PERFORM_DETECTOR_SCAN
%-------------------------------------------------------------------------

function perform_detector_scan(callback, ext)

%--
% unpack callback
%--

pal = callback.pal; par = callback.par;

%--------------------------------
% SETUP
%--------------------------------

%--
% get sound and channels
%--

data = get_browser(par.handle);

sound = data.browser.sound; channels = get_channels(data.browser.channels);

%--
% get scan
%--

%--
% get user scan from palette
%--

handles = get_control(pal.handle, 'scan_view', 'handles'); 

user_scan = parse_time_interval(get(handles.obj, 'string'));

user_scan = scan_create(user_scan.start, user_scan.stop, get_default_page_duration(sound));

%--
% intersect user scan with session scan
%--

scan = scan_intersect(user_scan, get_sound_scan(sound));

% NOTE: we disregard time stamps while reading

sound.time_stamp = [];

%--
% get output log
%--

output_log = get_control(pal.handle, 'output_log', 'value');

if iscell(output_log)
	output_log = output_log{1};
end

[log, pos] = get_browser_logs(par.handle, 'name', output_log);

%--------------------------------
% DETECT
%--------------------------------

%--
% pack context
%--

context = detector_context(ext, sound, scan, channels, log, par.handle, data);

%--
% scan and update log
%--

data.browser.log(pos) = detector_scan(context);

% NOTE: next two lines are still needed, they are old

set(par.handle, 'userdata', data);

browser_display(par.handle);
