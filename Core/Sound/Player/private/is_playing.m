function playing = is_playing

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
% check that a player is playing
%--

playing = 0;

if ...
	(~isempty(BUFFERED_PLAYER_1) && isplaying(BUFFERED_PLAYER_1)) || ...
	(~isempty(BUFFERED_PLAYER_2) && isplaying(BUFFERED_PLAYER_2)) ...
	
	playing = 1;
	
end
