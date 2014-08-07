function value = get_palette_property(pal, field)

% get_palette_property - get palette property
% -------------------------------------------
%
% value = get_palette_parent(pal, field)
%
% Input:
% ------
%  pal - palette handle
%  field - property field name
%
% Output:
% -------
%  value - parent handle

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
% $Revision: 3084 $
% $Date: 2005-12-20 18:54:15 -0500 (Tue, 20 Dec 2005) $
%--------------------------------

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% check input is palette
%--

if ~is_palette(pal)
	error('Input handle is not a palette.');
end

%--
% get state data from palette
%--

data = get(pal, 'userdata');

% NOTE: return palette state for no field input

if nargin < 2
	value = data; return;
end

%--
% check field name
%--

if ~ischar(field)
	error('Palette field name must be a string.');
end

fields = {'name', 'parent', 'children', 'control', 'opt', 'created'};

field = lower(field);

if ~ismember(field, fields)
	error('Input field is not a palette property.');
end

%-----------------------
% GET PROPERTY
%-----------------------

switch field
	
	case 'parent'
		
		value = get_field(data, 'parent', []);
		
		% NOTE: at the moment a screen parent means no parent
		
		if value == 0
			value = [];
		end
		
	otherwise
		
		% NOTE: we silently default to empty values when we can't find the field
		
		value = get_field(data, field, []);
		
end
