function obj = over_obj(h,type)

% over_obj - get handle of object pointer is over
% -----------------------------------------------
%
% obj = over_obj(h,type)
%
% Input:
% ------
%  h - figure to observe
%  type - type of object to check for
%
% Output:
% -------
%  obj - handle of object under pointer

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%------------------------------------------------------
% COMPUTE POINTER POSITION IN FIGURE
%------------------------------------------------------

%--
% get figure and pointer positions in pixels
%--

hu = get(h,'Units');

set(h,'Units','pixels'); h_pos = get(h,'Position');

set(h,'Units',hu);

ptr_pos = get(0,'PointerLocation');

%--
% compute pointer position in normalized figure units
%--

ptr_pos(1) = (ptr_pos(1) - h_pos(1)) / h_pos(3);

ptr_pos(2) = (ptr_pos(2) - h_pos(2)) / h_pos(4);

%------------------------------------------------------
% CHECK THAT POINTER IS OVER AXES IN FIGURE
%------------------------------------------------------

%--
% get figure axes children
%--

ax = findobj(get(h,'Children'),'flat','type','axes','Visible','on')';

%--
% check whether pointer is over axes
%--

for g = ax
	
	%--
	% get axes position in normalized figure units
	%--
	
	gu = get(g,'Units');
	
	set(g,'Units','norm'); g_pos = get(g,'Position');
	
	set(g,'Units',gu);
	
	%--
	% check that pointer is over axes
	%--
	
	if ( ...
		(ptr_pos(1) > g_pos(1)) & (ptr_pos(1) < (g_pos(1) + g_pos(3))) & ...
		(ptr_pos(2) > g_pos(2)) & (ptr_pos(2) < (g_pos(2) + g_pos(4))) ...
	)
		
		%------------------------------------------------------
		% CHECK THAT POINTER IS OVER OBJECT
		%------------------------------------------------------
		
		if (strcmp(type,'axes'))
			
			%--
			% object that we are looking for is axes
			%--
			
			obj = g;
			return;
			
		else
			
			%--
			% get axes children of specified type
			%--
			
			ch = findobj(get(g,'children'),'flat','type',type,'visible','on')';
			
			for k = 1:length(ch)
				
				%--
				% get position of object in normalized figure units
				%--
				
				ch_pos = get_position(ch(k),g_pos,g);
				
				%--
				% check whether pointer is over object in axes
				%--
				
				if ( ...
					(ptr_pos(1) > ch_pos(1)) & (ptr_pos(1) < (ch_pos(1) + ch_pos(3))) & ...
					(ptr_pos(2) > ch_pos(2)) & (ptr_pos(2) < (ch_pos(2) + ch_pos(4))) ...
				)
			
					obj = ch(k);
					return;
					
				end
				
			end
			
		end
				
	end
	
end

obj = [];


function pos = get_position(obj,r,par)

% get_position - get position of object with respect to figure
% ------------------------------------------------------------
%
% pos = get_position(obj,r,par)
%
% Input:
% ------
%  obj - object handle
%  r - parent position
%  par - parent handle
%
% Output:
% -------
%  pos - position with respect to figure

%--
% get parent handle if needed
%--

if ((nargin < 3) | isempty(par))
	par = get(obj,'parent');
end

%--
% compute position in normalized figure units
%--

switch (get(obj,'type'))
	
	case ({'patch','line'})
		
		%--
		% get parent limits and width
		%--
		 	
		% check direction of axes
		
		xl = get(par,'xlim');
		dxl = diff(xl);
		
		yl = get(par,'ylim');
		dyl = diff(yl);
		
		%--
		% get object bounding box position
		%--
		
		% compute this using built in functions to minimize dependence
		
		x = fast_min_max(get(obj,'xdata'));
		dx = diff(x);
		
		y = fast_min_max(get(obj,'ydata'));
		dy = diff(y);
		
		%--
		% compute position of object relative to figure
		%--
		
		% note the shifting and double scaling of the object bounding box
		
		pos = [ ...
			r(1) + r(3) * (x(1) - xl(1))/dxl, ...
			r(2) + r(4) * (y(1) - yl(1))/dyl, ...
			r(3) * (dx / dxl), ...
			r(4) * (dy / dyl) ...
		];
	
	case ('axes') 
		
		%--
		% the axes position is already given as part of the input
		%--
		
		pos = r;
		
% 	case ('image')
		
		%--
		% compare the image xdata and ydata to the axes xlim and ylim to
		% compute the position of the image in the figure. note that this
		% also requires the double scaling of the bounding box of the
		% image, as in the case of the line and patch
		%--
		
		
	otherwise
				
		pos = [nan nan nan nan];
		
end
