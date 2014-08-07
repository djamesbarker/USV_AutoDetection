function G = filt_tight(F,tol)

% filt_tight - tighten support of filter using value tolerance
% ------------------------------------------------------------
%
% G = filt_tight(F,tol)
%
% Input:
% ------
%  F - input filter
%  tol - filter value tolerance (def: 10^-4)
%
% Output:
% -------
%  G - tight support filter

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
% $Date: 2005-02-16 19:58:53 -0500 (Wed, 16 Feb 2005) $
% $Revision: 539 $
%--------------------------------

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set tolerance
%--

if ((nargin < 2) || isempty(tol))
	tol = 10^-6;
end

%--------------------------------------------
% COMPUTE TIGHT SUPPORT FILTER
%--------------------------------------------

%--
% compute mask of values exceeding tolerance
%--

Z = (abs(F) >= tol);

%--
% no entries satisfy tolerance
%--

if (all(Z(:) == 0))
	
	G = [];

%--
% all entries satisfy tolerance
%--

elseif (all(Z(:) == 1))
	
	G = F;

%--
% tighten to symmetric support
%--

else

	%--
	% get size and indexing for entries that satisfy tolerance
	%--
	
	[m,n] = size(Z);
	
	[i,j,v] = find(Z);

	%--
	% get min and max rows
	%--
	
	bi = fast_min_max(i);
	pi = min(bi(1),m - bi(2) + 1);
	bi = [pi, m - pi + 1];
	
	%--
	% get min and max columns
	%--
	
	bj = fast_min_max(j);
	pj = min(bj(1),n - bj(2) + 1);
	bj = [pj, n - pj + 1];

	%--
	% tighten filter support
	%--
	
	G = F(bi(1):bi(2),bj(1):bj(2));
	
end
