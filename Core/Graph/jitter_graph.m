function H = jitter_graph(G,d)

% jitter_graph - jitter graph positions
% -------------------------------------
% 
% H = jitter_graph(G)
%
% Input:
% ------
%  G - input graph
%  d - distortion parameter (def: 0.1)
%
% Output:
% -------
%  H - graph with jittered positions
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
% set distortion paramerter
%--

if (nargin < 2)
	d = 0.1;
end

%--
% get positions
%--

X = G.X;

%--
% distort positions
%--

X = X + d*(rand(size(X)) - 0.5);

%--
% set positions
%--

G.X = X;

H = G;
