function test_mask(X,Z)

% test_mask - test mask display options
% -------------------------------------
% 
% test_mask(X,Z)
%
% Input:
% ------
%  X - input image
%  Z - mask image

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

opt = mask_gray_color;

alpha = {0.2, 0.4, 0.6};

color = { ...
	[1 1 0], ...
	[1 0 1], ...
	[0 1 1] ...
};

bound = {-1, 0, 1};

M = max(X(:));

for i = 1:length(color)
for j = 1:length(bound)
for k = 1:length(alpha)
	
	opt.color = color{i};
	opt.bound = bound{j};
	opt.alpha = alpha{k};
	
	Y = mask_gray_color((M - X),Z,opt);
	
	fig; image_view(Y);
	
end
end
end
