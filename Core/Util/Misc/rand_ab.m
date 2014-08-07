function x = rand_ab(n, a, b)

% rand_ab - uniform random numbers in an interval
% -----------------------------------------------
%
% x = rand_ab(n, a, b)
%
% Input:
% ------
%  n - size of output
%  a - min value
%  b - max value
%
% Output:
% -------
%  x - random numbers in interval

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

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set default interval limit
%--

if nargin < 2
	a = 1;
end

%--
% set interval for single interval input
%--

if nargin < 3
	b = abs(a);
	a = -b;
end

%--
% set default number of outputs
%--

if nargin < 1
	n = 1;
end

%--
% check limits
%--

% NOTE: we simply swap the values

if b < a
	c = b; b = a; a = c;
end

%----------------------------------
% COMPUTE
%----------------------------------

rand('state', sum(100 * clock))

x = ((b - a) * rand(n)) + a;

