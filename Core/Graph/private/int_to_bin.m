function b = int_to_bin(x,k)

% int_to_bin - integer to binary conversion
% --------------------------------------
%
% b = int_to_bin(x,k)
%
% Input:
% ------
%  x - integers
%  k - length of binary representation
%
% Output:
% -------
%  b - binary representations

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
% set length of representation
%--

if (nargin < 2)
	k = max(floor(log2(x))) + 1;
end

%--
% compute binary representations
%--

n = length(x);

b = zeros(k,n);

y = x(:)';

for j = (k - 1):-1:0
	f = (y - 2^j) >= 0;
	y = y - (2^j)*f;
	b(j + 1,:) = f;
end	

