function y = bspline3(x, n, h)

% bspline3 - cubic b-spline
% ----------------------------------------------
% y = bspline3(x, n, h)
%
% Input:
% ------
%  x - input parameter vector
%  n - offset (number of indexes)
%  h - width parameter
%
% Output:
% -------
%  y - spline function values

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
% Author: Matt Robbins
%--------------------------------
% $Revision$
% $Date$
%--------------------------------

%--
% handle input
%--

if nargin < 3 || isempty(h)
	h = 1;
end

if nargin < 2 || isempty(n)
	n = 0;
end

x = x - h*n;

%--
% split x into pieces
%--

x_1 = x(x < -2*h);

x_2 = x(x >= -2*h & x < -h) + 2*h;

x_3 = x(x >= -h & x < 0) + h;

x_4 = h - x(x >= 0 & x < h);

x_5 = 2*h -x(x >= h & x < 2*h);

x_6 = x(x >= 2*h);

%--
% compute y by segment
%--

y_1 = zeros(size(x_1)); y_6 = zeros(size(x_6));

y_2 = x_2.^3;

y_3 = h^3 + 3*h^2*x_3 + 3*h*x_3.^2 - 3*x_3.^3; 

y_4 = h^3 + 3*h^2*x_4 + 3*h*x_4.^2 - 3*x_4.^3; 

y_5 = x_5.^3;

%--
% assemble y
%--

y = [y_1, y_2, y_3, y_4, y_5, y_6] / h^3;
