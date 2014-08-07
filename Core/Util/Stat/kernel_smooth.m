function y = kernel_smooth(h,c,k)

% kernel_smooth - smooth histogram using a kernel
% -----------------------------------------------
%
% y = kernel_smooth(h,c,k)
%
% Input:
% ------
%  h - bin counts
%  c - bin centers
%  k - kernel
%
% Output:
% -------
%  y - smoothed histogram

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
% normalize histogram
%--

nh = h / ((c(2) - c(1)) * sum(h));

%--
% smooth histogram using kernel 
%--

y = conv2(nh,k,'same');

%--
% consider edge effects
%--

k = cumsum(k);
n = length(k); 
n = floor(n/2) + 1;
k = k(end - n + 1:end);

y(1:n) = y(1:n) ./ k;
y(end - n + 1:end) = y(end - n + 1:end) ./ fliplr(k);
