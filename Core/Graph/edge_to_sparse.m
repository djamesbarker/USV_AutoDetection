function A = edge_to_sparse(E,W)

% edge_to_sparse - edge list to sparse matrix representation of graph
% -------------------------------------------------------------------
%
% A = edge_to_sparse(E,W)
%
% Input:
% ------
%  E - vertex edge list
%  W - vertex edge weights
%
% Output:
% -------
%  A - sparse matrix

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--
% set default uniform weights
%--

if (nargin < 2)
	W = [];
end

%--
% get length of edge list and compare with weights
%--

n = length(E);

if (~isempty(W) && (length(W) ~= n))
	error('Vertex edge lists and weights have different lengths.');
end

%--
% create sparse matrix
%--

A = sparse(n,n);

%--
% unweighted graph
%--

if (isempty(W))
	
	for k = 1:n
		if (~isempty(E{k}))
			
			if (any(E{k} > n))
				error('Edge vertex out of range.');
			end
			
			A(k,E{k}) = 1;
			
		end
	end
	
%--
% weighted graph
%--

else
	
	for k = 1:n
		if (~isempty(E{k}))
			
			if (any(E{k} > n))
				error('Vertex edge out of graph range.');
			end
						
			if (length(E{k}) ~= length(W{k}))
				error('Vertex edges and weights have different lengths.');
			end
			
			A(k,E{k}) = W{k};
			
		end
	end
	
end
