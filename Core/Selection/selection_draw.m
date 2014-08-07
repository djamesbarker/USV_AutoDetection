function handles = selection_draw(ax, sel, opt, update)

% selection_draw - draw selection on axes
% ---------------------------------------
%
% handles = selection_draw(ax, sel, opt, update)
%
% Input:
% ------
%  ax - axes
%  sel - selection
%  opt - selection options
%
% Output:
% -------
%  handles - selection object handles

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
% HANDLE INPUT
%---------------------------

%--
% set default update
%--

if (nargin < 4) || isempty(update)
	update = 1;
end

%--
% set default options
%--

if (nargin < 3) || isempty(opt)
	opt = get_axes_selection_options(ax); store = [];
else
	store = opt;
end

%---------------------------
% SETUP
%---------------------------

%--
% get selection handles or delete and clear handles based on update
%-- 

updating = update && isfield(sel, 'handles');

if updating
	handles = sel.handles;
else
	selection_delete(ax, sel); handles = selection_handles;
end

%--
% get selection object coordinates
%--

[x, y] = selection_coords('all', sel, ax);

%---------------------------
% DRAW SELECTION
%---------------------------

%-------------
% GRIDS
%-------------

if opt.grid.on
	
	%--
	% x grid
	%--
	
	if opt.grid.x.on

		if isempty(handles.grid.x)
			handles.grid.x = line( ...
				'parent', ax, ...
				'hittest', 'off' ...
			);
		end
		
		set(handles.grid.x, ...
			'tag', sel.tag, ...
			'xdata', x.grid.x, ...
			'ydata', y.grid.x, ...
			'linestyle', opt.grid.linestyle, ...
			'marker', 'none', ...
			'color', opt.grid.color ...
		);

		uistack(handles.grid.x, 'bottom');
		
	end

	%--
	% y grid
	%--
	
	if opt.grid.y.on	

		if isempty(handles.grid.y)
			handles.grid.y = line( ...
				'parent', ax, ...
				'hittest', 'off' ...
			);
		end
		
		set(handles.grid.y, ...
			'tag', sel.tag, ...
			'xdata', x.grid.y, ...
			'ydata', y.grid.y, ...
			'linestyle', opt.grid.linestyle, ...
			'marker', 'none', ...
			'color', opt.grid.color ...
		);

		uistack(handles.grid.y, 'bottom');
		
	end

end

%-------------
% PATCH
%-------------

%--
% selection patch
%--

if isempty(handles.patch)
	handles.patch = patch( ...
		'parent', ax ...
	);
end

set(handles.patch, ...
	'parent', ax, ...
	'tag', sel.tag, ...
	'xdata', x.patch, ...
	'ydata', y.patch, ...
	'linestyle', opt.linestyle, ...
	'facecolor', 'none', ...
	'edgecolor', opt.color ...
);

uistack(handles.patch, 'top');

% TEST: alpha does not work properly

if opt.alpha
	set(handles.patch, ...
		'facecolor', opt.color, ...
		'facealpha', opt.alpha ...
	); 
end

% NOTE: this should not be done for all selections

set_renderer(ax, opt);

%-------------
% CONTROLS
%-------------

%--
% control points
%--

if opt.control.on
		
	%--
	% perimeter control points
	%--
	
	if isempty(handles.control)
		
		for k = 1:(8 + opt.center.on)
			handles.control(end + 1) = line( ...
				'parent', ax ...
			);
		end
		
	end
	
	for k = 1:8
		
		set(handles.control(k), ...
			'tag', sel.tag, ...
			'xdata', x.control(k), ...
			'ydata', y.control(k), ...
			'linestyle', 'none', ...
			'marker', opt.control.marker, ...
			'markersize', opt.markersize, ...
			'color', opt.color, ...
			'userdata', k ...
		);
	
	end 
	
	%--
	% center control point
	%--

	if opt.center.on

		k = 9;

		set(handles.control(k), ...
			'parent', ax, ...
			'tag', sel.tag, ...
			'xdata', x.control(k), ...
			'ydata', y.control(k), ...
			'linestyle', 'none', ...
			'marker', opt.center.marker, ...
			'markersize', opt.markersize, ...
			'color', opt.color, ...
			'userdata', k ...
		);

	end
	
	uistack(handles.control, 'top');
	
end

%---------------------------
% CALLBACKS AND STATE
%---------------------------

%--
% pack handles in selection
%--

sel.handles = handles;

%--
% set patch callback
%--
	
sel.handles.obj = handles.patch;

set(handles.patch, 'buttondownfcn', {@selection_patch_callback, sel, store});

%--
% set control point edit callbacks
%--

for k = 1:length(handles.control)
	
	sel.handles.obj = handles.control(k);
	
	set(handles.control(k), ...
		'buttondownfcn', {@selection_edit_callback, 'start', sel, store} ...
	);

end

%---------------------------
% SET_RENDERER
%---------------------------

function set_renderer(ax, opt)

par = get(ax, 'parent');

if opt.alpha
	renderer = 'opengl';
else
	renderer = 'painters';
end

set(par, 'renderer', renderer);


