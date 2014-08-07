function Y = xyz_to_rgb(X,A)

% xyz_to_rgb - xyz to rgb conversion
% ----------------------------------
%
% Y = xyz_to_rgb(X,A)
%
% Input:
% ------
%  X - rgb image
%  A - colorspace conversion matrix
%
% Output:
% -------
%  Y - xyz image

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
% check size of input
%--

[m,n,d] = size(X);

if (d ~= 3)
	disp(' ');
	error('Input image does not have three channels.');
end

%--
% set the colorspace tranformation matrix
%--

if (nargin < 2)
	A = [ ...
		0.393  0.365  0.192; ...
		0.212  0.701  0.087; ...
		0.019  0.112  0.958 ...
	];
end

% scale colorspace transformation matrix

A = inv(A) .* 255;

%--
% compute conversion
%--

Y = rgb_reshape(rgb_vec(X)*A,m,n);
