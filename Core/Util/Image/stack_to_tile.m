function [Y,r,c] = stack_to_tile(X,m,n)

% stack_to_tile - tile stack frames into single image
% ---------------------------------------------------
%
% [Y,r,c] = stack_to_tile(X,m,n)
%         = stack_to_tile(X,t)
% 
% Input:
% ------
%  X - image stack
%  m,n - number of rows and columns 
%  t - type of tiling, row or column 'r' and 'c', horizontal or vertical bias 'h' and 'v'
%
% Output:
% -------
%  Y - image with stack frames tiled
%  r,c - number of rows and columns in tiling

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
% get number of frames
%--

N = length(X);

%--
% default tilings
%--

mn = [1,1; ...
	2,1; ...
	2,2; ...
	2,2; ...
	3,2; ...
	3,2; ...
	3,3; ...
	3,3; ...
	3,3; ...
	4,3; ...
	4,3; ...
	4,3];
	
%--
% set rows and columns
%--

switch (nargin)

	case (1)
	
		maxf = 36;
		
		if (N < 13)
							
			m = mn(N,1);
			n = mn(N,2);
			
		else
				
			sq = [2:sqrt(maxf)].^2;
			sq = sq(find(sq >= nf));
			m = sqrt(sq(1));
			n = m;
		
		end
	
	case (2)
	
		if (isstr(m))
			
			switch (m)
			
				case ('r')
					m = 1;
					n = N;
					
				case ('h')
					m = mn(N,2);
					n = mn(N,1);
					
				case ('v')
					m = mn(N,1);
					n = mn(N,2);
					
				case ('c')
					m = N;
					n = 1;
					
			end
		
		else
		
			if (length(m) == 2)
				n = m(2);
				m = m(1);
			else
				n = m;
			end
			
		end

end 

%--
% rename rows and columns
%--

r = m;
c = n;

%--
% check number of frames
%--

if (r*c < N)
	error('Too many frames for rows and columns');
end

%--
% allocate image
%--

[m,n,d] = size(X{1});

Y = zeros(m*r,n*c,d);

%--
% tile stack frames in image
%--

f = 1;
for k = 0:(r - 1)
for l = 0:(c - 1)
	Y(m*k + 1:m*(k + 1),n*l + 1:n*(l + 1),:) = X{f};
	f = f + 1;
	if (f > N)
		break;
	end
end
end

%--
% display image
%--

if (~nargout)

	h = fig;
	
	image_view(Y);
	
	% plot lines instead of using grid
	
	hold on; 
	
	for k = 1:(r - 1)
		t = plot([0, c*n],[k*m, k*m]);
		set(t,'color',0.5*ones(1,3));
	end
	
	for k = 1:(c - 1)
		t = plot([k*n, k*n],[0, r*m]);
		set(t,'color',0.5*ones(1,3));
	end
	
	hold off;
	
% 	image_grid(-m,-n);

	set(gca,'XTickLabel',[]);
	set(gca,'YTickLabel',[]);
	
% 	set(gca,'GridLineStyle','-');
% 	image_menu(h,'Grid');
	
% 	fig_menu(h,'Tight Bounding Box');
	
end
	
