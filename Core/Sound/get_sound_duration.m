function duration = get_sound_duration(sound)

% get_sound_duration - get duration using sessions
% ------------------------------------------------
%
% duration = get_sound_duration(sound)
%
% Inputs:
% -------
% sound - an XBAT sound structure
%
% Outputs:
% --------
% duration - the duration of the sound (in seconds)

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

if isempty(sound)
	duration = 0; return;
end

%--
% handle multiple inputs recursively
%--

if numel(sound) > 1
	
	duration = [];
	
	for k = 1:numel(sound)
		duration(k) = get_sound_duration(sound(k));
	end
	
	return;
	
end
	
%--
% get recording duration if there are no sessions
%--

if (isempty(sound.time_stamp) || ~sound.time_stamp.enable)
	duration = sound.duration; return;
end

%--
% get duration based on sessions state
%--

% NOTE: the result of this function is used as the slider duration

sessions = get_sound_sessions(sound);

duration = sessions(end).end;
