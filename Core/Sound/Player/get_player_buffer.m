function [buffer, player] = get_player_buffer

% get_player_buffer - access samples from current player
% ------------------------------------------------------
%
% buffer = get_player_buffer
%
% Output:
% -------
%  buffer - player buffer struct

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

% NOTE: consider renaming to 'get_play_buffer' and adding parent input

%--
% get player
%--

player = get_current_player;

if isempty(player)
	buffer = []; return;
end

%--
% get player data
%--

data = get(player, 'userdata');

%--
% pack buffer
%--

buffer.speed = data.speed;

buffer.samples = data.buffer;

buffer.length = length(buffer.samples);

buffer.ix = get(player, 'currentsample');
