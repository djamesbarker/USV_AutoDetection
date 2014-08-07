function sel = selection_standardize(sel)

% selection_standardize - make selection have positive offset
% -----------------------------------------------------------
%
% sel = selection_standardize(sel)
%
% Input:
% ------
%  sel - selection
%
% Output:
% -------
%  sel - standard selection

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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%--
% update anchor if needed
%--

if sel.offset(1) < 0
	sel.anchor(1) = sel.anchor(1) + sel.offset(1);
end

if sel.offset(2) < 0
	sel.anchor(2) = sel.anchor(2) + sel.offset(2); 
end

%--
% make offsets positive
%--

sel.offset = abs(sel.offset);
