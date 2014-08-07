function [x,L] = xtick_edit(x,L)

% xtick_edit - set and get XTick and XTickLabel
% ---------------------------------------------
% 
% h = xtick_edit(x,L)
% [x,L] = xtick_edit(h)
%
% Input:
% ------
%  x - XTick locations
%  L - XTickLabel strings
%  h - handle to parent axes (def: gca)
%
% Output:
% -------
%  h - handle to parent axes
%  x - XTick locations
%  L - XTickLabel strings

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
		% get XTick information from current axes
		%--
			
		h = gca;
		
		x = get(h,'XTick');
		if (nargout > 1)
			L = cellstr(get(h,'XTickLabel'));
		end
		
	case (1)

		%--
		% get XTick information from given axes
		%--
		
		if (ishandle(x))
			
			h = x;
			
			x = get(h,'XTick');
			if (nargout > 1)
				L = cellstr(get(h,'XTickLabel'));
			end
			
		%--
		% set XTick and corresponding XTickLabel of current axes
		%--
		
		else
		
			h = gca;
			set(h,'XTick',x);
			
			for k = 1:length(x)
				L{k} = num2str(x(k));
			end
			
			set(h,'XTickLabel',L);
			
			x = h;
			
		end
		
	case (2)
	
		%--
		% set XTick information of current axes
		%--
				
		h = gca;
		set(h,'XTick',x);
		
		if (~iscell(L) & ~isstr(L))
			for k = 1:length(L)
				t{k} = num2str(L(k));
			end
			L = t;
		end
		
		set(h,'XTickLabel',L);
		
		% output handle
		
		x = h;
		
end
		
