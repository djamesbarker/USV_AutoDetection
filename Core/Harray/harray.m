function [ax, h] = harray(par, layout, base)

% harray - create hierarchical axes array
% ---------------------------------------
%
% [ax, h] = harray(par, layout, base)
%
% Input:
% ------
%  par - parent figure
%  layout - hierarchical array layout
%  base - base layout
%
% Output:
% -------
%  ax - created axes
%  h - corresponding harray elements

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

%---------------------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------------------

%--
% set base layout
%--

% TODO: check base layout

if (nargin < 3) || isempty(base)
	base = layout_create(0); base.margin(1) = 0.5;
end

%--
% check for layout
%--

if (nargin < 2) || isempty(layout)
	error('Layout input is required.');
end

%--
% check layouts
%--

[flag, str] = layout_check(layout);

if any(~flag)
		
	if length(layout) == 1
		error(str);
	end
		
	for k = 1:length(layout)
		disp(str{k});
	end

	error('All layouts are not valid.');
	
end

%--
% set default parent
%--

if isempty(par)
	par = figure;
end

%---------------------------------------------------------------
% CREATE HIERARCHICAL ARRAY
%---------------------------------------------------------------

%--
% get parent position
%--

par_pos = get_size_in(par, base.units);

%--
% get some colors
%--

color.control = get(0, 'defaultuicontrolbackgroundcolor');

color.figure = get(0, 'defaultfigurecolor');

% NOTE: slightly darker color than mean

color.line = 0.25 * (color.control + color.figure);

%--
% create toolbar axes
%--

% TODO: add capability for multiple toolbars
	
pos = [ ...
	0, par_pos(4) - base.tool.size, par_pos(3), base.tool.size ...
];

tax = axes( ...
	'parent', par, ...
	'tag', 'HARRAY_TOOLBAR', ...
	'box', 'on', 'xtick', [], 'ytick', [], ...
	'xlim', [0, 1], 'ylim', [0, 1], ...
	'color', color.control, ...
	'xcolor', color.line, ...
	'ycolor', color.control, ...
	'units', base.units, 'position', pos ...
);

%--
% create statusbar axes
%--
	
pos = [ ...
	0, 0, par_pos(3), base.status.size ...
];

sax = axes( ...
	'parent', par, ...
	'tag', 'HARRAY_STATUSBAR', ...
	'box', 'on', 'xtick', [], 'ytick', [], ...
	'xlim', [0, 1], 'ylim', [0, 1], ...
	'color', color.control, ...
	'xcolor', color.line, ...
	'ycolor', color.control, ...
	'units', base.units, 'position', pos ...
);

%--
% create colorbar axes
%--

% NOTE: we use a single colorbar since a figure has a single colormap

pos(1) = par_pos(3) - (base.color.size + base.margin(2));

pos(2) = base.margin(3) + ...
	(base.status.on * base.status.size) + ...
	layout(1).margin(3) ...
; 

pos(3) = base.color.size;

pos(4) = par_pos(4) - ( ...
	base.margin(1) + base.margin(3) + ...
	(base.tool.on * base.tool.size) + (base.status.on * base.status.size) + ...
	layout(1).margin(1) + layout(1).margin(3) ...
);

cax = axes( ...
	'parent', par, ...
	'tag','HARRAY_COLORBAR', ...
	'box', 'on', 'xtick', [], 'ytick', [], ...
	'color', 'none', ...
	'xcolor', color.line, ...
	'ycolor', color.line, ...
	'units', base.units, 'position', pos ...
);

%--
% create base axes
%--

pos(1) = base.margin(4);

pos(2) = base.margin(3) + (base.status.on * base.status.size); 

pos(3) = par_pos(3) - ( ...
	base.margin(2) + base.margin(4) + ...
	(base.color.on * (base.color.size + base.color.pad)) ...
);

pos(4) = par_pos(4) - ( ...
	base.margin(1) + base.margin(3) + ...
	(base.tool.on * base.tool.size) + (base.status.on * base.status.size) ...
);

ax = axes( ...
	'parent', par, ...
	'tag', 'HARRAY_BASE', ...
	'units', base.units, 'position', pos ...
);

h(1) = harray_create;

h(1).level = 0;

h(1).axes = ax;

%--
% create axes for layout levels
%--

