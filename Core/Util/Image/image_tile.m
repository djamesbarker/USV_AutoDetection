function Y = image_tile(X,m,n)

% image_tile - tile image
% -----------------------
%
% Y = image_tile(X,m,n)
% 
% Input:
% ------
%  X - image to tile
%  m - number of rows or size of image
%  n - number of columns
%
% Output:
% -------
%  Y - tiled image

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
% parse size parameters
%--

if (nargin < 3)

	switch (length(m))
	
		% square space
		case (1)
			n = m;
		
		% m is size of image
		case (2)
			n = m(2);
			m = m(1);
			
	end
	
end

%--
% tile image
%--

switch (ndims(X))

	% scalar image
	
	case (2)
		Y = repmat(X,m,n);
		
	% rgb image
	
	case (3)
		for k = 1:3
			Y(:,:,k) = repmat(X(:,:,k),m,n);
		end
		
end
