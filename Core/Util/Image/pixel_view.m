function [x,y] = pixel_view(i,j,c,w)

% pixel_view - view pixel boundaries
% ----------------------------------
%
% [x,y] = pixel_view(i,j,c,w)
%
% Input:
% ------
%  i,j - row and column indices of pixels
%  c - display color (def: 'y')
%  w - display linewidth (def: 1)
%
% Output:
% -------
%  x,y - boundary coordinates

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
% build facets
%--

n = length(i);

x = zeros(4*n,2);
y = zeros(4*n,2);

for k = 1:n

	ik = i(k); ik1 = ik + 1;
	jk = j(k); jk1 = jk + 1;

	x((4*(k - 1) + 1):(4*k),:) = [jk jk; jk jk1; jk jk1; jk1 jk1];
	y((4*(k - 1) + 1):(4*k),:) = [ik ik1; ik1 ik1; ik ik; ik ik1];
	
end

%--
% remove duplicate facets and shift
%--

xy = [x y];

[u,ix] = unique(xy,'rows');

cix = setdiff_unique((1:4*n)',ix(:));

xy = setdiff_unique(u,xy(cix,:),'rows');

x = (xy(:,1:2) - 0.5)';
y = (xy(:,3:4) - 0.5)';

na = repmat(NaN,1,size(x,2));

x = [x; na];
y = [y; na];

%--
% display
%--

if (~nargout)

	%--
	% set line properties
	%--

	if (nargin < 4)
		w = 1;
	end
	
	if (nargin < 3)
		c = [1 1 0];
	end
	
	%--
	% display pixel boundary
	%--
	
	line(x(:),y(:),'color',c,'linewidth',w);
	
end





