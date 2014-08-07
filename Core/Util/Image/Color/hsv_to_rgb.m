function Y = hsv_to_rgb(X)

% hsv_to_rgb - hsv to rgb conversion
% ----------------------------------
%
% Y = hsv_to_rgb(X)
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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2004-02-11 06:56:06-05 $
% $Revision: 1.1 $
%--------------------------------

%--
% get size of input
%--

[m,n,d] = size(X);

%--
% compute according to input
%--

switch (d)
	
	case (1)
	
		%--
		% single color conversion
		%--
		
		if (m*n == 3)
			
			Y = hsv_to_rgb_(X(:)');
			
		%--
		% colormap conversion
		%--
		
		elseif (n == 3)	
			
			Y = hsv_to_rgb_(X);
			
		%--
		% improper input
		%-
		
		else
			
			disp(' ');
			error('Improper input size.');
			
		end
					
	case (3)
	
		%--
		% convert hue to degrees
		%--
		
		% this may not be the right place to do this
		
% 		r = (2 * pi) / 360;
% 		
% 		X(:,:,1) = X(:,:,1) .* r;
		
		%--
		% color image conversion
		%--
				
		X = rgb_vec(X);
				
		Y = hsv_to_rgb_(X);

% 		Y(Y < 0) = 0; this enforcing of positivity is probably related to the angle sign
				
		Y = rgb_reshape(Y,m,n);
		
end
