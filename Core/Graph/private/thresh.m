function Y = double_thresh(X,b)

% thresh - threshold interval of values
% -------------------------------------
% 
% Y = thresh(X,b)
%
% Input:
% ------
%  X - input matrix
%  b - interval string
%
% Output:
% -------
%  Y - threshold matrix
%

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
% parse interval string
%--

[b,t] = parse_interval(b);

%--
% compute threshold matrix
%--

switch (t)

	case 0
		Y = ((X > b(1)) & (X < b(2)));
		
	case 1
		Y = ((X > b(1)) & (X <= b(2)));
		
	case 2
		Y = ((X >= b(1)) & (X < b(2)));
		
	case 3
		Y = ((X >= b(1)) & (X <= b(2)));
		
end

