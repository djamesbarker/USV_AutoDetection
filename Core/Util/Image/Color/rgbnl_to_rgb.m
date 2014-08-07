function Y = rgbnl_to_rgb(X)

% rgbnl_to_rgb - nonlinear rgb to rgb image
% -----------------------------------------
%
% Y = rgbnl_to_rgb(X)
%
% Input:
% ------
%  X - rgb image
%
% Output:
% -------
%  Y - nonlinear rgb image

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
% compute conversion
%--

Y = X;

Y(:,:,1) = (Y(:,:,1) * (1/255)).^(2.5) * 255;
Y(:,:,2) = (Y(:,:,2) * (1/255)).^(2.5) * 255;
Y(:,:,3) = (Y(:,:,3) * (1/255)).^(2.5) * 255;
