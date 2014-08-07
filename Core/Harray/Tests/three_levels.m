function [ax, h] = three_levels

%--
% create layouts
%--
	
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

layout(1) = layout_create(2, 3);

layout(2) = layout_create(2, 2);

layout(2).col.frac = [0.75, 0.25]; layout(2).row.frac = [0.75, 0.25];

%--
% create harray
%--

par = fig; [ax, h] = harray(par, layout); 

%--
% color and display level and position information
%--

% NOTE: the first axes are the base axes

for k = 2:length(ax)

	%--
	% set color
	%--
	
	set(ax(k), 'color', 1 - 0.75 * rand(1, 3));
	
	%--
	% display level and position indices
	%--
	
	% TODO: make this into a function
	
	i = 2 * h(k).level - 1; j = i + 1; i = h(k).index(i); j = h(k).index(j);
	
	set(get(ax(k), 'title'), ...
		'string',['L', int2str(h(k).level), ' (', int2str(i), ',', int2str(j), ')'] ...
	);

end

% NOTE: this makes the display clearer

set(ax, ...
	'box', 'on', 'xticklabel', [], 'yticklabel', [] ...
);

%--
% display tool and status bar
%--

harray_toolbar(par, 'on'); harray_statusbar(par, 'on');

