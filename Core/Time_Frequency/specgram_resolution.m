function [dt, df] = specgram_resolution(param, rate)

% specgram_resolution - spectrogram time frequency resolution
% ----------------------------------------------------
%
% [dt, df] = specgram_resolution(param, rate)
%
% Input:
% ------
%  param - spectrogram parameters
%  rate - sample rate
%
% Output:
% -------
%  dt - time resolution
%  df - frequency resolution

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
% time frequency resolution
%--

overlap = round(param.fft * (1 - param.hop));

hop_samples = param.fft - overlap;

dt = (hop_samples * param.sum_length) / rate;

if nargout < 2
	return;
end

% NOTE: this may not be exact

nyq = rate / 2;

bins = floor(param.fft / 2) + 1;

df = nyq / (bins - 1);
	

% df = rate / param.fft;
