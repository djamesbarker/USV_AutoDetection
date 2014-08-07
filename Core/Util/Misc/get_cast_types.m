function [types,fun] = get_cast_types

% get_cast_types - get names and casting handles for castable types
% -----------------------------------------------------------------
%
% [types,fun] = get_cast_types
%
% Output:
% -------
%  types - names of types for which casting is available
%  fun - cell array of handles to cast functions

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
% $Revision: 1.7 $
% $Date: 2004-06-08 13:54:58-04 $
%--------------------------------

%--
% create persistent table of cast types
%--

persistent PERSISTENT_CAST_TYPES PERSISTENT_CAST_HANDLES;

if (isempty(PERSISTENT_CAST_TYPES))
	
	%--
	% list castable type names
	%--
	
	% NOTE: these are ordered from 'less' to 'more' numerical
	
	PERSISTENT_CAST_TYPES = { ...
		'char', ...
		'logical', ...
		'uint8', 'uint16', 'uint32', 'uint64', ...
		'int8', 'int16', 'int32', 'int64', ...
		'single', 'double' ...
	};

	%--
	% build caster function handles from names
	%--
	
	% NOTE: this is the built-in way to do this, but it generates an array
	
% 	PERSISTENT_CAST_HANDLES = str2func(PERSISTENT_CAST_TYPES);
	
	% NOTE: we can put function handles into cell arrays, since arrays are deprecated (?)
	
	for k = 1:length(PERSISTENT_CAST_TYPES)
		PERSISTENT_CAST_HANDLES{k} = eval(['@',PERSISTENT_CAST_TYPES{k}]);
	end
	
end

%--
% output types and function lists
%--

types = PERSISTENT_CAST_TYPES;

if (nargout > 1)
	fun = PERSISTENT_CAST_HANDLES;
end
