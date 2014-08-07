function time = get_sound_time(sound, time, backwards)

% get_sound_time - get sound times from slider times
% --------------------------------------------------
%
% time = get_sound_time(sound, time)
%
% Input:
% ------
%  sound - sound
%  time - slider times
%
% Output:
% -------
%  time - sound time

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

if nargin < 3 || isempty(backwards)
	backwards = 0;
end

% NOTE: when scheduled sound display is not hiding silence slider time is sound time

if has_sessions_enabled(sound) && xor(sound.time_stamp.collapse, backwards)
	time = get_session_time(time, sound);
end
