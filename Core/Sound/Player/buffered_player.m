function player = buffered_player(sound, ix, n, ch, speed, filter, buflen)

% buffered_player - create audioplayer for long playback
% ------------------------------------------------------
%
% player = buffered_player(sound, ix, n, ch, speed, filter, buflen)
%
% Input:
% ------
%  sound - sound to play
%  ix - starting index 
%  n - number of samples 
%  ch - channels to read
%  speed - play speed
%  filter - output of 'get_active_filters'
%  buflen - buffer length in samples
% 
% Output:
% -------
%  player - buffered player struct

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

%------------------------
% HANDLE INPUT
%------------------------

%--
% set default buffer
%--

if (nargin < 7) || isempty(buflen)
	buflen = 10^6;	
end

%--
% set default filter
%--

if (nargin < 6) 
	filter = [];
end

%------------------------
% CREATE PLAYER
%------------------------

%--
% create player state
%--

% NOTE: this keeps the required state to get filtered data and buffer

player.sound = sound;

player.filter = [];

if isfield(filter, 'signal_filter') && ~isempty(filter.signal_filter)
	
	for k = 1:numel(filter.signal_filter)
		player.filter(k).ext = filter.signal_filter(k);

		player.filter(k).context = filter.signal_context;
	end
	
end

player.speed = speed;

player.samplerate = [];

player.resample = [];

player.ix = ix;

player.n = n;

player.ch = ch; 

player.buffer = [];

player.buflen = buflen;

player.bix = ix; 

%--
% configure resample if needed
%--

[r, p, q] = get_player_resample_rate(player.speed * get_sound_rate(sound));

player.samplerate = r;

if isempty(p)
	return;
end

%---------------

% NOTE: here we build a filter that may supress spurious energy above the data band, we consider the playback speed

cutoff = (player.speed * sound.samplerate) / r;

if stop_whining && cutoff < 1
	
	b = firpm(128, [0, cutoff - 0.1, cutoff, 1], [1 1 0 0]);
	
% 	db_disp; figure; freqz(b, 1, 512, r);
	
	callback = {@resample, p, q, b};
else
	callback = {@resample, p, q};
end

%---------------

player.resample = callback;

