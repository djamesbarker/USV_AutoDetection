function C = zero_specgram(opt,rate,dt,nch)

% zero_specgram - spectrogram of zeros
% ------------------------------------
%
% C = zero_specgram(opt,rate,dt,nch)
%
% Input:
% ------
% opt - spectrogram options
% rate - sample rate
% dt - duration
% ch - the number of channels
% 
% Output:
% -------
% C - spectrogram of zeros

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
% get size of spectrogram image
%--

[f,t] = specgram_size(opt,rate,dt);

%--
% return array for single channel case
%--

if (nch < 2)
	C = zeros(f,t); return;
end

%--
% otherwise make cell array of channels like fast_specgram does
%--

C = cell(1,nch);

for ch = 1:nch
	C{ch} = zeros(f,t);
end



