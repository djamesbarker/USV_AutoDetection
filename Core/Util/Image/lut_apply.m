function Y = lut_apply(X,T,b,Z)

% lut_apply - apply look up table
% -------------------------------
% 
% Y = lut_apply(X,T,Z) 
%   = lut_apply(X,T,b,Z) 
%
% Input:
% ------
%  X - index image
%  T - look up table
%  b - lower and upper limits for X lookup (def: min and max of X)
%  Z - mask image (def: [])
%
% Output:
% -------
%  Y - value image

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
% $Date: 2005-02-17 16:38:29 -0500 (Thu, 17 Feb 2005) $
% $Revision: 545 $
%--------------------------------

%--------------------------------------------------
% INTEGER LOOK UP TABLE
%--------------------------------------------------

if (isa(X,'uint8'))
	
	%--
	% check number of arguments
	%--
	
	if (nargin > 3)
		error('Too many input arguments for UINT8 input image.');
	end
	
	%--
	% set default mask if needed
	%--
	
	if (nargin > 2)
		Z = b;
	else
		Z = [];
	end

	%--
	% check table size
	%--
	
	tmp = size(T);
	
	if (min(tmp) > 1)
		disp(' ');
		error('Look up table must be a vector.');
	end
	
	if (max(tmp) ~= 256)
		T((max(tmp) + 1):256) = 0;
	end
	
	%--
	% apply lut using mex
	%--
	
	Y = lut_(X,T,uint8(Z));
	
%--------------------------------------------------
% DOUBLE LOOK UP TABLE
%--------------------------------------------------

elseif (isa(X,'double'))

	%--
	% set default mask if needed
	%--
	
	if (nargin < 4)
		Z = [];
	end
    
	%--
    % set lookup limits if needed
	%--
	
	if ((nargin < 3) || isempty(b))
		b = fast_min_max(X);
	end
	
	%--
	% apply lut using mex
	%--
	
	Y = lut_(X,T,b,uint8(Z));
	
end
