function Y = morph_tophat(X,SE,t,Z,b)

% morph_tophat - morphological tophat
% -----------------------------------
% 
% Y = morph_tophat(X,SE,t,Z,b)
%
% Input:
% ------
%  X - input image or handle to parent figure
%  SE - structuring element
%  t - type of tophat
%
%   -1 - self complementary (def)
%    0 - dark
%    1 - bright
% 
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - tophat image

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

if (nargin < 5)
	b = -1;
end

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%--
% set type
%--

if (nargin < 3)
	t = -1;
end

%--
% compute tophat
%--

switch (t)
	
	%--
	% self complementary
	%--
		
	case (-1)
		
		if (isa(X,'double'))
			Y = morph_close(X,SE,Z) - morph_open(X,SE,Z);
		elseif (isa(X,'uint8'))
			Y = uint8(double(morph_close(X,SE,Z)) - double(morph_open(X,SE,Z)));
		end
		
	%--
	% dark
	%--
		
	
	case (0)
		
		if (isa(X,'double'))
			Y = morph_close(X,SE,Z) - X;
		elseif (isa(X,'uint8'))
			Y = uint8(double(morph_close(X,SE,Z)) - double(X));
		end
		
	%--
	% bright
	%--
		
	case (1)
		
		if (isa(X,'double'))
			Y = X - morph_open(X,SE,Z);
		elseif (isa(X,'uint8'))
			Y = uint8(double(X) - double(morph_open(X,SE,Z)));
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


