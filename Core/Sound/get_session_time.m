function time = get_session_time(sound, time)

% get_session_time - get expanded time from collapsed time
% --------------------------------------------------------
%
% [time, date] = get_session_time(time, sound)
%
% Inputs:
% -------
% time - vector of times
% sound - sound structure
%
% Outputs:
% --------
% time - vector of times

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
% $Revision: 819 $
% $Date: 2005-03-27 15:06:08 -0500 (Sun, 27 Mar 2005) $
%--------------------------------

collapsed = get_sound_sessions(sound, 1);

expanded = get_sound_sessions(sound, 0);

for k = 1:numel(time)
	
	session = find([collapsed.start] <= time(k) & [collapsed.end] > time(k));
	
	if isempty(session)
		session = length(expanded);
	end

	time(k) = time(k) + expanded(session).start - collapsed(session).start;
	
end
