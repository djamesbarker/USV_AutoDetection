function g = heap_plot(h)

% heap_plot - plot heap contents
% ------------------------------
%
% g = heap_plot(h)
%
% Input:
% ------
%  h - heap vector
%
% Output:
% -------
%  g - handle to figure

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

%-------------------------------
% SETUP
%-------------------------------

%--
% compute length and depth of tree
%--

n = length(h);

d = ceil(log2(n)) + 1;

%--
% compute vertex positions for full tree
%--

for k = d:-1:0
	
	% some scaling should improve the displays
	
	%--
	% positions in x
	%--
	
	x{k + 1} = linspace(-2^d, 2^d, 2^k + 2);
	x{k + 1} = x{k + 1}(2:end - 1);
	
	%--
	% positions in y
	%--
	
	y{k + 1} = -k * ones(size(x{k + 1}));
	
end

%--
% put positions into row format and prune to include only part of tree
%--

pos = [];

for k = 1:d
	pos = [pos; x{k}(:) y{k}(:)];
end

pos = pos(1:n,:);

%--
% create adjacency matrix for full tree
%--

A = sparse(n,n);

for k = 1:n
	
	tmp = bitshift(k,1);
	
	A(k,tmp:(tmp + 1)) = 1;
	A(tmp:(tmp + 1),k) = 1;
	
end

%--
% prune to include only part of tree
%--

A = A(1:n,1:n);

%-------------------------------
% DISPLAY
%-------------------------------

% reconsider creation of figure

fig;

set(gcf,'color',0 * ones(1,3));

%--
% display tree edges with the help of gplot
%--

[ex,ey] = gplot(A,pos);

edges = plot(ex,ey,'r');

%--
% set axes properties
%--

hold on;

set(gca,'visible','off');

%--
% display vertices using scatter
%--

vertex = scatter(pos(:,1),pos(:,2),49,'o');

set(vertex, ...
	'markeredgecolor',ones(1,3), ...
	'markerfacecolor',0.5 * ones(1,3) ...
);

%--
% display keys using text
%--

for k = 1:n
	
	switch (class(h))
		
		case ('double')	
			tmp = text(pos(k,1) + 1,pos(k,2),num2str(h(k)));
			set(tmp,'fontsize',7,'color',0.9 * [1 1 0]);
			
		case ('char')
			tmp = text(pos(k,1) + 1.5,pos(k,2),h(k));
			set(tmp,'fontsize',11,'color',0.9 * [1 1 0]);
			
	end
		
end
