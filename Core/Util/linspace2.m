function Y = linspace2(X1, X2, n)

% linspace2 - linspace for vectors and matrices
% ---------------------------------------------
%
% Y = linspace2(X1, X2, n)
%
% Input:
% ------
%  X1, X2 - start and end point
%  n - number of points
%
% Output:
% -------
%  Y - linearly spaced points

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
% $Revision: 2268 $
% $Date: 2005-12-13 12:19:40 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%--------------------
% HANDLE INPUT
%--------------------

%--
% set number of points
%--

if nargin < 3
    n = 100;
end

%--
% check input sizes
%--

if ndims(X1) > 2
	error('Only vectors and matrices are supported.');
end

if ~isequal(size(X1), size(X2))
	error('Start and end points must have the same shape.');
end

%--------------------
% HANDLE INPUT
%--------------------

[r, c] = size(X1);

% points

if max(r, c) == 1
	Y = linspace(X1, X2, n); return;
end

% vectors

if min(r, c) == 1
	
	% rows and columns
	
	if r == 1
		Y = [X1; ((1:(n - 2)) / (n - 1))' * (X2 - X1); X2];
	else
		Y = [X1, (X2 - X1) * ((1:(n - 2)) / (n - 1)), X2];
	end
	
	return;
	
end

% matrices

Y = zeros(r, c, n); Y(:,:,1) = X1; Y(:,:,n) = X2;

w = ((1:(n - 2)) / (n - 1)); X12 = X2 - X1;

for k = 1:(n - 2)
	Y(:,:,k) = w(k) * X12;
end
