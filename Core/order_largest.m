function [v,ix,Y] = order_largest(X,k)

% order_largest - compute largest elements in an array
% ----------------------------------------------------
%
% [v,ix,Y] = order_largest(X,k)
%
% Input:
% ------
%  X - array of values
%  k - largest position indices
%
% Output:
% -------
%  v - largest values
%  ix - largest value indices in input array
%  Y - partiallt ordered array

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
% check and sort desired indices
%--

if (any(k ~= round(k)) | any(k < 1))
	disp(' ');
	error('Order index values must be positive integers.');
end

% sort from largest to smallest

[k,kix] = sort(k(:)');
k = fliplr(k);

%--
% copy input array and invert order of values by changing sign
%--

Y = -X;

%--
% compute values and indices of largest values
%--

% the mex file changes the variable Y

[v,ix] = kth_smallest_(Y,k);

%--
% reorder output and fix signs on values
%--

v = fliplr(v);
v = -v(kix);

ix = fliplr(ix);
ix = ix(kix);

%--
% output array, change signs again
%--

if (nargout > 2)
	Y = -Y;
end
