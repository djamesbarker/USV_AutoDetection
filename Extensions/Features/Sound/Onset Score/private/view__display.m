function handles = view__display(par, feature, parameter, context)

% ONSET SCORE - view__display

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

%-------------------
% SETUP
%-------------------

feature

%--
% clean up display
%--

delete(findobj(par, 'tag', 'delete_me'));

%--
% set some colors
%--

% NOTE: these will be parameters eventually

color.gray = 0.5 * ones(1, 3);
	
color.onset = [0, 0.5, 0];
	
%-------------------
% DISPLAY
%-------------------

%--
% alias page and initialize handles
%--

page = context.page;

time = [page.start, page.start + page.duration];

handles = [];

%--
% loop over page channels
%--

for k = 1:length(page.channels)
	
	%--
	% get and update axes
	%--
	
	ax = findobj(par, 'type', 'axes', 'tag', int2str(page.channels(k)));
	
	% NOTE: there is no place to display channel information, continue;
	
	if isempty(ax)
		continue; 
	end

	set(ax, ...
		'xlim', time ...
	);
	
	%--
	% display feature
	%--
	
	handles(end + 1) = line( ...
		'parent', ax, ...
		'xdata', feature.time, ...
		'ydata', feature.onset.sequence, ...
		'linestyle', ':', ...
		'color', color.onset ...
	);

	handles(end + 1) = line( ...
		'parent', ax, ...
		'xdata', feature.time, ...
		'ydata', feature.onset.smooth, ...
		'linestyle', '-', ...
		'color', color.onset ...
	);
	
	center = feature.onset.mean; offset = feature.onset.std;
	
	guides = [center - 2 * offset, center + 2 * offset, center];
	
	for k = 1:length(guides)
		
		handles(end + 1) = line( ...
			'parent', ax, ...
			'xdata', time, ...
			'ydata', guides(k) * ones(1, 2), ...
			'color', color.gray, ...
			'linestyle', ':' ...
		);
	
	end
 
	set(handles(3:end), 'tag', 'delete_me');
	
%   	set(handles(end), 'linestyle', '-');
	
	peak = feature.onset.peaks;
	
	for j = 1:length(peak) 
		
		handles(end + 1) = line( ...
			'parent', ax, ...
			'xdata', feature.time(peak(j)), ...
			'ydata', feature.onset.sequence(peak(j)), ...
			'marker', 'o', ...
			'color', 0.75 * [1 0 0] ...
		);
	
% 		handles(end + 1) = line( ...
% 			'parent', ax, ...
% 			'xdata', feature.time(peak(j)) * ones(1, 2), ...
% 			'ydata', [0, feature.onset.sequence(peak(j))], ...
% 			'linestyle', ':', ...
% 			'color', 0.75 * [1 0 0] ...
% 		);
	
	
	end

end
