function pal = record_palette(sound)

% record_palette - create record palette for recording sounds
% -----------------------------------------------------------
%
% pal = record_palette(sound)
%
% Input:
% ------
%  sound - recordable sound
%
% Output:
% -------
%  pal - palette handle

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


% TODO: develop palette API
% -------------------------

% NOTE: palette functions should get context, this may include browser
% state and perhaps mode

% NOTE: palette functions should return controls, configuration options and
% palette name. based on the mode a palette may wish to change it's
% controls or perhaps not appear at all

% NOTE: browser_palettes should create palette and wrap callback, creation
% wraps registration, callback wrap can provide effects and loggind if
% needed

%--------------------------------
% CREATE PALETTE
%--------------------------------

%--
% define controls
%--

control(1) = control_create( ...
    'style','separator', ...
	'type', 'header', ...
    'string','Record' ...
);

control(end + 1) = control_create( ...
    'name','start', ...
	'lines',1.75, ...
    'style','buttongroup' ...
);

%--
% configure and create palette
%--

opt = control_group; opt.top = 0;

pal = control_group([],@record_callback,'Record',control,opt);

%--
% create analog input object
%--

[ai, adapter, info] = get_analog_input(sound.input.id, sound.input.adapter);


%--
% Set up data logging function and parameters
%--

set(ai, ...
	'SampleRate', sound.samplerate,...
	'SamplesAcquiredFcnCount', sound.samples(1), ...
	'SamplesAcquiredFcn', {@daq_dump,sound}, ...
	'SamplesPerTrigger', sound.cumulative(end) ...
);

%--
% set active channels for ai
%--

set_active_channels(ai, sound.input.channels);

%--------------------------------
% Record Callback
%--------------------------------

function record_callback(obj, eventdata)

[control, pal, par] = get_callback_context(obj);

switch (control.name)
	
	case ('start')
		
		data = get(par.handle,'userdata');
		
		id = data.browser.sound.input.id;
		
		ai = get_analog_input(id);
		
		set_user_data(ai, 'File_Index', 1);
		
		if (isempty(ai))
			return;
		end
		
		start(ai);
		
end


%-----------------------------------
% DAQ_DUMP
%-----------------------------------


function daq_dump(obj, event, sound)

% obj is the analog input object.

ix = get_user_data(obj, 'File_Index');

x = peekdata(obj, sound.samples(ix));

flushdata(obj);

sound_file_write([sound.path sound.file{ix}], x, sound.samplerate);

set_user_data(obj, 'File_Index', ix + 1);

