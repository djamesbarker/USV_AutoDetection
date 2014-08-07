function D = dist_hamming(x,y)

% dist_hamming - hamming distance matrix for integers
% ---------------------------------------------------
%
% D = dist_hamming(x,y)
%
% Input:
% ------
%  x - integers (row index)
%  y - integers (column index)
%
% Output:
% -------
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
% compute integer binary representations
%--

% add some error cheking on the fact that inputs are integers

k = max(max(floor(log2(x))) + 1, max(floor(log2(y))) + 1);

x = int_to_bin(x,k);
y = int_to_bin(y,k);

%--
% compute distance matrix
%--

D = dist_euclidean(x,y).^2;
