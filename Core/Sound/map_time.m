function time = map_time(sound, to, from, time)

% map_time - map time between 'record', 'slider', and 'real' time
% ---------------------------------------------------------------
%
% time = map_time(sound, to, from, time)
%
% Input:
% ------
%  sound - sound (contains mapping info)
%  to    - type of time to map to
%  from  - type of time to map from
%  time  - time to map from (seconds)
%
% Output:
% -------
%  time - mapped time (seconds)

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
% Author: Matt Robbins
%--------------------------------
% $Revision$
% $Date$
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

% NOTE: when profiling this function 90% of the time was spent on the type check!

% NOTE: this shows why it is better to reveal this function through aliases

% types = {'record', 'slider', 'real'};
% 
% if ~ismember(to, types) || ~ismember(from, types)
% 	error('Invalid time type.');
% end

if ~has_sessions_enabled(sound)
	return;
end

if strcmp(from, to)
	return;
end

%--------------------------------
% MAP TIME (IF NEEDED)
%--------------------------------

switch to
	
	case 'record'
		
		switch from
			
			case 'slider'
				
				if ~sound.time_stamp.collapse
					time = get_recording_time(sound, time);
				end
				
			case 'real'
				
				time = get_recording_time(sound, time);
				
		end
		
	case 'slider'
		
		switch from
			
			case 'record'
				
				if ~sound.time_stamp.collapse
					time = get_session_time(sound, time);
				end
				
			case 'real'
				
				if sound.time_stamp.collapse
					time = get_recording_time(sound, time);
				end
				
		end
		
	case 'real'
		
		switch from
			
			case 'record'
				
				time = get_session_time(sound, time);
				
			case 'slider'
				
				if sound.time_stamp.collapse
					time = get_session_time(sound, time);
				end
				
		end
		
end
