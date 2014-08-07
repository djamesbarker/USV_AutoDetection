function h = acquire_sound(name)

% TODO: work with 'audiodevinfo' to get input audio devices. possibly
% reconcile this with the 'daqhwinfo'

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

% TODO: get 'nidaq' card from eric to see how this impacts the above, among
% other things

% TODO: improve channel handling code, this should be helped if we can get
% the 'nidaq'

% TODO: implement store to sound file

% TODO: interface redesign

% TODO: integration as format???

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% set default name
%--

if ((nargin < 1) || isempty(name))
    name = 'New Sound';
end

%-------------------------
% SETUP
%-------------------------

[ai,adapter] = get_input(name);

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
    'space',1.75, ...
    'value',1 ...
);

control(end + 1) = control_create( ...
    'style','separator', ...
    'align','right', ...
    'name','Configure', ...
    'string','Configure' ...
);

%--
% adapter
%--

% NOTE: assume we can get adapter from input object 'name'

info = daqhwinfo; 

adapters = info.InstalledAdaptors;

ix = find(strcmp(adapters,adapter));

control(end + 1) = control_create( ...
	'name','adapter', ...
	'style','popup', ...
	'string',upper(adapters), ...
	'value',ix ...
);

%--
% samplerate
%--

value = get_samplerate(ai);

control(end + 1) = control_create( ...
    'name','sample_rate', ...
    'style','slider', ...
    'min', 8000, ...
    'max', 44100, ...
    'value',value ...
);

%--
% duration
%--

value = get_duration(ai);

control(end + 1) = control_create( ...
    'name','duration', ...
    'style','slider', ...
	'type','integer', ...
    'min', 1, ...
    'max', 5 * 60, ...
    'value',value ...
);

%--
% channels
%--

N = discover_num_channels(adapter);

for k = 1:N
	
	val = length(ai.channel.index) >= k;
	
	control(end + 1) = control_create( ...
        'name',['channel_' int2str(k)], ...
        'style','checkbox', ...
        'value',val ...
    );

end

%--
% start stop
%--

if length(ai.channel.index)
	state = '__ENABLE__';
else
	state = '__DISABLE__';
end

control(end + 1) = control_create( ...
    'name','start_stop', ...
	'lines',1.75, ...
	'active', 0,...
	'initialstate', state,...
    'style','buttongroup' ...
);

%--
% Progress header
%--

control(end + 1) = control_create( ...
    'style','separator', ...
    'type','header', ...
    'string','Progress' ...
);

control(end + 1) = control_create( ...
    'style','waitbar', ...
    'name','PROGRESS' ...
);

for k = 1:N
	control(end + 1) = control_create( ...
		'name',['channel_', int2str(k), '_display'], ...
		'label',1, ...
		'style','axes', ...
		'lines',4 ...
	);
end

%----------------------------------
% CREATE DIALOG
%----------------------------------

%--
% configure palette options
%--

control(end).space = 2;

opt = control_group; opt.top = 0; opt.width = 12;

%--
% create and position palette
%--

name = 'Acquire';

out = control_group([],@acquire_sound_callback,name,control,opt);

position_palette(out,0,'center');

%--
% get axes handles and initialize line objects
%--

x = zeros(100,1);

for k = 1:N
	
	%--
	% get scope axes handles
	%--
	
	tag = ['channel_', int2str(k), '_display'];
	
	ax = findobj(control_update([],out,tag),'type','axes');
		
	%--
	% create scope lines
	%--
	
	h(k) = line( ...
		'parent', ax, ...
		'erasemode','xor', ...
		'XData', 1:length(x), ...
		'YData', x(:,1) ...
	);
	
end

get(h(1),'parent');

set(ai,'UserData',h);

drawnow;

%----------------------------------
% ACQUIRE_SOUND_CALLBACK
%----------------------------------

function result = acquire_sound_callback(obj,eventdata)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1938 $
% $Date: 2005-10-17 08:49:40 -0400 (Mon, 17 Oct 2005) $
%--------------------------------

[control,par] = get_callback_context(obj);

