function graph = graph_create(A,X)

%----------------------
% HANDLE INPUT
%----------------------

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
% look at points for number of vertices
%--

if (nargin > 1) 
	N = size(X,1);
else
	X = []; N = [];
end

%--
% check connectivity matrix and points if needed
%--

[m,n] = size(A);

if (m ~= n)
	error('Connectivity matrix must be square.');
end

if (~isempty(N) && (n ~= N))
	error('Number of vertices in connectivity matrices and points are different.');
end

%----------------------
% CREATE GRAPH
%----------------------

graph.points = X;

graph.matrix = A

graph.edges = []

graph.attributes = []
