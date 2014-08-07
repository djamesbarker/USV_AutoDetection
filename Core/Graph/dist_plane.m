function D = dist_plane(x,y)

% dist_plane - distance matrix for plane points 
% ---------------------------------------------
%
% D = dist_plane(x,y)
%
% Input:
% ------
%  x - plane positions (row index)
%  y - plane positions (column index)
%
% Output:
% ------
%  D - distance matrix

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
% put vectors into complex numbers
%--

if (isreal(x))
	x = x(:,1) + i*x(:,2);
end

if (isreal(y))
	y = y(:,1) + i*y(:,2);
end

%--
% compute distance matrix
%--

% non-hermitian transpose

x = x.';

m = length(x);
n = length(y);

D = abs(repmat(x,[n,1]) - repmat(y,[1,m]));
