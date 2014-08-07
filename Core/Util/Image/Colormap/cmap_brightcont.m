function C = cmap_brightcont(map,b,c,r,n)

% cmap_brightcont - brightness and contrast controlled colormap
% -------------------------------------------------------------
%
% C = cmap_brightcont(map,b,c,i,n)
%
% Input:
% ------
%  map - colormap to control
%  b - brightness
%  c - contrast
%  r - reverse
%  n - number of colors
% 
% Output:
% -------
%  C - colormap matrix

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
% set number of colors
%--

if ((nargin < 5) || isempty(n))
	n = 256;
else
	if ((n < 2) || (round(n) ~= n))
		disp(' ');
		error('Number of colors must be integer larger than two.');
	end
end

%--
% set reverse
%--

if ((nargin < 4) || isempty(r))
	r = 0;
end

%--
% set brightness and contrast
%--

if ((nargin < 3) || isempty(c))
	c = 0;
else
	if ((c < 0) || (c > 1))
		disp(' ');
		error('Contrast parameter must be in zero to one range.');
	end
end

if ((nargin < 2) || isempty(b))
	b = 0.5;
else
	if ((b < 0) || (b > 1))
		disp(' ');
		error('Brightness parameter must be in zero to one range.');
	end
end

%--
% set map to control
%--

if ((nargin < 1) || isempty(map))
	map = 'gray';
else
	if (~ischar(map))
		disp(' ');
		error('Map parameter must be a colormap function name string.');
	end 
end

%--
% create colormap using brightness and contrast
%--

if (c == 1)
	
	%--
	% create two color colormap for full contrast
	%--
	
	C = feval(map,2);
	
	if (r)
		C = flipud(C);
	end
	
	n1 = round(b * n);
	n2 = n - n1;
	
	C = [ones(n1,1) * C(1,:); ones(n2,1) * C(2,:)];
	
elseif (c == 0)
	
	%--
	% create 'linear' colormap over range for lowest contrast
	%--
	
	C = feval(map,n);
	
	if (r)
		C = flipud(C);
	end
	
else
	
	%--
	% create 'linear' colormap over limited range for intermediate contrast
	%--
	
	m = round((1 - c) * n);
	
	C = feval(map,m);
	
	if (r)
		C = flipud(C);
	end
	
	n1 = round(b * (n - m));
	n2 = (n - m) - n1;
	
	C = [ones(n1,1) * C(1,:); C; ones(n2,1) * C(end,:)];
	
end

