function F = filt_rank(F, tol)

% filt_rank - update filter rank used in approximation
% ----------------------------------------------------
%
% F = filt_rank(F, tol)
%
% Input:
% ------
%  F - filter decomposition structure
%  tol - rank computation tolerance (def: same as in 'rank')
%
% Output:
% -------
%  F - filter with updated rank

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
% configure for direct computation
%--

if (nargin > 1) && (tol == 0)
	F.tol = 0; F.rank = 0; return;
end

%--
% set convenience variables
%--

H = F.H; [m, n] = size(H); S = F.S;

%--
% compute numerical rank
%--

k = ~(length(S) == min(m, n));

% NOTE: rank is an operator property and hence uses the singular values

if k == 0
	
	% NOTE: this code reuses the singular values and is equivalent to rank
	
	if nargin < 2
		tol = max(m,n) * eps(max(S));
	end

	F.tol = tol; F.rank = sum(S > tol);
	
else
	
	if (nargin < 2)
		[F.rank, F.tol] = rank2(H);
	else
		F.tol = tol; F.rank = rank(H, tol);
	end
	
end

%--
% set rank to one if null
%--

if F.rank == 0
	F.rank = 1;
end


%----------------------------------------------
% RANK2
%----------------------------------------------

% NOTE: this is the matlab rank function modified to output tolerance

function [r, tol] = rank2(A, tol)

S = svd(A);

if nargin == 1
   tol = max(size(A)') * eps(max(S));
end

r = sum(S > tol);
