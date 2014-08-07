function [value, unit] = is_proper_size_unit(obj, unit)

% is_proper_size_unit - check and normalize size unit for object
% --------------------------------------------------------------
%
% [value, unit] = is_proper_size_unit(obj, unit)
%
% Input:
% ------
%  obj - sizeable object
%  unit - proposed unit
% 
% Output:
% -------
%  value - propriety
%  unit - normalized unit string

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
% check units type
%--

if ~ischar(unit)
	error('Units must be specified as a string.');
end

%--
% expand some unit abbreviations
%--

switch lower(unit)
	
	case 'cm', unit = 'centimeters';
		
	case 'in', unit = 'inches';
		
	case 'px', unit = 'pixels';

end

%--
% get allowed object units and check we are one of them
%--

try
	units = set(obj, 'units');
catch
	value = 0; unit = '__NO_UNITS__'; return;
end

value = ismember(unit, units);

