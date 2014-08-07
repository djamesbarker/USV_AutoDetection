function Y = box_filter(X, F, b, opt)

% box_filter - linear box filtering
% ---------------------------------
% 
% Y = box_filter(X, F, b, opt)
%   = box_filter(X, F, b, opt)
%
% Input:
% ------
%  X - input image
%  F - box filter
%  b - boundary behavior (def: -1, look at 'image_pad')
%  opt - pad option (def: 1)
%
% Output:
% -------
%  Y - box filtered image

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
% $Date: 2006-08-29 14:04:35 -0400 (Tue, 29 Aug 2006) $
% $Revision: 6339 $
%--------------------------------

% TODO: generalize function to handle multiple boxes

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% set default padding
%--

if (nargin < 4) || isempty(opt)
	opt = 1;
end 

%--
% set boundary behavior
%--

if (nargin < 3)
	b = -1;
end

%--
% ensure double image
%--

X = double(X); 

%--------------------------------------
% COMPUTE
%--------------------------------------

%--
% handle multiple plane images
%--

if (ndims(X) > 2)
	
	[r, c, d] = size(X);
	
	for k = 1:d
		Y(:, :, k) = box_filter(X(:, :, k), F, b, opt);
	end	
	
%--
% scalar image
%--

else
		
	%--
	% create equivalent box filter
	%--
	
	% NOTE: any filter value information is discarded, the support is used
	
	[m, n] = size(F);
	
	F = zeros(m + 2, n + 2);
	
	F(1, 1) = 1; 
	F(m + 1, 1) = -1;
	F(1, n + 1) = -1;
	F(m + 1, n + 1) = 1;
	
	%--
	% pad image if needed
	%--
	
	if opt
		X = image_pad(X, [(m - 1), (n - 1)] ./ 2, b);
	end
	
	%--
	% integrate and use sparse linear filter
	%--
	
	% TODO: improve or get rid of 'image_pad'
	
	X = image_pad(X, [1 1], -1);
		
	Y = integral_image_(X);
	
	Y = linear_filter_sparse_(Y, F);
		
end
