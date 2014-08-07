function Y = morph_par_gradient(X,SE,r,t,Z)

% morph_par_gradient - morphological parametric gradient
% ------------------------------------------------------
% 
% Y = morph_par_gradient(X,SE,r,t,Z)
%
% Input:
% ------
%  X - input image
%  SE - structuring element
%  r - rank from extremes
%  t - type of gradient
%
%   -1 - inner
%    0 - symmetric (def)
%  	 1 - outer
%
%  Z - computation mask image (def: [])
%
% Output:
% -------
%  Y - parametric gradient image

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

%--
% set mask
%--

if (nargin < 5)
	Z = [];
end

%--
% set gradient type
%--

if (nargin < 4)
	t = 0;
end

%--
% check depth
%--

s = floor(se_size(SE)/2);

if ((r < 1) | (r >= s))

	str = ['Rank parameter must be integer from 1 to ' num2str(s - 1) '.'];
	error(str);

elseif ((r > 1) & (r < s))

	if (floor(r) ~= r)
		str = ['Rank parameter ' num2str(d) ' must be integer.'];
		error(str);
	end

end
		
%--
% parametric gradient
%--

switch (t)

	%--
	% inner
	%--
	
	case (-1)
	
		%--
		% compute inner gradient
		%--
		
		if (isa(X,'double'))
		
			Y = X - rank_filter(X,SE,r,Z);	
			
		elseif (isa(X,'uint8'))
		
			Y = double(X) - double(rank_filter(X,SE,r,Z));
			
		end
		
	%--
	% symmetric
	%--
	
	case (0)

		%--
		% double image
		%--
		
		if (isa(X,'double'))

			%--
			% structuring element
			%--
			
			B = se_mat(SE);
			pq = se_supp(SE);
			
			%--
			% full operator
			%--
			
			if (isempty(Z))
			
				X = image_pad(X,pq,-1);
				Y = morph_par_gradient_d(X,uint8(B),r);
				
			%--
			% mask operator
			%--
			
			else
			
				X = image_pad(X,pq,-1);
				Z = image_pad(Z,pq,0);
				Y = morph_par_gradient_d(X,uint8(B),r,uint8(Z));
			
			end

		%--
		% uint8 image
		%--
		
		elseif (isa(X,'uint8'))
	
			%--
			% structuring element
			%--
			
			B = se_mat(SE);
			pq = se_supp(SE);
			
			%--
			% full operator
			%--
			
			if (isempty(Z))
			
				X = image_pad(X,pq,-1);
				Y = morph_par_gradient_u8(X,uint8(B),r);	
				
			%--
			% mask operator
			%--
			
			else
			
				X = image_pad(X,pq,-1);
				Z = image_pad(Z,pq,0);
				Y = morph_par_gradient_u8(X,uint8(B),r,uint8(Z));	
				
			end
		
		end
			
	%--
	% outer
	%--
	
	case (1)
	
		%--
		% reflect rank
		%--
		
		r = se_size(SE) - r + 1;
		
		%--
		% compute outer gradient
		%--
		
		if (isa(X,'double'))
		
			Y = rank_filter(X,SE,r,Z) - X;	
			
		elseif (isa(X,'uint8'))
		
			Y = double(rank_filter(X,SE,r,Z)) - double(X);
				
		end
		
end

	
