function type = get_type(caller)

% get_type - get type of extension by examining caller location
% -------------------------------------------------------------
%
% type = get_type(caller)
%
% Output:
% -------
%  type - type of caller if computable

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%--
% compute type from caller location
%--

% NOTE: the caller location includes the immediate parent directory as well

loc = caller.loc;

switch (length(loc))
	
	case (2)	
		 type = lower(loc{1});
		 
	case (3) 
		type = lower([loc{2}, '_', loc{1}]);
		
	% TODO: implement some way of handling more organization
	
	otherwise
		type = '';
		
end

% NOTE: remove traling 's', this is not very smart code
		
if (type(end) == 's')
	type(end) = [];
end
