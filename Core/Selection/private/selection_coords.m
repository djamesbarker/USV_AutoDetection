function [x, y] = selection_coords(type, sel, ax)

% selection_coords - get coordinates for selection object display
% ---------------------------------------------------------------
%
% [x, y] = selection_coords(type, sel, ax)
%
% Input:
% ------
%  type - type of coordinates
%  sel - selection
%  ax - parent axes
%
% Output:
% -------
%  x, y - coordinates for selection object display

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

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% check coordinate type
%--

types = {'patch', 'control', 'grid__x', 'grid__y', 'all'}; type = lower(type);
	
if ~ismember(types, type)
	error('Unrecognized coordinate type.');
end

%--
% handle all recursively, not terribly efficient
%--

if strcmp(type, 'all')
	
	type = types(1:end - 1);

	for k = 1:length(type)
		[x.(type{k}), y.(type{k})] = selection_coords(type{k}, sel, ax);
	end

	% NOTE: this collapsed the struct to match handles struct in 'selection_draw'
	
	x = unflatten(x); y = unflatten(y);

	return;

end

%--------------------------
% COMPUTE COORDINATES
%--------------------------

%--
% compute point representation of selection
%--

sel = selection_standardize(sel);

x1 = sel.anchor(1); x2 = sel.anchor(1) + sel.offset(1);

y1 = sel.anchor(2); y2 = sel.anchor(2) + sel.offset(2);

%--
% compute coordinates based on type
%--

switch type

	case 'patch'

		x = [x1, x2, x2, x1, x1];

		y = [y1, y1, y2, y2, y1];

	case 'control'

		c = sel.anchor + 0.5 * sel.offset;

		x = [x2, x2, c(1), x1, x1, x1, c(1), x2, c(1)]; 

		y = [c(2), y2, y2, y2, c(2), y1, y1, y1, c(2)];

	% TODO: break grid lines under selection
	
	case 'grid__x'

		ylim = get(ax, 'ylim'); 

		x = [x1, x1, nan, x1, x1, nan, x2, x2, nan, x2, x2]; 

		y = [ylim(1), y1, nan, y2, ylim(2), nan, ylim(2), y2, nan, y1, ylim(1)];

	case 'grid__y'

		xlim = get(ax, 'xlim'); 

		x = [xlim(1), x1, nan, x2, xlim(2), nan, xlim(2), x2, nan, x1, xlim(1)]; 

		y = [y1, y1, nan, y1, y1, nan, y2, y2, nan, y2, y2];

end
