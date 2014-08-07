function Y = rank_filter(X,SE,r,n,b)

% rank_filter - rank filter
% -------------------------
%
% Y = rank_filter(X,SE,r,n,b)
%   = rank_filter(X,SE,r,Z,b)
%
% Input:
% ------
%  X - input image or handle to parent image
%  SE - structuring element
%  r - rank from smallest
%  n - number of iterations (def: 1)
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - rank filtered image

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
% $Revision: 1781 $
% $Date: 2005-09-14 18:53:31 -0400 (Wed, 14 Sep 2005) $
%--------------------------------

%---------------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------------

%--
% check for handle input
%--

[X, N, tag, flag, g, h] = handle_input(X,inputname(1));

%--
% set boundary behavior
%--

if (nargin < 5)
	b = -1;
end

%--
% set default rank if needed
%--

s = se_size(SE);

% NOTE: default is min filter or erosion

if ((nargin < 3) || isempty(r))
	r = 1;
end

%--
% check rank
%--

if ((r < 1) | (r > s))

	str = ['Rank parameter must be integer from 1 to ' num2str(s) '.'];
	error(str);

elseif ((r >= 1) & (r <= s))

	if (floor(r) ~= r)
		str = ['Rank parameter ' num2str(r) ' must be integer.'];
		error(str);
	end

end

%--
% iteration or mask
%--

if ((nargin < 4) | isempty(n))

	n = 1;
	Z = [];

else

	Z = [];

	[rr,cc,ss] = size(X);

	if (all(size(n) == [rr,cc]))
		Z = n;
		n = 1;
	end

end

%--
% special cases of erosion and dilation
%--

if (r == 1)

	Y = morph_erode(X,SE,n);

elseif (r == se_size(SE))

	Y = morph_dilate(X,SE,n);

end

%--
% color image
%--

if (ndims(X) > 2)

	[rr,cc,ss] = size(X);

	for k = 1:ss
		if (isempty(Z))
			Y(:,:,k) = rank_filter(X(:,:,k),SE,r,n,b);
		else
			Y(:,:,k) = rank_filter(X(:,:,k),SE,r,Z,b);
		end
	end

	%--
	% scalar image
	%--

else

	%--
	% structuring element
	%--

	B = se_mat(SE);
	
	pq = se_supp(SE);

	%--
	% iterate operator
	%--

	if (isempty(Z))

		for j = 1:n
			X = image_pad(X,pq,b);
			Y = rank_filter_(X,uint8(B),r);
			X = Y;
		end

	%--
	% mask operator
	%--

	else

		X = image_pad(X,pq,b);
		Z = image_pad(Z,pq,0);
		Y = rank_filter_(X,uint8(B),r,uint8(Z));

	end

end

%--
% display output
%--

if (flag & view_output)

	switch(view_output)

		case (1)
			figure(h);
			set(hi,'cdata',Y);
			set(gca,'clim',fast_min_max(Y));

		otherwise
			fig;
			image_view(Y);

	end

end
