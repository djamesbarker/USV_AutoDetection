function [Z,r,c] = mask_separable(m,r,c)

% mask_separable - create separable index masks
% ---------------------------------------------
%
% [Z,r,c] = mask_separable(m,r,c)
%         = mask_separable(m,r)
%
% Input:
% ------
%  m - size of mask
%  r - indices for rows or negative jump size
%  c - indices for columns or negative jump size (def: r)
%
% Output:
% -------
%  Z - separable index mask
%  r - indices for rows 
%  c - indices for columns

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

%--
% set column indexing
%--

if (nargin < 3)
	c = r;
end

%--
% create regular indexing from negative jumps
%--

if (r(1) < 0)
	r = 1:-r(1):m(1);
end

if (c(1) < 0)
	c = 1:-c(1):m(2);
end

%--
% index shift for mex
%--

r = r - 1;
c = c - 1;

%--
% compute mask
%--

Z = mask_separable_(m,r,c);
