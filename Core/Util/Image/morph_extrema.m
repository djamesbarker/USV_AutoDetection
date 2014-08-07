function Y = morph_extrema(X,t,h,b)

% morph_extrema - regional extrema of image
% -----------------------------------------
%
% Y = morph_extrema(X,t,h,b)
%
% Input:
% ------
%  X - input image or handle to parent figure
%  t - type of extrema
%
%    0 - regional minima
%    1 - regional max
%
%  h - height of extrema (def: 1)
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - regional extrema

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
% $Date: 2004-12-21 19:10:44 -0500 (Tue, 21 Dec 2004) $
% $Revision: 335 $
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

% %--
% % check for binary input
% %--
% 
% if (~is_binary(X))
% 	error('Input image must be binary image.');
% end

%--
% set boundary behavior
%--

if (nargin < 4)
	b = -1;
end

%--
% set height
%--

if (nargin < 3)
	h = 1;
end

%--
% coerce double image
%--

X = double(X);

%--
% compute min or max
%--

switch (t)

	%--
	% regional min
	%--
	
	case (0)	
		Y = (X ~= morph_geo_erode(X + h,X,inf,b));
	
	%--
	% regional max
	%--
	
	case (1)	
		Y = (X ~= morph_geo_dilate(X - h,X,inf,b));
	
end

%--
% display output
%--

if (flag && view_output)
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
