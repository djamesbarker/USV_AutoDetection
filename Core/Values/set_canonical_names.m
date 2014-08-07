function desc = set_canonical_names(desc,value)

% set_canonical_names - set canonical names for structure values
% --------------------------------------------------------------
%
% value = set_canonical_names(desc,value)
%
% Input:
% ------
%  desc - structure description structure
%  value - value structure
%
% Output:
% -------
%  desc - updated description

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

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% get fieldnames from value structure
%--

% NOTE: we assume that input is either value struct or names

if (isstruct(value))
	names = fieldnames(flatten_struct(value));
else
	names = value;
end

%------------------------------
% SET NAMES
%------------------------------

%--
% set canonical names in description structure
%--

% NOTE: flatten and unflatten achieves this

desc = flatten_struct(desc);

for k = 1:length(names)
	desc.([names{k}, '__name']) = names{k};
end

desc = unflatten_struct(desc);
