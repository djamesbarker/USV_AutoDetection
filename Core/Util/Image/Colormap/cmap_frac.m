function C = cmap_frac(n,f,c)

% cmap_frac - fractional colormap
% -------------------------------
%
% C = cmap_frac(n,f,c)
%
% Input:
% ------
%  n - number of levels
%  f - partition of unit interval (def: [0,0.25,0.5,0.75,1])
%  c - colors used for each fraction of interval
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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% set colors for fractions
%--

if ((nargin < 2) | isempty(c))
	c = [ ...
		0.5, 0.1, 0.1; ... 	
		0.9, 0.9, 0.7; ...	
		0.1, 0.5, 0.1 ...
	];
end

%--
% set number of colors
%--

if (nargin < 1)
	n = 256;
end	

%--
% set colormap of current figure
%--

if (~nargout)
	colormap(cmap_frac(n,f,c));
end

%--
% check partition values
%--

if (any(diff(f) < 0))
	error('Interval partition values must be increasing.');	
end

if (~(f(end) - f(1)))
	error('Interval is null.');	
end 

%--
% create colormap
%--
