function R = test_linear(X,n,p)

% test_linear - test linear filtering code
% ----------------------------------------
%
% R = test_linear(X,n,p)
%
% Input:
% ------
%  X - input image
%  n - number of samples
%  p - filter density
%
% Output:
% -------
%  R - timing and accuracy results

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
% $Revision: 295 $
% $Date: 2004-12-16 13:55:03 -0500 (Thu, 16 Dec 2004) $
%--------------------------------

%------------------------
% HANDLE INPUT
%------------------------

if ((nargin < 3) || isempty(p))
	p = 0.1;
end

if ((nargin < 2) || isempty(n))
	n = 10;
end

%-------------------------
% RUN TESTS
%-------------------------

%--
% create test filter masks
%--

P = 20; Q = 20; 

S = (2*P + 1)*(2*Q + 1);

for k = 1:n
	
	%--
	% compute non-zero mask and density of linear filter
	%--
	
	% NOTE: need to enforce positive density
	
	M = double(rand(2*P + 1,2*Q + 1) < p);
	
	d(k) = sum(M(:)) / S;
	
	%--
	% compute random filter with required sparsity pattern and unit sum
	%--
	
	F{k} = M .* rand(2*P + 1,2*Q + 1);
	
	F{k} = F{k} / sum(F{k}(:));
		
end

%--
% pad input image
%--

Y = image_pad(X,[P,Q],-1);

%--
% compute and compare filtering performance and accuracy
%--

for k = 1:n
	
	%--
	% filter with direct and sparse code
	%--
	
	tic; Y1 = linear_filter_(Y,F{k}); t1(k) = toc;
	
	tic; Y2 = linear_filter_sparse_(Y,F{k}); t2(k) = toc;
		
	%--
	% compare output
	%--
	
	E(k,:) = fast_min_max(Y1 - Y2);
	
end
	
%--
% output results
%--

% NOTE: direct computation time, sparse time, speedup ratio, error bounds

% TODO: format this as a table

disp(' ');
disp('TIME, SPARSE TIME, SPEEDUP, ERROR');

R = [t1', t2', (t1./t2)', d', E]
	
