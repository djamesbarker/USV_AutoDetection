function [step,comp,branch] = graph_dfs(G)

% graph_dfs - depth first search
% ------------------------------
%
% [step,comp] = graph_dfs(G)
%
% Input:
% ------
%  G - graph
%
% Output:
% -------
%  step - depth first search order
%  comp - connected component labels

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

% TODO: create mex version

global DFS_CURR_STEP DFS_STEP DFS_CURR_COMP DFS_COMP DFS_BRANCH;

%--
% get size of graph
%--

n = size(G.E,1); 

%--
% set depth first search and connected component global variables
%--

DFS_CURR_STEP = 1; DFS_STEP = zeros(n,1); 

DFS_CURR_COMP = 1; DFS_COMP = zeros(n,1);

DFS_BRANCH = -1 * ones(n,1);

%--
% perform depth first search and get connected components
%--

for k = 1:n
	
	if (DFS_STEP(k) == 0)
		visit(G,k);
		DFS_CURR_COMP = DFS_CURR_COMP + 1;
	end
	
end
	
%--
% output results
%--

step = DFS_STEP;

comp = DFS_COMP;

branch = DFS_BRANCH;

%--------------------------------------
% VISIT
%--------------------------------------

function visit(G,k)

% visit - visit adjacent vertices recursively
% -------------------------------------------
%
% visit(G,k)
%
% Input:
% ------
%  G - graph
%  k - index of vertex to visit

global DFS_CURR_STEP DFS_STEP DFS_CURR_COMP DFS_COMP DFS_BRANCH;
	
%--
% set and update depth first search order
%--

DFS_STEP(k) = DFS_CURR_STEP;

DFS_CURR_STEP = DFS_CURR_STEP + 1;

%--
% set component label
%--

DFS_COMP(k) = DFS_CURR_COMP;

%--
% visit adjacent vertices
%--

for j = 1:length(G.E{k})
	
	if (DFS_STEP(G.E{k}(j)) == 0)
		
		visit(G,G.E{k}(j));
		DFS_BRANCH(k) = DFS_BRANCH(k) + 1;
		
	end
	
end
