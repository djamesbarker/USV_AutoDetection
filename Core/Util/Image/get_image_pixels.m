function [i,j,x] = get_image_pixels(h,n)

% get_image_pixels - get pixel data
% ---------------------------------
%
% [i,j,x] = get_image_pixels(X,n)
%         = get_image_pixels(h,n)
%
% Input:
% ------
%  X - image
%  h - handle to parent figure or axes (def: gcf)
%  n - number of pixels to select
%
% Output:
% ------
%  i,j - row and column indices
%  x - pixel values one pixel per row

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
% $Date: 2003-07-06 13:36:53-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% set number of pixels
%--

if (nargin < 2)
	n = Inf;
end

%--
% set parent handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% handle input
%--

if (ishandle(h))

	% get indices
	
	[j,i] = ginput(n);
	
	i = round(i);
	j = round(j);
	
	% get values
	
	if (nargout > 2)
	
		X = get_image_data(h);
		
		switch(ndims(X))
			case (2)
				x = X(sub2ind(size(X),i,j));
			case(3)
				x = zeros(length(i),3);
				for k = 1:length(i)
					x(k,:) = vec_col(X(i(k),j(k),:))';
				end
		end
		
	end
	
%--
% image input
%--

else
	
	X = h;
	
	% display image
	
	g = fig;	image_view(X);
	
	% get indices
	
	[j,i] = ginput(n);
	
	i = round(i);
	j = round(j);
	
	% get values
	
	if (nargout > 2)
	
		switch(ndims(X))
			case (2)
				x = X(sub2ind(size(X),i,j));
			case(3)
				x = zeros(length(i),3);
				for k = 1:length(i)
					x(k,:) = vec_col(X(i(k),j(k),:))';
				end
		end
		
	end
	
	% close display
	
	close(g);
	
end
