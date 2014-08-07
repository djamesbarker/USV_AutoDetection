function types = get_extension_types(refresh, field, value)

% get_extension_types - get names of extension types
% --------------------------------------------------
% 
% types = get_extension_types(refresh)
%
%       = get_extension_types(refresh, 'target', value)
%
%       = get_extension_types(refresh, 'class', value)
%
% Input:
% ------
%  refresh - force refresh flag
%
% Output:
% -------
%  types - names of extension types, possibly of given type or class
%
% NOTE:
% -----
%  Type refers to the object reference in extension type. Class to action.

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
% $Revision: 1141 $
% $Date: 2005-06-27 12:33:47 -0400 (Mon, 27 Jun 2005) $
%--------------------------------

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set no refresh default
%--

if ~nargin
	refresh = 0;
end
	
%--
% return persistent store if available and wanted
%--

persistent PERSISTENT_EXTENSION_TYPES;

if ~isempty(PERSISTENT_EXTENSION_TYPES) && ~refresh && (nargin < 2)
	types = PERSISTENT_EXTENSION_TYPES; return;
end

%----------------------------------
% GET EXTENSION TYPES
%----------------------------------

%--
% get types definition directory
%--

types_dir = [path_parts(mfilename('fullpath')), filesep, 'Types'];

%--
% get types
%--

% NOTE: types are represented by a function of the same name that defines the API

types = what(types_dir); 

types = sort(file_ext(types.m));

%--
% copy to persistent store
%--

PERSISTENT_EXTENSION_TYPES = types;

%----------------------------------
% SELECT TYPES
%----------------------------------

% NOTE: extension type strings consist of a target and class

if (nargin > 1)
	
	switch (field)
		
		%--
		% select based on class or target
		%--
		
		% TODO: consider developing class and target lists
		
		case {'class', 'target'}

			for k = length(types):-1:1
				
				if isempty(strfind(types{k}, value))
					types(k) = [];
				end
				
			end
			
		%--
		% unrecognized selection field
		%--
		
		otherwise, error('Unrecognized extension selection field.');

	end
	
end
	
