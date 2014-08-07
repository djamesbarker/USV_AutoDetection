function sessions = get_sound_sessions(sound,collapse)

% get_sound_sessions - get the recording session boundaries
% ---------------------------------------------------------
%
% sessions = get_sound_sessions(sound)
%
% Inputs:
% -------
% sound - an XBAT sound structure
% collapse - collapse sessions to recording time
%
% Outputs:
% --------
% sessions - vector of session start/end times

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

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% return empty for no sessions
%--

if isempty(sound.time_stamp)
	sessions = []; return;
end

if ~isfield(sound.time_stamp, 'table')
	sessions = []; return;
end
	
if isempty(sound.time_stamp.table)
	sessions = []; return;
end

%--
% get collapse state from sound if not provided
%--

% NOTE: this allows override of sound collapse state

if nargin < 2 || isempty(collapse)
	collapse = sound.time_stamp.collapse;
end

%-------------------------
% BUILD SESSIONS
%-------------------------

durations = diff([sound.time_stamp.table(:, 1); sound.duration]);

if collapse
	start_times = sound.time_stamp.table(:, 1);
else
	start_times = sound.time_stamp.table(:, 2);
end

end_times = start_times + durations;

sessions = struct('start', [], 'end', []); 

sessions = repmat(sessions, 1, length(start_times));

for k = 1:length(sessions)
	sessions(k).start = start_times(k); sessions(k).end = end_times(k);
end

