function player = get_current_player

%--
% access global players
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

global BUFFERED_PLAYER_1 BUFFERED_PLAYER_2;

%--
% set default empty player and test for playing or paused player
%--

player = [];

if is_playing_or_paused(BUFFERED_PLAYER_1)
	
	player = BUFFERED_PLAYER_1; return;
	
end

if is_playing_or_paused(BUFFERED_PLAYER_2)
	
	player = BUFFERED_PLAYER_2; return;
	
end


%--------------------------------
% IS_PLAYING_OR_PAUSED
%--------------------------------

function value = is_playing_or_paused(player)

% is_playing_or_paused - check for player
% ---------------------------------------
%
% value = is_playing_or_paused(player)
%
% Input:
% ------
%  player - player
%
% Output:
% -------
%  value - result of test (0 - no player, 1 - playing, 2 - paused)

%--
% check for availability
%--

if isempty(player)
	value = 0; return;
end

%--
% check for playing
%--

value = isplaying(player);

if value
	return;
end

%--
% check for paused
%--

current = get(player, 'currentsample'); 

total = get(player, 'totalsamples');

% NOTE: players reset to sample number 1 when done

value = 2 * ((current < total) && (current > 1));

