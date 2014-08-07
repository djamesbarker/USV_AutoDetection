function X = get_button_image(file, transparent)

% GET_BUTTON_IMAGE get image to place on button
%
% X = get_button_image(file, transparent)

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
% set white to be transparent
%--

if nargin < 2
	transparent = ones(1, 3);
end

%--
% load image
%--

X = double(imread(file)) / 255;

%--
% make transparent color transparent
%--

X = rgb_replace(X, transparent, nan * ones(1, 3));


%--------------------
% RGB_REPLACE
%--------------------

function X = rgb_replace(X, c1, c2)

row = size(X, 1); col = size(X, 2);

X = rgb_vec(X);

% NOTE: this does not scale well for large images

for k = 1:(row * col)
	
	if all(X(k, :) == c1)
		X(k, :) = c2;
	end
	
end

X = rgb_reshape(X, row, col);
