function h = browser(f, varargin)

% browser - sound browsing interface
% ----------------------------------
%
% browser(f, t, dt, ch)
%
% Input:
% ------
%  f - sound structure or type of sound to browse
%  t - initial time in seconds
%  dt - duration of display in seconds
%  ch - channels to view (def: selection dialog if channels > 2)
%
% Output:
% -------
%  h - handle to browser figure

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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%------------------------------------------------------
% INITIALIZE
%------------------------------------------------------

% TODO: move to startup script

%--
% display splash screen the first time and set root
%--

% if isempty(get_env('xbat_root'))
% 	splash_image(select_splash, 1.5);
% end

xbat_root;

%--
% turn off divide by zero warning
%--

warning off MATLAB:divideByZero

%------------------------------------------------------
% HANDLE INPUT
%------------------------------------------------------

%--
% handle variable sound type input
%--

if ischar(f)

	%--
	% check sound type string
	%--
	
	[ignore, f] = is_sound_type(f);
	
	if isempty(f)
		error('Unrecognized sound type input.');
	end
	
	%--
	% load or create sound
	%--
	
	if strcmp(f, 'Sound')
		f = sound_load; 
	else
		f = sound_create(f);
	end
	
	%--
	% return if no sound is available
	%--
	
	if isempty(f)
		h = []; return;	
	end
	
%--
% check sound structure 
%--

elseif isstruct(f)

	%--
	% check sound type field and set input mode
	%--
	
	[ignore, type] = is_sound_type(f.type);
	
	if isempty(type)
		error('Unrecognized sound type.');
	end

%--
% workspace variable
%--

elseif isnumeric(f)
	
	var = find_in_workspace(f);
	
	%--
	% create temporary workspace variable if needed
	%--
	
	if isempty(var)
		var.name = 'TEMP'; assignin('base', var.name, f); 
	end
	
	f = sound_create('variable', var.name);
	
%--
% improper sound input
%--	
	
else

	error('Input must be of a proper string or structure.');
	
end

%------------------------------------------------------
% SETUP
%------------------------------------------------------

%--
% get user and library context
%--

user = get_active_user;

lib = get_active_library(user);

tag = browser_tag(f, lib, user);

name = browser_name(f);

%------------------------------------------------------
% CREATE BROWSER
%------------------------------------------------------

%--
% create browser 
%--

browser = browser_create(f, varargin{:});

% NOTE: browser is empty only if sound creation was cancelled

if isempty(browser)
	h = []; return;
end

%--
% declare that we are opening sound
%--

sound_is_open(tag);

%--
% stop scrolling daemon
%--

stop(scrolling_daemon);

%--
% create figure
%--

if (nargin < 5)
	h = figure;
end

%--
% get existing userdata in case something is already stored there
%--

data = get(h, 'userdata');

data.browser = browser;

%--
% set figure properties
%--

% NOTE: a buttondown function is not needed, this is handled by  the palette daemon timer

set(h, ...
	'name', name, ...
	'tag', tag, ...
	'doublebuffer', 'on', ...
	'numbertitle', 'off', ...
	'buttondown', 'browser_palettes(gcf,''Show'');', ...
	'userdata', data ...
);

%--
% declare sound is open
%--

% NOTE: we do this because we have a properly tagged figure to answer this question

sound_is_open(h);

%--
% annotation related fields
%--

[ANNOT, ANNOT_NAMES] = get_annotations('update');

data.browser.annotation.annotation = ANNOT;

data.browser.annotation.name = ANNOT_NAMES;

data.browser.annotation.view = ANNOT_NAMES;

data.browser.annotation.active = '';

%--
% measurement related fields
%--

[MEAS, MEAS_NAMES] = get_measurements(h, 'update');

data.browser.measurement.measurement = MEAS;

data.browser.measurement.name = MEAS_NAMES;

data.browser.measurement.view = MEAS_NAMES;

data.browser.measurement.active = '';

set(h, 'userdata', data);

%--
% create separator using axes
%--

% NOTE: the separator is not needed newer versions

tmp = eval(strtok(version, '.'));

