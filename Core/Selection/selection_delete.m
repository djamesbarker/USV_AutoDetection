function n = selection_delete(ax, sel)

% selection_delete - delete selections in axes
% --------------------------------------------
% 
% selection_delete(ax, sel)
%
% Input:
% ------
%  ax - selection axes
%  sel - selections (def: all selections in axes)
%
% Output:
% -------
%  n - number of selections deleted

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
% get all axes selections
%--

if nargin < 2
	sel = get_axes_selections(ax);
end

%--
% delete selections
%--

n = length(sel);

for k = 1:n
	try
		delete(findobj(ax, 'tag', sel(k).tag));
	catch
		n = n - 1;
	end
end
