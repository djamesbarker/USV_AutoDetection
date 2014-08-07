function start_cb(obj, eventdata)

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
% get and update player
%--

player = get(obj, 'userdata');

% NOTE: we only need to set the starting index for next player

player.bix = player.bix + player.buflen;

%--
% create next player if we need to
%--

if player.bix >= player.ix + player.n

	next_player = [];
	
else
	
	%--
	% get samples from sound
	%--
	
	X = get_data(player);
	
	player.buffer = X;
	
	%--
	% create player
	%--
	
	next_player = audioplayer(X, player.samplerate);
	
	set(next_player, ...
		'startfcn', @start_cb, ...
		'stopfcn', @stop_cb, ...
		'userdata', player ...
	);
	
end

%--
% set next global player
%--

switch get(obj, 'tag')

	case 'BUFFERED_PLAYER_1'
		set(next_player, 'tag', 'BUFFERED_PLAYER_2'); BUFFERED_PLAYER_2 = next_player;

	case 'BUFFERED_PLAYER_2'
		set(next_player, 'tag', 'BUFFERED_PLAYER_1'); BUFFERED_PLAYER_1 = next_player;

end
