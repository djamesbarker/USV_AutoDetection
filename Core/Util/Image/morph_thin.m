function Y = morph_thin(X, SE1, SE2, Z)

% morph_thin - morphological thinning (binary)
% --------------------------------------------
% 
% Y = morph_thin(X, SE1, SE2, Z)
%
% Input:
% ------
%  X - input image
%  SE1 - element to fit 
%  SE2 - element to miss
%  Z - mask image (def: [])
%
% Output:
% -------
%  Y - thinned image

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
% $Date: 2005-01-24 18:41:38 -0500 (Mon, 24 Jan 2005) $
% $Revision: 458 $
%--------------------------------

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% check for single plane binary image
%--

if (ndims(X) > 2) || ~is_binary(X)
	error('Input image must be single plane binary image.');
end

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%-------------------------
% COMPUTE
%-------------------------

%--
% thin
%--

ix = find(morph_fit_miss(X, SE1, SE2, Z));

Y = X; Y(ix) = 0;

		




