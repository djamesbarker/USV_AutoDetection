
% scr_hist_edge_lengths - compute distributions of edge lengths
% -------------------------------------------------------------
%
% Input:
% ------
%  n - size of underlying lattices
%  m - number of graphs to compute
%  b - linking interval for color

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
% compute over watts model
%--

ll = [];
for k = 1:m
	G = watts_example(n,b);
	[L,l] = edge_lengths(G{1}.X,G{2}.E);
	ll = [ll; l];
end

LW = ll;

fig; hist_1d(ll,n + 1)
	

%--
% compute over random function model
%--

ll = [];
for k = 1:m
	G = figueroa_example(n,b);
	[L,l] = edge_lengths(G{1}.X,G{2}.E);
	ll = [ll; l];
end

LF = ll;

fig; hist_1d(ll,n + 1)
