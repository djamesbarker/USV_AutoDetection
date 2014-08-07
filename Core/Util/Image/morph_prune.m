function Y = morph_prune(X, n)

% morph_prune - morphological pruning (binary)
% --------------------------------------------
% 
% Y = morph_prune(X, n)
%   = morph_prune(X, Z)
%
% Input:
% ------
%  X - input image or handle to parent image
%  n - iterations of operation (def: 1)
%  Z - computation mask image (def: [])
%
% Output:
% -------
%  Y - pruned image

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% check for single plane binary image
%--

if (ndims(X) > 2)
	error('Input image must be single plane image.');
end

%--
% handle label images
%--

if ~is_binary(X)
	L = X; X = uint8(X > 0);
end

%--
% iteration or mask
%--

if (nargin < 3) | isempty(n)
	n = 1; Z = [];
else
	Z = [];
	if all(size(n) == size(X))
		Z = n; n = 1;
	end
end

%--------------------------
% COMPUTE
%--------------------------

%--
% create image to collect prune points
%--

P = logical(size(X));

%--
% iterated computation
%--

if (isempty(Z))

	for k = 1:n

		%--
		% prune
		%--
		
		for l = [1:4, 6:9]

			% two point element
			
			SE1 = zeros(3); SE1(5) = 1; SE1(l) = 1;

			% two point complement
			
			SE2 = ones(3); SE2(5) = 0; SE2(l) = 0;

			ix = find(morph_fit_miss(X, SE1, SE2));
			
			P(ix) = 1;
					
		end
		
		ix = find(P); 
		
		Y = X; Y(ix) = 0;

		X = Y;

	end

%--
% masked computation
%--

else

	%--
	% prune
	%--
	
	for l = [1:4, 6:9]

		% two point element
		
		SE1 = zeros(3); SE1(5) = 1; SE1(l) = 1;

		% two point complement
		
		SE2 = ones(3); SE2(5) = 0; SE2(l) = 0;

		ix = find(morph_fit_miss(X, SE1, SE2, Z));
		
		P(ix) = 1;
				
	end
	
	ix = find(P);
	
	Y = X; Y(ix) = 0;

end

%--
% mask input label image to prune
%--

if exist('L', 'var')
	Y = double(Y) .* L;
end
