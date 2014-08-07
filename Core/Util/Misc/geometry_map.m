function out = geometry_map(geometry, opt)

% geometry_map - display map containing the sensor array
% ------------------------------------------------------
%
% geometry_map(geometry, opt)
%
% opt = geometry_map
%
% Input:
% ------
%  geometry - sound sensor array geometry
%  opt - map display options
%
% Output:
% -------
%  opt - default map display options

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
% set default options
%--

if nargin < 2 || isempty(opt)
	
	opt.marker = 'o';
	
	opt.markersize = 5;
	
	opt.grid = 'on';
	
	opt.min_zoom = 1;
	
	opt.max_zoom = 10^4;
	
	if nargout
		out = opt; return;
	end
	
end

%------------------------------
% CREATE MAP FIGURE
%------------------------------

if (nargin < 3)
	fig_tag = 'MAP_FIGURE';
end

%--
% get figure (singleton)
%--

fig = findobj(0, 'type', 'figure', 'tag', fig_tag);

if isempty(fig)
	
	data.zoom = 2;
	
	fig = figure('tag', fig_tag, 'name', fig_tag);
	
	set(fig, ...
		'windowbuttondownfcn', {@map_zoom, geometry, opt}, ...
		'numbertitle', 'off', ...
		'userdata', data ...
	); 
	
end

map_zoom(fig, [], geometry, opt, 64);


%----------------------------------------------
% MAP_ZOOM
%----------------------------------------------

function map_zoom(obj, eventdata, geometry, opt, zoomfact)

%------------------------------
% SETUP
%------------------------------

%--
% use selection type to determine zoom
%--

type = get(obj, 'SelectionType');

if nargin < 5 || isempty(zoomfact)

	%--
	% left click zooms in, any other kind zooms out
	%--
	
% 	if double_click(obj, .25)
% 		type = 'normal';
% 	end
		
	switch (type)
		
		case ({'normal', 'open'}), zoomfact = 0.5;
			
		case ({'alt', 'extend'}), zoomfact = 2;
			
	end
	
end

data = get(obj, 'userdata');

data.zoom = data.zoom * zoomfact;

if data.zoom > opt.max_zoom
	data.zoom = opt.max_zoom;
elseif data.zoom < opt.min_zoom
	data.zom = opt.min_zoom;
end

[lat, lon] = get_zoom_range(geometry, data.zoom);

clf(obj);

figure(obj);

set(obj, 'userdata', data);

%--
% set text interpreter
%--

interpreter = get(0, 'DefaultTextInterpreter');

% NOTE: this is the default interpreter, use get factory

set(0, 'DefaultTextInterpreter', 'tex');

%------------------------------
% DRAW MAP
%------------------------------

%--
% set up projection
%--

ellipsoid = geometry.ellipsoid;

m_proj('mercator', ...
	'longitude', lon, ...
	'latitude', lat ...
);

%--
% draw bathymetry
%--

if (35 > diff(lon) && diff(lon) > 1) && (35 > diff(lat) && diff(lat) > 1)
	try
		m_tbase('contour', floor(100/sqrt(diff(lat))));
	catch
		m_elev('contour', floor(100/sqrt(diff(lat))));
	end
else
	m_elev('contour', 15);
end

%--
% draw coastline
%--

m_coast('color', [0.3 0.3 0], 'linewidth', 3);

m_grid(...
	'xlabeldir', 'end', ...
	'fontsize', 10 ...
);

m_line(geometry.global(:,2), geometry.global(:,1), ...
	'linestyle', 'none', ...
	'marker', opt.marker, ...
	'markersize', opt.markersize, ...
	'markerfacecolor', [1 1 0], ...
	'markeredgecolor', [0.5 0.5 0.5] ...
);

%--
% set text interpreter
%--

set(0, 'DefaultTextInterpreter', interpreter);

colorbar;

%------------------------------
% HACK MAP
%------------------------------

patches = findobj(gca, 'type', 'patch');

[depth, ix] = sort(cell2mat(get(patches, 'userdata'))); patches = patches(ix);

% color = 
for k = 1:length(patches)
	
end

%-----------------------------------------------
% GET_ZOOM_RANGE
%-----------------------------------------------

function [lat, lon] = get_zoom_range(geometry, zoom)

if nargin < 2 || isempty(zoom)
	zoom = 2;
end

min_max_lon = fast_min_max(geometry.global(:, 2)); 

lon_center = mean(min_max_lon); lon_range = diff(min_max_lon); 

min_max_lat = fast_min_max(geometry.global(:, 1)); 

lat_center = mean(min_max_lat); lat_range = diff(min_max_lat);

vec = [-0.5, 0.5];

lon = lon_center + (zoom * vec * lon_range);

lat = lat_center + (zoom * vec * lon_range);
