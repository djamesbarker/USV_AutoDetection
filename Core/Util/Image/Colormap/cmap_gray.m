function C = cmap_gray(n,b,c)

% cmap_gray - brightness and contrast controlled gray colormap
% ------------------------------------------------------------
%
% C = cmap_gray(n,b,c)
%
% Input:
% ------
%  n - number of colors
%  b - brightness
%  c - contrast
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
% set brightness and contrast
%--

if (nargin < 3)
	c = 0;
end

if (nargin < 2)
	b = 0.5;
end

%--
% set number of colors
%--

if (nargin < 1)
	n = 256;
end

%--
% create colormap
%--

if (c == 1)
	
	%--
	% black and white colormap
	%--
	
	n1 = round(b * n);
	n2 = n - n1;
	C = [zeros(n1,3); ones(n2,3)];
	
elseif (c == 0)
	
	%--
	% linear colormap over all range
	%--
	
	C = gray(n);
	
else
	
	%--
	% linear colormap over limited range
	%--
	
	m = round((1 - c) * n); % length of range of variation
	C = gray(m);
	
	n1 = round(b * (n - m));
	n2 = (n - m) - n1;
	
	C = [zeros(n1,3); C; ones(n2,3)];
	
end

