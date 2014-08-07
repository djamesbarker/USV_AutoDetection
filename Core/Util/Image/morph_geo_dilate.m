function Y = morph_geo_dilate(X,U,n,b)

% morph_geo_dilate - morphological geodesic dilation
% --------------------------------------------------
% 
% Y = morph_geo_dilate(X,U,n,b)
%   = morph_geo_dilate(X,U,Z,b)
%
% Input:
% ------
%  X - input image
%  U - upper bound image 
%  n - iterations of operation (def: inf)
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - geodesically dilated image

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% set boundary behavior
%--

if (nargin < 4)
	b = -1;
end

%--
% iteration or mask
%--

if ((nargin < 3) | isempty(n))
	n = inf;
	Z = [];
else
	Z = [];
	[r,c,s] = size(X);
	if (all(size(n) == [r,c]))
		Z = n;
		n = 1;
	end
end

%--
% check bound
%--

if (any(vec_col(X > U)))
	error('Parts of input image are smaller than lower bound image.');
end

%--
% color image
%--

if (ndims(X) > 2)
	
	[r,c,s] = size(X);
	
	for k = 1:s
		if (isempty(Z))
			Y(:,:,k) = morph_geo_dilate(X(:,:,k),U(:,:,k),n,b);
		else
			Y(:,:,k) = morph_geo_dilate(X(:,:,k),U(:,:,k),Z,b);
		end
	end	
	
%--
% scalar image
%--

else

	%--
	% upper bound
	%--
	
	U = image_pad(U,[1,1],b);
	
	%--
	% iterate operator
	%--
	
	for j = 1:n
	
		%--
		% pad
		%--
		
		X = image_pad(X,[1,1],b);

		if (~isempty(Z))
			Z = image_pad(Z,[1,1],0);
		end
			
		%--
		% compute
		%--
					
		[Y,A] = morph_geo_dilate_(X,U);
		
		%--
		% convergence
		%--
		
		if (any(A(:)))
			X = Y;
		else
			break;
		end

	end
	
end
