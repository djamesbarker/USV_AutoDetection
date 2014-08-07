function [t, yp] = spline_eval(y, x, N, A)

%-----------------------
% HANDLE INPUT
%-----------------------

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

if nargin < 4 || isempty(A)
	A = 1;
end

if (nargin < 3) || isempty(N)
	N = 100; 
end

if (nargin < 2)
	x = [];
end

%-----------------------
% EVALUATE SPLINE
%-----------------------

%--
% make parametric curve grid
%--

t = linspace(0, length(y) - 3, N);

%--
% evaluate y component of spline
%--

% NOTE: we consider y the default, because we think of a spline function

dys = A * (y(2) - y(1)); dye = A * (y(end) - y(end - 1));

y = y(2:end-1);

wy = bspline_weights([dys; y(:); dye]);

yp = eval_bspline(t, wy);

%--
% evaluate x component of spline if needed
%--

% NOTE: this maps the parametric curve grid from the interval onto a curve

if isempty(x) 
    return;
end

dxs = A * (x(2) - x(1)); dxe = A * (x(end) - x(end - 1));

x = x(2:end-1);

wx = bspline_weights([dxs; x(:); dxe]);

t = eval_bspline(t, wx);

