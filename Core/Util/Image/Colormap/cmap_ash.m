function C = cmap_ash(n,f,p)

% cmap_ash - combination of gray and hot colormaps
% ------------------------------------------------
% 
% C = cmap_ash(n,p)
% 
% Input:
% ------
%  n - number of levels (def: 256)
%  p - percentile vector (def: look at code)
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

%--
% set percentile vector
%--

if (nargin < 2)
	p = [0, 0.5:0.1:0.7, 0.75:0.05:0.80, 0.825:0.025:0.90, 0.91:0.01:0.99, 0.995, 1];
end

%--
% set levels
%--

if (nargin < 1)
	n = 256;
end	

%--
% set colormap of current figure
%--

if (~nargout)
	colormap(cmap_ash(n,p));
end

%--
% create colormap
%--

x = linspace(0,1,n)';

C = [sin(f(1)*x + p(1)).^2, sin(f(2)*x + p(2)).^2, sin(f(3)*x + p(3)).^2];

C = C/max(C(:));
