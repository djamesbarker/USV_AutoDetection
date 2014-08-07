function r = se_rep(SE)

% se_rep - representation type of structuring element
% ---------------------------------------------------
% 
% r = se_rep(SE)
%
% Input:
% ------
%  SE - structuring element
%
% Output:
% -------
%  r - representation type 'mat', 'vec', or ''

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
% $Date: 2006-06-06 17:29:13 -0400 (Tue, 06 Jun 2006) $
% $Revision: 5169 $
%--------------------------------

%--
% get size of input
%--

[m,n] = size(SE);

%--
% displacement vectors
%--

if ((n == 2) && all(round(SE(:)) == SE(:)))
 
	r = 'vec';

%--
% matrix
%--

elseif (rem(m,2) && rem(n,2) && all((SE(:) ~= 0) == SE(:)))

	r = 'mat';

%--
% not a structuring element
%--
	
else

	r = '';
	
	if (~nargout)	
		warning('Input is not a structuring element.');
	end

end
