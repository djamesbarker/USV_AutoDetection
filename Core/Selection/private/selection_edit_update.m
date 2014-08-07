function sel = selection_edit_update(ax, sel, opt)

% selection_edit_update - update selection in edit callback 
% ---------------------------------------------------------
%
% sel = selection_edit_update(ax, sel, opt)
%
% Input:
% ------
%  sel - selection
%  point - current point
%
% Output:
% -------
%  sel - updated selection

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

%---------------------------
% SETUP
%---------------------------

%--
% get current point
%--

point = get(ax, 'currentpoint'); point = point(1, 1:2);

%--
% get control index
%--

control = find(sel.handles.control == sel.handles.obj);

%--
% enforce limits if needed
%--

if opt.limit.x
	
	xlim = get(ax, 'xlim'); 
	
	switch control
		
		case {3, 7}
			
		case 9
			point(1) = clip_to_range(point(1), ...
				xlim + 0.5 * [1, -1] * sel.offset(1) ...
			);
			
		otherwise, point(1) = clip_to_range(point(1), xlim);
			
	end
	
end

if opt.limit.y
	
	ylim = get(ax, 'ylim');
	
	switch control
		
		case {1, 5}
			
		case 9
			point(2) = clip_to_range(point(2), ...
				ylim + 0.5 * [1, -1] * sel.offset(2) ...
			);
			
		otherwise, point(2) = clip_to_range(point(2), ylim);
			
	end
	
end

%---------------------------
% UPDATE SELECTION
%---------------------------

switch control
	
	%--
	% HORIZONTAL EDIT
	%--
	
	% NOTE: these are the basic horizontal updates
	
	case 1
		sel.offset(1) = point(1) - sel.anchor(1);
		
	case 5
		sel.offset(1) = sel.anchor(1) + sel.offset(1) - point(1); sel.anchor(1) = point(1);
	
	%--
	% VERTICAL EDIT
	%--
	
	% NOTE: these are basic vertical updates
	
	case 3
		sel.offset(2) = point(2) - sel.anchor(2);
		
	case 7
		sel.offset(2) = sel.anchor(2) + sel.offset(2) - point(2); sel.anchor(2) = point(2);
		
	%--
	% DIAGONAL EDIT
	%--
	
	% NOTE: diagonal edits are composed using basic horizontal and vertical updates
	
	case 2
		sel.offset(1) = point(1) - sel.anchor(1); 
		sel.offset(2) = point(2) - sel.anchor(2);
		
	case 4
		sel.offset(1) = sel.anchor(1) + sel.offset(1) - point(1); sel.anchor(1) = point(1);
		sel.offset(2) = point(2) - sel.anchor(2);
		
	case 6
		sel.offset(1) = sel.anchor(1) + sel.offset(1) - point(1); sel.anchor(1) = point(1);
		sel.offset(2) = sel.anchor(2) + sel.offset(2) - point(2); sel.anchor(2) = point(2);
		
	case 8
		sel.offset(1) = point(1) - sel.anchor(1);
		sel.offset(2) = sel.anchor(2) + sel.offset(2) - point(2); sel.anchor(2) = point(2);
		
	%--
	% TRANSLATION EDIT
	%--
	
	case 9
		sel.anchor = sel.anchor + (point - (sel.anchor + 0.5 * sel.offset));
		
end
