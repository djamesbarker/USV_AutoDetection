function Y = image_mist(X,p,r)

% image_mist - probabilistically thin 'binary' image
% --------------------------------------------------
%
% Y = image_mist(X,p)
%
% Input:
% ------
%  X - input binary image
%  p - density for zero
%  r - ratio of one and zero density
%
% Output:
% -------
%  Y - thinned image

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
% $Revision: 1.2 $
% $Date: 2003-07-16 03:46:10-04 $
%--------------------------------

%--
% set default ratio
%--

if ((nargin < 3) | isempty(r))
	r = 2;
else
	if (r < 1)
		disp(' ');
		error('Ratio must be larger than one.');
	end
end

%--
% set default zero density
%--

if ((nargin < 2) | isempty(p))
	p = 0.1;
end

%--
% map image to fixed range
%--

X = lut_range(X,[0,(r - 1) * p]);

%--
% create uniform random image
%--

N = rand(size(X));

%--
% compute thinned image5
%--

Y = double((X + N) > p);
