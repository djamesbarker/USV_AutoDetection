function borders = get_session_borders(sessions, time)

% get_session_borders - find nearest borders surrounding a set of times
% ---------------------------------------------------------------------
%
% borders = get_session_boundaries(sessions, time)
%
% Input:
% ------
%  sessions - session objects
%  time - time vector (usually 1 or two points)
%
% Output:
% -------
%  borders - nearest session boundaries
%
%

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

if isempty(sessions)
	borders = []; return;
end
	
session_ix = find([[sessions.end] > max(time)] & [[sessions.start] < min(time)]);

if isempty(session_ix)
	borders = []; return;
end

borders = [sessions(session_ix).start,sessions(session_ix).end];

	
