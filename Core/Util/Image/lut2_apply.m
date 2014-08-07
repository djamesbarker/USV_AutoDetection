function Y = lut2_apply(X1,X2,L,b1,b2,Z)

% lut2_apply - apply two dimensional look up table
% ------------------------------------------------
% 
% Y = lut2_apply(X1,X2,L,Z) 
%   = lut2_apply(X1,X2,L,b1,b2,Z) 
%
% Input:
% ------
%  X1, X2 - index images
%  L - look up table
%  b1 - lower and upper limits for X1 lookup (def: min and max of X1)
%  b2 - lower and upper limits for X2 lookup (def: min and max of X2)
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

%--
% type indicators
%--

t1 = isa(X1,'uint8');
t2 = isa(X2,'uint8');

%--
% compute depensing on index image types
%--

switch (t1 + t2)
	
%--
% double images
%--

case (0)
	
	%--
	% set mask
	%--
	
	if (nargin < 6)
		Z = [];
	end
	
	%--
    % set limits for look up
    %--
	
	if (nargin < 5)
		b2 = fast_min_max(X2);
	end
    
    if (nargin < 4)
		b1 = fast_min_max(X1);
	end
    
	%--
    % ensure table is double
    %--
	
    L = double(L);

	%--
	% apply look up table using mex
	%--
	
	Y = lut2_(X1,X2,L,b1,b2,uint8(Z));
	
%--
% mixed type images
%--

case (1)
	
	%--
	% set mask
	%--
	
	if (nargin < 6)
		Z = [];
	end
	
	%--
    % set limits for look up
    %--
	
	if (nargin < 5)
		b2 = fast_min_max(X2);
	end
    
    if (nargin < 4)
		b1 = fast_min_max(X1);
	end
	
	%--
	% convert uint8 image to double
	%--
	
	if (t1)
		X1 = double(X1);
	else
		X2 = double(X2);
	end
    
	%--
    % ensure table is double
    %--
	
    L = double(L);
	
	%--
	% apply look up table using mex
	%--
	
	Y = lut2_(X1,X2,L,b1,b2,uint8(Z));
	
%--
% uint8 images
%--

case (2)
	
	%--
	% check number of arguments
	%--
	
	if (nargin > 4)
		error('Too many input arguments for UINT8 input images.');
	end
	
	%--
	% set mask
	%--
	
	if (nargin > 3)
		Z = b1;
	else
		Z = [];
	end
	
	%--
	% apply look up table using mex
	%--
	
	Y = lut2_(X1,X2,L,uint8(Z));
	
end
