function Y = image_shift(X,v,b)

% image_shift - shift an image
% ----------------------------
% 
% Y = image_shift(X,v,b)
% 
% Input:
% ------
%  X - input image
%  v - displacement vector
%  b - boundary behavior
%
%   -2 - cyclic boundary
%   -1 - reflecting boundary
%    0 - zero padding
%    n - n padding
%
% Output:
% -------
%  Y - shifted image

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

b = double(b);

%--
% grayscale or rgb image
%--

d = ndims(X);

switch (d)

	case (2)
	
		%--
		% get size of image
		%--
		
		mn = size(X);
		
		%--
		% create padded image
		%--
		
		Y = image_pad(X,abs(v),b);
		
		%--
		% crop padded image
		%--
		
		rc = (abs(v) + 1) + v;
		
		Y = Y(rc(1):(rc(1) + mn(1) - 1),rc(2):(rc(2) + mn(2) - 1));
		
	case (3)
	
		%--
		% initialize output
		%--
		
		Y = zeros(size(X));
		
		%--
		% shift plane by plane
		%--
		
		for k = 1:3
			Y(:,:,k) = image_shift(X(:,:,k),v,b);	
		end

end


	
	
	
	
	
