function Y = morph_close(X,SE,Z,b)

% morph_close - morphological closing
% -----------------------------------
% 
% Y = morph_close(X,SE,Z,b)
%
% Input:
% ------
%  X - input image or handle to parent figure
%  SE - structuring element
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - closed image

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

%--
% check for handle input
%--

[X, N, tag, flag, g, h] = handle_input(X,inputname(1));

%--
% set boundary behavior
%--

if (nargin < 4)
	b = -1;
end

%--
% set mask
%--

if (nargin < 3)
	Z = [];
end

%--
% color image
%--

if (ndims(X) > 2)
	
	[r,c,s] = size(X);
	
	for k = 1:s
		Y(:,:,k) = morph_close(X(:,:,k),SE,Z,b);
	end	
	
%--
% scalar image
%--
	
else
	
	%--
	% compute closing
	%--
	
	Y = morph_erode(morph_dilate(X,SE,[],b),se_tr(SE),Z,b);
	
	%--
	% mask operator
	%--
	
	if (~isempty(Z))
		Y = mask_apply(Y,X,Z);
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
