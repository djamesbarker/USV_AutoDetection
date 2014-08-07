function Y = rgb_linear(X,V)

% rgb_linear - linear transform of colorspace
% -------------------------------------------
%
% Y = rgb_linear(X,V)
%
% Input:
% ------
%  X - input image
%  V - linear transformation
%
% Output:
% -------
%  Y - linear transform colorspace image

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
% get image size
%--

[m,n,d] = size(X); 

if (d ~= 3)
	disp(' ');
	error('Input image does not have three channels.');
end

%--
% check size of transform
%--

if (any(size(V) ~= 3))
	error('Colorspace transformation matrix must be 3 by 3.');
end

%--
% apply linear transform
%--

Y = rgb_reshape(rgb_vec(X)*V,m,n);


