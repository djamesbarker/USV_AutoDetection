function Y = image_to_stack(X)

% image_to_stack - put multi plane images in stack
% ------------------------------------------------
%
% Y = image_to_stack(X)
%
% Input:
% ------
%  X - multi plane image
%
% Output:
% -------
%  Y - image stack

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
% get number of planes
%--

d = size(X,3);

%--
% put image planes in stack
%--

if (d > 1)
	for k = 1:d
		Y{k} = X(:,:,k);
	end
else
	Y{1} = X;
end
		
