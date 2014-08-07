function s = eval_bspline(t, weights, spline_fun)

% eval_bspline - evaluate b-spline approximation
% ----------------------------------------------
% s = eval_bspline(t, weights, spline_fun)
%
% Input:
% ------
%  t - parameter vector
%  weights - weights
%  spline_fun - function handle to individual spline function
%
% Output:
% -------
%  s - values for t

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

if nargin < 4 || isempty(spline_fun)
	spline_fun = @bspline3;
end

s = zeros(size(t));

for j = 1:length(weights)
	s = s + weights(j) * spline_fun(t, j - 2);
end
