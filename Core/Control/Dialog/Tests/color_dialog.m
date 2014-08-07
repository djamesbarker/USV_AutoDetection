function out = color_dialog(name, head, color)

% color_dialog - color selection dialog
% -------------------------------------
%
% out = color_dialog(name, head, color)
%
% Input:
% ------
%  name - dialog name
%  head - header message
%  color - initial color
%
% Output:
% -------
%  out - dialog output structure

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

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set default color
%--

if (nargin < 3) || isempty(color)
	color = [0.25, 0.5, 0.25];
end

%--
% set default head
%--

if (nargin < 2) || isempty(head)
	head = 'Color';
end

%--
% set default name
%--

if (nargin < 1) || isempty(name)
	name = 'Select Color';
end

%----------------------------------
% CREATE CONTROLS
%----------------------------------

%--
% dialog header
%--

control(1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', head ...
);

%--
% color display axes
%--

% NOTE: the number of lines along with the dialog group options produce a square

control(end + 1) = control_create( ...
	'name', 'color', ...
	'style', 'axes', ...
	'label', 0, ...
	'width', 0.55, ...
	'align', 'left', ...
	'space', 1.5, ...
	'lines', 4 ...
);

%--
% color rating
%--

% NOTE: this control style is in development

control(end + 1) = control_create( ...
	'name', 'rating', ...
	'style', 'rating', ...
	'space', 1.5, ...
	'value', 3, ...
	'max', 6 ...
);

%--
% color controls
%--

names = {'red', 'green', 'blue'};

for k = 1:length(names)
	
	control(end + 1) = control_create( ...
		'name',names{k}, ...
		'style','slider', ...
		'min',0, ...
		'max',1, ...
		'value',color(k) ...
	);

end

control(end).space = 2;

% TODO: neither of these properties are currently handled properly

control(end).onload = 1;

% NOTE: this property should be handled using an observer

control(end).active = 1;

%----------------------------------
% CREATE DIALOG
%----------------------------------

%--
% configure dialog options
%--

opt = dialog_group;

opt.width = 9;

%--
% create dialog
%--

out = dialog_group(name, control, opt, @dialog_callback);


%----------------------------------
% DIALOG_CALLBACK
%----------------------------------

function result = dialog_callback(obj, eventdata)

result = [];

[control, par] = get_callback_context(obj); 

switch control.name
	
	case {'red', 'green', 'blue'}
		
		%--
		% update color display
		%--
		
		values = get_control_values(par.handle);
		
		color = values_to_color(values);
		
		color_display(par.handle, color);
		
		%--
		% store color in color display axes control
		%--
		
		control_update([], par.handle, 'color', color);
		
end


%----------------------------------
% VALUES_TO_COLOR
%----------------------------------

function color = values_to_color(values)

color(1) = values.red;

color(2) = values.green;

color(3) = values.blue;


%----------------------------------
% COLOR_DIALOG_CALLBACK
%----------------------------------

function color_display(pal, color)

% color_display - update color display in color dialog
% ----------------------------------------------------
%
% color_display(pal, color)
%
% Input:
% ------
%  pal - palette figure
%  color - color to display

%--
% get color display axes handle
%--

% NOTE: select axes object from axes control handles

ax = findobj(control_update([], pal, 'color'), 'type', 'axes');

%--
% get handle to or create image in color display axes
%--

obj = findobj(pal, 'tag', 'color_image');

if isempty(obj)
		
	obj = image( ...
		'tag', 'color_image', ...
		'parent', ax, ...
		'xdata', [0, 1], ...
		'ydata', [0, 1] ...
	);

	% NOTE: the layer top setting is critical for proper axes display
	
	set(ax, ...
		'layer', 'top', ...
		'xtick', [], ...
		'ytick', [], ...
		'xlim', [0, 1], ...
		'ylim', [0, 1] ...
	);

end

%--
% set image data according to color
%--

% NOTE: we create a one pixel color image, we need to use the third dimension

for k = 1:3
	value(:,:,k) = color(k);
end

set(obj, 'cdata', value);




