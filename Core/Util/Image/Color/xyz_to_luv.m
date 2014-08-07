function Y = xyz_to_luv(X,w)

% xyz_to_luv - xyz to luv conversion
% ----------------------------------
%
% Y = xyz_to_luv(X,w)
%
% Input:
% ------
%  X - xyz image
%  w - white point
%
% Output:
% -------
%  Y - luv image

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
   w = [0.9642,1,0.8249]; % D50, 2 graden waarnemer
end

Xn = w(1);
Yn = w(2);
Zn = w(3);

%--
% separate input planes
%--

tmp = X;

X = double(tmp(:,:,1));
Y = double(tmp(:,:,2));
Z = double(tmp(:,:,3));

Y0 = Y ./ Yn;

%--
% allocate output planes
%--

L = zeros(size(X));
u = L;
v = L;

%--
% compute conversion
%--

offset = 0.008856;

io = Y0 > offset;
I = find(io);
L(I)= 116 .* ((Y0(I)).^(1/3)) - 16;
io = ~io;
I = find(io);
L(I)= 903.3 .* Y0(I);

tmp = X + (15 * Y) + (3 * Z);
I = find(tmp);
u(I) = (4 * X(I)) ./ tmp(I);
v(I) = (9 * Y(I)) ./ tmp(I);

tmpn = Xn + (15 * Yn) + (3 * Zn);
un = (4 * Xn) ./ tmpn;
vn = (9 * Yn) ./ tmpn;

tmp = 13 * L;
u = tmp .* (u - un);
v = tmp .* (v - vn);

Y(:,:,1) = L;
Y(:,:,2) = u;
Y(:,:,3) = v;
