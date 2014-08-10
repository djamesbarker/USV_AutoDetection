function [handles, context] = on__page(widget, data, parameter, context)

% HISTOGRAM - on__page

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
% get image data
%--

images = get_image_handles(context.par); 

X = [];

for k = 1:length(images)
	Xk = get(images(1), 'cdata'); X = [X; Xk(:)];
end

%--
% get and clear axes
%--

ax = findobj(widget, 'tag', 'histogram_axes'); cla(ax);

%--
% compute and display histogram
%--

[h, c] = hist_1d(X, 51);

handles = line( ...
	'parent', ax, ...
	'xdata', c, ...
	'ydata', h ...
);
