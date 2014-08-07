function C = cmap_tint(c,n)

% cmap_tint - tinted monochrome colormap
% --------------------------------------
% 
% C = cmap_tint(c,n)
% 
% Input:
% ------
%  c - tint color
%  n - number of levels
%  
% Output:
% -------
%  C - colormap

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
% set number of levels
%--

if (nargin < 2)
	n = 256;
end

%--
% set color
%--

if (nargin < 1)
	c = uisetcolor([1 0 0],'Select Tint Color:');
end

%--
% set colormap of current figure
%--

if (~nargout)
	colormap(cmap_tint(c,n));
end

%--
% create colormap by varying saturation
%--

c = rgb_to_hsv(c);

x = linspace(0,1,n)';
o = ones(n,1);

C = [c(1)*o, x, c(3)*x];
C = hsv_to_rgb(C);
