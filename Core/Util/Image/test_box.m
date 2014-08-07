function R = test_box(n,p,it)

% test_box - test box filtering code
% ----------------------------------
%
% R = test_box(n,p,it)
%
% Input:
% ------
%  n - size of image
%  p - box support parameters
%  it - number of iterations
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

if ((nargin < 3) || isempty(it))
	it = 10;
end

if ((nargin < 2) || isempty(p))
	p = [20,40];
end

if ((nargin < 1) || isempty(n))
	n = [300,900];
end

%-------------------------
% RUN TESTS
%-------------------------

%--
% create box filter
%--

F = ones(2*p(1) + 1,2*p(2) + 1);

%--
% compute and compare filtering performance and accuracy
%--

for k = 1:it
	
	%--
	% create random image
	%--
	
	X = 100000 * rand(n(1),n(2));
	
	%--
	% filter with direct and sparse code
	%--
	
	tic; Y1 = linear_filter(X,F); t1(k) = toc;
	
	tic; Y2 = box_filter(X,F); t2(k) = toc;
			
	%--
	% compare output
	%--
	
	E = fast_min_max(Y1 - Y2);
	
	%--
	% pack results and display
	%--
	
	% NOTE: direct computation time, sparse time, speedup ratio, error bounds

	R(k,:) = [t1(k), t2(k), t1(k)/t2(k), E]
	
end
	
