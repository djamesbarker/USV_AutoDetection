function handles = geometry_plot(geometry, pal, ax, sel, ref, par)

% geometry_plot - plot array geometry
% -----------------------------------
%
% handles = geometry_plot(par, ax)
%
% Input:
% ------
%  par - browser handle
%  pal - palette handle
%  ax - display axes
%
% Output:
% -------
%  handles - structured handles

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
% handle input
%--

if nargin < 6
	par = get_active_browser;
end

if nargin < 5
	ref = [];
end

if nargin < 4
	sel = [];
end

handles = [];

%--
% try to get geometry axes
%--

if nargin < 3 || isempty(ax) || ~ishandle(ax)
	
	ax = findobj(pal, 'tag', 'Geometry_Plot', 'type', 'axes');
	
	if isempty(ax)
		return;
	end
	
end

%--
% check whether we are here through clicking
%--

if ax == overobj('axes')
	flag = 1;
else
	flag = 0;
end

%--
% update display
%--
	
delete(get(ax,'children'));

array_line = line(geometry(:,1), geometry(:,2), ...
	'parent', ax, ...
	'tag', 'ARRAY_LINE', ...
	'linestyle', 'none', ...
	'marker', 'o', ...
	'markerfacecolor', [.5 .5 .5], ...
	'markeredgecolor', [0 0 0], ...
	'hittest', 'off' ...
); %#ok<NASGU>

select_line = line(geometry(1,1), geometry(1,2), ...
	'parent', ax, ...
	'tag', 'SELECT_LINE', ...
	'linestyle', 'none', ...
	'marker', 'o', ...
	'markersize', 10, ...
	'color', [1 0 0], ...
	'hittest', 'off' ...
);

reference_line = line(geometry(1,1), geometry(1,2), ...
	'parent', ax, ...
	'tag', 'REFERENCE_LINE', ...
	'linestyle', 'none', ...
	'marker', 'o', ...
	'markersize', 6, ...
	'markerfacecolor', [0 0 1], ...
	'markeredgecolor', [0 0 0], ...
	'hittest', 'off' ...
);

%--
% compute axis limits
%--

xlim = fast_min_max(geometry);

if diff(xlim)
	dx = 0.1 * diff(xlim);
else
	dx = 1;
end

center = mean(geometry);

lim = [xlim(1) - dx, xlim(2) + dx];

xlim = lim - (mean(lim) - center(1));

ylim = lim - (mean(lim) - center(2));

set(ax, 'xlim', xlim, 'ylim', ylim);

%--
% select closest channel
%--

if flag == 1

	%--
	% get closest channel
	%--

	p = get(ax, 'currentpoint');

	p = p(1,:); p(3) = 0;
	
	d = sum((geometry - repmat(p, [size(geometry,1),1])).^2, 2);

	[ignore, ix] = sort(d);

	%--
	% display highlight
	%--

	set(select_line, ...
		'xdata', geometry(ix(1), 1), ...
		'ydata', geometry(ix(1), 2) ...
	);

	%--
	% update select channel
	%--
	
	g = findobj(pal, 'tag', 'Select Channel', 'style', 'popupmenu');
	
	set(g, 'value', ix(1));

	browser_controls(par, 'Select Channel', g);
	
	set_control(pal, 'channel', 'value', ix(1));
	
	%--
	% update reference channel on double_click
	%--
	
% 	if double_click(ax)	
% 		
% 		set(reference_line, ...
% 			'xdata', geometry(ix(1), 1), ...
% 			'ydata', geometry(ix(1), 2) ...
% 		);
% 		
% 		set_control(pal, 'reference', 'value', 1);
% 		
% 		control_callback([], pal, 'reference');
% 		
% 		return;
% 		
% 	end

else

	%--
	% get select channel value
	%--
	
	g = findobj(pal, 'tag', 'Select Channel', 'style', 'popupmenu');
	
	value = get(g, 'value');
	
	if isempty(value)
		value = sel;
	end

	%--
	% display highlight
	%--
	
	set(select_line, ...
		'xdata', geometry(value, 1), ...
		'ydata', geometry(value, 2) ...
	);

end

set(reference_line, ...
	'xdata', geometry(ref, 1), ...
	'ydata', geometry(ref, 2) ...
);




