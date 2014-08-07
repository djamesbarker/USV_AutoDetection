function [g,h] = vario_compute(X,h,b)

% vario_compute - compute empirical variogram
% -------------------------------------------
% 
% [g,h] = vario_compute(X,h,b)
%
% Input:
% ------
%  X - image
%  h - maximum distance to consider
%  b - linking interval
%
% Output:
% -------
%  g - variogram
%  h - grid points

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

flag = 1;

%--
% compute ticks and labels
%--

if (nargin > 2)

	b = parse_interval(b);
	
	if (b(1) == 0);
		tick = [-b(2), 0, b(2)];
		tick_label = {'-b','','b'};
	else
		tick = [-b(2), -b(1), 0, b(1), b(2)];
		tick_label = {'-b','-a','','a','b'};
	end

end
	
%--
% display image
%--

if (flag)
	fig;
	image_view(X);
	image_menu; image_menu(gcf,'Colorbar');
	title_edit('Random Function');
end

%--
% compute variogram
%--

for k = 1:h

	%--
	% get ring and filters
	%--
	
	SE = se_diff(se_ball(k + 0.5),se_ball(k - 0.5));
	
	F = se_filt(SE);
	
	%--
	% compute variogram for this distance
	%--
	
	Y = zeros(size(X));
	
	for j = 1:length(F)
		T = linear_filter(X,F{j});
		Y = Y + T.^2;
	end
	
	g(k) = sum(Y(:)) / (prod(size(X)) * length(F));
	
	%--
	% display difference distribution
	%--
	
	if (flag)
	
		if (rem(k,4) == 1)
			fig;
		end
		
		p = mod(k - 1,4) + 1;
		
		subplot(2,2,p);
		hist_1d(T,101);
		ylabel_edit(['h = ' num2str(k)]);
		title('');
		
		if (nargin > 2)
			set(gca,'XTick',tick);
			set(gca,'XTickLabel',tick_label);
		end
		
	end
	
end

% append 0 assuming no nugget effect

h = 0:h; 
g = [0, g];

%--
% display computed variogram
%--

if (flag)
	fig;
	plot(h,g);
	title_edit('Computed Variogram of Random Function');
end 
