function browser = browser_create(sound, t, dt, fo, ch)

% browser_create - create browser data structure
% ----------------------------------------------
%
% browser = browser_create(sound, t, dt, fo, ch)
%
% Input:
% ------
%  sound - sound structure or sound type
%  t - initial time
%  dt - duration of display 
%  fo - fraction of page overlap
%  ch - channels to view 
%
% Output:
% -------
%  browser - browser data structure

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

% NOTE: various elements of this structure should be documented to make development easier

%----------------------------------------------------
% HANDLE INPUT
%----------------------------------------------------

%--
% check sound input
%--

if ~ischar(sound) && ~isstruct(sound)
	error('Input must be XBAT sound structure or sound type string.');	
end	

%--
% get sound if needed
%--

if ischar(sound)
	
	sound = get_sound_from_type(sound);

	if isempty(sound)
		browser = []; return;
	end
	
end

%----------------------------------------------------
% HANDLE INPUTS
%----------------------------------------------------

%--
% add view field if needed
%--

% this is a temporary fix to the problem of older sound structures

if ~isfield(sound, 'view')
	sound.view = view_create;
end

%--
% set channels displayed
%--

if (nargin < 5)	

	%--
	% use view channels if available
	%--
	
	if ~isempty(sound.view.channels)
		ch = sound.view.channels;
	else
		ch = channel_matrix(sound.channels);	
	end
		
else
	
	%--
	% check channels input
	%--
	
	if (min(ch) < 1) || (max(ch) > sound.channels)
		
		warning('Selected channels for display are not available. Using all available channels.');
		
		ch = channel_matrix(sound.channels);
		
	else
		
		%--
		% use the provided channel list to produce the channel list
		%--
		
		% this functionality may become obsolete
		
		C = channel_matrix(sound.channels);
		
		C = channel_matrix_update(C, 'display', ch);
		
		ch = C;
		
	end
	
end

%--
% set initial time
%--

if (nargin < 2) || isempty(t)
	
	%--
	% use view time if available
	%--
	
	if ~isempty(sound.view.channels)
		t = sound.view.time;
	else
		t = 0;	
	end
	
else
	
	%--
	% check start time input
	%--
	
	if (t > sound.duration) || (t < 0)
		
		warning('Desired display start time is out of bounds. Start time reset to start of sound.');
		
		t = 0;
		
	end
	
end

%--
% set page duration
%--

if (nargin < 3) || isempty(dt)
	
	%--
	% use view page size if available
	%--
	
	if ~isempty(sound.view.page)
		
		dt = sound.view.page.duration;
		
	else		
		
		% NOTE: the duration is important
		
		% NOTE: actual duration currently creates problem with browser slider
		
		dt = get_default_page_duration(sound);
		
	end
	
else
	
	%--
	% check page duration
	%--
	
	if ((t + dt) > sound.duration)
		
		warning('Desired page duration exceeds end of sound, page duration reset.');
		
		dt = sound.duration - t;
		
	end
	
end

%--
% set page overlap
%--

if nargin < 4 || isempty(fo)
	
	%--
	% user view page overlap if available
	%--
	
	if ~isempty(sound.view.page)
		fo = sound.view.page.overlap;
	else
		fo = 0.25;
	end		
		
else
	
	%--
	% check and fix page overlap
	%--
	
	if (fo >= 1 || fo < 0)
		fo = 0.1;
	end
	
end

%-------------------------------------
% PACK BROWSER FIELDS INTO STRUCTURE
%-------------------------------------

%--
% parent and children
%--

browser.parent = []; % parent of browser for log browser

browser.children = []; % children of browser

%--
% sound
%--

browser.sound = sound;

%--
% display fields
%--

browser.channels = ch; 

browser.time = t;

%--
% page definition fields
%--

browser.page.duration = dt; 

browser.page.overlap = fo;
	
% use page frequency bounds of view if available, these are not edited

if ~isempty(sound.view.page)	
	browser.page.freq = sound.view.page.freq;	
else
	browser.page.freq = [];
end

%--
% spectrogram fields
%--

if isempty(sound.specgram)
	browser.specgram = fast_specgram;
else
	browser.specgram = update_time_resolution(sound, browser.page.duration, sound.specgram);
end

browser.specgram.on = 1; 

% FIXME: the following two state elements are no longer in use

browser.specgram.diff = 0; 

browser.specgram.filter = 'None';

%--
% colormap fields
%--

