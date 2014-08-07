function Y = morph_gradient(X,SE,t,Z)

% morph_gradient - morphological gradient
% ---------------------------------------
% 
% Y = morph_gradient(X,SE,t,Z)
%
% Input:
% ------
%  X - input image or handle to parent figure
%  SE - structuring element
%  t - type of gradient
%
%   -1 - inner (dilation)
%    0 - symmetric (dilation - erosion) (default)
%    1 - outer (erosion)
%
%  Z - computation mask image (def: [])
%
% Output:
% -------
%  Y - gradient image

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
% $Revision: 473 $
% $Date: 2005-01-27 17:04:34 -0500 (Thu, 27 Jan 2005) $
%--------------------------------

% this function currently does not support image stacks

% given optimization of the erosion and dilation code consider using these

%--
% check for handle input
%--

[X, N, tag, flag, g, h] = handle_input(X,inputname(1));

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%--
% set type of gradient
%--

if (nargin < 3)
	t = 0;
end

%--
% color image
%--

if (ndims(X) > 2)
	
	[rr,cc,ss] = size(X);
	
	for k = 1:ss
		Y(:,:,k) = morph_gradient(X(:,:,k),SE,t,Z);
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
	% full operator
	%--
	
	if (isempty(Z))
		
		% TODO: the mex version of this code needs debugging
		
% 		%--
% 		% compute gradient using mex
% 		%--
% 		
% 		X = image_pad(X,pq,-1);
%
% 		Y = morph_gradient_(X,uint8(B),t);
		
		%--
		% compute gradient using erosion and dilattion
		%--
		
		switch (t)
			
			%--
			% inner gradient
			%--
			
			case (-1)
				Y = morph_dilate(X,SE) - X;
				
			%--
			% symmetric gradient
			%--
			
			case (0)
				Y = morph_dilate(X,SE) - morph_erode(X,SE);
				
			%--
			% outer gradient
			%--
			
			case (1)
				Y = X - morph_erode(X,SE);
				
		end
		
	%--
	% mask operator
	%--
	
	else
	
		% TODO: there are problems with the mex, so this is probably wrong
		
		X = image_pad(X,pq,-1);
		Z = image_pad(Z,pq,0);
		Y = morph_gradient_(X,uint8(B),t,uint8(Z));
	
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
