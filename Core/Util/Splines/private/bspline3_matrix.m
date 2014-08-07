function [A_inv A] = bspline3_matrix(n, h)

% spline_matrix - get inverse coefficient matrix for cubic b-splines
% ------------------------------------------------------------------
% [A_inv A] = bspline_matrix3(n, h)
%
% Input:
% ------
%  n - size
%  h - spline width
%
% Output:
% -------
%  A_inv - inverse matrix
%  A - matrix

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
% $Revision$
% $Date$
%--------------------------------

persistent BSPLINE3_TABLE;

if isempty(BSPLINE3_TABLE)
	BSPLINE3_TABLE = cell(100);
end

%--
% get from table if possible
%--

if ~isempty(BSPLINE3_TABLE{h, n})	
	
	A_inv = BSPLINE3_TABLE{h,n}.inverse; 
	
	A = BSPLINE3_TABLE{h,n}.matrix; 
	
	return;

end

%--
% compute
%--

A = diag(4*ones(1, n)) + diag(ones(1, n - 1), 1) + diag(ones(1, n - 1), -1);

tail = [-3/h, 0, 3/h];

A(1, 1:3) = tail;

A(end,end-2:end) = tail;

A_inv = inv(A);

%--
% store in table
%--

BSPLINE3_TABLE{h, n}.matrix = A; 

BSPLINE3_TABLE{h, n}.inverse = A_inv;
