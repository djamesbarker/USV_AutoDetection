function A = normalize_dim(A, k, opt)

% normalize_dim - center and normalize dimension
% ----------------------------------------------
%
% A = normalize_dim(A, k)
%
% Input:
% ------
%  A - array to normalize
%  k - dimension to normalize
%
% Output:
% -------
%  A - normalized array

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
% set default normalization options
%--

if nargin < 3
	
	opt.center = 1; opt.normalize = 1;
	
	if ~nargin
		A = opt; return;
	end
	
end

%--
% set default dimension to normalize
%--

if (nargin < 2) || isempty(k)
	k = 1;
end

%--
% get dimensions and check input
%--

d = ndims(A); 

if k > d
	error('Dimension to normalize is not available.');
end

%--
% get repeat vector to reconstitute collapsed array
%--

m = size(A, k); rep = ones(1, d); rep(k) = m;

%--
% normalize array dimension
%--

if opt.center
	A = A - repmat(mean(A, k), rep);
end

if opt.normalize
	A = A ./ sqrt(repmat(sum(A.^2, k), rep));
end
