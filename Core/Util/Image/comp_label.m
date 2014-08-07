function Y = comp_label(X, SE, nn)

% comp_label - connected component labelling (binary)
% ---------------------------------------------------
% 
% Y = comp_label(X, nn)
%   = comp_label(X, SE, nn)
%
% Input:
% ------
%  X - input image
%  nn - number of neighbors
%  SE - connectivity element
%
% Output:
% -------
%  Y - label image

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
% $Date: 2006-06-06 17:29:13 -0400 (Tue, 06 Jun 2006) $
% $Revision: 5169 $
%--------------------------------

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% check for single plane binary image
%--

if (ndims(X) > 2) || ~is_binary(X)
	error('Input image must be single plane binary image.');
end

%--
% handle variable input
%--

switch (nargin)

	case (1)
		
		SE = []; nn = 4;
		
	case (2)
		
		if ~isempty(se_rep(SE))
			nn = 4;
		else
			SE = []; nn = 4;
		end
		
end

%-------------------------------------------
% LABEL COMPONENTS
%-------------------------------------------

%--
% simple connected components
%--

if isempty(SE)
	
	Y = comp_label_(uint8(X), nn);

%--
% connectivity element components
%--
	
else
	
	Y = morph_dilate(uint8(X), SE);	
	
	Y = comp_label_(Y, nn);
	
	Y = mask_apply(Y, X);
	
end
