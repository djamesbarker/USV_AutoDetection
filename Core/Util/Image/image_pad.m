function Y = image_pad(X, pq, b)

% image_pad - pad image for sliding window processing
% ---------------------------------------------------
% 
% Y = image_pad(X, pq, b)
% 
% Input:
% ------
%  X - input image
%  pq - support parameters
%  b - boundary behavior
%
%   -2 - cyclic boundary
%   -1 - reflecting boundary
%    n - n padding for n >= 0
%
% Output:
% -------
%  Y - padded image

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
% grayscale or rgb image
%--

p = pq(1); q = pq(2);

if q >= size(X, 2) || p >= size(X, 1)
	b = 0;
end

d = ndims(X);

switch (d)

	case (2)
	
		%--
		% get image size
		%--
		
		[m, n] = size(X);
		
		%--
		% pad image depending on boundary conditions
		%--
		
% 		p = pq(1); q = pq(2);
		
		switch (b)
		
			case (-2)
			
				Y = [ ...
					X(m-p+1:m, n-q+1:n), X(m-p+1:m, :), X(m-p+1:m, 1:q); ...
					X(:, n-q+1:n), X, X(:, 1:q);
					X(1:p, n-q+1:n), X(1:p, :), X(1:p, 1:q) ...
				];
					
			case (-1)
		
				Y = [ ...
					fliplr(flipud(X(1:p, 1:q))), flipud(X(1:p, :)), fliplr(flipud(X(1:p, n-q+1:n))); ...
					fliplr(X(:, 1:q)), X, fliplr(X(:, n-q+1:n));
					fliplr(flipud(X(m-p+1:m, 1:q))), flipud(X(m-p+1:m, :)), fliplr(flipud(X(m-p+1:m, n-q+1:n))) ...
				];
					
			case (0)
			
				Y = [ ...
					zeros(p, n + 2*q); ...
					zeros(m, q), X, zeros(m, q); ...
					zeros(p, n + 2*q) ...
				];
			
			otherwise
			
				if (b > 0)
					
					Y = [ ...
						b * ones(p, n + 2*q); ...
						b * ones(m, q), X, b * ones(m, q); ...
						b * ones(p, n + 2*q) ...
					];
				
				end
			
		end
		
	case (3)
	
		%--
		% initialize output depending on datatype
		%--
			
		Y = zeros(size(X) + [2 * pq, 0]);
		
		if isa(X, 'uint8')
			Y = uint8(Y);
		end
		
		%--
		% pad plane by plane
		%--
		
		for k = 1:3
			Y(:,:,k) = image_pad(X(:,:,k), pq, b);
		end

end
