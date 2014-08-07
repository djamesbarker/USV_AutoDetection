function [N,ix,i,j] = get_image_neigh(X,SE,Z,j)

% get_image_neigh - get image neighborhood data
% ---------------------------------------------
%
% [N,ix,i,j] = get_image_neigh(X,SE)
%            = get_image_neigh(X,SE,i,j)
%            = get_image_neigh(X,SE,Z)
%
% Input:
% ------
%  X - input image
%  SE - structuring element
%  Z - selection mask
%
% Output:
% -------
%  N - image neighborhood data
%  ix - index corresponding to center pixel
%  i,j - row and column indices

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
% $Date: 2003-07-06 13:36:52-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% pixels and selection mask
%--

switch (nargin)

	case (2)
		[i,j] = get_image_pixels(X);
		[m,n] = size(X);
		Z = mask_ixd([m, n; i j]);
			
	case (4)
		i = Z;
		[m,n] = size(X);
		Z = mask_ixd([m, n; i j]);
		
end
	
%--
% structuring element
%--
	
B = se_mat(SE);
pq = se_supp(SE);
		
%--
% pad images
%--

X = image_pad(X,pq,-1);
Z = image_pad(Z,pq,0);

%--
% create index set
%--

[i,j] = find(Z);

%--
% get neighborhood data
%--

N = get_neigh_(X,uint8(SE),i - 1,j - 1);

%--
% get index
%--

if (nargout > 1)
	v = sum(abs(se_vec(SE)),2);
	ix = find(v == 0);
end


