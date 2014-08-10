function [handles, context] = on__page(widget, data, parameter, context)

% SIMILARITY MATRIX - on__page

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
% get display axes
%--

ax = similarity_matrix_axes(widget);

if isempty(ax)
	return;
end

%--
% compute similarity matrix
%--

% NOTE: this way of getting the spectrogram images will change

images = data.browser.images;

for k = 1:length(images)
	X{k} = get(images(k), 'cdata');
end

% NOTE: for now we only use the first channel

X = X{1}; 

X = normalize_dim(X, 1);

% NOTE: the simple transpose is a conjugate transpose

S = X' * X;

%--
% display matrix
%--

time = [data.page.start, data.page.start + data.page.duration];

im = findobj(ax, 'tag', 'image');

if isempty(im) 
	im = imagesc(time, time, S, 'parent', ax);
else
	set(im, ...
		'cdata', S, ...
		'xdata', time, ...
		'ydata', time ...
	);
end

set(im, 'tag', 'image');

set(ax, ...
	'xlim', time, ...
	'ylim', time, ...
	'tag', 'similarity_matrix_axes' ...
);


delete(get_cursor(ax, 1)); delete(get_cursor(ax, 2));
