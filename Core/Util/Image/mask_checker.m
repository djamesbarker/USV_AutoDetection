function Z = mask_checker(m,t)

% mask_checker - create checkerboard masks
% ----------------------------------------
%
% Z = mask_checker(m,t)
%
% Input:
% ------
%  m - size of mask
%  t - parity of row and column sum, even (0) or odd (1)
%    
% Output:
% -------
%  Z - checkerboard mask

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
% build mask according to type
%--

switch (t)

	%--
	% even row and column sum 
	%--
	
	case (0)
		Z = mask_parity(m,[0,0]) | mask_parity(m,[1,1]);
	
	%--
	% odd row and column sum
	%--
	
	case (1)
		Z = mask_parity(m,[0,1]) | mask_parity(m,[1,0]);

end	
		
		
