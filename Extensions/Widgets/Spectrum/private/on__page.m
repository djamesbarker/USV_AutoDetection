function [handles, context] = on__page(widget, data, parameter, context)

% SPECTRUM - on__page

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

handles = [];

%--
% get handles
%--

ax = spectrum_axes(widget); [center, low, high] = page_line(ax);

%--
% get image data
%--

% TODO: this should be part of the event data

im = data.browser.images;

if iscell(im)
	im = im{1};
end

im = im(1);

X = get(im, 'cdata');

%--
% compute spectrum estimates
%--

[rows, cols] = size(X);

S = sum(X, 2) ./ cols;

D = sqrt(sum((X - S * ones(1, cols)).^2, 2) ./ (cols - 1));

%--
% display lines
%--

grid = linspace(0, 0.5 * data.sound.rate, rows);

set(center, ...
	'xdata', grid, 'ydata', S ...
);

set(low, ...
	'xdata', grid, 'ydata', S - D ...
);

set(high, ...
	'xdata', grid, 'ydata', S + D ...
);


%--
% set spectrum y axis limits according to page
%--

clim = get(data.browser.axes(1), 'clim');

set(ax, 'ylim', clim);

set(ax, 'xlim', data.page.freq);
