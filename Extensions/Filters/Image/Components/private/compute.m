function [Y, context] = compute(X, parameter, context)

% COMPONENTS - compute

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

%-------------------------------------
% THRESHOLD IMAGE
%-------------------------------------

% TODO: add edge enhancement options, and thresholding options

%--
% enhance horizontal edges
%--

% F = ones(3, 1) * [-1 -1 -1 0 1 1 1];

F = filt_binomial(3, 2 * parameter.edge_scale + 1, [0, 1]);

Y = linear_filter(X, F);

Y = circshift(Y, [0, parameter.edge_scale]);

% Y = morph_tophat(X, ones(11), 1);

% par = get_active_browser();
% 
% ext = get_browser_extension('image_filter', par, 'x_edge');
% 
% fun = ext.fun.compute;
% 
% Y = fun(X, ext.parameter);

%--
% select top percentile of edge image
%--

Y = uint8(Y > fast_rank(Y, -(parameter.edge_percent / 100)));

%-------------------------------------
% PROCESS BINARY IMAGE
%-------------------------------------

%--
% close small holes in image
%--

SE = ones(3); 

SE([1, 3, 7, 9]) = 0;

Y = morph_close(Y, SE);

%-------------------------------------
% COMPONENT PROCESSING
%-------------------------------------

%--
% label components
%--

L = comp_label(Y, parameter.neighbors);

% L = comp_label(Y, SE, parameter.neighbors);

%--
% sieve components using size
%--

% TODO: compute based on context, consider a time-frequency square

L = comp_sieve(L, '[1,25]');

small = fast_rank(get_comp_sizes(L), parameter.component_percent / 100);

Y = comp_sieve(L, ['[1,' int2str(small), ']']);

%--
% remove boundary components
%--

% NOTE: top and bottom are reversed

trbl = zeros(1,4); trbl(1) = 1;

Y = comp_bdry(Y, trbl);


