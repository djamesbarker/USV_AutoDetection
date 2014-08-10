function result = control__callback(callback, context)

% SENSOR_GEOMETRY - control__callback

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

result = [];

%--
% get units and set control labels
%--

units = get_control(callback.pal.handle, 'units', 'value');

control_names = {'x', 'y', 'z'};  

alternate_names = {'latitude', 'longitude', 'altitude'};

switch units{1}
	
	case 'lat-lon'
		
		type = 'global';
		
		for k = 1:length(control_names)
			set_control(callback.pal.handle, control_names{k}, 'label', alternate_names{k});
		end
					
	case 'xyz'
		
		type = 'local';
		
		for k = 1:length(control_names)
			set_control(callback.pal.handle, control_names{k}, 'label', control_names{k});
		end
		
	otherwise
		
end

%--
% get geometry
%--

handles = get_control(callback.pal.handle, 'sensor_geometry', 'handles');

geometry_ax = handles.obj;

geometry = get(geometry_ax, 'userdata');

%--
% get selected channel and reference channel from axes
%--

ch = get_selected_channel(geometry_ax);

ref = get_reference_channel(geometry_ax);

if isempty(ref)
	[ignore, ref] = min(sum(geometry.local.^2, 2));
end

%--
% perform control callback
%--

value = get_control(callback.pal.handle, callback.control.name, 'value');

switch callback.control.name	
	
	case 'units'
		
		set_control(callback.pal.handle, 'ellipsoid', 'enable', strcmp(units{1}, 'lat-lon'));
		
		set_control(callback.pal.handle, 'reference', 'enable', strcmp(units{1}, 'lat-lon'));
		
	case 'channel'
		
		ch = str2num(value{1});
		
		set_selected_channel(geometry_ax, ch);
		
	case 'reference'
		
		if value	
			ref = ch; set_reference_channel(geometry_ax, ch);
		end
	
	case 'x'
		
		geometry.(type)(ch, 1) = str2num(value);
			
	case 'y'
		
		geometry.(type)(ch, 2) = str2num(value);
		
	case 'z'
		
		geometry.(type)(ch, 3) = str2num(value);
			
end

%--
% synchronize geometry and store it in the fishbowl
%--

geometry = sync_geometry(geometry, type, ref);

set(geometry_ax, 'userdata', geometry);

%--
% plot geometry
%--

geometry_plot(geometry.local, callback.pal.handle, geometry_ax, ch, ref);

%--
% update reference indicators
%--

ch = get_selected_channel(geometry_ax); ref = get_reference_channel(geometry_ax);

set_control(callback.pal.handle, 'reference', 'value', ref == ch);

%--
% update position controls
%--		

if ~isempty(ch)
	
	set_control(callback.pal.handle, 'x', 'value', num2str(geometry.(type)(ch, 1)));
	
	set_control(callback.pal.handle, 'y', 'value', num2str(geometry.(type)(ch, 2)));
	
	set_control(callback.pal.handle, 'z', 'value', num2str(geometry.(type)(ch, 3)));
	
end
	

%-----------------------------------
% GET_SELECTED_CHANNEL
%-----------------------------------

function ch = get_selected_channel(ax)

ch = [];

selection = findobj(ax, 'tag', 'SELECT_LINE');

array = findobj(ax, 'tag', 'ARRAY_LINE');

if isempty(get(selection, 'xdata'))
	return;
end

compare = [ ...
	[get(selection, 'xdata') == get(array, 'xdata')] & ...
	[get(selection, 'ydata') == get(array, 'ydata')] ...
];

ch = find(compare, 1, 'first');


%----------------------------------
% SET_SELECTED_CHANNEL
%----------------------------------

function set_selected_channel(ax, ch)

if nargin < 2 
	ch = [];
end

selection = findobj(ax, 'tag', 'SELECT_LINE');

array = findobj(ax, 'tag', 'ARRAY_LINE');

x = get(array, 'xdata'); y = get(array, 'ydata');

set(selection, 'xdata', x(ch), 'ydata', y(ch));


%----------------------------------
% GET_REFERENCE_CHANNEL
%----------------------------------

function ch = get_reference_channel(ax)

ch = [];

array = findobj(ax, 'tag', 'ARRAY_LINE');

ref = findobj(ax, 'tag', 'REFERENCE_LINE');

if isempty(get(ref, 'xdata'))
	return;
end

compare = [ ...
	[get(ref, 'xdata') == get(array, 'xdata')] & ...
	[get(ref, 'ydata') == get(array, 'ydata')] ...
];

ch = find(compare, 1, 'first');

%-----------------------------------
% SET_REFERENCE_CHANNEL
%-----------------------------------

function set_reference_channel(ax, ch)

if nargin < 2 
	ch = [];
end

ref = findobj(ax, 'tag', 'REFERENCE_LINE');

array = findobj(ax, 'tag', 'ARRAY_LINE');

x = get(array, 'xdata'); y = get(array, 'ydata');

set(ref, 'xdata', x(ch), 'ydata', y(ch));
