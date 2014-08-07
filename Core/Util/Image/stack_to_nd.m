function Y = stack_to_nd(X)

% stack_to_nd - convert image stack to multiple plane image
% ---------------------------------------------------------
% 
% Y = stack_to_nd(X)
%
% Input:
% ------
%  X - image stack
% 
% Output:
% -------
%  Y - multiple plane image

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
% check grayscale stack input
%--

t = is_stack(X);

if (~t)
	error('Input is not an image stack.');
end

if (t > 1)
	error('Only grayscale image stacks are supported.');
end

%--
% put frames into n-dimensional image
%--

[r,c] = size(X{1}); s = length(X);

Y = zeros(r,c,s);

for k = 1:s
	Y(:,:,k) = X{k};
end
