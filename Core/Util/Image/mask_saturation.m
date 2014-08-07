function Y = mask_saturation(X,Z)

% mask_saturation - saturation representation of mask
% ---------------------------------------------------
% 
% Y = mask_saturation(X,Z)
%
% Input:
% ------
%  X - input image
%  Z - mask image
%
% Output:
% -------
%  Y - saturation mask image

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
% $Revision: 626 $
% $Date: 2005-02-28 20:22:02 -0500 (Mon, 28 Feb 2005) $
%--------------------------------

%--
% create hsv image
%--

Y = rgb_to_hsv(X);

%--
% mask saturation plane
%--

Y(:,:,2) = mask_apply(Y(:,:,2),Z);

% convert back to rgb

Y = hsv_to_rgb(Y);
