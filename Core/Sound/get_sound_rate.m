function rate = get_sound_rate(sound)

% get_sound_rate - get effective sound sample rate
% ------------------------------------------------
%
% rate = get_sound_rate(sound)
%
% Input:
% ------
%  sound - sound
%
% Output:
% -------
%  rate - current sample rate of sound

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

if isempty(sound.output.rate)
	rate = sound.samplerate;
else
	rate = sound.output.rate;
end
