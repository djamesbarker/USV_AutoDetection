function X = rle2_decode(R,L)

% rle2_decode - run-length decoding and labelling of binary image
% ---------------------------------------------------------------
%
% R = rle2_decode(X,L)
%
% Input:
% ------
%  R - run-length code
%  L - run-length based label look-up table
%
% Output:
% -------
%  X - binary or labelled image

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

if (nargin < 2)
	
	X = rle2_decode_(R);
	
else
	
	% NOTE: the direct labelling of runs is not exposed here
	
	X = rle2_decode_(R,L,0);
	
end
