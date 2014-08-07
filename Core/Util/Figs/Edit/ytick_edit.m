function [y,L] = ytick_edit(y,L)

% ytick_edit - set and get YTick and YTickLabel
% ---------------------------------------------
% 
% h = ytick_edit(y,L)
% [y,L] = ytick_edit(h)
%
% Input:
% ------
%  y - YTick locations
%  L - YTickLabel strings
%  h - handle to parent axes (def: gca)
%
% Output:
% -------
%  h - handle to parent axes
%  y - YTick locations
%  L - YTickLabel strings

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
% $Revision: 1.0 $
% $Date: 2003-09-16 01:30:52-04 $
%--------------------------------

%--
% handle variable input
%--

switch (nargin)

	case (0)
	
		%--
		% get YTick information from current axes
		%--
			
		h = gca;
		
		y = get(h,'YTick');
		if (nargout > 1)
			L = cellstr(get(h,'YTickLabel'));
		end
		
	case (1)

		%--
		% get YTick information from given axes
		%--
		
		if (ishandle(y))
			
			h = y;
			
			y = get(h,'YTick');
			if (nargout > 1)
				L = cellstr(get(h,'YTickLabel'));
			end
			
		%--
		% set YTick and corresponding YTickLabel of current axes
		%--
		
		else
		
			h = gca;
			set(h,'YTick',y);
			
			for k = 1:length(y)
				L{k} = num2str(y(k));
			end
			
			set(h,'YTickLabel',L);
			
			y = h;
			
		end
		
	case (2)
	
		%--
		% set YTick information of current axes
		%--
				
		h = gca;
		set(h,'YTick',y);
		
		if (~iscell(L) & ~isstr(L))
			for k = 1:length(L)
				t{k} = num2str(L(k));
			end
			L = t;
		end
		
		set(h,'YTickLabel',L);
		
		% output handle
		
		y = h;
		
end
		
