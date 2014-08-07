function type = type_norm(type, skip)

% type_norm - flexible handling of type through normalization
% -----------------------------------------------------------
%
% type = type_norm(type, skip)
%
% Input:
% ------
%  type - type string
%  skip - skip available types check
%
% Output:
% -------
%  type - normalized type string

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
% $Revision: 1035 $
% $Date: 2005-05-11 15:37:03 -0400 (Wed, 11 May 2005) $
%--------------------------------

% TODO: this function can be generalized by providing types list input

%--
% set default no skip
%--

if (nargin < 2) || isempty(skip)
	skip = 0; 
end

%--
% normalize input string
%--

% NOTE: allow spaces, capitalization, irrelevant whitespace, and simple plural

type = lower(strrep(strtrim(type), ' ', '_'));

if type(end) == 's'
	type(end) = [];
end

%--
% possibly check normalized type against available types
%--

return;

% if skip
% 	return;
% end
% 
% if ~is_extension_type(type)
% 	
% 	% NOTE: throw error if no output was requested, otherwise empty output is failure
% 	
% 	if ~nargout
% 		error(['Unrecognized extension type ''', type, '''.']);
% 	else
% 		type = '';
% 	end
% 	
% end

