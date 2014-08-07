function A = randsym(n,d)

% randsym - full random symmetric matrix
% --------------------------------------
%
% A = randsym(n,d)
%
% Input:
% ------
%  n - size of matrix
%  d - desired eigenvalues
%
% Output:
% -------
%  A - full random symmetric matrix with possibly specified eigenvalues

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%--
% set default eigenvalues
%--

% NOTE: default values are uniform in the unit interval

if ((nargin < 2) || isempty(d))
	d = rand(1,n);
end

%--
% create random orthogonal basis
%--

V = orth(rand(n));

%--
% put together random symmetric matrix
%--

A = V * diag(d) * V';
