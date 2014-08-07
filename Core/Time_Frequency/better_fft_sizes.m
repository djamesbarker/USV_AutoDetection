function n = better_fft_sizes(a, b, f)

% better_fft_sizes - get better fft sizes in range
% ------------------------------------------------
%
% n = better_fft_sizes(a, b, f)
%
% Input:
% ------
%  a - min size
%  b - max size
%  f - better factors
%
% Output:
% -------
%  n - better sizes in range

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
% $Revision: 2268 $
% $Date: 2005-12-13 12:19:40 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% set default factors and max powers
%--

% NOTE: this input is not revealed in help

% NOTE: the first column contains the factor the second the max power

if nargin < 3
	f = setdiff(primes(64), 17);
end 

%--
% set default min and max
%--

if (nargin < 2)
	b = 2^16;
end

if (nargin < 1) 
	a = 2^5;
end

%--------------------------------
% COMPUTE SIZES FROM FACTORS
%--------------------------------

%--
% select factors
%--

L = cell(0);

for k = 1:numel(f)
	L{end + 1} = f(k).^[1:floor(log_b(b, f(k)))];
end 

%--
% compose and sort factors
%--

n = 1;

for k = 1:length(L)
	
	nk = sort(kron(n, L{k})); 
	
	ix = find(nk > b, 1); 
	
	if ~isempty(ix)
		nk = nk(1:ix);
	end
	
	n = [n, nk];
	
end

n = sort(n(:)); 

%--
% select sizes in range
%--

ix1 = find(n >= a); ix2 = find(n <= b); 

if isempty(ix1) || isempty(ix2)
	n = []; return;
end

n = n(ix1(1):ix2(end));

%--
% display results
%--

if (~nargout)
	
	str = ['''Better'' FFT sizes between ', int2str(a), ' and ', int2str(b)];
	
	disp(' ');
	
	disp(str_line(str));
	disp(str)
	disp(str_line(str));
	
	disp(' ');
	
	str = factor_str(n);
	
	for k = 1:length(str)
		disp(str{k});
	end

	disp(' ');
	
end
	
