function [v,q] = hist_2d_level(H,p)

% hist_2d_level - level curves for 2d histogram
% ----------------------------------------------
%
% [v,q,p] = hist_2d_levels(H,p)
%
% Input:
% ------
%  H - histogram
%  p - cumulative probabilities (def: [0.25, 0.5, 0.75])
%
% Output:
% -------
%  v - contour values to obtain cumulative probabilities
%  q - actual cumulative probabilities

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
% $Date: 2003-09-16 01:32:05-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% set levels
%--

if (nargin < 2)
	p = [0.25, 0.5, 0.75];
end
	
%--
% normalize histogram, get value range
%--

H = H / sum(H(:));

b = fast_min_max(H);

%--
% bisect to find contour values
%--
	
v = zeros(size(p));
q = v;

for k = 1:length(p)
	[v(k),q(k)] = bisect(H,p(k),b(1),b(2));
end



function [v,q] = bisect(H,p,a,b)

% bisect - bisect a cdf given by a normalized histogram
% -----------------------------------------------------
%
% [v,q] = bisect(H,p,a,b)
%
% Input:
% ------
%  H - normalized histogram
%  p - desired probability
%  a,b - lower and upper limits for bisection
%
% Output:
% -------
%  v - approximate value which gives desired level
%  q - actual probability
%

%--
% set iterations and tolerance
%--

it = 50;
tol = 10^(-2);

%--
% iterate bisection
%--

for k = 1:it

	%--
	% compute function at mid point
	%--

	v = (a + b) / 2;
	q = sum(H(find(H <= v)));

	%--
	% bisect
	%--

	if ((q - p) > tol)
		b = v;
	elseif ((q - p) < -tol)
		a = v;
	else
		return;
	end
	
end

