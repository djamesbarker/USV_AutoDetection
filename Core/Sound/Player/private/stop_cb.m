function stop_cb(obj, eventdata)

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
% return if we were paused
%--

if get(obj, 'currentsample') ~= 1	
	return;
end 

%--
% select next player when we are done
%--

switch get(obj, 'tag')

	case 'BUFFERED_PLAYER_1'
		next_player = BUFFERED_PLAYER_2;

	case 'BUFFERED_PLAYER_2'
		next_player = BUFFERED_PLAYER_1;

end

% NOTE: clean up and return if there is no next player and the current player is done

if isempty(next_player)
	BUFFERED_PLAYER_1 = []; BUFFERED_PLAYER_2 = []; return;
end

%--
% start next player
%--

play(next_player);
