function [ix, str] = get_current_session(sound, time)

%--
% handle input
%--

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

if nargin < 2 || isempty(time)
	slider = get_time_slider(get_active_browser); time = slider.value;
end

if nargin < 1 || isempty(sound)
	sound = get_active_sound;
end

ix = []; str = '';


if ~has_sessions_enabled(sound)
	return;
end

%--
% get real time
%--

time = map_time(sound, 'real', 'slider', time);

%--
% get sessions in real time
%--

sessions = get_sound_sessions(sound, 0);

if isempty(sessions)
	return;
end

starts = [sessions(:).start];

stops = [sessions(:).end];

%--
% find current session and output info string
%--

ix = find([time < stops], 1, 'first');

str = sec_to_clock(starts(ix));

