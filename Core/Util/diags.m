function [D, ix] = diags(A, ix)

% diags - get multiple diagonals from a matrix as matrix
% ------------------------------------------------------
%
% [D, ix] = diags(A, ix)
%
% Input:
% ------
%  A - matrix
%  ix - diagonal indices
%
% Output:
% -------
%  D - diagonals as columns matrix
%  ix - diagonal indices

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
% set default indices
%--

% NOTE: an all indices default is convenient, since it is hard to express when we want it

if (nargin < 2)
	ix = -(size(A, 1) - 1):(size(A, 2) - 1);
end

%--
% get diagonals
%--

n = length(diag(A)); D = zeros(n, length(ix)); 

for k = 1:length(ix)
	
	d = diag(A, ix(k));
	
	if ix(k) < 0
		D(n - length(d) + 1:end, k) = d;
	else
		D(1:length(d), k) = d;
	end
	
end
