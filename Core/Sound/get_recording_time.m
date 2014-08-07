function time = get_recording_time(sound,time)

% get_recording_time - map time out of sessions
% ---------------------------------------------
%
% time = get_recording_time(sound,time)
%
% Inputs:
% -------
% time - sound times
% sound - sound
%
% Outputs:
% --------
% time - recording times

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

%--
% get collapsed and expanded session boundary slider times
%--

collapsed = get_sound_sessions(sound,1);

% NOTE: these are also sound times

expanded = get_sound_sessions(sound,0);

%--
% map times back to recording time
%--

for k = 1:numel(time)
	
	%--
	% get time session index
	%--
	
	ix = find([expanded.start] <= time(k) & [expanded.end] >= time(k));
	
	%--
	% if time is in between sessions set it to be the end of the previous one
	%--
	
	if isempty(ix)
		time(k) = max([collapsed([expanded.end] < time(k)).end]); continue;
	end
	
	%--
	% if time is right on the border between two adjacent sessions, pick the first one
	%--
	
	if numel(ix) > 1
		ix = ix(1);
	end
	
	%--
	% get time difference for this session and update time
	%--
		
	distortion = collapsed(ix).start - expanded(ix).start;
	
	time(k) = time(k) + distortion;
	
end
