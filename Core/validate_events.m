function [event,reject,why] = validate_events(event,sound)

% validate_events - validate correctness of events
% ------------------------------------------------
%
% [event,reject] = validate_events(events,sound)
%
% Input:
% ------
%  events - events
%  sound - parent sound
%
% Output:
% -------
%  event - validated events
%  reject - rejected events

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
% $Revision: 4977 $
% $Date: 2006-05-11 19:29:21 -0400 (Thu, 11 May 2006) $
%--------------------------------

%----------------------------
% SETUP
%----------------------------

% NOTE: pack nyquist into sound to help in frequency validation

sound.nyquist = get_sound_rate(sound) / 2;

%----------------------------
% VALIDATE EVENTS
%----------------------------

why = {};

%--
% create empty rejects array
%--

reject = empty(event_create);

%--
% loop over events
%--

for k = length(event):-1:1
	
	%--
	% validate channel
	%--
	
	if isempty(event(k).channel)
		
		if (sound.channels == 1)
			event(k).channel = 1;
		else

			reject(end + 1) = event(k); event(k) = [];
			
			why = union(why, 'channel number'); continue;
		
		end
		
	else
		
		if ~proper_channel(event(k),sound)
			
			reject(end + 1) = event(k); event(k) = []; 
			
			why = union(why, 'channel number'); continue;
			
		end
		
	end
	
	%--
	% validate level
	%--
	
	if isempty(event(k).level)
		
		event(k).level = 1;
	
	else
		
		if ~proper_level(event(k),sound)
			
			why = union(why, 'heirarchical level');
			
			reject(end + 1) = event(k); event(k) = []; continue;
			
		end

	end

	%--
	% validate time
	%--
	
	if ~proper_time(event(k),sound)		
		
		why = union(why, 'time bounds');
		
		reject(end + 1) = event(k); event(k) = []; continue;
		
	end
	
	event(k).duration = diff(event(k).time);

	%--
	% validate freq
	%--
	
	if ~proper_freq(event(k),sound)	
		
		why = union(why, 'frequency bounds');
		
		reject(end + 1) = event(k); event(k) = []; continue;
		
	end
	
	event(k).bandwidth = diff(event(k).freq);
	
end		

%----------------------------
% PROPER_CHANNEL
%----------------------------

function value = proper_channel(event,sound)

channel = event.channel;

if (floor(channel) ~= channel) || (channel < 1) || (channel > sound.channels)
	value = 0;
else
	value = 1;
end


%----------------------------
% PROPER_LEVEL
%----------------------------

function value = proper_level(event,sound)

% TODO: add checking of children levels

level = event.level;

if (floor(level) ~= level) || level < 1
	value = 0;
else
	value = 1;
end


%----------------------------
% PROPER_TIME
%----------------------------

function value = proper_time(event,sound)

time = event.time;

if isempty(time) || (~isequal(size(time),[1,2])) || (time(2) <= time(1)) || any(time > sound.duration) || any(time < 0)
	value = 0;
else
	value = 1;
end


%----------------------------
% PROPER_FREQ
%----------------------------

function value = proper_freq(event,sound)

freq = event.freq;

if isempty(freq) || (~isequal(size(freq),[1,2])) || (freq(2) <= freq(1)) || any(freq > sound.nyquist) || any(freq < 0)
	value = 0; 
else
	value = 1;
end




