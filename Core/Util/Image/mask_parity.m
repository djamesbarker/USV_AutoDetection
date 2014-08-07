function Z = mask_parity(m,p)

% mask_parity - create parity masks
% ---------------------------------
%
% Z = mask_parity(m,p)
%
% Input:
% ------
%  m - size of mask
%  p - parity of rows and columns
%
%   -1 - all
%    0 - even
%    1 - odd
%
% Output:
% -------
%  Z - parity mask

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
% $Revision: 335 $
% $Date: 2004-12-21 19:10:44 -0500 (Tue, 21 Dec 2004) $
%--------------------------------

%--
% create mask according to type
%--

if (all(p > -1))

	% set type parameter

	t = p(1) + 2*p(2);

	Z = mask_parity_(m,t);	
	
elseif ((p(1) == -1) && (p(2) > -1))

	% set type parameter

	t = 4;
	if (~p(2))
		t = 5;
	end
		
	Z = mask_parity_(m,t);	
	
elseif ((p(1) > -1) && (p(2) == -1))

	% set type parameter

	t = 6;
	if (~p(1))
		t = 7;
	end
		
	Z = mask_parity_(m,t);	
	
else

	disp(' ');
	error('No mask is needed to select all rows and columns.');

end

		
