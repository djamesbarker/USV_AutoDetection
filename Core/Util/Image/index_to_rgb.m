function Y = index_to_rgb(X,C)

% index_to_rgb - convert indexed image to rgb
%
% Y = index_to_rgb(X,C)
%
% Input:
% ------
%  X - indexed image
%  C - colormap
%
% Output:
% -------
%  Y - rgb image
%

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
% allocate rgb image
%--

[m,n] = size(X);

Y = zeros(m,n,3);

%--
% create rgb image using lut
%--

for k = 1:3
	Y(:,:,k) = lut_apply(X,C(:,k),1,1);
end
