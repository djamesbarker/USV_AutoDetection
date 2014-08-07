function [Y,k] = morph_distance(X,SE,n,b)

% morph_distance - distance transform (binary)
% --------------------------------------------
%
% [Y,k] = morph_distance(X,SE,n,b)
%
% Input:
% ------
%  X - input binary image or handle to parent figure
%  SE - structuring element
%  n - largest distance parameter
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - distance transform image
%  k - number of erosions computed

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% image or handle
%--

flag = 0;

if (ishandle(X))
    h = X;
    hi = get_image_handles(h);
    if (length(hi) == 1)
        X = get(hi,'cdata');
        flag = 1;
    else
        warning('Figure has more than one image. No computation performed.');
        return;
    end 
end

%--
% check for binary input
%--

if (~is_binary(X))
	error('Input image must be binary image.');
end

%--
% set boundary behavior
%--

if (nargin < 4)
	b = -1;
end

%--
% set largest distance parameter
%--

if (nargin < 3)
	n = max(size(X));
end

%--
% coerce uint8
%--

X = uint8(X);

%--
% iterate erosion
%--

Y = zeros(size(X));
k = 1;

while ((k < n) & (max(X(:))))

	Y = Y + double(X);	
	X = morph_erode(X,SE,X,b);
	k = k + 1;
	
end

%--
% display output
%--

if (flag & view_output)
	switch(view_output)
	case (1)
        figure(h);
        set(hi,'cdata',Y);
		set(gca,'clim',fast_min_max(Y));
	otherwise
		fig;
		image_view(Y);
	end
end



