function event = event_sound_read(event, sound, pad, taper)

% event_sound_read - read event samples from sound
% ------------------------------------------------
%
% event = event_sound_read(event, sound, pad, taper)
%
% Input:
% ------
%  event - event to read
%  sound - sound to read from
%  pad - seconds to pad
%  taper - taper indicator
%
% Output:
% -------
%  event - event with samples and rate

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

% NOTE: this function is a start, there are various possible refinements

%-------------------
% HANDLE INPUT
%-------------------

if nargin < 4
	taper = 0;
end

if nargin < 3
	pad = 0;
end

%--
% handle multiple events recursively
%--

if length(event) > 1
	
	% NOTE: the single event function catches exceptions
	
	for k = 1:length(event) 
		event(k) = event_sound_read(event(k), sound, pad, taper);
	end
	
	return; 
	
end

%-------------------
% SETUP
%-------------------

MAX_SAMPLES = 10^7;

%-------------------
% READ EVENT
%-------------------

%--
% append fields to event
%--

% NOTE: consider adding these fields to the basic event

event.samples = []; event.rate = get_sound_rate(sound);

%--
% check that event is of reasonable size
%--

if (event.rate * event.duration) > MAX_SAMPLES
	return;
end

%--
% read page samples and add to page, also add sample rate
%--

% NOTE: read behaves as if input time was 'slider' time

if ~pad
	
	% NOTE: event times are 'record' times and no mapping is required in read, faster
	
	sound.time_stamp = [];

	try
		event.samples = sound_read(sound, 'time', event.time(1), event.duration, event.channel);
	catch
		nice_catch(lasterror, 'WARNING: Event sample read failed.');
	end
	
else
	
	base = event;
	
	% NOTE: this is required because of the strange, but desirable, 'hide silence' mode
    
    if ~isempty(sound.time_stamp)
        sound.time_stamp.collapse = 0;
    end  
    
	event.time = map_time(sound, 'real', 'record', event.time);
	
	event.time = event.time + pad * [-1 , 1];    
	
	base.pad = pad;
	
	base.real_time = event.time;
	
	try
        
		base.samples = sound_read(sound, 'time', event.time(1), diff(event.time), event.channel);
	
	catch

		nice_catch(lasterror, 'WARNING: Padded event sample read failed.'); event = base; return;
	
	end
	
	if taper
		
		n = floor(pad * get_sound_rate(sound));

		base.samples(1:n) = linspace(0, 1, n)' .* base.samples(1:n);
		
		base.samples(end - n + 1:end) = linspace(1, 0, n)' .* base.samples(end - n + 1:end);
		
	end
	
	event = base;
	
end
