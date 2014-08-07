function [r, p, q] = get_player_resample_rate(r)

% get_player_resample_rate - get player rate and resample factors
% ---------------------------------------------------------------
%
% [r, p, q] = get_player_resample_rate(r)
%
% Input:
% ------
%  r - input samplerate
%
% Output:
% -------
%  r - player samplerate
%  p,q - resample factors

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
% create list of typical play supported rates
%--

persistent TYPICAL_PLAY_RATES;

if isempty(TYPICAL_PLAY_RATES)
	TYPICAL_PLAY_RATES = [8000, 11025, 22050, 44100, 48000]; 
end

%--
% check if we are playing a supported rate
%--

if ismember(r, TYPICAL_PLAY_RATES)
	p = []; q = []; return;
end

%--
% select sufficient rates from available rates
%--

rates = TYPICAL_PLAY_RATES(TYPICAL_PLAY_RATES >= r);

if isempty(rates)
	rates = TYPICAL_PLAY_RATES(end);
end

%--
% select samplerate based on efficient resampling scheme 
%--

for k = 1:length(rates)
	[p(k), q(k)] = rat(rates(k) / r);
end

[ignore, ix] = min(p + q); 

r = rates(ix); p = p(ix); q = q(ix);
