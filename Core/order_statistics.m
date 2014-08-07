function [v,ix] = order_statistics(X,k)

% order_statistics - compute order statistics of an array
% -------------------------------------------------------
%
% [v,ix] = order_statistics(X,k)
%
% Input:
% ------
%  X - array of values
%  k - depth of elements
%
% Output:
% -------
%  v - order statistic values
%  ix - order statistic value indices in input array

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
% check desired depths
%--

if (any(k ~= round(k)) | any(k == 0))
	disp(' ');
	error('Order index values must be non-zero integers.');
end

%--
% separate positive and negative depths
%--

ixp = find(k > 0);
kp = k(ixp);
np = length(kp);

ixn = find(k < 0);
kn = k(ixn);
nn = length(kn);

%--
% compute smallest and largest elements in array
%--

if (np)
	Y = X;
	[vp,ixvp] = order_smallest(Y,kp);
end

if (nn)
	Y = X;
	[vn,ixvn] = order_largest(Y,-kn);
end

%--
% interleave values and indices to reflect input
%--

if ((np ~= 0) & (nn ~= 0))
	
	v(ixp) = vp;
	ix(ixp) = ixvp;
	
	v(ixn) = vn;
	ix(ixn) = ixvn;
	
else
	
	if (np)
		v = vp;
		ix = ixvp;
	else
		v = vn;
		ix = ixvn;
	end
	
end

