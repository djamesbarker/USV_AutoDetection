function h = mask_view(X,Z,t,c)

% mask_view - view masks and masked images
% ----------------------------------------
%
% h = mask_view(Z)
%   = mask_view(X,Z,t)
%   = mask_view(X,Z,t,c)
%
% Input:
% ------
%  Z - mask image
%  X - image to mask
%  t - type of mask display for rgb images (def: 2)
%
%    1 - black background
%    2 - saturation mask
%
%  c - mask color (def: [1, 1, 0.4])
%
% Output:
% -------
%  h - handle to axes

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

%--
% single mask display
%--

if (nargin == 1)
	h = image_view(X);
	return;
end

%--
% set color
%--

if (nargin < 4)
	c = [1, 1, 0.4];
end

%--
% set type of mask display
%--

if (nargin < 3)
	t = 2;
end

%--
% display mask based on image type
%--

%--
% rgb image
%--

if (is_rgb(X))

	%--
	% compute mask display based on type
	%--
	
	switch (t)
	
	%--
	% black background
	%--
	
	case (1)
		
		% create double image (is this needed ?)
		
		X = lut_range(double(X),[0,1]);
		
		% apply mask image
		
		for k = 1:3
			X(:,:,k) = mask_apply(X(:,:,k),Z);
		end
		
		% display
		
		h = image_view(X);
	
	%--
	% saturation mask
	%--
	
	case (2)
		
		% create hsv image
		
		X = rgb_to_hsv(X);
		
		% mask saturation plane
		
		X(:,:,2) = mask_apply(X(:,:,2),Z);
		
		% convert back to rgb
		
		X = hsv_to_rgb(X);
		
		% display
		
		h = image_view(X);
	
% 	%--
% 	% scatter mask
% 	%--
% 	
% 	case (3)
% 
% 		% get mask index set
% 		
% 		[i,j] = find(Z);
% 		
% 		% display by scatter on image
% 		
% 		h = image_view(X);
% 		hold on;
% 		scatter(j,i,9,c);

	otherwise
		
		error('Unrecognized mask display type.');

	end
	
%--
% grayscale image
%--

else

	%--
	% compute mask display based on type
	%--
	
	switch (t)
	
	%--
	% black background
	%--
	
	case (1)

		% apply mask and display
		
		h = image_view(mask_apply(X,Z));
	
	%--
	% saturation mask
	%--
	
	case (2)
		
		% create double rgb gray image
	
		T = lut_range(double(X),[0,1]);
		
		[m,n] = size(T);	
		
		X = zeros(m,n,3);
		
		for k = 1:3
			X(:,:,k) = T;
		end
	
		% create color mask
		
		T = double(Z);
		
		Z = zeros(m,n,3);
		
		for k = 1:3
			Z(:,:,k) = (1 - c(k)) * mask_apply(X(:,:,k),T);
		end
	
		% create masked image
		
		X = X - Z;
		
		% display
		
		h = image_view(X);
		
% 	%--
% 	% scatter mask
% 	%--
% 	
% 	case (3)
% 
% 		% get mask index set
% 		
% 		[i,j] = find(Z);
% 		
% 		% display by scatter on image
% 		
% 		h = image_view(X);
% 		hold on;
% 		
% 		plot(j,i,'o','markeredgecolor',c,'markersize',20);
% 		
% 		set(get_image_handles,'erasemode','normal');

	otherwise
		
		error('Unrecognized mask display type.');

	end
	
end
