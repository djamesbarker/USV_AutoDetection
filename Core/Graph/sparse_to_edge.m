function [E,W] = sparse_to_edge(A)

% sparse_to_edge - sparse matrix to edge list representation of graph
% -------------------------------------------------------------------
%
% [E,W] = sparse_to_edge(A)
%
% Input:
% ------
%  A - sparse matrix
%
% Output:
% -------
%  E - vertex edge list
%  W - vertex edge weights

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
% get size of sparse matrix
%--

[m,n] = size(A);

if (m ~= n)
	error('Matrix is not square.');
end

%--
% unweighted graph
%--

if (nargout < 2)
	
	E = cell(n,1);

	for k = 1:n
		E{k} = find(A(k,:));
	end
	
%--
% weighted graph
%--

else
	
	E = cell(n,1); W = cell(n,1);

	for k = 1:n
		[ignore,E{k},W{k}] = find(A(k,:));
	end
	
end













