function X = get_data(player)

%--
% get sound, starting index and duration, and channels from player
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

sound = player.sound;

ix = player.bix; n = min(player.buflen, (player.ix + player.n) - player.bix);

ch = player.ch;

%--
% get samples from source
%--
		
if isfield(sound, 'data')
	X = sound.data;
else
	X = sound_read(sound, 'samples', ix, n, ch);
end

%--
% filter samples
%--

% NOTE: the context here has as page the full display page, set in 'browser_sound_menu'

% TODO: consider gain normalization and setting, after each filter or after all filters, peak or RMS?

if ~isempty(player.filter)
	
% 	in = max(abs(X(:)));
	
	for k = 1:numel(player.filter)
		X = apply_signal_filter(X, player.filter(k).ext, player.filter(k).context);
	end
	
% 	out = max(abs(X(:)));
	
end

%--
% resample for player
%--

X = player_resample(X, player);
