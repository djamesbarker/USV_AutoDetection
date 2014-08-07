function Y = morph_thick(X,SE1,SE2,Z)

% morph_thick - morphological thickening (binary)
% -----------------------------------------------
% 
% Y = morph_thick(X,SE1,SE2,Z)
%
% Input:
% ------
%  X - input image of handle to parent image
%  SE1 - structuring element to fit 
%  SE2 - structuring element to miss
%  Z - computation mask image (def: [])
%
% Output:
% -------
%  Y - thickened image

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
% check for color image
%--

if (ndims(X) > 2)
	error('Color images are not supported.');
end

%--
% check for binary input
%--

if (~is_binary(X))
	error('Input image must be binary image.');
end

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%--
% thick
%--

ix = find(morph_fit_miss(X,SE1,SE2,Z));
Y = X;
Y(ix) = 1;

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
	
		




