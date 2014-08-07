function R = rect_factor(n)

% rect_factor - compute rectangle factorizations
% ----------------------------------------------
%
% R = rect_factor(n)
%
% Input:
% ------
%  n - positive integer sequence
%
% Output:
% -------
%  R - rectangle factorizations for all elements of sequence

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
% $Revision: 990 $
% $Date: 2005-04-28 20:06:31 -0400 (Thu, 28 Apr 2005) $
%--------------------------------

%-----------------------------------------
% HANDLE INPUT
%-----------------------------------------

%--
% consider integer sequences recursively
%--

if (length(n) > 1)
	
	R = [];
	
	for k = 1:length(n)
		
		Rk = rect_factor(n(k));
		
		if (~isempty(Rk))
			R = unique([R; Rk],'rows');
		end
		
	end
	
	return;
	
end

%-----------------------------------------
% COMPUTE RECTANGLE FACTORIZATIONS
%-----------------------------------------

%--
% factor number
%--

f = factor(n);

% NOTE: return when the number of factors is too large

if (length(f) > 7)
	disp(' ');
	error('There is a limit of 7 factors for this computation.');
end

%--
% compute permutations of factors
%--

pf = perms(f);

%--
% compute unique possible rectangles
%--

R = [];

% NOTE: for primes, this loop is never executed, and empty rectangles are output

for k = 1:(length(f) - 1)
	
	Rk = unique( ...
		[prod(pf(:,1:k),2), prod(pf(:,(k + 1):end),2)], 'rows' ...
	);

	R = unique([R; Rk],'rows');
	
end
