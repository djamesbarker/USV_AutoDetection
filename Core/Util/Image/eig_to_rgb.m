function Y = eig_to_rgb(X,V,c) 

% eig_to_rgb - eigencolor to rgb conversion
% -----------------------------------------
%
%  Y = eig_to_rgb(X,V,c) 
%
% Input:
% ------
%  X - eigencolor image
%  V - eigencolor basis
%  c - mean color
%
% Output:
% ------
%  X - rgb image

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
% $Date: 2003-07-06 13:36:51-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% get size of input
%--

[m,n,d] = size(X);

if (d ~= 3)
	error('Input image is not a multi-channel image.');
end

%--
% make double image
%--

X = double(X);

%--
% convert to rgb
%--

Y = rgb_reshape(rgb_vec(X)*inv(V) + ones(m*n,1)*c,m,n);

%--
% enforce positivity
%--

Y(find(Y < 0)) = 0;

