function Y = unsharp_filter(X,a,b)

% unsharp_filter - unsharp masking filter
% ---------------------------------------
%
% Y = unsharp_filter(X,a,b)
% 
% Input:
% ------
%  X - input image
%  a - unsharp masking parameter (def: 1.1)
%  b - boundary behavior (def: -1)
% 
% Output:
% -------
%  Y - filtered image

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
% set boundary behavior
%--

if (nargin < 3)
	b = -1;
end

%--
% set unsharp masking parameter
%--

if (nargin < 2)
	a = 1.1;
else
	if (a < 1)
		disp(' ');
		error('Unsharp masking parameter must be larger than 1.');
	end
end

%--
% create mask
%--

F = -ones(3);
F(2,2) = 9*a - 1;

%--
% apply linear filter
%--

Y = linear_filter(X,F);

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
