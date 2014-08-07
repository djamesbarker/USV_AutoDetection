function scan = get_sound_scan(sound, duration, overlap, collapse)

% get_sessions_scan - get default sound scan
% ------------------------------------------
%
% scan = get_sound_scan(sound, duration, overlap)
%
% Input:
% ------
%  sound - sound
%  duration - page duration
%  overlap - page overlap
%
% Output:
% -------
%  scan - default scan for sound  

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

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

if nargin < 4
    collapse = 1;
end

%--
% set default scan page configuration
%--

if (nargin < 3) || isempty(overlap)
	overlap = 0;
end

if (nargin < 2) || isempty(duration)
	duration = get_default_page_duration(sound);
end

%-----------------------------------------
% GET SCAN BLOCKS FROM SOUND
%-----------------------------------------

%--
% get session start and stop times
%--

sessions = get_sound_sessions(sound, collapse);

%--
% get scan blocks
%--

if isempty(sessions)
	
	% NOTE: when there are no sessions scan spans whole sound
	
	start = 0; stop = sound.duration; interval = 0;

else

	% NOTE: interval value of three indicates start and stop are session boundaries
	
	start = [sessions.start]; stop = [sessions.end]; interval = 3 * ones(size(start));
	
end

%--
% build scan with interval information
%--

scan = scan_create(start, stop, duration, overlap, interval);

