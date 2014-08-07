function [p,q] = se_supp(SE)

% se_supp - support parameters of structuring element
% ---------------------------------------------------
%
% [p,q] = se_supp(SE)
%
% Input:
% ------
%  SE - structuring element
%
% Output:
% -------
%  p - row support or both row and column support
%  q - column support

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
% $Revision: 5169 $
% $Date: 2006-06-06 17:29:13 -0400 (Tue, 06 Jun 2006) $
%--------------------------------

%--
% get support depending on representation
%--

switch (se_rep(SE))

	case ('vec'), p = max(abs(SE), [], 1);
		
	case ('mat'), p = (size(SE) - 1) / 2;
			
end

%--
% separate support parameters if needed
%--

if (nargout > 1)
	q = p(2); p = p(1);
end