if ~isempty(sound.view.colormap)
	
	browser.colormap = sound.view.colormap;
	
else 
	
	browser.colormap.name = 'Gray '; 
	browser.colormap.invert = 1;
	browser.colormap.auto_scale = 1;
	browser.colormap.brightness = 0.5; 
	browser.colormap.contrast = 0;

end

%--
% grid fields
%--

browser.grid = grid_create;

if ~isempty(sound.view.grid)
	browser.grid = struct_update(browser.grid, sound.view.grid); 
end

%--
% playback fields
%--

browser.play.speed = 1;

browser.play.band_filter = 1;

switch sound.channels

	%--
	% single channel sound
	%--
	
	case 1, browser.play.channel = [1, 1];
	
	%--
	% stereo sound
	%--
	
	case 2
		
		if (length(ch) > 1)
			browser.play.channel = [1, 2];
		else
			browser.play.channel = [ch, ch];
		end
	
	%--
	% multiple channel
	%--
	
	otherwise, browser.play.channel = [ch(1), ch(1)];
	
end

%---------------------------------------------------------------
% SELECTION FIELDS
%---------------------------------------------------------------

%--
% SELECTION MODE FIELDS
%--

% NOTE: 'selection.on' and 'selection.mode' are not being used properly

browser.selection.on = 1;

browser.selection.mode = 2;

browser.selection.zoom = 0;

%--
% SELECTION STORAGE FIELDS
%--

browser.selection.event = empty(event_create); 

browser.selection.log = [];

browser.selection.handle = [];

%--
% VIEW OPTIONS
%--

browser.selection.color = color_to_rgb('Bright Red');

browser.selection.linestyle = linestyle_to_str('Solid');

browser.selection.linewidth = 1;

browser.selection.patch = 0;

browser.selection.grid = 1;

browser.selection.label = 0;

browser.selection.control = 1;

% TODO: what is this ?

browser.selection.copy = [];

%---------------------------------------------------------------
% SIGNAL OPTIONS
%---------------------------------------------------------------

browser.signal.on = 1;

browser.signal.color = color_to_rgb('Bright Blue');

browser.signal.linestyle = linestyle_to_str('Solid');

browser.signal.linewidth = 1;

%---------------------------------------------------------------
% DISPLAY OBJECT HANDLES
%---------------------------------------------------------------

browser.axes = [];

browser.images = [];

browser.colorbar = [];

browser.slider = [];

browser.status = [];

browser.status_left = [];

browser.status_right = [];

%---------------------------------------------------------------
% LOGGING FIELDS
%---------------------------------------------------------------

% NOTE: this field is obsolete, the author should be simply the current user

browser.author = '';

browser.log = [];

browser.log_active = 0;

% NOTE: selected events are saved to this log

browser.event_selection_log = temp_log;

% NOTE: realtime detections are saved to this log

browser.active_detection_log = temp_log;

%---------------------------------------------------------------
% EXTENSION STORES
%---------------------------------------------------------------

%--
% get all extension types
%--

types = get_extension_types;

%--
% build context for extension initialization
%--

% TODO: determine what else should be in context, look at 'get_browser_extension'

% NOTE: this will be assigned in 'extension_initialize', we set it to keep fields in familiar order

context.ext = [];

context.user = get_active_user;

context.library = get_active_library;

context.sound = sound;

% NOTE: we want to include the field, but the parent does not exist yet

context.par = [];

context.page.start = browser.time;

context.page.duration = browser.page.duration;

context.page.channels = get_channels(browser.channels);

context.debug = 0;

%--
% create extension registry for browser
%--

for k = 1:numel(types)
	
	%--
	% get and initialize extensions
	%--
	
	exts = get_extensions(types{k});
	
	if ~isempty(exts)
		exts = extension_initialize(exts, context);
	end
	
	%--
	% create extension type registry
	%--
	
	% NOTE: this stores state for browser extension
	
	browser.(types{k}).ext = exts;
	
	% NOTE: active determines whether the extension runs with relevant context
	
	browser.(types{k}).active = '';
	
	% NOTE: this determines whether the extension displays if possible
	
	browser.(types{k}).display = {};
	
	% NOTE: this determines whether the extension recomputes on relevant change
	
	browser.(types{k}).recompute = {};
	
end

%---------------------------------------------------------------
% ANNOTATION FIELDS
%---------------------------------------------------------------

browser.annotation.annotation = [];

