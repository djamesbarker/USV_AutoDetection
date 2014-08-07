function f = filt_binomial(m, n, d)

% filt_binomial - create binomial filters
% ---------------------------------------
%
% f = filt_binomial(m, n, d)
%
% Input:
% ------
%  m - row length of filter
%  n - column length of filter
%  d - derivative indicator
%
% Output:
% -------
%  f - binomial filter

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
% $Date: 2006-06-11 21:57:45 -0400 (Sun, 11 Jun 2006) $
% $Revision: 5223 $
%--------------------------------

%------------------------------
% HANDLE INPUT
%------------------------------

if (nargin < 3) 
	d = [0, 0];
end

if (nargin < 2)
	n = 1;
end

if (m < 1) || (n < 1)
  error('Length of filter must be larger than or equal to 1');
end

%------------------------------
% CREATE FILTER
%------------------------------

%--
% create filter and normalize
%--

f = binomial(m, d(1)) * binomial(n, d(2))'; 

f = f ./ sum(abs(f(:)));


%------------------------------
% BINOMIAL
%------------------------------

function f = binomial(m, d)

%--
% create column filter
%--

f = 1;

for k = 1:(m - 1)
	f = conv([0.5 0.5]', f);
end
  
%--
% compute derivative if needed
%--

if d
	
	ix = length(f) / 2;

	if mod(length(f), 2)
		ix = floor(ix); f = f(1:ix); f = [-f; 0; flipud(f)];
	else
		f = f(1:ix); f = [-f; flipud(f)];
	end

end