if (tmp < 7)
	
	tmp = axes('position', [0,1,1,0.01]);

	set(tmp, ...
		'xcolor', color_to_rgb('Gray'), 'xtick', [], ...
		'ycolor', color_to_rgb('Gray'), 'ytick', [], ...
		'hittest', 'off', ...
		'tag', 'Separator' ...
	);

%--
% create toolbar
%--

% NOTE: this is only available in later matlab versions

else
	
	%--
	% turn off docking controls
	%--
	
	set(h, 'dockcontrols', 'off');
	
	%--
	% create toolbar
	%--
	
	% it is not clear which controls should appear in this toolbar
	
end

%---------------------------------------------
% STATUS BAR
%---------------------------------------------

%--
% create status bar using axes
%--

status_axes = axes( ...
	'parent', h, ...
	'position', [0,0,1,0.1] ...
);

set(status_axes, ...
	'color', get(0, 'defaultuicontrolbackgroundcolor'), ...
	'xcolor', color_to_rgb('Gray'), 'xtick',[], 'xlim', [0,1], ...
	'ycolor', color_to_rgb('Gray'), 'ytick',[], 'ylim', [0,1], ...
	'xaxislocation', 'top', ...
	'tag', 'Status' ...
);

data.browser.status = status_axes;

%--
% add text objects to left and right of status bar
%--

tmp = text( ...
	'parent', status_axes, ...
	'position', [0,0.5,0], ...
	'string', '' ...
);

set(tmp, ...
	'color', get(0, 'defaultuicontrolforegroundcolor'), ...
	'margin', 1, ...
	'horizontalalignment', 'left', ...
	'verticalalignment', 'middle', ...
	'tag', 'Status_Text_Left' ...
);

data.browser.status_left = tmp;

rel = ver('matlab'); rel = rel.Version;

tmp = text( ...
	'parent', status_axes, ...
	'position', [0.75,0.5,0], ...
	'string', ['XBAT  ', xbat_version, '  MATLAB  ', rel] ...
);

set(tmp, ...
	'color', get(0, 'defaultuicontrolforegroundcolor'), ...
	'margin', 1, ...
	'horizontalalignment', 'left', ...
	'verticalalignment', 'middle', ...
	'tag', 'Status_Text_Right' ...
);

data.browser.status_right = tmp;

%--
% produce browser display and update userdata
%--

% NOTE: that we save the state so we can call display

set(h, 'userdata', data);

[ax, im, sli] = browser_display(h, 'create', data);

% NOTE: the display creates a set of handles that are stored in the state

data.browser.axes = ax;

data.browser.images = im;

data.browser.slider = sli;

set(h, 'userdata', data); 

%--
% setup interface menus
%--

browser_file_menu(h);

browser_edit_menu(h);

browser_view_menu(h);

browser_sound_menu(h);

browser_filter_menu(h); 

% NOTE: not implemented yet

browser_feature_menu(h);

browser_detect_menu(h);

browser_log_menu(h);

browser_annotate_menu(h);

browser_measure_menu(h);

browser_window_menu;

browser_help_menu(h); % in progress

new_extension_menu(h);

browser_svn_menu(h);

%--
% set key bindings
%--

set(h, 'keypressfcn', @browser_keypress_callback);

%--
% set resize function
%--

browser_resizefcn(h);

%--
% ensure window is not accidentaly closed (does not protect from delete)
%--

set(h, 'closerequestfcn', 'browser_file_menu(gcf,''Close'');');

%--
% display colorbar and try to display actual size
%--

browser_view_menu(h, 'Colorbar');

browser_window_menu(h, 'Half Size');

%--
% update sound in library
%--

% NOTE: we try to update the sound, otherwise add it to the current library

% NOTE: tag information determine which library to save to

if ~ismember(f.type, {'variable', 'synthetic'})
	browser_sound_save(h);
end

%--
% update palette display
%--

browser_palettes(h, 'Show');

%--
% start daemons if needed
%--

name = { ...
	'XBAT Browser Daemon', ...
	'XBAT Scrolling Daemon', ...
	'XBAT Jogging Daemon' ...
};

fun = { ...
	@browser_daemon, ... 
	@scrolling_daemon, ...
	@jogging_daemon ...
};

% NOTE: run existing daemons, creates and run missing ones

for k = 1:length(name)
	timer_run(name{k}, fun{k});
end
