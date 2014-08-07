function Y = median_filter(X,SE,n,b)

% median_filter - median filter
% -----------------------------
% 
% Y = median_filter(X,SE,n,b)
%   = median_filter(X,SE,Z,b)
%
% Input:
% ------
%  X - input image or handle to parent figure
%  SE - structuring element
%  n - iterations of operation (def: 1)
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1 ~ reflecting)
%
% Output:
% -------
%  Y - median filtered image

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
% $Revision: 5233 $
% $Date: 2006-06-12 18:45:19 -0400 (Mon, 12 Jun 2006) $
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

if ((nargin < 3) || isempty(n))
	n = 1;
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
% color image
%--

if (ndims(X) > 2)
	
	[r,c,s] = size(X);
	
	for k = 1:s
		
		if (isempty(Z))
			Y(:,:,k) = median_filter(X(:,:,k), SE, n, b);
		else
			Y(:,:,k) = median_filter(X(:,:,k), SE, Z, b);
		end

	end
	
%--
% scalar image
%--

else
	
	%--
	% structuring element
	%--
	
	B = se_mat(SE); pq = se_supp(SE);
	
	%--
	% iterate operator
	%--
	
	if (isempty(Z))
		
		for j = 1:n
			X = image_pad(X, pq, b);
			Y = median_filter_(X, uint8(B));
			X = Y;
		end
	
	%--
	% mask operator
	%--
			
	else

		X = image_pad(X, pq, b); Z = image_pad(Z, pq, 0);
		
		Y = median_filter_(X, uint8(B), uint8(Z));
		
	end
	
end
