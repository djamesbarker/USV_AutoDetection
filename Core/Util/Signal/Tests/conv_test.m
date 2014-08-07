function [passed, info] = conv_test(n, m, tol)

% conv_test - compare and time 'conv', 'filter', and 'fast_conv'
% --------------------------------------------------------------
%
% [passed, info] = conv_test(n, m, tol)
%
% Input:
% ------
%  n - length of signal
%  m - length of filter
%  tol - max sample error tolerance
%
% Output:
% -------
%  passed - result
%  info - error, timing, and speedup

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

if nargin < 3
	tol = 10^5;
end

if nargin < 2
	m = 10^3;
end

if nargin < 1
	n = 10^5;
end

%--
% convolve random vectors
%--

x = randn(n, 1); h = randn(m, 1);

% NOTE: 'conv' and 'fast_conv' are equivalent

start = clock; y1 = conv(x, h); elapsed.conv = etime(clock, start);

start = clock; y2 = fast_conv(x, h); elapsed.fast_conv = etime(clock, start);

% NOTE: 'filter' requires some padding to match

start = clock; y3 = filter(h, 1, [x; zeros(m - 1, 1)]); elapsed.filter = etime(clock, start);

%--
% collect and pack output result and info
%--

info.error = max(abs(y1 - y2)) + max(abs(y2 - y3)) + max(abs(y1 - y3));

info.signal = n;

info.filter = m;

info.elapsed = elapsed;

% NOTE: we compute the average speedup considering equal use of 'filter' and 'conv'

info.speedup = (elapsed.conv + elapsed.filter) / (2 * elapsed.fast_conv);

passed = info.error < tol;

if ~nargout
	
	flatten(info)
	
	clear passed;
	
end
