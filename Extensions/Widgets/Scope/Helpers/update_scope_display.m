function handles = update_scope_display(widget, start, duration, samples, context)

%--
% get scope axes
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

ax = scope_axes(widget);

if isempty(ax)
	return;
end

%--
% update scope time display
%--

% TODO: this function needs context as input

% TODO: this time display does not consider grid options, we need context

set(get(ax(1), 'title'), 'string', get_browser_time_string([], start, context));

%--
% update scope line display
%--

if isempty(duration) || isempty(samples)
	return;
end

time = linspace(start, start + duration, size(samples, 1));

handles = scope_line(ax);

% NOTE: consider only updating 'ydata' here, and no update on axes

set(handles(1), 'xdata', time, 'ydata', samples(:, 1));

if length(handles) > 1
	
	if size(samples, 2) > 1
		samples = samples(:, 2);
	end
	
	set(handles(2), 'xdata', time, 'ydata', samples);

end

%--
% update scope axes
%--

scope_axes(widget, ...
	'xlim', [start, start + duration] ...
);
