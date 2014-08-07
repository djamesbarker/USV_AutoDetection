function sound = recording_dialog(name,path)

%--------------------------------
% Author: Matt Robbins, Harold Figueroa
%--------------------------------
% $Revision: 2196 $
% $Date: 2005-12-02 18:16:46 -0500 (Fri, 02 Dec 2005) $
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

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% set default name
%--

if ((nargin < 1) || isempty(name))
    name = 'New Sound';
end

%--
% det default path
%--

if ((nargin < 2) || isempty(path))
	
	path = create_dir([xbat_root, filesep, 'Recordings']);
	
	if (isempty(path))
		error('Failed to create default output path for new sound.');
	end
	
end

%-------------------------
% CREATE CONTROLS
%-------------------------

%--
% sound header
%--

control(1) = control_create( ...
    'style','separator', ...
    'type','header', ...
    'string','Sound' ...
);

%--
% name
%--

control(end + 1) = control_create( ...
    'name','name', ...
    'style','edit', ...
    'string',name, ...
    'value',1 ...
);

%--
% Format
%--

formats = get_writeable_formats;

control(end + 1) = control_create( ...
	'name', 'format', ...
	'style', 'popup', ...
	'string', {formats.name}, ...
	'value', 1 ...
);	

%--
% File Length
%--

file_lengths = {1, 2, 5, 10, 60, 120, 300, 600};

control(end + 1) = control_create( ...
	'name', 'file_length', ...
	'style', 'popup', ...
	'string', seconds_to_time(file_lengths), ...
	'value', 3 ...
);

%--
% path
%--

control(end + 1) = control_create( ...
    'name','path', ...
    'style','edit', ...
    'string',path, ...
	'lines',3, ...
    'space',0.5, ...
    'value',1 ...
);

%--
% Path browse
%--

control(end + 1) = control_create( ...
    'name',{'browse'}, ...
	'alias',{'Browse ...'}, ...
	'lines', 1.75, ...
	'width',1/3, ...
	'align','right', ...
	'space', 1, ...
    'style','buttongroup' ...
);

%--
% Configure
%--

control(end + 1) = control_create( ...
    'style','separator', ...
    'type','header', ...
    'string','Source' ...
);

%--
% adapter
%--

% NOTE: perform adapter callback on load to setup channels properly

adapters = get_adapters; 

Nadapters = length(adapters);

[adapter_names{1:Nadapters}] = deal(adapters.name);

control(end + 1) = control_create( ...
	'name','adapter', ...
	'style','popup', ...
	'onload', 1, ...
	'string', adapter_names, ...
	'value', 1 ...
);

%--
% samplerate
%--

% TODO: there is somethin weird in the way this controls is being rendered

control(end + 1) = control_create( ...
    'name','samplerate', ...
    'style','slider', ...
    'min', 1000, ...
    'max', 44100, ...
    'value',8000 ...
);

%--
% duration
%--

control(end + 1) = control_create( ...
    'name','duration', ...
    'style','slider', ...
	'type','integer', ...
    'min', 1, ...
    'max', 1000000, ...
    'value',120 ...
);

%--
% channels
%--

control(end + 1) = control_create( ...
	'name','channels', ...
	'style','listbox', ...
	'string', [], ...
	'lines',3, ...
	'max', 2, ...
	'min', 0 ...
);

%----------------------------------
% CREATE DIALOG
%----------------------------------

%--
% configure palette options
%--

opt = dialog_group; opt.top = 0; opt.width = 12.5;

%--
% create and position palette
%--

sound = dialog_group('Record', control, opt, @new_sound_callback);


%-------------------------------------
% CALLBACK FUNCTION
%-------------------------------------

function result = new_sound_callback(obj,eventdata)


[control,par] = get_callback_context(obj);

%--
% get analog input object
%--

[ignore,adapter_hw_name] = control_update([],par.handle,'adapter');

[ai adapter info] = get_analog_input('XBAT_ACQUISITION_SETUP', adapter_hw_name);		

[N names IDs] = num_channels(ai);

minrate = max(100, info.MinSampleRate);

maxrate = info.MaxSampleRate;

%--
% perform callbacks
%--

switch (control.name)
	
	%--
	% browse...
	%--
	
	case ('browse')
		
		uigetdir
		
		[ignore, p] = control_update([], par.handle, 'path');
		
		p = uigetdir(p);
		
		if ischar(p)
		
			control_update([], par.handle, 'path', p);
			
			set_user_data(ai, 'dump_dir', p);
			
		end
			
	%--
	% Path
	%--
		
	case ('path')
		
		[ignore, p] = control_update([],par.handle,'path');
		
		if ~isdir(p)
			
			qu = 'The specified directory does not exist, would you like to create it?';
				
			if strcmpi(quest_dialog(qu), 'Yes');  
			
				mkdir(p);
							
			else
				
				p = get_user_data(ai, 'dump_dir');
				
				control_update([], par.handle, 'path', p);
				
			end
			
		end
		
		set_user_data(ai, 'dump_dir', p);
		
    %--
    % name
    %--
    
    case ('name')
        
		[ignore, name] = control_update([],par.handle,'name');
 		  	
 		set_user_data(ai, 'dump_name', name);
		
    %--
    % adapter
    %--
    
    case ({'adapter', 'samplerate', 'duration'})
		
		handle = control_update([], par.handle, 'samplerate');
		
		set(handle, ...
			'min', minrate, ...
			'max', maxrate ...
		);
		
		handle = control_update([], par.handle, 'channels');
		
		set(handle(2), ...
			'value', [], ...
			'String', names ...
		);
				   
		
		slider_sync(obj,control.handles);
		
        [ignore,rate] = control_update([],par.handle,'samplerate');
		
		if rate < minrate
			rate = minrate;
		elseif rate > maxrate
			rate = maxrate;
		end
		
		rate = set_samplerate(ai,rate);
		
		%--
		% account for some devices supporting only discrete set of rates
		%--
		
		control_update([],par.handle,'samplerate',rate);
		
		%--
		% update duration
		%--
		
		slider_sync(obj,control.handles);
        
		[garbage, time] = control_update([], par.handle, 'duration');
		
		set_duration(ai,time);
	
	%--
	% Channels
	%--
		
	case ('channels')
		
		[handle, desired_channels_string] = control_update([], par.handle, 'channels');

		desired_channels = cell_find(names, desired_channels_string);
		
		if strcmp(adapter.type, 'winsound')

			%--
			% Winsound Driver behavior, sequentially added/removed channels
			%--

			indexes = 1:max(desired_channels);

			[h values] = control_update([], par.handle, 'channels', names(indexes));

		end
		
end
	
delete(ai);


%--------------------------------
% GET_DURATION
%--------------------------------

function duration = get_duration(obj)

duration = obj.SamplesPerTrigger / obj.Samplerate;


%--------------------------------
% SET_DURATION
%--------------------------------

function duration = set_duration(obj,duration)

% NOTE: works like 'setverify'

samples = floor(duration * get_samplerate(obj));

samples = setverify(obj,'SamplesPerTrigger',samples);

if (nargout)
	duration = get_duration(obj);
end


%--------------------------------
% GET_SAMPLERATE
%--------------------------------

function rate = get_samplerate(obj)

rate = obj.SampleRate;


%--------------------------------
% SET_SAMPLERATE
%--------------------------------

% NOTE: works like 'setverify'

function rate = set_samplerate(obj,rate)

duration = get_duration(obj);

rate = setverify(obj,'samplerate',rate); 

set_duration(obj,duration);
