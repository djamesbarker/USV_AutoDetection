function [times,start,sessions] = get_session_boundaries(sound, time, duration)

% get_session_boundaries - get sessions boundaries within limits
% --------------------------------------------------------------
%
% [times] = get_session_boundaries(sound, time, duration)
%
% Inputs:
% -------
%  sound - sound structure
%  time - start time of time extend
%  duration - time extent
%
% Outputs:
% --------
%  times - vector of times

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


if ~has_sessions_enabled(sound)
	times = []; start = []; sessions = []; return;
end

%--
% get time limits and sessions.  
%--

% NOTE: sound-time/session-time transformations are taken care of in get_sound_sessions()
	
limits = [time, time + duration];

sessions = get_sound_sessions(sound);

%--
% get boundary times
%--

[start_times, start_ix] = in_limits([sessions.start], limits);

[end_times, end_ix] = in_limits([sessions.end], limits);

[times,ix] = sort([start_times, end_times]);

if (nargout)
	start = [ones(size(start_times)), zeros(size(end_times))]; start = start(ix);
end

sessions = sessions([start_ix end_ix]);


%-----------------------------------
% IN_LIMITS
%-----------------------------------

function [values, ix] = in_limits(values, limits)

ix = find((values < limits(2)) & (values > limits(1)));

values = values(ix);
