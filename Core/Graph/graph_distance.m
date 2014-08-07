function G = graph_distance(V,fun,b)

% graph_distance - create distance graph
% --------------------------------------
%
% G = graph_distance(V,fun,b)
%
% Input:
% ------
%  V - values
%  fun - distance function
%  b - distance linking activity interval
%
% Output:
% -------
%  G - distance network
%    .V - values
%    .E - edges
%

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
% set values
%--

G.V = V;

%--
% compute distance matrix
%--

D = feval(fun,V,V);

%--
% threshold using activity interval graph
%--

A = thresh(D,b);

%--
% set graph
%--

G.E = sparse_to_edge(A);




