function X = field_image(F,t)

% field_image - complex field color image visualization
% -----------------------------------------------------
% 
% X = field_image(F,t)
%
% Input:
% ------
%  F - complex field image
%  t - norm scaling 'lin' or 'log' (def: 'lin')
%
% Output:
% -------
%  X - color field image

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
% $Date: 2003-09-16 01:31:20-04 $
% $Revision: 1.1 $
%--------------------------------

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set default scaling
%--

if (nargin < 2)
	t = 'lin';
end

%---------------------------------------
% CREATE HSV REPRESENTATION
%---------------------------------------

%--
% map angle to hue
%--

X(:,:,1) = lut_range(angle(F),[0,360]);
	
%--
% set full saturation
%--

X(:,:,2) = ones(size(F));

%--
% map magnitude to value
%--

% consider better mappings here 

switch (t)
	
	case ('lin')
		X(:,:,3) = abs(F);
		
	case ('log')
		X(:,:,3) = log10(abs(F) + 1);
		
	otherwise
		error('Only linear and logarithmic scaling are supported.');
		
end

%--
% normalize magnitude
%--

X(:,:,3) = lut_range(X(:,:,3),[0,1]);

%---------------------------------------
% CREATE RBG IMAGE
%---------------------------------------

X = hsv_to_rgb(X);
