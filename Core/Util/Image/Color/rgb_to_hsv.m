function Y = rgb_to_hsv(X)

% rgb_to_hsv - rgb to hsv conversion
% ----------------------------------
%
% Y = rgb_to_hsv(X)
%
% Input:
% ------
%  X - rgb image
%
% Output:
% -------
%  Y - hsv image

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
% get size of input
%--

[m,n,d] = size(X);

%--
% map input values into the unit interval if needed
%--

b = fast_min_max(X);

if ((b(1) < 0) | (b(2) > 1))
	
% 	disp(' ');
% 	warning('Converting RGB image to unit values.');
	
	X = lut_range(X,[0 1]);
	
end

%--
% compute according to input
%--

switch (d)

	case (1)
	
		%--
		% single color conversion
		%--
		
		if (m*n == 3)
			
			Y = rgb_to_hsv_(X(:)');
			
		%--
		% colormap conversion
		%--
		
		elseif (n == 3)	
			
			Y = rgb_to_hsv_(X);
			
		%--
		% improper input
		%--
		
		else
		
			disp(' ');
			error('Improper input size.');
			
		end
	
	case (3)
	
		%--
		% color image conversion
		%--
				
		X = rgb_vec(X);
				
		Y = rgb_to_hsv_(X);
			
		Y = rgb_reshape(Y,m,n);
		
		%--
		% map hue to radians
		%--
		
		% this may not be the right place to do this
		
% 		r = 360 / (2 * pi);
% 		
% 		Y(:,:,1) = Y(:,:,1) ./ r;
		
end
