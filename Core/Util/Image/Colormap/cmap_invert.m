function C = cmap_invert(h)

% cmap_invert - invert colormap
% -----------------------------
%
% C = cmap_invert(C)
%   = cmap_invert(h)
%
% Input:
% ------
%  C - colormap
%  h - handle to figure (def: gcf)

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
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% invert colormap
%--

if (ishandle(h))
	C = flipud(get(h,'colormap'));
	set(h,'colormap',C);
else
	C = flipud(C);
end
