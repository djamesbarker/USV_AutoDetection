function Y = rgb_reshape(X,m,n)

% rgb_reshape - reshape rgb columns into rgb image
% ------------------------------------------------
%
% Y = rgb_reshape(X,m,n)
%   = rgb_reshape(X,m)
% 
% Input:
% ------
%  X - rgb columns
%  m - rows, or rows and columns
%  n - columns
% 
% Output:
% -------
%  Y - rgb image

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
% set rows and columns
%--

if (nargin < 3)
	n = m(2);
	m = m(1);
end

%--
% check rgb columns
%--

if (size(X,2) ~= 3)
	error('Input image is not in pixel row format.');
end

%--
% reshape image
%--

Y = zeros(m,n,3);

for k = 1:3
	Y(:,:,k) = reshape(X(:,k),m,n);
end
