function y = fast_rank(X,k,Z)

% fast_rank - fast ranked value computation
% -----------------------------------------
% 
% y = fast_rank(X,k,Z)
%   = fast_rank(X,f,Z)
%
% Input:
% ------
%  X - input image
%  k - rank parameter
%  f - fraction of data element is above or below (when negative)
%  Z - computation mask (def: []) 
%
% Output:
% -------
%  y - ranked value

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
% $Revision: 2304 $
% $Date: 2005-12-15 13:52:40 -0500 (Thu, 15 Dec 2005) $
%--------------------------------

%--
% set mask
%--

if (nargin < 3)
	Z = [];
end

%--
% apply mask
%--

if (~isempty(Z))
	ix = find(Z);
	X = X(ix);
end

%--
% check for rank or fraction
%--

if (nargin < 2)
	error('Rank or fraction parameter is missing.');
end
	
%--
% convert fraction to rank 
%--

N = numel(X);

if (abs(k) > 0 && abs(k) < 1)

	% size of array
	
	N = numel(X);

	% rank from lowest and highest
	
	if (k > 0)
		k = ceil(N*k);
	else
		k = N + floor(N*k) + 1;
	end
	
end

%--
% check rank is in range
%--

if (k < 1 || k > N)
	error('Rank or fraction parameter out of range.');
end

%--
% compute using mex
%--

switch (k)
	
case (1)
	y = min(X(:));
	
case (N)
	y = max(X(:));
	
otherwise
	y = fast_rank_(X,k);
	
end
