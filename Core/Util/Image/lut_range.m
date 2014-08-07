function Y = lut_range(X,b)

% lut_range - map values to specified range
% -----------------------------------------
%
% Y = lut_range(X,b)
%
% Input:
% ------
%  X - input image
%  b - specified range (def: [0,255])
%
% Output:
% -------
%  Y - image with specified range

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
% $Revision: 792 $
% $Date: 2005-03-22 20:08:18 -0500 (Tue, 22 Mar 2005) $
%--------------------------------

%--
% set default range
%--

if ((nargin < 2) || isempty(b))
	b = [0,255];
end

%--
% create double image
%--

X = double(X);

%--
% get value extremes
%--

c = fast_min_max(X);

if (0)
	
	%--
	% create look up table
	%--

	% NOTE: this length table can be slightly faster for uint8 valued images

	T = linspace(b(1),b(2),256);

	%--
	% apply look up table
	%--

	Y = lut_apply(X,T,c);

	%--
	% reshape multiple plane image
	%--

	if (ndims(X) > 2)
		Y = reshape(Y,size(X));
	end
	
else
	
	% NOTE: this code has not been tested
	
	%--
	% compute scaling and translation constants
	%--
		
	a = diff(b) / diff(c);
	
	c = b(1) - (a * c(1));

	Y = (a .* X) + c;

end


