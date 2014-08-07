function p = loggauss_fit(X)

% loggauss_fit - log generalized gaussian fit
% -------------------------------------------
% 
% p = loggauss_fit(X)
%
% Input:
% ------
%  X - input data
%
% Output:
% -------
%  p - log generalized gaussian parameters [mean, deviation, shape]

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
% put data in column and zero center
%--

% remove zeros from values

X = X(:);
ix = find(X == 0);
X(ix) = [];

% compute log transformation

X = log(X);

% center values

m = sum(X)/length(X);
X = X - m;

%--
% fit using mex and update mean parameter
%--

p = zeros(1,3);
[p(3),p(2),p(1)] = gauss_fit_(X);

p(1) = p(1) + m;
