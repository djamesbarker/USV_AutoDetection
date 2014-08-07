function [Y,V,c] = rgb_to_eig(X)

% rgb_to_eig - rgb to eigencolor conversion
% -----------------------------------------
%
% [Y,V,c] = rgb_to_eig(X)
%
% Input:
% ------
%  X - rgb image
%
% Output:
% -------
%  Y - eigencolor image
%  V - eigencolor basis
%  c - mean color

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
% get size of input
%--

[m,n,d] = size(X);

if (d ~= 3)
	disp(' ');
	error('Input image does not have three channels.');
end

%--
% make double image
%--

X = double(X);

%--
% subtract mean color
%--

X = rgb_vec(X);
c = mean(X,1);
X = X - ones(m*n,1)*c;

%--
% compute covariance
%--

C = (X' * X) ./ (m * n);

%--
% compute eigencolors
%--

[V,d] = eig_sort(C);
V = V * diag(1 ./ sqrt(d));

%--
% compute eigencolor image
%--

Y = rgb_reshape(X*V,m,n);

%--
% display output if needed
%--

if (1)
	
	%--
	% set mean to gray
	%--
	
% 	c = [128,128,128];
	
	%--
	% set position options for axes array
	%--
	
	p = axes_array;
	p.xspace = 0.025;
	p.yspace = 0.075;
	
% 	%--
% 	% rgb image display
% 	%--
% 	
% 	g = fig;
% 	h = axes_array(2,2,p,g);
% 	
% 	N = {'$ f \dix{R} $','$ f \dix{G} $','$ f \dix{B} $'};
% 	for k = 1:3
% 		axes(h(k + 1));
% 		image_view(X(:,:,k));
% 		title_edit(N{k});
% 	end
% 	
% 	axes(h(1,1)); 
% 	image_view(X);
% 	title_edit('$ f $');
% 		
% 	image_menu(g,'No Ticks');
% 	image_menu(g,'Normal Size');
% 	image_menu(g,'Gray');
	
	%--
	% eigencolor image display (scalar display)
	%--
	
	g = fig;
	h = axes_array(2,2,p,g)';
	
	for k = 1:3
		N{k} = ['$ g \dix{' num2str(k) '}, \,\, \sqrt{\lambda \dix{' num2str(k) '}} \eqw ' num2str(sqrt(d(k))) ' $'];
	end
	
	for k = 1:3
		axes(h(k + 1));
		image_view(Y(:,:,k));
		title_edit(N{k});
	end
	
	axes(h(1,1)); 

	image_view(eig_to_rgb(Y,V,c));
	
	title_edit('$ f $');
		
	image_menu(g,'No Ticks');
	image_menu(g,'Normal Size');
	image_menu(g,'Gray');
	
% 	%--
% 	% eigencolor image decomposition display (rgb display)
% 	%--
% 	
% 	g = fig;
% 	h = axes_array(2,2,p,g)';
% 	
% 	for k = 1:3
% 		N{k} = ['$ g \dix{' num2str(k) '}, \,\, \sqrt{\lambda \dix{' num2str(k) '}} \eqw ' num2str(sqrt(d(k))) ' $'];
% 	end
% 	
% 	for k = 1:3
% 		
% 		axes(h(k + 1));
% 		
% 		tmp = Y;
% 		tmp(:,:,setdiff(1:3,k)) = 0;
% 		tmp = eig_to_rgb(tmp,V,c);
% 		
% 		image_view(tmp);
% 		
% 		title_edit(N{k});
% 		
% 	end
% 	
% 	axes(h(1,1)); 
% 
% 	image_view(eig_to_rgb(Y,V,c));
% 	
% 	title_edit('$ f $');
% 		
% 	image_menu(g,'No Ticks');
% 	image_menu(g,'Normal Size');
% 	image_menu(g,'Gray');
% 	
% 	%--
% 	% eigencolor image channels display (rgb display)
% 	%--
% 	
% 	g = fig;
% 	h = axes_array(2,2,p,g)';
% 	
% % 	for k = 1:3
% % 		N{k} = ['$ g \dix{' num2str(k) '}, \,\, \sqrt{\lambda \dix{' num2str(k) '}} \eqw ' num2str(sqrt(d(k))) ' $'];
% % 	end
% 	
% 	zch = {[2,3],1,3,2};
% 	
% 	for k = 1:4
% 		
% 		axes(h(k));
% 		
% 		tmp = Y;
% 		tmp(:,:,zch{k}) = 0;
% 		tmp = eig_to_rgb(tmp,V,c);
% 		
% 		image_view(tmp);
% 		
% % 		title_edit(N{k});
% 		
% 	end
% 		
% 	image_menu(g,'No Ticks');
% 	image_menu(g,'Normal Size');
% 	image_menu(g,'Gray');
	
end
