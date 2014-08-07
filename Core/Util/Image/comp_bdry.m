function [Y, R] = comp_bdry(X, trbl)

% comp_bdry - remove boundary connected components 
% ------------------------------------------------
% 
% [Y, R] = comp_bdry(X, trbl)
%
% Input:
% ------
%  X - label image
%  trbl - remove boundary indicators
%
% Output:
% -------
%  Y - interior component image
%  R - boundary components image

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
% $Date: 2006-06-06 17:29:13 -0400 (Tue, 06 Jun 2006) $
% $Revision: 5169 $
%--------------------------------

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% check for color image
%--

if (ndims(X) > 2)
	error('Color images are not supported.');
end

%--
% set default boundary removal indicator
%--

if (nargin < 2)
	trbl = ones(1,4);
end

%------------------------------
% COMPUTE
%------------------------------

%--
% get labels that are connected to indicated boundaries 
%--

if isempty(trbl)
	
	d = [X(1,:)'; X(:,1); X(:,end); X(end,:)'];

else

	d = [];
	
	if trbl(1) % top
		d = [d; X(1,:)'];
	end
	
	if trbl(2) % right
		d = [d; X(:,end)];
	end
	
	if trbl(3) % bottom
		d = [d; X(end,:)'];
	end
	
	if trbl(4) % left
		d = [d; X(:,1)];
	end
	
end
	
d = unique(d);

%--
% create and apply look-up table to remove boundary components
%--

L = 0:max(X(:)); L(d + 1) = 0;

Y = lut_apply(X, L);

%--
% get boundary components if needed
%--

if (nargout > 1)
	R = X - Y;
end

