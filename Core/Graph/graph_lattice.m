function G = graph_lattice(m,n,t)

% graph_lattice - create lattice graph
% ------------------------------------
%
% G = graph_lattice(m,n,t)
%
% Input:
% ------
%  m - number of rows
%  n - number of columns (def: m)
%  t - type of lattice (def: 'sq')
%    'tri' - triangular
%    'sq' - square 
%    'hex' - hexagonal   
%
% Output:
% -------
%  G - lattice graph
%    .X - locations
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
% set type
%--

if (nargin < 3)
	t = 'sq';
end

%--
% set columns
%--

if (nargin < 2)
	n = m;
end

%--
% create lattice
%--

switch (t)

	%--
	% square
	%--
	
	case 'sq'
	
		%--
		% compute positions
		%--
		
		[X,Y] = meshgrid(1:n,1:m);
				
		%--
		% compute edges
		%--
		
		A = kron(speye(n),tridiag(m,[1,0,1])) | ...
			kron(tridiag(n,[1,0,1]),speye(m));
		
		%--
		% create graph
		%--
		
		G.X = [X(:), Y(:)];
		
		G.E = sparse_to_edge(A);
	
	%--
	% triangular
	%--
	
	case 'tri'
	
		%--
		% compute positions
		%--
		
		h = sqrt(3)/2;
		
		[X,Y] = meshgrid(1:n,1:h:(h*(m + 1)));
		
		S = repmat([zeros(1,n); 1/2*ones(1,n)],[ceil(m/2), 1]);
		S = S(1:m,:);
		
		X = X - S;
		
		x = X(:)';
		y = Y(:)';
		
		X = [x; y];
				
		%--
		% create graph
		%--
				
		G = graph_distance(X,'dist_euclidean','[0.95, 1.05]');

		G.X = G.V';
		
		G.V = [];
		
	%--
	% hexagonal
	%--
	
	case 'hex'
	
		%--
		% compute positions
		%--
		
		%--
		% compute edges
		%--
		
		%--
		% create graph
		%--
		
% 		G.X = 
% 		
% 		G.E = 
		
end
