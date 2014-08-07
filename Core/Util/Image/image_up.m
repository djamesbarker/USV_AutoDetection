function Y = image_up(X,u)

% image_up - upsample an image
% ----------------------------
% 
% Y = image_up(X,u)
%
% Input:
% ------
%  X - input image
%  u - rates for rows and columns (def: [2,2])
%
% Output:
% -------
%  Y - upsampled image

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
% set rates
%--

if (nargin < 2)
	u = [2,2];
end

%--
% color image
%--

if (ndims(X) > 2)
	
	[r,c,s] = size(X);
	
	for k = 1:s
		Y(:,:,k) = image_up_(X(:,:,k),u);
	end
	
%--
% scalar image
%--

else
		
	Y = image_up_(X,u);
	
	% Y = im_col_up(im_col_up(X,u(2))',u(1))';

end
	
%--
% local function
%--
		
function Y = im_col_up(X,u)

% im_col_up - image column upsample
% ---------------------------------
%
% Y = im_col_up(X,u)
%
% Input:
% ------
%  X - input image
%  u - upsampling rate
%
% Output:
% -------
%  Y - upsampled image
%

%--
% get size of image
%--

[m,n] = size(X);

%--
% upsample along columns
%--

Y = reshape([X; zeros((u-1)*m,n)],m,u*n);

%--
% remove last zero column
%--

Y = Y(:,1:u*n-1);










