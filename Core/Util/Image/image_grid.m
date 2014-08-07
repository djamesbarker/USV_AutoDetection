function h = image_grid(r,c,h)

% image_grid - grid display for images 
% ------------------------------------
%
% h = image_grid(r,c,h)
%   = image_grid(r,c)
% 
% Input:
% ------
%  r,c - row and column indices or block size when negative
%  h - handle to axes (def: gca)
% 
% Output:
% -------
%  h - handle to axes

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
% set axes
%--

if (nargin < 3)
	h = gca;
end

%--
% set columns
%--

if (nargin < 2)
	c = r;
end

%--
% put r and c in row form
%--

r = r(:)';
c = c(:)';

%--
% generate regular grids
%--

flag_r = 1;

if (length(r) == 1)
	if (r < 0)
		yl = get(findobj(gca,'type','image'),'ydata');
		r = 0:-r:ceil(yl(2));
	elseif (r == 0)
		flag_r = 0;
	end
end

flag_c = 1;

if (length(c) == 1)
	if (c < 0)
		xl = get(findobj(gca,'type','image'),'xdata');
		c = 0:-c:ceil(xl(2));
	elseif (c == 0)
		flag_c = 0;
	end
end

%--
% setup grid
%--
	
if (flag_r)
	set(h,'Ytick',r + 0.5);
% 	set(h,'YTickLabel',r);
	set(h,'YTickLabel',[]);
else
	set(h,'Ytick',[]);
end

if (flag_c)
	set(h,'Xtick',c + 0.5);
% 	set(h,'XTickLabel',c);
	set(h,'XTickLabel',[]);
else
	set(h,'Xtick',[]);
end

		
