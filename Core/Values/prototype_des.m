function des = prototype_des(value)

% prototype_des - generate description from prototype
% ---------------------------------------------------
%
% des = prototype_des(value)
%
% Input:
% ------
%  value - prototype of value
% 
% Output:
% -------
%  des - value description

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
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

%------------------------------
% CREATE DESCRIPTION
%------------------------------

%--
% get canonical names and corresponding values
%--

[names,values] = get_canonical_names(value);

%--
% compute flattened field description
%--

for k = 1:length(names)
	des.(names{k}) = simple_des(names{k},values{k});
end

%--
% collapse to get description
%--

des = unflatten_struct(des);


%------------------------------
% SIMPLE_DES
%------------------------------

function des = simple_des(name,value)

% simple_des - description for simple prototype value
% ---------------------------------------------------

%--
% infer description contents based on prototype value
%--

switch (class(value))
	
	case ('cell')
		
		% NOTE: set like syntax suggests no order
		
		type = 'categorical'; range = unique(value); interval = [];
		
	case ('char')
		
		if (size(value,1) == 1)
			
			% NOTE: a single row character array is an expression to evaluate
			
			type = 'numerical'; [range,interval] = parse_interval(value);
			
		else
		
			% NOTE: stiffness of character matrices suggests order
			
			type = 'ordinal'; range = cellstr(value); interval = [];
			
		end
		
	case ('double')
		
		% NOTE: an array suggests order
		
		type = 'ordinal'; range = value(:); interval = [];
		
end

%--
% infer range and interval information if needed
%--

des = des_create( ...
	'name',name, ...
	'type',type, ...
	'range',range, ...
	'interval',interval ...
);