%--
% get named input object
%---

% NOTE: name is stored in tag to keep adapter information in name

[ignore,name] = control_update([],par.handle,'name');
        
ai = daqfind('tag',name);

if (~isempty(ai))
    ai = ai{1};
end

adapter = find_adapter_type(ai);

N = discover_num_channels(adapter);

%--
% perform callbacks
%--

switch (control.name)
	
    %--
    % name
    %--
    
    case ('name')
        
        if (~isempty(ai))
            set(ai,'tag',name);
		end     
		
    %--
    % adapter
    %--
    
    case ('adapter')
        
        % NOTE: expect problems with channels
        
        %--
        % clear existing input object
        %--

        if (~isempty(ai))
            prop = get(ai); delete(ai);
        else
            prop = [];
        end
        
        %--
        % create new input object for specified adapter
        %--
        
        [ignore,adapter] = control_update([],par.handle,'adapter');
        
        % NOTE: output is cell and we use uppercase display
                		
        ai = analoginput(lower(adapter{1}));
        
        set(ai,'tag',name);
        
        if (~isempty(prop))
            set(ai,'samplerate',prop.SampleRate);
        end
        
    %--
    % sample_rate
    %--
    
    case ('sample_rate')
                
		slider_sync(obj,control.handles);
		
        [ignore,rate] = control_update([],par.handle,'sample_rate');
        
        if (~isempty(ai))
			
			rate = set_samplerate(ai,rate);
    
			control_update([],par.handle,'sample_rate',rate);
			
		end
		
    %--
    % duration
    %--
		
    case ('duration')
		
		slider_sync(obj,control.handles);
        
		[garbage, time] = control_update([], par.handle, 'duration');
		
		set_duration(ai,time);
	
	%--
	% start_stop
	%--
		
	% TODO: implement name aliasing for buttons
	
	case ('start_stop')		
				
		if (is_logging(ai))
		
			stop(ai); 
			
			set(obj,'string','Start'); status = '__ENABLE__';
			
		else
			
			set(ai, ...
				'TimerFcn', @daq_run, ...
				'StopFcn', @daq_stop ...
			);
		
			start(ai); 
			
			set(obj,'string','Stop'); status = '__DISABLE__';
			
		end
		
		for ix = 1:N		
			control_update([], par.handle, ['channel_' num2str(ix)], status);	
		end
						  
end

%--
% channel
%--

% NOTE: channel select boxes need some special behavior

if strfind(control.name, 'channel')
	
	temp = control.name; 
	
	channel_ix = str2num(temp(findstr(temp, '_')+1:end));
	
	% NOTE: there may be a better way to do this, but the channel indexes
	% come back as a cell array if there's more than one, or as a scalar
	% otherwise.
	
	if strcmp(class(ai.channel.index), 'cell')
	
		existing_channels_cell = ai.channel.index;
		
		for ix = 1:length(existing_channels_cell)
			existing_channels(ix) = existing_channels_cell{ix};
		end
		
	else
		
		existing_channels = ai.channel.index;
		
	end
	
	channel_exists = ~isempty(find(channel_ix == existing_channels)); 
	
	[garbage, value] = control_update([], par.handle, control.name);
	
	% NOTE: the 'winsound' driver mandates sequential channel
	% enabling/disabling
	
	if ~strcmp(adapter, 'winsound')
		
		%--
		% "normal" channel behavior
		%--
		
		if value == 1 && ~channel_exists

			addchannel(ai, channel_ix);

		elseif value == 0 && channel_exists

			delete(ai.channel(channel_ix));

		end
		
	else
		
		%--
		% "wierd" winsound behavior
		%--
		
		if value == 1
			
			delete(ai.channel);
			
			addchannel(ai, [1:channel_ix]);
					
			for ix = 1:channel_ix-1
				control_update([], par.handle, ['channel_' num2str(ix)] , 1);
			end
			
		elseif value == 0
			
			ixs = channel_ix:sum(existing_channels > 0);
			
			delete(ai.channel(ixs));
			
			for ix = channel_ix+1:N
				control_update([], par.handle, ['channel_' num2str(ix)] , 0);
			end
			
		end

	end
			
	%--
	% Enable/Disable start_stop button
	%--
	
	if ~isempty(ai.channel.index)
		control_update([], par.handle, 'start_stop', '__ENABLE__');
	else
		control_update([], par.handle, 'start_stop', '__DISABLE__');
	end
			
