function browser_code_stats(stats)

%--
% create and layout figure 
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

par = figure;

layout = layout_create(1, 1); layout.margin(1) = 0.5; layout.margin(4) = 0.75;

harray(par, layout);

handles = harray_select(par, 'level', 1);

%--
% set state
%--

data = get(par, 'userdata');

data.stats = stats;

data.axes = handles;

set(par, 'userdata', data);

%--
% display stats
%--

stats_display(par, data);




function stats_display(par, data)

if nargin < 2
	data = get(par, 'data');
end

delete(findobj(data.axes, 'type', 'line'));

% NOTE: this is the code lines distribution

lines = log2(data.stats.lines(:, 1))

xlim = [0, max(lines)];

set(data.axes, 'xlim', xlim, 'ylim', [0, 1]);

for k = 1:length(lines)
	line('xdata', lines(k) * ones(1, 2), 'ydata', [0, 0.5]);
end
