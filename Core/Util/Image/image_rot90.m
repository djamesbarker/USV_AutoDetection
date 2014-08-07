function Y = image_rot90(X,n)

% image_rot90 - rotate image multiple of 90 degrees
% -------------------------------------------------
%
% Y = image_rot90(X,n)
%
% Input:
% ------
%  X - input image
%  n - multiple of 90 to rotate
%
% Output:
% -------
%  Y - rotated image

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
% get effective n
%--

n = mod(n,4);

%--
% scalar or color  image
%--

d = ndims(X);

switch (d)

	case (2)
	
		switch (n)
		
			case (1)
				Y = X';
				Y = flipud(Y);
				
			case (2)
				Y = flipud(X);
				Y = fliplr(Y);
			
			case (3)
				Y = X';
				Y = fliplr(Y);
			
		end
			
	case (3)
		
		switch (n)
		
			case (1)
				Y = permute(X,[2 1 3]);
				Y = flipdim(Y,1);
				
			case (2)
				Y = flipdim(X,1);
				Y = flipdim(Y,2);
			
			case (3)
				Y = permute(X,[2 1 3]);
				Y = flipdim(Y,2);
			
		end
		
end
