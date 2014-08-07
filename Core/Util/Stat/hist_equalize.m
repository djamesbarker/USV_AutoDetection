function Y = hist_equalize(X,Z)

% hist_equalize - histogram equalization
% --------------------------------------
%
% Y = hist_equalize(X,Z)
%
% Input:
% ------
%  X - input image
%  Z - computation mask (def: [])
% 
% Output:
% -------
%  Y - histogram equalized image

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
% $Date: 2005-12-15 13:52:40 -0500 (Thu, 15 Dec 2005) $
% $Revision: 2304 $
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
% set mask
%--

if (nargin < 2)
	Z = [];
end

%--
% create double image
%--

X = double(X);

%--
% compute extreme values and pdf
%--

b = fast_min_max(X);
[h,c] = hist_1d(X,256,b);

%--
% create look up table using cdf
%--

L = cumsum(h);
L = b(1) + [0, (b(2) - b(1))*(L / L(end))];

%--
% apply look up table
%-- 

Y = lut_apply(X,L,b,Z);

%--
% apply mask
%--

if (~isempty(Z))
	Y = mask_apply(Y,X,Z);
end

% think about the meaning and computation implied by the masking in the different
% operations

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

