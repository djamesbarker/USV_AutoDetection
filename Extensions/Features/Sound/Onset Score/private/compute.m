function [feature, context] = compute(page, parameter, context)

% ONSET SCORE - compute

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

feature = struct;

%--
% get samples
%--

if ~isempty(page.filtered)
	page.samples = page.filtered;
end

%--
% compute spectrogram
%--

rate = get_sound_rate(context.sound);

[X, freq, time] = fast_specgram(page.samples, rate, 'norm', context.sound.specgram);

%--
% compute feature time
%--

% NOTE: the common onset feature time grid is between spectrogram frames

time(end) = []; time = time + 0.5 * (time(2) - time(1));

feature.time = page.start + time;

%--
% compute onset score
%--

onset = diff_dist(X, 'foote');

feature.onset.sequence = onset;

% TODO: this should be into a 'get_stats' type function

feature.onset.range = fast_min_max(onset);

feature.onset.mean = mean(onset);

feature.onset.std = std(onset);

% TODO: make the scale a parameter

[feature.onset.peaks, feature.onset.smooth] = scale_peaks(onset(:), 63);
