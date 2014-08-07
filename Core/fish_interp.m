function X = fish_interp(X,b,p)

% fish_interp - perform simple fish-eye effect interpolation
% ----------------------------------------------------------
%
% Y = fish_interp(X,b,p)
%
% Input:
% ------
%  X - input image
%  b - band to distort
%  p - distortion parameter
%
% Output:
% -------
%  X - interpolated image

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
% $Date: 2004-12-12 23:59:12 -0500 (Sun, 12 Dec 2004) $
% $Revision: 261 $
%--------------------------------

%--
% set band
%--

if ((nargin < 2) | isempty(b))
	b = [0,0.5];
end

%--
% compute band indices
%--

[m,n] = size(X);

m1 = max(floor(m*b(1)),1);

m2 = min(ceil(m*b(2)),m);

%--
% compute interpolation grid
%--

xi = lut_range(fish_grid(length(m1:m2)),[m1,m2]);

%--
% computer interpolated pixels
%--

X(m1:m2,:) = interp1(m1:m2,X(m1:m2,:),xi,'linear');
