function elapsed = get_player_elapsed

%--
% get current audioplayer
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

current = get_current_player;

% NOTE: return empty when there is no player

if isempty(current)
	elapsed = []; return;
end

%--
% get player
%--

player = get(current, 'userdata');

%--
% compute elapsed time from player
%--

% NOTE: this is the play resample conversion ratio

warp = (player.speed * player.sound.samplerate) / player.samplerate;

ix = player.bix + warp * get(current, 'currentsample');

% NOTE: convert samples to time

elapsed = (ix - player.ix) / player.sound.samplerate;

