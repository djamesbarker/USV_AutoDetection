function h = colormap_bar(g)

% colormap_bar - create colormap choice toolbar
% ---------------------------------------------
%
% h = colormap_bar(g)
%
% Input:
% ------
%  g - handle to figure to control (def: gcf)
%
% Output:
% -------
%  h - handle to toolbar figure

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
% $Date: 2003-07-06 13:36:51-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% set figure to control
%--

if (nargin < 1)
	g = gcf;
end

%--
% add image_menu to controlled figure
%--

figure(g); image_menu;

%--
% create toolbar
%--

h = figure;

L = { ...
	'Grayscale', ''; ...
	'Real', 'Real Options ...'; ...
	'Bone', 'Copper'; ...
	'Pink', 'Hot'; ...
	'HSV', 'Jet' ...
};

T = { ...
	'Grayscale colormap', ''; ...
	'Colormap for display of positive and negative values', 'Set colors for negative, zero, and positive values'; ...
	'Grayscale with a tinge of blue', 'Copper tone colormap'; ...
	'Grayscale with a tinge of pink', 'Black, red, yellow, white colormap'; ...
	'Hue, saturation, value colormap', 'Variant of HSV' ...
};

button_group(h, ...
	'image_menu', ...
	'Colormap', ...
	L,[],[],g,T);

%--
% close toolbar when controlled figure is closed
%--

close_fun = get(g,'CloseRequestFcn');
set(g,'CloseRequestFcn',['delete(' num2str(h) '); ' close_fun]);
