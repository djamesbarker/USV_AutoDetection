function Y = hist_specify(X,h,c)

% hist_specify - histogram specification
% --------------------------------------
%
% Y = hist_specify(X,h,c)
%
% Input:
% ------
%  X - input image
%  h - bin frequencies
%  c - bin centers
% 
% Output:
% -------
%  Y - histogram specified image

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2005-12-15 13:52:40 -0500 (Thu, 15 Dec 2005) $
% $Revision: 2304 $
%--------------------------------

%--
% coerce double image
%--

X = double(X);

%--
% create uniformly distributed image
%--

% compute extreme values and pdf

b = fast_min_max(X);

[hx,cx] = hist_1d(X,256,b);

% create look up table using cdf

T = cumsum(hx);

T = [0, (T / T(end))];

%--
% apply look up table
%-- 

Y = lut_apply(X,T,b);

%--
% specify histogram
%--
	
% create look up table using cdf

x = cumsum(h + 10^(-10));
x = [0, (x / x(end))];

w = c(2) - c(1);
y = [c - (w / 2), c(end) + (w / 2)];

% create uniform grid on range use interp1
	
xi = linspace(0,1,256);
w = (xi(2) - xi(1));
	
T = interp1(x,y,xi,'linear');
	
% second look up

Y = lut_apply(Y,T,fast_min_max(Y));