end


%----------------------------------
% DAQ_RUN (CALLBACK)
%-----------------------------------

function daq_run(obj, event)

%--
% get input object data
%--

channels = length(obj.channel.index);

X = peekdata(obj, 100);

if (size(X, 1) ~= 100)
	X = zeros(100, channels);
end

%--
% update signal displays
%--

% TODO: store display configuration options in userdata, many options here

handles = obj.UserData;

for k = 1:channels	
	set(handles(k), 'YData', X(:,k));
end

drawnow;

%--
% udpate waitbar
%--

par = ancestor(handles(1),'figure');

waitbar_update(par,'PROGRESS', ...
	'value', obj.SamplesAcquired / obj.SamplesPerTrigger ...
);


%-----------------------------------
% DAQ_STOP (CALLBACK)
%-----------------------------------

function daq_stop(obj, event)

%--
% get acquisition palette handle
%--

% NOTE: get figure ancestor of axes handles stored in input object

handles = obj.UserData;

par = ancestor(handles(1),'figure');

%--
% update enable state of channel controls
%--

N = discover_num_channels(find_adapter_type(obj));

for ix = 1:N
	control_update([], par, ['channel_' num2str(ix)], '__ENABLE__');
end

%--
% update waitbar state
%--

waitbar_update(par,'PROGRESS', ...
	'value', 1 ...
);


%-----------------------------------
% DISCOVER_NUM_CHANNELS
%-----------------------------------

function N = discover_num_channels(adapter)

% TODO: consider multiple devices that use same adapter

%--
% create temporary input object for adapter type
%--

temp = analoginput(adapter);

%--
% add channels until we get an error
%--

N = 0;

while (1)
	try
		N = N + 1; addchannel(temp,N);
	catch
		N = N - 1; break;
	end
end

%--
% delete input object
%--

delete(temp);


%--------------------------------
% FIND_ADAPTER_TYPE
%--------------------------------

function adapter = find_adapter_type(ai)

% TODO: consider getting device id, is there another way of getting this

%--
% set list of supported adapters
%--

% NOTE: this list is available in DAQ toolbox documentation

adapters = { ...
	'advantech',...
	'hpe1432',...
	'keithley',...
	'mcc',...
	'nidaq',...
	'parallel',...
	'winsound'...
};

%--
% get adapter type from input object name
%--

% NOTE: this relies on having adapter as name prefix

name = get(ai,'name'); 	

ix = find(strncmp(adapters,name,3));

if (isempty(ix))
	adapter = []; return;
end

adapter = adapters{ix};


%--------------------------------
% IS_LOGGING
%--------------------------------

% NOTE: replaces the function 'islogging', not available in previous version

function value = is_logging(obj)

value = strcmpi(obj.Logging,'on');


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

samples = floor(duration * obj.SampleRate);

set(obj,'SamplesPerTrigger',samples);

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


%--------------------------------
% GET_INPUT
%--------------------------------

function [obj,adapter] = get_input(name)

% get_input - get input object and associated adapter
% ---------------------------------------------------
% 
% [obj,adapter] = get_input(name)
%
% Input:
% ------
%  name - input object name (actually stored in tag)
%
% Output:
% -------
%  obj - input object
%  adapter - adapter

%--
% get named input object, create if needed
%--

obj = daqfind('tag',name);

if (~isempty(obj))
    	
	obj = obj{1};
	
	adapter = find_adapter_type(obj);
			  
else
    
	% make a new input object with system default adapter type?
	
	info = daqhwinfo; 
	
	adapters = info.InstalledAdaptors;
	
    adapter = adapters{2};

	%--
	% create and name input object
	%--
	
    obj = analoginput(adapter);
	
	set(obj,'tag',name);
	
end



