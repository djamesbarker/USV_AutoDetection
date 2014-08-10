function handles = layout(widget, parameter, context)

% SCOPE - layout

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
% clear existing widget axes
%--

delete(findobj(widget, 'type', 'axes'));

%--
% layout axes and get handles
%--

% NOTE: for single channel files we only ever need one scope

if context.sound.channels < 2
	n = 1;
else
	n = 2;
end

layout = layout_create(n, 1); layout.margin(1) = 0.5; layout.margin(4) = 0.75;

harray(widget, layout);

handles = harray_select(widget, 'level', 1);

%--
% tag and label axes
%--

for k = 1:n
	set(handles(k), 'tag', ['scope_axes::', int2str(k)], 'xticklabel', []);
end

%-------------
% TEST CODE
%-------------

%--
% set display options
%--

% TODO: this should happen at a higher level

color = context.display.grid.color;

set(handles, 'xcolor', color, 'ycolor', color);

%--
% display zero line
%--

for k = 1:length(handles)
	
	line( ...
		'parent', handles(k), ...
		'xdata', [-10^10, 10^10], ...
		'ydata', [0, 0], ...
		'linestyle', ':', ...
		'color', color ...
	);

end