for k = 1:length(layout)

	%--
	% find parent axes for this level
	%--
		
	lev = cell2mat({h.level}');
	
	ix = find(lev == (k - 1));
	
	for j = 1:length(ix)
	
		%--
		% compute positions of children relative to this parent
		%--
		
		pos = pos_rel(h(ix(j)).axes, layout(k));
		
		%--
		% create children axes and hierarchical array structures
		%--
		
		% TODO: consider a tagging formalism that uses a layout level, row,
		% and column tags, say LEVEL(ROW,COL)::LEVEL(ROW,COL):: ...
		
		for i2 = 1:layout(k).col.size
			
			%--
			% get column tag string
			%--
			
			if ~isempty(layout(k).col.label)
				col_tag = layout(k).col.label{i2};
			else
				col_tag = '';
			end
			
		for i1 = 1:layout(k).row.size

			%--
			% get row tag string
			%--
			
			if ~isempty(layout(k).row.label)
				row_tag = layout(k).col.label{i1};
			else
				row_tag = '';
			end
			
			%--
			% build tag string
			%--
			
			switch (~isempty(col_tag) + ~isempty(row_tag))
				
				case 0, tag = '';
					
				case 1, tag = [row_tag, col_tag];
					
				case 2, tag = [row_tag, '::', col_tag];
					
			end
			
			%--
			% create axes
			%--

			% NOTE: the max protects us from non-positive width and height
			
			ax = axes( ...
				'parent', par, ...
				'tag', tag, ...
				'box', 'on', ...
				'units', layout(k).units, 'position', max(pos{i1, i2}, eps) ...
			);
		
			%--
			% add created axes to parent's children
			%--

			h(ix(j)).children(i1, i2) = ax;

			%--
			% add new element to harray array
			%--

			h(end + 1) = harray_create;

			h(end).level = k;

			h(end).index = [h(ix(j)).index, i1, i2];

			h(end).axes = ax;
			
			h(end).parent = h(ix(j)).axes;

		end
			
		end
				
	end
	
end

%--
% pad harray indices 
%--

nix = length(h(end).index);

% NOTE: we can break because the index lengths are increasing

for k = 1:length(h)
	
	ixl = length(h(k).index);
	
	if (ixl < nix)
		h(k).index = [h(k).index, zeros(1, nix - ixl)];
	else
		break;
	end
	
end

%--
% store harray data in tagged axes and make these invisible
%--

data.type = 'harray';

data.base = base;

data.layout = layout;

data.harray = h;

set(h(1).axes, ...
	'tag', 'HARRAY_BASE_AXES', ...
	'userdata', data, ...
	'visible', 'off', ...
	'hittest', 'off' ...
);

%--
% set resize function
%--

set(par, ...
	'resizefcn', @harray_resize ...
);

%--
% set tool, status, and color bar visibility
%--

if ~base.tool.on
	harray_toolbar(par, 'off');
end 

if ~base.status.on
	harray_statusbar(par, 'off');
end

if ~base.color.on
	harray_colorbar(par, 'off');
end

%--
% create bar tabs
%--

% TEST CODE: create toggle tab using patch

create_tab(par, 'status');

create_tab(par, 'tool');

%--
% output axes handles
%--

ax = [h.axes]';


%---------------------------------------------------------------
% HARRAY_RESIZE
%---------------------------------------------------------------

function flag = harray_resize(par, eventdata)

% harray_resize - resize function for harray display figures
% ----------------------------------------------------------
%
% flag = harray_resize(par,eventdata)
%
% Input:
% ------
%  par - parent figure handle
%  eventdata - not currently used
%
% Output:
% -------
%  flag - success flag

%--
% get harray data
%--

data = harray_data(par);

base = data.base;

layout = data.layout;

h = data.harray;

%--
% get parent figure size
%--

par_pos = get_size_in(par, base.units);

%--
% resize toolbar axes
%--

pos = [ ...
	0, par_pos(4) - base.tool.size, par_pos(3), base.tool.size ...
];

if ~base.tool.on
	pos(2) = par_pos(4) - 0.1 * pos(4);
end
	
ax = findobj(par, 'tag', 'HARRAY_TOOLBAR');

set(ax, ...
	'units', base.units, 'position', pos ...
);

set_tab_positions(ax, 'tool');

%--
% create status axes
%--

pos = [ ...
	0, 0, par_pos(3), base.status.size ...
];

if ~base.status.on
	pos(2) = -0.8 * pos(4);
end
	
ax = findobj(par, 'tag', 'HARRAY_STATUSBAR');

set(ax, ...
	'units', base.units, 'position', pos ...
);

set_tab_positions(ax, 'status');

%--
% resize colorbar axes
%--

% NOTE: we use a single colorbar since a figure has a single colormap

if base.color.on

	pos(1) = par_pos(3) - (base.color.size + base.margin(2) + layout(1).margin(2));
	
	pos(2) = base.margin(3) + ...
		(base.status.on * base.status.size) + ...
		layout(1).margin(3) ...
	; 

	pos(3) = base.color.size;
	
	pos(4) = par_pos(4) - ( ...
		base.margin(1) + base.margin(3) + ...
		(base.tool.on * base.tool.size) + (base.status.on * base.status.size) + ...
		layout(1).margin(1) + layout(1).margin(3) ...
	);

	set(findobj(par, 'tag', 'HARRAY_COLORBAR'), ...
		'units', base.units, 'position', pos ...
	);

end

%--
% resize base axes
%--

pos(1) = base.margin(4);

pos(2) = base.margin(3) + (base.status.on * base.status.size); 

pos(3) = par_pos(3) - ( ...
	base.margin(2) + base.margin(4) + ...
	(base.color.on * (base.color.size + base.color.pad)) ...
);

pos(4) = par_pos(4) - ( ...
	base.margin(1) + base.margin(3) + ...
	(base.tool.on * base.tool.size) + (base.status.on * base.status.size) ...
);

set(h(1).axes,...
	'units', base.units, 'position', pos ...
);

%--
% resize other axes in a top down way
%--

flag = 1;

for k = 1:length(layout)

	%--
	% find parent axes for this level
	%--
	
	lev = cell2mat({h.level}');
	
	ix = find(lev == (k - 1));
	
	for j = 1:length(ix)
	
		%--
		% compute new positions of children relative to parent
		%--
		
		pos = pos_rel(h(ix(j)).axes, layout(k));
		
		%--
		% update children positions
		%--
		
		for i2 = 1:size(pos, 2)
			
			for i1 = 1:size(pos, 1)

				if (any(pos{i1, i2} <= 0))
					flag = 0;
				end

				% NOTE: the max protects us from non-positive width and height

				set(h(ix(j)).children(i1, i2), ...
					'units', layout(k).units, 'position', max(pos{i1, i2}, eps) ...
				);

			end
			
		end

	end
	
end


%---------------------------------------------------------------
% POS_REL
%---------------------------------------------------------------

% TODO: develop tree based layout descriptions, this function will work

function pos = pos_rel(par, layout)

% pos_rel - compute children positions relative to parent
% -------------------------------------------------------
%
% pos = pos_rel(par,layout)
%
% Input:
% ------
%  par - parent axes
%  layout - children layout
%
% Output:
% -------
%  pos - children positions relative to parent

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

%--
% get size of parent in margin units and update using margins
%--

par_pos = get_size_in(par, layout.units);

par_pos(1:2) = par_pos(1:2) + layout.margin([4, 3]);

par_pos(3) = par_pos(3) - (layout.margin(2) + layout.margin(4));

par_pos(4) = par_pos(4) - (layout.margin(1) + layout.margin(3));

%--
% compute positions of children based on level configuration
%--

% NOTE: even for uniform layouts pad and frac are vectors

dx = (par_pos(3) - sum(layout.col.pad)) .* layout.col.frac;

dy = (par_pos(4) - sum(layout.row.pad)) .* fliplr(layout.row.frac);

for j = 1:layout.col.size
	
	for i = 1:layout.row.size

		pos{i, j} = [ ...
			par_pos(1) + sum(layout.col.pad(1:j - 1)) + sum(dx(1:j - 1)), ...
			par_pos(2) + sum(layout.row.pad(1:i - 1)) + sum(dy(1:i - 1)), ...
			dx(j), dy(i) ...
		];

	end
	
end

pos = flipud(pos);


%---------------------------------------------------------------
% HARRAY_CREATE
%---------------------------------------------------------------

function h = harray_create

% harray_create - create structure for harray elements
% ----------------------------------------------------
%
% h = harray_create

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

h.axes = [];

h.index = [];

% NOTE: a level is stored explicitly for convenience

h.level = [];

% NOTE: the harray elements are linked up and down

h.parent = [];

h.children = [];


%---------------------------------------------------------------
% CREATE_TAB
%---------------------------------------------------------------

function handles = create_tab(par, bar, str)

% create_tab - create tab to attach to bar
% ----------------------------------------
%
% create_tab(par, bar, str)
%
% Input:
% ------
%  par - parent
%  bar - bar
%  str - tab string
%
% Output:
% -------
%  handles - created object handles

%---------------------
% HANDLE INPUT
%---------------------

%--
% set default no string, use marker
%--

if nargin < 3
	str = '';
end

%--
% check bar
%--

bars = {'tool', 'status'};

if ~ismember(bar, bars)
	error('Unrecognized bar.');
end 

%--
% check and get data from parent
%--

data = harray_data(par);

if isempty(data)
	error('Parent does not contain hierarchical arrays.');
end

%--
% get bar handle
%--

switch bar
	
	case 'status', ax = findobj(par, 'tag', 'HARRAY_STATUSBAR');
		
	case 'tool', ax = findobj(par, 'tag', 'HARRAY_TOOLBAR');
		
end

if isempty(ax)
	return;
end

%---------------------
% CREATE TAB
%---------------------

%--
% get bar colors
%--

color.control = get(ax, 'color'); color.line = get(ax, 'xcolor');

%--
% compute tab element positions
%--

[pos, marker] = get_tab_positions(ax, bar);

%--
% tab elements
%--

handles = rectangle( ...
	'tag', 'TOGGLE_TAB', ...
	'position', pos.tab, ...
	'curvature', [0.3 0.6], ...
	'parent', ax, ...
	'edgecolor', color.line, ...
	'facecolor', color.control, ...
	'clipping', 'off' ...
);

set_rectangle_curvature(handles, 10); 

handles(end + 1) = rectangle( ...
	'tag', 'TOGGLE_PATCH', ...
	'position', pos.patch, ...
	'parent', ax, ...
	'edgecolor', 'none', ...
	'facecolor', color.control, ...
	'clipping', 'off' ...
);

%--
% tab symbol
%--

if isempty(str)

	handles(end + 1) = line( ...
		'tag', 'TOGGLE_MARKER', ...
		'parent', ax, ...
		'xdata', pos.marker(1), ...
		'ydata', pos.marker(2), ...
		'clipping', 'off', ...
		'hittest', 'off', ...
		'linestyle', 'none', ...
		'marker', marker, ...
		'markerfacecolor', 'none', ...
		'markeredgecolor', color.line ...
	);

%--
% tab string
%--

else
	
	handles(end + 1) = text(pos.marker(1), pos.marker(2), str, ...
		'parent', ax, ...
		'color', color.line, ...
		'hittest', 'off', ...
		'horizontalalignment', 'center', ...
		'verticalalignment', 'middle' ...
	);

end

%---------------------
% TAB CALLBACK
%---------------------

set(handles(1), 'buttondownfcn', {@tab_callback, par, bar, handles(end)});


%---------------------------------------------------------------
% TAB_CALLBACK
%---------------------------------------------------------------

function tab_callback(obj, eventdata, par, bar, marker)

%--
% check we are using markers
%--

if ~isequal(get(marker, 'type'), 'line')
	marker = 0;
end

%--
% toggle bar display
%--

switch bar

	case 'tool'
		
		state = harray_toolbar(par);

		if marker
			if isequal(state, 'on')
				set(marker, 'marker', '^');
			else
				set(marker, 'marker', 'v');
			end
		end

	case 'status'
		
		state = harray_statusbar(par);

		if marker
			if isequal(state, 'on')
				set(marker, 'marker', 'v');
			else
				set(marker, 'marker', '^');
			end
		end

end


%---------------------------------------------------------------
% GET_TAB_POSITIONS
%---------------------------------------------------------------

function [pos, marker] = get_tab_positions(ax, bar, wide, data)

%--
% handle input
%--

par = ancestor(ax, 'figure');

if nargin < 4
	data = harray_data(par);
end

if nargin < 3
	wide = 2;
end

%--
% get base layout units and size of parent
%--

base = data.base;

par_pos = get_size_in(par, base.units);

%--
% compute tab element positions
%--

% NOTE: the 'patch' position is not for a patch, is functions as a patch

switch bar
	
	case 'status'
		
		width = wide * base.status.size / par_pos(3);
		
		off = 0.49 - width/2;
		
		pos.tab = [off + 0.5 - width/2, 0.5, width, 1.25];
		
		width = 1.5 * width;
		
		pos.patch = [off + 0.5 - width/2, 0.4, width, 0.55];
		
		pos.marker = [off + 0.5, 1.35]; marker = 'v';
		
	case 'tool'
		
		width = wide * base.tool.size / par_pos(3);
		
		off = 0.49 - width/2;
		
		pos.tab = [off + 0.5 - width/2, -0.75, width, 1.25];
		
		width = 1.5 * width;
		
		pos.patch = [off + 0.5 - width/2, 0.0, width, 0.55];
		
		pos.marker = [off + 0.5, -0.35]; marker = '^';
		
end


%---------------------------------------------------------------
% SET_TAB_POSITIONS
%---------------------------------------------------------------

function [pos, marker] = set_tab_positions(ax, bar, wide, data)

%--
% handle input
%--

par = ancestor(ax, 'figure');

if nargin < 4
	data = harray_data(par);
end

if nargin < 3
	wide = 1.75;
end

%--
% get tab positions
%--

[pos, marker] = get_tab_positions(ax, bar, wide, data);

%--
% update tab elements
%--

tab = findobj(ax, 'tag', 'TOGGLE_TAB');

set(tab, ...
	'position', pos.tab ...
);

patch = findobj(ax, 'tag', 'TOGGLE_PATCH');

set(patch, ...
	'position', pos.patch ...
);

marker = findobj(ax, 'tag', 'TOGGLE_MARKER');

set(marker, ...
	'xdata', pos.marker(1), 'ydata', pos.marker(2) ...
);





