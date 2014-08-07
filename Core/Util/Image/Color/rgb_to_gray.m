function Y = rgb_to_gray(X)

% rgb_to_gray - rgb to grayscale image
% ------------------------------------
%
% Y = rgb_to_gray(X)
%
% Input:
% ------
%  X - rgb image
%
% Output:
% -------
%  Y - grayscale image

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
% get size of input
%--

[m,n,d] = size(X);

if (d ~= 3)
	error('Input image is not a multiple channel image.');
end

%--
% make double image
%--

X = double(X);

%--
% rgb to ??? transformation
%--

V = [ ...
	0.393  0.365  0.192; ...
	0.212  0.701  0.087; ...
	0.019  0.112  0.958 ...
];

%--
% apply transformation
%--

Y = reshape(rgb_vec(X)*V(2,:)',m,n);
