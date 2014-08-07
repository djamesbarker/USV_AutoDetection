function Y = xyz_to_lab(X,w)

% xyz_to_lab - lab to xyz conversion
% ----------------------------------
%
% Y = xyz_to_lab(X,w)
%
% Input:
% ------
%  X - xyz image
%  w - white point
%
% Output:
% -------
%  Y - lab image

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
% set white point
%--

if (nargin < 2)
   w = [0.9642, 1, 0.8249];
end

Xn = w(1);
Yn = w(2);
Zn = w(3);

%--
% separate planes and rename
%--

tmp = X;

X = double(tmp(:,:,1)) ./ Xn;
Y = double(tmp(:,:,2)) ./ Yn;
Z = double(tmp(:,:,3)) ./ Zn;

%--
% allocate output planes
%--

L = zeros(size(X));
a = L;
b = L;

%--
% compute conversion
%--

offset = 0.008856;

I = find(Y <= offset);   % Assuming I are few elements
fY = Y.^(1/3);
fY(I) = 7.787 * Y(I) + (16/116);

L = 116 * (fY) - 16;

I = find(X <= offset);
a = X.^(1/3);
a(I) = 7.787 * X(I) + (16/116);
a = (a - fY) * 500;

I = find(Z <= offset);
b = Z.^(1/3);
b(I) = 7.787 * Z(I) + (16/116);
b = (fY - b) * 200;

Y(:,:,1) = L;
Y(:,:,2) = a;
Y(:,:,3) = b;
