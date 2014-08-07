function duration = get_default_page_duration(sound)

% NOTE: perhaps consider some machine parameters and page mode

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

%--
% estimate default page duration
%--

duration = (2^18) / get_sound_rate(sound);

%--
% ensure integer duration or full sound duration
%--

duration = round(duration);

if duration < 1
	duration = 1;
end

if duration > sound.duration
	duration = sound.duration;
end
