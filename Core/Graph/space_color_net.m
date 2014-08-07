function G = space_color_example(n,j,bs,bc)

% space_color_example - random proximity and color network
% --------------------------------------------------------
%
% G = space_color_example(n,j,bs,bc)
%
% Input:
% ------
%  n - size of lattice
%  j - lattice distortion parameter (def: 0.5)
%  bs - distance interval for space linking (def: '[0,1.1]')
%  bc - distance interval for color linking (def: '[0.047,0.05]')
%
% Output:
% -------
%  G - lattice and proximity network
%
%    G{1} - lattice
%      .X - positions
%      .E - edges
%
%    G{2} - lattice
%      .V - values
%      .E - edges
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
% set linking intervals
%--

if (nargin < 4)
	bc = '[0.047,0.05]';
end

if (nargin < 3)
	bs = '[0,1.25]';
end

%--
% set jitter parameter
%--

if (nargin < 2)
	j = 0.5;
end

%--
% create jittered lattice
%--

G{1} = graph_lattice(n);
G{1} = jitter_graph(G{1},j);
	
%--
% create spatial proximity network
%--
	
G{2} = graph_distance(G{1}.X,'dist_plane',bs);

%--
% create color proximity network
%--

G{3} = graph_distance(rand(1,n^2),'dist_real',bc);

%--
% display graph
%--

fig;

% display lattice

H = scatter(G{1}.X(:,1),G{1}.X(:,2),150,'o');

axis([0, (n + 1), 0, (n + 1)]);
axis('equal');

set(gca,'visible','off');
set(gca,'units','normalized','position',[0 0 1 1]);

hold on;

% gplot(edge_to_sparse(G{1}.E),G{1}.X,'k:');

% display spatial proximity graph
	
gplot(edge_to_sparse(G{2}.E),G{1}.X,'k:');

% display color proximity graph
	
gplot(edge_to_sparse(G{3}.E),G{1}.X,'r');

% map values to marker colors

for k = 1:length(H)
	set(H(k),'MarkerFaceColor',G{3}.V(k)*ones(1,3));
	set(H(k),'MarkerEdgeColor',zeros(1,3));
end

set(gcf,'color',[0.9 0.9 0.5]);



