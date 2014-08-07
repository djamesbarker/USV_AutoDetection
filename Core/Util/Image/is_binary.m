function t = is_binary(X)

% is_binary - check for binary image
% ----------------------------------
%
% t = is_binary(X)
%
% Input:
% ------
%  X - input image
%
% Output:
% -------
%  t - test result

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
% $Date: 2006-06-27 15:35:44 -0400 (Tue, 27 Jun 2006) $
% $Revision: 5430 $
%--------------------------------

%--
% assume it all went to plan
%--

t = 1;

%--
% double image
%--

if (isa(X,'double'))

	b = fast_min_max(X);
	
	if ((b(1) < 0) || (b(2) > 1))
		t = 0;
		return;
	end
	
	if (any(round(X) ~= X))
		t = 0;
		return;
	end
	
%--
% uint8 image
%--

elseif (isa(X,'uint8'))

	b = fast_min_max(X);
	
	if ((b(1) < 0) || (b(2) > 1))
		t = 0;
		return;
	end
	
end
