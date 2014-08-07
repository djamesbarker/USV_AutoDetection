function C = cmap_pseudo(n,f,p)

% cmap_pseudo - pseudo color colormap
% -----------------------------------
% 
% C = cmap_pseudo(n,f,p)
% 
% Input:
% ------
%  n - number of levels (def: 256)
%  f - frequencies for colors (def: 2*pi*[0.4, 0.5, 0.6])
%  p - phase shifts for colors (def: [0, 0, 0])
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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% set phase shifts
%--

if (nargin < 3)
	p = 2*pi*[0, 0, 0];
end

%--
% set frequencies
%--

if (nargin < 2)
	f = 2*pi*[0.4, 0.47, 0.55];
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
	colormap(cmap_pseudo(n,f,p));
end

%--
% create colormap
%--

x = linspace(0,1,n)';

C = [sin(f(1)*x + p(1)).^2, sin(f(2)*x + p(2)).^2, sin(f(3)*x + p(3)).^2];

C = C/max(C(:));
