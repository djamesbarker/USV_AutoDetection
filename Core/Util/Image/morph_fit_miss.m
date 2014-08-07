function Y = morph_fit_miss(X, SE1, SE2, Z, b)

% morph_fit_miss - morphological fit and miss (binary)
% ----------------------------------------------------
%
% Y = morph_fit_miss(X, SE1, SE2, Z, b)
%
% Input:
% ------
%  X - input image
%  SE1 - element to fit 
%  SE2 - element to miss
%  Z - mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - fit and miss image

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

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% check for single plane binary image
%--

if (ndims(X) > 2) || ~is_binary(X)
	error('Input image must be single plane binary image.');
end

%--
% set boundary behavior
%--

if (nargin < 5)
	b = -1;
end

%--
% set mask
%--

% NOTE: we thin the mask using the input binary image

if (nargin < 4) || isempty(Z)
	Z = X;
else
	Z = Z & X;
end

%--
% structuring element
%--
	
if ~isequal(se_supp(SE1), se_supp(SE2))
	error('Structuring elements do not have same support.');
end
	
%---------------------------
% COMPUTE
%---------------------------

%--
% setup
%--

B1 = se_mat(SE1); B2 = se_mat(SE2); pq = se_supp(SE1);

%--
% full computation
%--

if isempty(Z)

	X = image_pad(X, pq, b);
	
	Y = morph_fit_miss_(uint8(X), uint8(B1), uint8(B2));
	
%--
% masked computation
%--

else

	X = image_pad(X, pq, b); Z = image_pad(Z, pq, 0);
	
	Y = morph_fit_miss_(uint8(X), uint8(B1), uint8(B2), uint8(Z));
	
end


