function str = integer_unit_string(value, unit, large, pad)

%--
% handle input
%--

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

if nargin < 4
	pad = ' ';
end

if nargin < 3
	large = [];
end

%--
% convert value to string, possibly with padding
%--

str = int_to_str(value, large, pad);

%--
% add unit information if needed and possible
%--

if nargin < 2 || isempty(unit)
	return;
end

if (abs(value) > 1) || (value == 0)
	unit = string_plural(unit);
end

str = [str, ' ', unit];

