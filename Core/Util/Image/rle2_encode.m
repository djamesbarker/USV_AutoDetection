function R = rle2_encode(X,T)

% rle2_encode - binarization and run-length encoding of images
% ------------------------------------------------------------
%
% R = rle2_encode(X,T)
%
% Input:
% ------
%  X - input image
%  T - binarization threshold (def: [], no binarization)
%
% Output:
% -------
%  R - run-length code

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

% NOTE: some error checking would be needed for general use

%--
% set default thresold
%--

if (nargin < 2)
	T = [];
end

%--
% convert input to double if needed
%--

% TODO: mex should handle a variety of types

if (~strcmp(class(X),'double'))
	X = double(X);
end

%--
% mex for encoding with binarization if needed
%--

if (isempty(T))
	R = rle_encode_(X);
else
	R = rle_encode_(X,T);
end

