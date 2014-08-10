function [handles, context] = on__play__update(widget, data, parameter, context)

% SIMILARITY MATRIX - on__play__update

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

handles = [];

%--
% get relevant times
%--

page = data.page;

time = [page.start, page.start + page.duration];

current = get_play_time(context.par); 

%--
% update cursors
%--

ax = similarity_matrix_axes(widget);

if isempty(ax)
	return;
end

get_cursor(ax, 1, ...
	'xdata', current * ones(1,2), ...
	'ydata', time ...
);

get_cursor(ax, 2, ...
	'ydata', current * ones(1,2), ...
	'xdata', time ...
);
