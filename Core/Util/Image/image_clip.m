function Y = image_clip(X,b)

% image_clip - clip range of an image 
% -----------------------------------
%
% Y = image_clip(X,b)
% 
% Input:
% ------
%  X - input image
%  b - image value bounds (def: [0,255])
%
% Output:
% -------
%  Y - clipped image

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
% set bounds
%--

if (nargin < 2)
	b = [0,255];
end
 
%--
% initialize output image
%--

Y = X;

%--
% clip lower bound pixels
%--

ix = find(X < b(1));
Y(ix) = b(1);

%--
% clip upper bound pixels
%--

ix = find(X > b(2));
Y(ix) = b(2);
