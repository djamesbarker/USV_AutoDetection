function [div,rem] = div_rem(x,y)

% div_rem - integer division and remainder
% ----------------------------------------
%
% [div,rem] = div_red(x,y)
%
% Input:
% ------
%  x - value
%  y - divisor
%
% Output:
% -------
%  div - integer division result 
%  rem - remainder after integer division

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
% $Revision: 2261 $
% $Date: 2005-12-09 17:58:49 -0500 (Fri, 09 Dec 2005) $
%--------------------------------

%--
% check input sizes
%--

if (numel(y) > 1)
	if (numel(x) > 1)
		if (~isequal(size(x),size(y)))
			error('Divisor must be scalar or same size as values.');
		end
	else
		error('Divisor must be scalar for scalar input value.');
	end
end

%--
% compute division and possibly remainder
%--

div = floor(x ./ y);

if (nargout > 1) 
	rem = x - (div .* y);
end
