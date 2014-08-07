function D = dist_euclidean(x,y)

% dist_euclidean - euclidean distance matrix for vectors
% ------------------------------------------------------
%
% D = dist_euclidean(x,y)
%
% Input:
% ------
%  x - column vectors  (row index)
%  y - column vectors (column index)
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
% pack vectors into multidimensional arrays
%--

m = size(x,2);
n = size(y,2);

% non hermitian transpose

x = x.';

x = repmat(permute(x,[1 3 2]),[1 m]);
y = repmat(permute(y,[3 2 1]),[n 1]);

%--
% compute distance matrix
%--

D = sqrt(sum((x - y).^2,3));

% D = (sum((x - y).^p,3)).^(1/p);

