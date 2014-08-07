function F = filt_decomp(H, k, tol)

% filt_decomp - singular value decomposition of filter
% ----------------------------------------------------
%
% F = filt_decomp(H, k, tol)
%
% Input:
% ------
%  H - filter mask
%  k - rank of decomposition (def: 0, economy size full decomposition)
%  tol - rank computation tolerance (def: same as in 'rank')
%
% Output:
% -------
%  F - filter decomposition structure

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
% $Date: 2006-08-29 14:04:35 -0400 (Tue, 29 Aug 2006) $
% $Revision: 6339 $
%--------------------------------

%-------------------------------
% HANDLE INPUT
%-------------------------------

%--
% set order of decomposition
%--

if nargin < 2
	k = 0;
end

%--
% check order of decomposition
%--

[m, n] = size(H);

if (k > 0) && (k > min(m, n))
	k = 0;
end

%-------------------------------
% COMPUTE DECOMPOSITION
%-------------------------------

%--
% compute full or partial singular value decomposition
%--

if k == 0
	[U, S, V] = svd(H, 'econ');
else
	[U, S, V] = svds(H, k);
end

S = diag(S)';

%-------------------------------
% OUTPUT FILTER
%-------------------------------

F = filt_create;

%--
% set filter mask and decomposition fields
%--

F.H = H;

F.S = S; F.X = V; F.Y = U;

%--
% set tolerance based rank
%--

if nargin < 3
	F = filt_rank(F);
else
	F = filt_rank(F, tol);
end

%--
% approximation and computation fields
%--

% NOTE: the approximation perspective uses norm of remaining singular vectors

if k == 0
	E = 0;
else
	E = norm(H - (U * diag(S) * V'), 'fro');
end

E = sqrt(cumsum([E,  fliplr(S.^2)])); 

E(end) = []; E = fliplr(E);

F.error = E;

% NOTE: the theoretical speed is off due to overhead

d = length(S);

F.speed = (2*m*n - 1) ./ (((1:d) .* ((2*m - 1) + (2*n - 1))) + (0:(d - 1)));
