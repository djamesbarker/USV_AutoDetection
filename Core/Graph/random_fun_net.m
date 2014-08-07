function G = random_fun_example(n,b,it,A)

% random_fun_example - lattice and proximity network
% --------------------------------------------------
%
% G = random_fun_example(n,b)
%
% Input:
% ------
%  n - size of lattice (def: 10)
%  b - distance interval for linking (def: '[0.047,0.05]')
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
% set linking interval
%--

if (nargin < 2)
	b = '[0.047,0.05]';
end

%--
% set size of lattice
%--

if (nargin < 1)
	n = 10;
end

%--
% create lattice network
%--

G{1} = graph_lattice(n);
G{1} = jitter_graph(G{1},0.2);

%--
% create proximity network
%--
	
% create spatial covariance

if (it)
	if (nargin < 4)
		V = median_filter(rand(n,n),se_ball(2),it);
	else
		V = median_filter(A,se_ball(3),it);
	end
else
	if (nargin < 4)
		V = rand(n,n);
	else
		V = A;
	end
end

G{2} = graph_distance(V(:)','dist_real',b);

%--
% display graph
%--

if (~nargout)

	fig;
	
	% display lattice
	
	H = scatter(G{1}.X(:,1),G{1}.X(:,2),150,'o');
	
	axis([0, (n + 1), 0, (n + 1)]);
	axis('equal');
	
	set(gca,'visible','off');
	set(gca,'units','normalized','position',[0 0 1 1]);
	
	hold on;
	
	gplot(edge_to_sparse(G{1}.E),G{1}.X,'k:');
		
	% map values to marker colors
	
	for k = 1:length(H)
		set(H(k),'MarkerFaceColor',G{2}.V(k)*ones(1,3));
		set(H(k),'MarkerEdgeColor',zeros(1,3));
	end
	
	set(gcf,'color',[0.9 0.9 0.5]);
	
	% display proximity graph
		
	gplot(edge_to_sparse(G{2}.E),G{1}.X,'r');
	
end



