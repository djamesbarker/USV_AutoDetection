function Y = mask_apply(X1,X2,Z)

% mask_apply - compose and mask images
% ------------------------------------
% 
% Y = mask_apply(X1,X2,Z)
%   = mask_apply(X1,Z)
%
% Input:
% ------
%  X1 - input image 
%  X2 - input image or scalar
%  Z - indicator for X1
%
% Output:
% -------
%  Y - composed or masked image

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
% handle variable input
%--

if (nargin < 3)
	Z = X2;
	X2 = zeros(size(X1));
end

%--
% image or scalar
%--

if (length(X2) == 1)
	X2 = X2*ones(size(X1));
end

%--
% color image
%--

if (ndims(X1) == 3)
	
	Y = zeros(size(X1));
	
	for k = 1:3
		Y(:,:,k) = mask_apply(X1(:,:,k),X2(:,:,k),Z);
	end
	
else

	%--
	% get image types
	%--
	
	i1 = isa(X1,'UINT8');
	i2 = isa(X2,'UINT8');
	
	%--
	% compute masked composition
	%--
	
	switch (i1 + i2)
			
	%--
	% mixed images
	%--
	
	case (1)
			
		if (i1)
			X1 = double(X1);
		else 
			X2 = double(X2);
		end
		
		Y = mask_(X1,X2,uint8(Z));
	
	%--
	% same type images
	%--
	
	otherwise
			
		Y = mask_(X1,X2,uint8(Z));
				
	end
	
end
