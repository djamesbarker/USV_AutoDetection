function [Y,ix] = image_perm(X,opt)

% image_perm - permute the pixel values of an image
% -------------------------------------------------
%
% [Y,ix] = image_perm(X)
%
% Y = image_perm(X,ix)
%   = image_perm(X,seed)
%
% Input:
% ------
%  X - image to permute
%  ix - permutation indices
%  seed - random number generator seed
%
% Output:
% -------
%  Y - permuted image
%  ix - permutation indices

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

if ((nargin < 2) || isempty(opt))
	
	%--
	% no seed or permutation provided as input
	%--
	
	seed = [];
	ix = [];
	
else
	
	%--
	% seed provided as input
	%--
	
	if (length(opt) == 1)
		
		seed = opt;
		ix = [];
		
	%--
	% permutation provided as input
	%--
	
	else
		
		[m,n,d] = size(X);
		
		if (prod(size(ix)) ~= (m * n))
			disp(' ');
			error('Permutation indices must be of the same size as matrix.');
		else
			seed = [];
			ix = opt;
		end
		
	end
	
end

%-----------------------------------------------------
% PERMUTE IMAGE
%-----------------------------------------------------

%--
% get size of image
%--

[m,n,d] = size(X);

%--
% get permutation indices
%--

if (isempty(ix))
	
	if (~isempty(seed))
		rand('state',seed);
	else
		rand('state',sum(100*clock));
	end
	
	ix = randperm(m * n);
	
end
		
%--
% reshape permute and reshape
%--

if (d > 1)
	
	X = rgb_vec(X);
	Y = X(ix,:);
	Y = rgb_reshape(Y,m,n);
	
else
	
	X = X(:);
	Y = X(ix);
	Y = reshape(Y,m,n);
	
end


