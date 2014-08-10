function [feature, context] = compute(page, parameter, context)

% AMPLITUDE - compute

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
% work with filtered samples if available
%--

if ~isempty(page.filtered)
	page.samples = page.filtered;
end

%--
% compute various amplitude envelope estimates 
%--

% NOTE: the time scale parameter should inspect the rate to set bounds

rate = get_sound_rate(context.sound); 

n = round(rate * parameter.block); m = round(n * parameter.overlap);

if length(page.samples) < 5000
	feature.wave = page.samples;
else
	feature.wave = [];
end

%-------------------

% NOTE: pad to allow last block to be computed

[N, M] = size(page.samples);

if m
	N0 = m * floor((N - n) / m) + n;
else
	N0 = n * floor(N / n);
end

pad = n - (N - N0);

page.samples = [page.samples; zeros(pad, M)];

%-------------------

A1 = fast_amplitude(page.samples, n, m, 'rms'); 

[A2, A3] = fast_amplitude(page.samples, n, m, 'abs');

feature.rms.value = A1;

feature.abs.value = A2;

feature.max.value = A3;

%--
% compute common feature time
%--

% NOTE: this time is for all features that have no time

feature.time = linspace(page.start, page.start + page.duration, length(A1) + 1);

feature.time(end) = [];

