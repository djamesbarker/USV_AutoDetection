function [X, Y, Z, W] = ocr_test(in, SE, nn, r)

% ocr_test - connected component sieving test
% -------------------------------------------
%
% [X, Y, Z, W] = ocr_test(in, SE, nn, r)
%
% Input:
% ------
%  in - image file
%  SE - structuring element used in dilation
%  nn - number of neighbors used for components
%  r - range of component size to remove
%
% Output:
% -------
%  X - input image
%  Y - clean image
%  Z - removed image
%  W - component images

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

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set range
%--

% NOTE: analysis of the component size distribution can support this decision

if (nargin < 4) || isempty(r)
	r = '[4,4000]';
end

%--
% set number of neighbors
%--

if (nargin < 3) || isempty(nn)
	nn = 8;
end

%--
% set structuring element
%--

% NOTE: more complex connectivity can be used to extract other component types

if (nargin < 2)
	SE = [];
end 

%--
% load image
%--

if (nargin < 1) || isempty(in)
	X = load_gray;
else
	X = load_gray(in);
end

%--
% downsample, and invert
%--

% NOTE: this is specific to large binary black and white image input

X = uint8(~X(1:4:end, 1:4:end));

%-----------------------------------
% COMPUTE
%-----------------------------------

%--
% compute connected components
%--

if isempty(SE)
	Y = comp_label(X, nn);
else
	Y = comp_label(X, SE, nn);
end

%--
% send through sieve
%--

[Z,Y] = comp_sieve(Y, r);

%--
% get some components
%--

[R, C, V] = find(Y); % NOTE: this allows faster component search using only non-zeros

j = 0;

label = unique(Y(find(Y)));

for k = 1:min(length(label), 500)
	
% 	[r,c] = find(Y == label(k));
	
	ix = find(V == label(k)); r = R(ix); c = C(ix);
	
	[r1, r2] = fast_min_max(r); [c1, c2] = fast_min_max(c);
	
	% simple test on enclosing box of component
	
	% another simple test can be based on the aspect ratio
	
	w = (c2 - c1); h = (r2 - r1);
	
	if ((w > 10) & (h > 4))
		
		tmp = X(r1:r2, c1:c2);
		
		% TODO: add simple test on density
		
		% NOTE: some analysis on the density distribution can support this decision
		
		% TODO: also compute centroid of component
		
		d = sum(tmp(:)) / (h * w);
		
% 		if (d > 0.1)

			j = j + 1;

			W(j).image = X(r1:r2, c1:c2);
			W(j).density = d;
			W(j).rows = [r1, r2];
			W(j).cols = [c1, c2];
			
% 		end
		
	end
	
end

if (j == 0)
	W = [];
end

%-----------------------------------
% DISPLAY RESULTS
%-----------------------------------

%--
% input image
%--

fig;

image_view(uint8(~X));
colormap(gray);
axis('image');
title('Input');

% display component boxes

hold on;

for k = 1:length(W);
	if (W(k).density < 0.2)
		draw_box(W(k),[1 0 0]);
	else
		draw_box(W(k),[0 0 1]);
	end
end

zoom on;

%--
% clean image
%--

fig;

image_view(Y);
cmap_label;
axis('image');
title('Clean');


% % display component boxes
% 
% hold on;
% 
% for k = 1:length(W);
% 	if (W(k).density > 0.2)
% 		draw_box(W(k),[1 1 1]);
% 	end
% end

zoom on;

%--
% removed image elements
%--

fig;

image_view(Z);
cmap_label;
axis('image');
title('Removed');

zoom on;

%-----------------------------------
% SUB FUNCTIONS
%-----------------------------------

%-----------------------------------
% DRAW_BOX
%-----------------------------------

function h = draw_box(W,c)

r1 = W.rows(1);
r2 = W.rows(2);

r1 = W.cols(1);
r2 = W.rows(2);

x = [W.cols(1), W.cols(2), W.cols(2), W.cols(1), W.cols(1)];
y = [W.rows(1), W.rows(1), W.rows(2), W.rows(2), W.rows(1)];

h = plot(x,y);

set(h,'color',c);
