function prop = get_settable(obj)

% get_settable - get settable properties and values for object
% ------------------------------------------------------------
%
% prop = get_settable(obj)
%
% Input:
% ------
%  obj - object handle
%
% Output:
% -------
%  prop - settable properties struct

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
% $Revision: 2095 $
% $Date: 2005-11-09 16:11:39 -0500 (Wed, 09 Nov 2005) $
%--------------------------------

%--
% get settable fields and corresponding values and pack into struct
%--

fields = fieldnames(set(obj)); values = get(obj,fields);

prop = cell2struct(values(:),fields(:));

%--
% remove fields we really can't set properly
%--

% NOTE: these were discovered using figure to figure out settable

improper = {'Children','CurrentCharacter'};

prop = remove_field(prop,improper);
