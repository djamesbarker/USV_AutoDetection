function x = fish_grid(n,p)

% fish_grid - create non-uniform grid in unit interval
% ----------------------------------------------------
%
% x = fish_grid(n,p)
%
% Input:
% ------
%  n - number of points in grid
%  p - grid parameters
%
% Output:
% -------
%  x - non-uniform grid points in unit interval

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
% $Date: 2004-12-12 23:59:12 -0500 (Sun, 12 Dec 2004) $
% $Revision: 261 $
%--------------------------------

%--
% set parameters
%--

if ((nargin < 2) | isempty(p))
	p = 2.5;
end

%--
% set number of points
%--

if ((nargin < 1) | isempty(n))
	n = 32;
end

%--
% compute non-uniform grid on unit circle
%--

if (mod(n,2) == 0)
	
	y = linspace(0,1,n/2);
	x = (1 - y).^(1/p) / 2;
	x = [fliplr(x), 1 - x];
	
else
	
	y = linspace(0,1,floor(n/2));
	x = (1 - y).^(1/p) / 2;
	x = [fliplr(x), 0.5, 1 - x];
	
% 	y = linspace(0,1,floor(n/2));
% 	
% 	% parabolic
% 	
% 	x = sqrt(y);
% 	
	% circular
	
% 	x = sqrt(1 - y.^2) ./ 2;
% 	x = [fliplr(x), 0.5, 1 - x];
	
end
	
