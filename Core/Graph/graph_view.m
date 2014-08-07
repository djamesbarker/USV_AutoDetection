function h = view_graph(G,H)

% view_graph - display graph
% --------------------------
%
% h = view_graph(G,H)
%
% Input:
% ------
%  G,H - graphs
%
% Output:
% -------
%  h - handles to scattered vertices
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
% display spatial graph
%--

	%--
	% scatter plot of vertices
	%--
	
	if (nargin > 1)
		h = scatter(G.X(:,1),G.X(:,2),150,'o');
	else
		h = scatter(G.X(:,1),G.X(:,2),100,'o','filled');
	end
	
	hold on;
	
	%--
	% plot edges
	%--
	
	gplot(edge_to_sparse(G.E),G.X,'k:');
	
%--
% display non-spatial graph
%--

if (nargin > 1)
	
	%--
	% color vertices using scalar attribute
	%--
	
	for k = 1:length(h)
		set(h(k),'MarkerFaceColor',H.V(k)*ones(1,3));
		set(h(k),'MarkerEdgeColor',zeros(1,3));
	end
	
	%--
	% plot edges
	%--
	
	gplot(edge_to_sparse(H.E),G.X,'r');

end

%--
% set axes and figure properties
%--

axis('equal');

set(gca,'visible','off');
% set(gca,'units','normalized','position',[0 0 1 1]);

set(gcf,'color',[0.9 0.9 0.5]);


