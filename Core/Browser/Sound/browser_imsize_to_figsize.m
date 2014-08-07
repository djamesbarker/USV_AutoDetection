function [width, height] = browser_imsize_to_figsize(width, height, ch, status, color, slider)

% browser_imsize_to_figsize - compute figure size for a given image size
%-----------------------------------------------------------------------
%
% Inputs:
% -------
% width - image width
% height - image height
% ch - number of channels
% sb - status bar flag (1 = status bar present)
% cb - color bar flag (1 = color bar present)
%
% Outputs:
% --------
% width - figure width
% height - figure height

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
% Author: Matt Robbins
%--------------------------------
% $Revision: 1935 $
% $Date: 2005-10-14 16:58:12 -0400 (Fri, 14 Oct 2005) $
%--------------------------------

[layout, tile] = browser_tile_layout(status, color, slider);

%--
% compute width and height
%--

% NOTE: image size is already in pixels, so we don't multiply by the tile size

height = (height * ch) + tile * ((layout.yspace * (ch - 1)) + (layout.bottom + layout.top));

width = width + tile * (layout.left + layout.right + layout.colorbar);
