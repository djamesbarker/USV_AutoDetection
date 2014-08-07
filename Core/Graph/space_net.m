function G = space_example(n,b,d)

% space_example - random proximity network
% ----------------------------------------
%
% G = space_example(n,b,d)
%
% Input:
% ------
%  n - size of lattice
%  b - distance interval for linking (def: '[0,1.1]')
%  d - lattice distortion parameter (def: 0.7)
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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% set default distortion parameter
%--

if ((nargin < 3) || isempty(d))
	d = 0.7;
end

%--
% set default linking interval
%--

if ((nargin < 2) || isempty(b))
	b = '[0,1.1]';
end

%--
% create jittered lattice
%--

G{1} = graph_lattice(n);

G{1} = jitter_graph(G{1},d);
	
%--
% create proximity network
%--
	
G{2} = graph_distance(G{1}.X,'dist_plane',b);

%----------------------------------------
% DISPLAY NETWORK
%----------------------------------------

% TODO: put this into a function

fig;

% display lattice

% H = scatter(G{1}.X(:,1),G{1}.X(:,2),150,'o');

% display proximity graph
	
gplot(edge_to_sparse(G{2}.E),G{1}.X,'r');

hold on;

H = scatter('v6',G{1}.X(:,1),G{1}.X(:,2),64,'o');

axis([0, (n + 1), 0, (n + 1)]);
axis('equal');

set(gca,'visible','off');
set(gca,'units','normalized','position',[0 0 1 1]);

hold on;

[step,comp,branch] = graph_dfs(G{2});

nc = max(comp);

C = hsv(nc);

C = C(randperm(nc),:);

% C = max((C(randperm(nc),:) - 0.1), zeros(nc,3));

for k = 1:n^2
	
	tmp = text(G{1}.X(k,1) + 0.2,G{1}.X(k,2),int2str(step(k)));
	
	set(tmp,'fontsize',7,'color',0.6 * ones(1,3));
	
	if (branch(k) > 0)
		set(H(k),'markersize',12);
	end
	
end

% gplot(edge_to_sparse(G{1}.E),G{1}.X,'k:');


% create gray markers

for k = 1:length(H)
	set(H(k),'MarkerFaceColor',C(comp(k),:));
	set(H(k),'MarkerEdgeColor',ones(1,3));
end

set(gcf,'color',0 * ones(1,3));



