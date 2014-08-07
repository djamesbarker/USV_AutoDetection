function Y = luv_to_xyz(X,w)

% luv_to_xyz - luv to xyz conversion
% ----------------------------------
%
% Y = luv_to_xyz(X,w)
%
% Input:
% ------
%  X - luv image
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
% set white point
%--

if (nargin < 2)
   w = [0.9642, 1, 0.8249]; 
end

Xn = w(1);
Yn = w(2);
Zn = w(3);

%--
% separate input planes
%--

L = double(X(:,:,1));
u = double(X(:,:,2));
v = double(X(:,:,3));

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

io = L > 8;
I = find(io);
Y(I) = (((L(I) + 16) / 116).^3) * Yn;
io = ~io;
I = find(io);
Y(I) = L(I) .* (Yn/903.3);

tmpn = Xn + (15 * Yn) + (3 * Zn);
un = (4 * Xn) ./ tmpn;
vn = (9 * Yn) ./ tmpn;

tmp = 13 * L;
I = find(tmp);
u(I) = u(I) ./ tmp(I) + un;
v(I) = v(I) ./ tmp(I) + vn;
I = find(~tmp);
u(I) = 0;
v(I) = 0;

I = find(v);
tmp = zeros(size(L));
tmp(I) = (9 * Y(I)) ./ v(I);
X = u .* tmp * 0.25;

Z = (tmp - X - (15 * Y)) * (1/3);

tmp(:,:,1) = X;
tmp(:,:,2) = Y;
tmp(:,:,3) = Z;

Y = tmp;
