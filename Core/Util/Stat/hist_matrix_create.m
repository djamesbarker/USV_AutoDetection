function data = hist_matrix_create

% hist_matrix_create - create histogram matrix display structure
% --------------------------------------------------------------
%
% data = hist_matrix_create
%
% Output:
% -------
%  data - histogram matrix display structure

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
% data and variable names
%--

data.data = [];
data.names = [];

%--
% data related parameters
%--

data.bins = [];
data.bounds = [];
data.mask = [];

%--
% histogram computation and display parameters
%--

data.counts = []; 
data.centers = [];
data.breaks = [];

histogram.view = 1;
histogram.color = color_to_rgb('Gray');
histogram.linestyle = 'Solid';
histogram.linewidth = 1;
histogram.patch = -1;

data.histogram = histogram;
	
%--
% kernel computation and display options
%--

kernel.length = 1/8;
kernel.type = 'Tukey';

kernel.view = 1;
kernel.color = color_to_rgb('Dark Gray');
kernel.linestyle = 'Dash';
kernel.linewidth = 2;
kernel.patch = -1;

data.kernel = kernel;

%--
% fit computation and display options
%--

fit.model = 'Generalized Gaussian';

fit.view = 0;
fit.color = color_to_rgb('Red');
fit.linestyle = 'Solid';
fit.linewidth = 2;
fit.patch = -1;

data.fit = fit;

%--
% displayed axes handles and options
%--

data.axes = [];

grid.on = 0;
grid.color = color_to_rgb('Dark Gray');
grid.x = 1;
grid.y = 1;

data.grid = grid;

%--
% displayed image handles and options
%--

data.images = [];

data.colormap = 'Bone';
