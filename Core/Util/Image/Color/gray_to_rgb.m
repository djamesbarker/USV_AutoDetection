function Y = gray_to_rgb(X,C,opt)

% gray_to_rgb - convert a grayscale image to rgb using a colormap
% ---------------------------------------------------------------
%
% Y = gray_to_rgb(X,C,opt)
%
% Input:
% ------
%  X - input grayscale image
%  C - colormap matrix
%  opt - integer output option
%
% Output:
% -------
%  Y - rgb image

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------

%--
% set defaut output
%--

if ((nargin < 3) || isempty(opt))
	opt = 0;
end

%--
% set and check colormap
%--

if ((nargin < 2) || isempty(C))
	C = gray(256);
end

if ((size(C,2) ~= 3) || any(~isreal(C)))
	disp(' ');
	error('Colormap matrix must be real and have three columns.');
end

b = fast_min_max(C);

if ((b(1) < 0) || (b(2) > 1))
	disp(' ');
	error('RGB values in colormap matrix must be between zero and one.');
end

%--
% check that image has single plane
%--

if (ndims(X) > 2)
	disp(' '); 
	error('Only scalar images are supported.');
end

%--
% convert complex images to abs
%--

if (any(~isreal(X)))
	
	X = abs(X);
	
	disp('  ');
	warning('Converting complex image to norm image.');
	
end

%--------------------------------------------------
% CREATE RGB IMAGE
%--------------------------------------------------

%--
% allocate output image
%--

[m,n] = size(X);

Y = zeros(m,n,3);

%--
% use colormap as lookup table
%--

b = fast_min_max(X);

for k = 1:3
	Y(:,:,k) = lut_apply(X,C(:,k),b);
end

%--
% optionally output uint8 image
%--

if (opt) 
	Y = uint8(lut_range(Y));
end
