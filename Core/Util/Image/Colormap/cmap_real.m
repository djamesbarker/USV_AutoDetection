function C = cmap_real(n,c,b)

% cmap_real - colormap for real valued data
% -----------------------------------------
%
% C = cmap_real(n,c,b)
%
% Input:
% ------
%  n - number of levels (def: 256)
%  c - negative, neutral, and positive color
%  b - bounds for display (def: extreme values)
%
% Output:
% -------
%  C - colormap

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
% $Date: 2005-01-28 14:19:39 -0500 (Fri, 28 Jan 2005) $
% $Revision: 477 $
%--------------------------------

%--
% set bounds
%--

if (nargin < 3)

	%--
	% get image
	%--
	
	h = findobj(gcf,'type','image');

	for k = length(h):-1:1
		if (strcmp(get(h(k),'tag'),'TMW_COLORBAR'))
			h(k) = [];
		end
	end
	
	if isempty(h)
		error('Current figure does not contain image.');
	end

	%--
	% get extreme values of image data
	%--
	
	j = 1;
	for k = 1:length(h)
		tmp = get(h(k),'CData');
		if (ndims(tmp) < 3)
			b(j,:) = fast_min_max(get(h(k),'CData'));
			j = j + 1;
		end
	end
	b = fast_min_max(b);
	
	for k = 1:length(h)
		set(get(h(k),'parent'),'clim',b);
	end

end

%--
% set negative, neutral, and positive colors
%--

if ((nargin < 2) || isempty(c))
	
	% red-green view
	
% 	c = [ ...
% 		0.5, 0.1, 0.1; ... 	
% 		0.9, 0.9, 0.7; ...	
% 		0.1, 0.5, 0.1 ...
% 	];

	c = [ ...
		0.1, 0.1, 0.7; ... 	% 0.1, 0.3, 0.7; ... 	
		1 ,1, 0.97; ...	
		0.0, 0, 0.0 ...
	];

	% island view
	
% 	c = [ ...	
% 		1, 1, 0; ...	
% 		0.5, 0.8, .9; ... 
% 		0.0, 0.0, 0.0 ...
% 	];

end

%--
% set number of colors
%--

if (nargin < 1)
	n = 256;
% 	n = 129;
end	

%--
% set colormap of current figure
%--

if (~nargout)
	colormap(cmap_real(n,c,b));
end

%--
% check b
%--

if (b(2) < b(1))
	error('Bound values must be increasing.');	
elseif (all(b == 0))
	error('Bounds are zero.');	
end 

%--
% gamma ??
%--

g = 0.5;

%--
% strictly positive data
%--

if (all(b > eps))

	p = round(((b(2) - b(1)) / b(2)) * n);
	x = linspace(0,1,n + p)';
	
	% C = (x.^g)*c(2,:);
	C = (x.^g)*c(3,:) + (1 - (x.^g))*c(2,:);
	
	C = C((p + 1):end,:);

%--
% data with zero as a limit
%--

elseif (any(b == 0))

	if (b(1) == 0)	
	
		x = linspace(0,1,n)';
		
		% C = (x.^g)*c(2,:);
		C = (x.^g)*c(3,:) + (1 - (x.^g))*c(2,:);
				
	else
		
		x = linspace(0,1,n)';
		
		% C = (x.^g)*c(1,:);
		C = (x.^g)*c(1,:) + (1 - (x.^g))*c(2,:);
		
		C = flipud(C);
				
	end

%--
% strictly negative data
%--

elseif (all(b < -eps))

	p = round(((b(1) - b(2)) / b(2)) * n);
	x = linspace(0,1,n + p)';
	
	% C = (x.^g)*c(1,:);
	C = (x.^g)*c(1,:) + (1 - (x.^g))*c(2,:);
	
	C = C(p+1:end,:);
	C = flipud(C);

%--
% positive and negative data
%--

else

	r = b(1) / (b(1) - b(2));
	nlen = round(r * n);
	plen = n - nlen;
	
	if (nlen >= plen)	
		x = linspace(0,1,nlen)';
		
		% Cn = (x.^g)*c(1,:);
		Cn = (x.^g)*c(1,:) + (1 - (x.^g))*c(2,:);
		
		Cn = flipud(Cn);
		
		% Cp = (x.^g)*c(2,:);
		Cp = (x.^g)*c(3,:) + (1 - (x.^g))*c(2,:);
		
		C = [Cn; Cp(2:plen,:)];		
	else	
	
		x = linspace(0,1,plen)';
		
		% Cn = (x.^g)*c(1,:);
		Cn = (x.^g)*c(1,:) + (1 - (x.^g))*c(2,:);
		
		Cn = flipud(Cn(1:nlen,:));
		
		% Cp = (x.^g)*c(2,:);
		Cp = (x.^g)*c(3,:) + (1 - (x.^g))*c(2,:);
		
		C = [Cn; Cp(2:end,:)];
	end 

end
