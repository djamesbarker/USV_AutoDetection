function str = to_str(value, sep)

% to_str - convert a vector of values to string
% ---------------------------------------------
%
% str = to_str(value)
%
% Input:
% ------
%  value - value
%
% Output:
% -------
%  str - string

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

% TODO: allow for two configurable separators

%--
% set default implode separator
%--

if nargin < 2
	sep = '|';
end 

%--
% create row value vector
%--

value = value(:)';

%--
% consider class of value for conversion
%--

str = '';

switch class(value)
	
	case 'char', str = value;
		
	case 'cell'
		
		for k = 1:length(value)
			str{k} = to_str(value{k}, ';');
		end
		
	case 'struct'
		
		if length(value) > 1
			error('Only scalar structs are supported.');
		end
		
		value = flatten_struct(value); field = fieldnames(value);
		
		for k = 1:length(field)		
			str{k} = [field{k}, ':', to_str(value.(field{k}), ';')];
		end
		
	otherwise
		
		if all(value == floor(value))
			
			str = int_to_str(value);
		
		else
			
			str = cell(size(value));
		
			for k = 1:length(value)
				str{k} = num2str(value(k));
			end

		end

end

%--
% implode cell arrays to get string
%--

while iscell(str)
	str = str_implode(str, sep);
end
