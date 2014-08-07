function obj = set_size_in(obj, unit, in)

% set_size_in - set object size in specified units
% ------------------------------------------------
%
% obj = set_size_in(obj, unit, in)
%
% Input:
% ------
%  obj - object to set
%  unit - set unit
%  in - position input
%
% Output:
% -------
%  obj - handle set

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
% check units input
%--

[proper, unit] = is_proper_size_unit(obj, unit);

if ~proper
	error(['Input units ''', unit, ''' are not valid units for input object.']);
end

%--
% get initial properties
%--

initial.pos = get_size_in(obj, unit);

initial.unit = get(obj, 'units');

%--
% handle different input types
%--

if ~isstruct(in)
	
	pos = in;
	
else	
	
	pos = initial.pos;
	
	names = {'left', 'bottom', 'width', 'height'};
	
	for k = 1:numel(names)
		
		if ~isfield(in, names{k}) || isempty(in.(names{k}))
			continue
		end
		
		pos(k) = in.(names{k});	
		
	end
	
end

%--
% set size carefully
%--

try
	
	set(obj, 'units', unit); set(obj, 'position', pos);
	
	set(obj, 'units', initial.unit);
	
catch
	
	set(obj, 'units', unit); set(obj, 'position', initial.pos);
	
	set(obj, 'units', initial.unit);
	
end
	


			
