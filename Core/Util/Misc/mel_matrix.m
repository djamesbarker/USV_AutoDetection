function A = mel_matrix(N, f1, f2, t, p)

% mel_matrix - compute mel-weighting matrix
% -----------------------------------------
%
% M = mel_matrix(N, f1, f2, t, p)
%
% Input:
% ------
%  N - number bins to summarize
%  f1 - number of linearly spaced filters
%  f2 - number of logarithmically spaced filters
%  t - transition point
%  p - normalization type

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
% $Revision: 677 $
% $Date: 2005-03-08 19:57:35 -0500 (Tue, 08 Mar 2005) $
%--------------------------------

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% set default normalization type
%--

if nargin < 5
	p = 2;
end

%--
% set fraction of range to consider linearly
%--

if nargin < 4
	t = 0.5;
end

%--
% set number of linear and logarithmic filters
%--

if nargin < 3
	f2 = 6;
end

if nargin < 2
	f1 = 14;
end

%--
% set number of bins to collapse
%--

if nargin < 1
	N = 512;
end

%-----------------------
% SETUP
%-----------------------

%--
% compute filter centers and edges
%--

% NOTE: this is the number of bins collapsed linearly and logarithmically

n1 = round((N - 1)* t); n2 = (N - 1) - n1;

c1 = round(linspace(0, n1, f1 + 2));

c2 = round(logspace(log10(c1(end - 1)), log10(N - 1), f2 + 2));

% NOTE: this creates a transitional filter

c1(end) = c2(2);

%-----------------------
% COMPUTE
%-----------------------

A = [];

for k = 1:f1
	A(:, end + 1) = triangle(N, c1(k), c1(k + 1), c1(k + 2), p);
end

% NOTE: the logarithmic filters are not symmetric

for k = 1:f2
	A(:, end + 1) = triangle(N, c2(k), c2(k + 1), c2(k + 2), p);
end

if ~nargout
	
	fig; plot(A); title('MEL-FILTERS'); xlabel('FREQ'); ylabel('MAG');
	
	set(gca, ...
		'xlim', [1, N], ...
		'ylim', [0, 1.1 * max(A(:))] ...
	);

	hold on; plot(sum(A, 2), 'k:');
	
end


%------------------------------
% TRIANGLE
%------------------------------

function C = triangle(N, low, center, high, p)

% triangle - create triangle sequence column
% ------------------------------------------
%
% C = triangle(N, low, center, high, p)
%
% Input:
% ------
%  N - length of sequence
%  low, center, high - low, center, and high elements
%  p - normalization type
%
% Output:
% -------
%  C - triangle sequence

%--
% set default normalization
%--

if nargin < 5
	p = 2;
end

%--
% compute triangle sequence
%--

C = zeros(N, 1); 

C((low:center) + 1) = linspace(0, 1, center - low + 1);

C((center:high) + 1) = linspace(1, 0, high - center + 1);

%--
% normalize sequence
%--

if p < 0
	return;
end

C = C ./ norm(C, p);
