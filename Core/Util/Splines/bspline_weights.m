function w = bspline_weights(f, h)

% bspline_weights - get spline matrix and solve for weights
% ---------------------------------------------------------
% w = bspline_weights(f, h)
%
% Input:
% ------
%  f - values of function on equi-spaced grid
%  h - grid space
%
% Output:
% -------
%  w - weights

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

if nargin < 2 || isempty(h)
	h = 1;
end

A_inv = bspline3_matrix(length(f), h);

w = A_inv * f(:);


