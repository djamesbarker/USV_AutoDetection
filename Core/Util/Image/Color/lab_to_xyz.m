function Y = lab_to_xyz(X,w)

% lab_to_xyz - lab to xyz conversion
% ----------------------------------
%
% Y = lab_to_xyz(X,w)
%
% Input:
% ------
%  X - lab image
%  w - white point
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
% set white point and rename components
%--

if (nargin < 2)
   w = [0.9642, 1, 0.8249];
end

Xn = w(1);
Yn = w(2);
Zn = w(3);

%--
% separate planes
%--

L = double(X(:,:,1));
a = double(X(:,:,2));
b = double(X(:,:,3));

%--
% allocate output planes
%--

X = zeros(size(L));
Y = X;
Z = X;

%--
% compute conversion
%--

offset = 0.008856;

fY = (L + 16) .* (1/116);
I = find(fY <= (7.787 * offset + (16/116)));
Y = fY.^3;
Y(I) = (1/7.787) * (fY(I) - (16/116));

a = a./500 + fY;
I = find(a <= (7.787 * offset + (16/116)));
X = a.^3;
X(I) = (1/7.787) * (a(I) - (16/116));

b = fY - b./200;
I = find(b <= (7.787 * offset + (16/116)));
Z = b.^3;
Z(I) = (1/7.787) * (b(I) - (16/116));

tmp(:,:,1) = Xn * X;
tmp(:,:,2) = Yn * Y;
tmp(:,:,3) = Zn * Z;

Y = tmp;
