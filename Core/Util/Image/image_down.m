function Y = image_down(varargin)

% image_down - downsample an image
% --------------------------------
%
% Y = image_down(X,d,F)
%   = image_down(X,d,t,SE)
%
% Input:
% ------
%  X - input image
%  d - downsampling rates for rows and columns (def: [2,2])
%  F - linear pre-filter
%  t - type of non-linear pre-filter, 'median_filter'
%  SE - structuring element
%
% Output:
% -------
%  Y - downsampled image

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
% handle variable input
%--

switch (nargin)
		
	%--
	% no pre-filter downsampling
	%--
	
	case ({1,2})
	
		%--
		% rename input and set rates
		%--
		
		switch (nargin)
		
			case (1)
				X = varargin{1};
				d = [2,2];
				
			case (2)
				X = varargin{1};
				d = varargin{2};
				
		end

		%--
		% scalar or color image
		%--
		
		p = ndims(X);
		
		switch (p)
		
			%--
			% scalar image
			%--
			
			case (2)
			
				% use largest reduction first
					
				if (d(1) >= d(2))
					Y = X(1:d(1):end,:);
					Y = Y(:,1:d(2):end);
				else
					Y = X(:,1:d(2):end);
					Y = Y(1:d(1):end,:);
				end
			
			%--
			% rgb image
			%--
			
			case (3)
				
				for k = 1:3
					Y(:,:,k) = image_down(X(:,:,k),d);
				end
				
		end
	
	%--
	% linear pre-filter downsampling
	%--
	
	case (3)
	
		%--
		% rename input
		%--
		
		X = varargin{1};
		d = varargin{2};
		F = varargin{3};
		
		%--
		% scalar or color image
		%--
		
		p = ndims(X);
		
		switch (p)
		
			%--
			% scalar image
			%--
			
			case (2)
			
				% apply pre-filter to preserved pixels
				
				Z = mask_separable(size(X),-d(1),-d(2));
				Y = linear_filter(X,F,Z);
				
				% use largest reduction first
				
				if (d(1) >= d(2))
					Y = X(1:d(1):end,:);
					Y = Y(:,1:d(2):end);
				else
					Y = X(:,1:d(2):end);
					Y = Y(1:d(1):end,:);
				end
			
			%--
			% rgb image
			%--
			
			case (3)
				
				% convert to eigencolor
				
				b = fast_min_max(X);
				[X,V,c] = rgb_to_eig(X);
				
				% downsample using linear pre-filter
				
				for k = 1:3
					Y(:,:,k) = image_down(X(:,:,k),d,F);
				end
				
				% convert to rgb
				
				Y = eig_to_rgb(Y,V,c);
				Y = lut_range(Y,b);
				
		end
	
	%--
	% non-linear pre-filter
	%--
	
	case (4)
	
		%--
		% rename input
		%--
		
		X = varargin{1};
		d = varargin{2};
		t = varargin{3};
		SE = varargin{4};
		
		%--
		% scalar or color image
		%--
		
		p = ndims(X);
		
		switch (p)
		
			%--
			% scalar image
			%--
			
			case (2)
			
				% apply pre-filter to preserved pixels
				
				Z = mask_separable(size(X),-d(1),-d(2));
				Y = feval(t,X,SE,Z);
				
				% use largest reduction first
				
				if (d(1) >= d(2))
					Y = X(1:d(1):end,:);
					Y = Y(:,1:d(2):end);
				else
					Y = X(:,1:d(2):end);
					Y = Y(1:d(1):end,:);
				end
			
			%--
			% rgb image
			%--
			
			case (3)
				
				% convert to eigencolor
				
				b = fast_min_max(X);
				[X,V,c] = rgb_to_eig(X);
				
				% downsample using linear pre-filter
				
				for k = 1:3
					Y(:,:,k) = image_down(X(:,:,k),d,t,SE);
				end
				
				% convert to rgb
				
				Y = eig_to_rgb(Y,V,c);
				Y = lut_range(Y,b);
				
		end
	
end


