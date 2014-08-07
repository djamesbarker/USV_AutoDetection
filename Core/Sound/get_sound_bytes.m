function bytes = get_sound_bytes(sound)

% get_sound_bytes - get bytes from sound
% --------------------------------------
%
% bytes = get_sound_bytes(sound)
%
% Input:
% ------
%  sound - sound array
%
% Output:
% -------
%  bytes - bytes in each sound

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
% get number of bytes for each sound
%--

% NOTE: if we cannot get the bytes from the sound we output zero, consider nan

bytes = zeros(size(sound));

for k = 1:numel(sound)
	
	if isfield(sound(k).info, 'bytes')
		bytes(k) = sound(k).info.bytes;
	end

end
