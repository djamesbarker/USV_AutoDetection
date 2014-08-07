function H = comp_size_sim(p,N,s,nn)

% comp_size_sim - simulate component size distribution
% ----------------------------------------------------
% 
% H = comp_size_sim(p,N,s,nn)
%
% Input:
% ------
%  p - occupation probability grid (def: [0.25, 0.5, 0.75])
%  N - number of simulations (def: 256)
%  s - size of simulation images (def: [128, 128])
%  nn - number of neighbors (def: 8)
%
% Output:
% -------
%  H - component size distributions

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

%-------------------------------------
% HANDLE INPUT
%-------------------------------------

%--
% set number of neighbors
%--

if ((nargin < 4) || isempty(nn))
	nn = 8;
end

%--
% set simulation image size
%--

if ((nargin < 3) || isempty(s))
	s = [128, 128];
end

%--
% set number of simulations per grid point
%--

if ((nargin < 2) || isempty(N))
	N = 256;
end

%--
% set simulation grid
%--

if ((nargin < 1) || isempty(p))
	p = [0.25, 0.5, 0.75];
end

%-------------------------------------
% SIMULATE SIZE DISTRIBUTIONS
%-------------------------------------

% number of pixels

np = prod(s);

%--
% loop over grid points
%--

for k = 1:length(p)
	
	% initialize temporary histogram
	
	h = zeros(1, np + 1);
	
	fig; ax1 = subplot(1, 2, 1); ax2 = subplot(1, 2, 2);
	
	figs_tile;
	
	%--
	% perform simulations at grid points
	%--
	
	for j = 1:N
		
		%--
		% simulate image
		%--
		
		X = uint8(rand(s(1), s(2)) > (1 - p(k)));
		
		%--
		% label image
		%--
		
		L = comp_label(X, nn);
		
		%--
		% display simulation
		%--
		
		axes(ax1); 
		
		imagesc(L); 
		
		title(['P = ' num2str(p(k))]);
		
		axis('image'); 
		
		cmap_label; 
		
		drawnow;
		
		%--
		% compute component size distribution
		%--
		
		M = max(L(:));
		
		count = hist_1d(L, M, [1, M]);
				
		h = h + hist_1d(count, (np + 1), [0, np]);

		%--
		% display results
		%--
		
		axes(ax2); 
		
		loglog(h ./  sum(h),'r.'); 
		
		grid on;
		
		title(['N = ' int2str(j)]);
		
		drawnow;
		
	end
	
end


