function y = bin2str(x)

% bin2str - binary to string conversion
% -------------------------------------
%
% y = bin2str(x)
%
% Input:
% ------
%  x - binary array
%
% Output:
% -------
%  y - cell array of 'off' and 'on' strings

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
% $Revision: 1286 $
% $Date: 2005-07-26 13:55:35 -0400 (Tue, 26 Jul 2005) $
%--------------------------------

% NOTE: consider extending to other types, particularly 'char' in a different way

%--
% create cell array
%--

y = cell(size(x));

%--
% fill cell array
%--

for k = 1:length(x)

	if (x(k))
		y{k} = 'On';
	else
		y{k} = 'Off';
	end
	
end

%--
% output string
%--

if (length(x) == 1)
	y = y{1};
end
