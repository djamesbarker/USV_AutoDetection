function hist_smooth

% hist_smooth - compute smoothed histogram
% ----------------------------------------
%
% [h,c,v] = hist_smooth(X,e,n,b);
% 
% Input:
% ------
%  X - input image
%  e - epsilon parameter
%  n - number of bins (def: 256)
%  b - bounds for values (def: extreme values)
%
% Output:
% -------
%  h - bin counts
%  c - bin centers
%  v - bin breaks

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
% $Date: 2003-09-16 01:32:06-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% compute histogram
%--
		
[h,c,v] = hist_1d(X,n,b)		
	
%--
% smooth histogram
%--
	
O = v(1);
w = c(2) - c(1);

m = round(E / w);
LUT = conv2(h,ones(1,2*m + 1),'same');
