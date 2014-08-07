function [names,values] = get_canonical_names(value)

% get_canonical_names - canonical names for struct fields
% -------------------------------------------------------
%
% [names,values] = get_canonical_names(value)
%
% Input:
% ------
%  value - struct
%
% Output:
% -------
%  names - canonical names
%  values - values corresponding to names

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

% NOTE: canonical names are fieldnames of flat structure

%--
% get canonical names
%--

flat = flatten_struct(value);

names = fieldnames(flat);

%--
% get corresponding values if needed
%--

if (nargout > 1)
	
	values = cell(length(names),1);
	
	for k = 1:length(names)
		values{k} = flat.(names{k});
	end
	
end
