function str = factor_str(n)

% factor_str - create string representation of prime factorization
% ----------------------------------------------------------------
%
% str = factor_str(n)
%
% Input:
% ------
%  n - integer to factor
%
% Output:
% -------
%  str - string representation of prime factors

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
% $Revision: 2271 $
% $Date: 2005-12-13 12:58:18 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%----------------------
% HANDLE INPUT
%----------------------

n = max(1, round(n));

%--
% handle array input recursively
%--

if (numel(n) > 1)
	
	str = cell(size(n)); 
	
	for k = 1:numel(n)
		str{k} = factor_str(n(k));
	end
	
	return;
	
end 

%----------------------
% CREATE FACTOR STRING
%----------------------

%--
% factor integer and collect like factors
%--

f = factor(n);

p = unique(f);

for k = 1:length(p)
	e(k) = sum((p(k) == f));
end

%--
% create factorization text string
%--

str = [int2str(n), ' = ', int2str(p(1))];

if (e(1) > 1)
	str = [str '^' int2str(e(1))];
end

for k = 2:length(p)
	str = [str ' x ' int2str(p(k))];
	if (e(k) > 1)
		str = [str '^' int2str(e(k))];
	end
end
	
