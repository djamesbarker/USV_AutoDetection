function selection_axes_callback(obj, eventdata, opt)

% selection_axes_callback - callback for selection axes
% -----------------------------------------------------
%
% selection_axes_callback(obj, eventdata, opt)
%
% Input:
% ------
%  obj, eventdata - matlab callback input
%  opt - selection options

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

% TODO: add selection modes: use double click, use selection state, use key press

%--------------------
% AXES SELECTION
%--------------------

%--
% get selection points
%--

ax = obj;

p1 = get(ax, 'currentpoint'); p1 = p1(1, 1:2);

rbbox; 

p2 = get(ax, 'currentpoint'); p2 = p2(1, 1:2);

%--
% enforce selection limits
%--

if opt.limit.x
	
	xlim = get(ax, 'xlim');
	
	p1(1) = clip_to_range(p1(1), xlim); p2(1) = clip_to_range(p2(1), xlim);
	
end

if opt.limit.y
	
	ylim = get(ax, 'ylim');
	
	p1(2) = clip_to_range(p1(2), ylim); p2(2) = clip_to_range(p2(2), ylim);
	
end

%--
% compute anchor offset representation and pack selection
%--

% TODO: factor 'selection_create'

tag = [opt.name, '::SELECTION::', int2str(10^12 * rand(1))];

sel.tag = tag;

sel.anchor = min([p1; p2], [], 1);

sel.offset = max([p1; p2], [], 1) - sel.anchor;

%--
% draw selection
%--

selection_draw(ax, sel);
