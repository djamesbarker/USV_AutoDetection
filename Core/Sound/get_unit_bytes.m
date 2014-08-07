function [value, unit] = get_unit_bytes(bytes, unit, base)

% get_unit_bytes - get bytes in provided unit
% -------------------------------------------
%
% [value, unit] = get_unit_bytes(bytes, unit, base)
%
% Input:
% ------
%  bytes - bytes
%  unit - unit
%  base - unit base
%
% Output:
% -------
%  value - value 
%  unit - unit

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

%------------------
% HANDLE INPUT
%------------------

%--
% set and check base
%--

% NOTE: the default is the base typically used for storage

if nargin < 3
	base = 1000;
end

bases = [1000, 1024];

if ~ismember(base, bases)
	error('Unrecognized base for byte units.');
end

%--
% set default unit
%--

if (nargin < 2) 
	unit = [];
end

units = {'b', 'kb', 'mb', 'gb', 'tb', 'pb'};

if ~isempty(unit) && ~ismember(unit, units)
	error('Unrecognized bytes unit.');
end

%--
% sanity check on bytes
%--

if any(bytes < 0)
	error('Input bytes must be positive.');
end

%------------------
% GET UNIT BYTES
%------------------

if ~isempty(unit)
	
	value = convert_to_unit(bytes, unit);
	
else
	
	k = 1; unit = units{k}; 
	
	while k < length(units)
		
		value = convert_to_unit(bytes, unit, base);

		if any(round(value) == 0) || all(round(value) < base)
			return;
		end

		k = k + 1; unit = units{k};
	
	end
	
end


%------------------
% CONVERT_TO_UNIT
%------------------

function value = convert_to_unit(bytes, unit, base)

switch unit
	
	case 'b', value = bytes;
		
	case 'kb', value = bytes / base;

	case 'mb', value = bytes / base^2;
		
	case 'gb', value = bytes / base^3;
		
	case 'tb', value = bytes / base^4;
		
	case 'pb', value = bytes / base^5;
		
end
