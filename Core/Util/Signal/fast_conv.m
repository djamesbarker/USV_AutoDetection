function Y = fast_conv(X, h)

% fast_conv - fast convolution
% ----------------------------
% 
% Y = fast_conv(X, h)
%
% Input:
% ------
%  X - input signals as columns
%  h - filter
%
% Output:
% -------
%  Y - filtered signals as columns

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
% handle input
%--

% TODO: generalize to handle filter bank input

h = h(:);

%--
% compute size
%--

% NOTE: consider using 'better_fft_sizes'

n = size(X, 1) + size(h, 1) - 1; N = pow2(nextpow2(n));

%--
% convolve in the frequency domain
%--

% NOTE: 'fft' pads signals as needed to match size input

X = fft(X, N); H = fft(h, N); 

Y = X .* (H * ones(1, size(X, 2)));

%--
% return to initial domain and select
%--

Y = real(ifft(Y, N)); Y = Y(1:n, :);