browser.annotation.name = [];

browser.annotation.view = [];

% NOTE: this prompts for annotaion on new event creation

browser.annotation.active = '';

%---------------------------------------------------------------
% MEASUREMENT FIELDS
%---------------------------------------------------------------

browser.measurement.measurement = [];

browser.measurement.name = {};

browser.measurement.view = {};

% TODO: use this to set recompute for measurement

browser.measurement.recompute = {};

% NOTE: it should be possible to have multiple measures active

browser.measurement.active = {};

%---------------------------------------------------------------
% TEMPLATE FIELDS
%---------------------------------------------------------------

% NOTE: provide templates for automating a series of computations

browser.template.template = [];

browser.template.name = [];

browser.template.view = [];

browser.template.active = '';

%---------------------------------------------------------------
% VIEW NAVIGATION FIELDS
%---------------------------------------------------------------

state.time = browser.time;

state.page = browser.page;

state.channels = browser.channels;

state.play.channel = browser.play.channel;

state.specgram = browser.specgram;

browser.view.state(1) = state;

browser.view.length = 1;

browser.view.position = 1;

browser.view.max = 32;

%---------------------------------------------------------------
% WINDOW FIELDS
%---------------------------------------------------------------

browser.parent = [];

browser.children = [];

browser.palettes = [];

browser.palette_states = [];

browser.palette_display = 1;

%--
% browser renderer
%--

browser.renderer = 'Auto';

%--
% profiler flag
%--

browser.profile = 1;

%--
% browser save
%--

browser.save = [];


%---------------------------------------------------------------
% COLORMAP_CREATE
%---------------------------------------------------------------


%---------------------------------------------------------------
% GRID_CREATE
%---------------------------------------------------------------

function grid = grid_create

%--
% general grid switch
%--

% NOTE: this is probably not in use

grid.on = 1;

grid.color = color_to_rgb('Dark Gray');

%--
% time grid
%--

grid.time.on = 0;

grid.time.spacing = 1;

grid.time.labels = 'clock';

grid.time.realtime = 1;

%--
% file grid
%--

grid.file.on = 1;

grid.file.labels = 1;

%--
% session grid
%--

grid.session.on = 1;

grid.session.labels = 1;

%--
% frequency grid
%--

grid.freq.on = 0;

grid.freq.spacing = [];

grid.freq.labels = 'kHz';


%---------------------------------------------------------------
% GET_SOUND_FROM_TYPE
%---------------------------------------------------------------

% NOTE: this function allows creating a browser without knowledge of sound location

function sound = get_sound_from_type(type)

%--
% check input sound type
%--

% TODO: 'is_sound_type' is stale

[ignore,type] = is_sound_type(type);

if (isempty(type))
	error('Unrecognized sound type.');
end

%--
% get sound according to sound type string
%--

switch (type)

	%--
	% create new sound from type
	%--

	case ({'file','file stream','file sequence'})

		sound = sound_create(type);

		% NOTE: return empty on cancel

		if (isempty(sound))
			sound = []; return;
		end

	%--
	% loading sound from file
	%--

	% TODO: use sound load function in this branch
	
	case ('sound')

		%--
		% get current directory
		%--

		pi = pwd;

		%--
		% try to start in sound directory
		%--

		p = get_env('xbat_path_sound');

		if (~isempty(p))
			try
				cd(p);
			catch
				set_env('xbat_path_sound',pi);
			end
		end

		%--
		% get sound from file
		%--

		[fn,p] = uigetfile2( ...
			{'*.mat','MAT-Files (*.mat)'; '*.*','All Files (*.*)'}, ...
			'Select XBAT Sound File: ' ...
		);

		% NOTE: return on cancel

		if (~fn)
			cd(pi); sound = []; return;
		end

		%--
		% load selected file
		%--

		sound = load([p,fn]);

		%--
		% check number of variables in file
		%--

		field = fieldnames(sound);

		if (length(field) > 1)
			cd(pi); warning('Improper XBAT sound file.'); return;
		end

		%--
		% rename sound variable
		%--

		eval(['sound = sound.' field{1} ';']);

		%--
		% update sound directory and return to initial directory
		%--

		set_env('xbat_path_sound',p); cd(pi);

		%--
		% return if sound loading failed
		%--

		if (isempty(sound))
			sound = []; return;
		end

	%--
	% error
	%--
	
	otherwise, error('Unrecognized XBAT sound type.');

end
