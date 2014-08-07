function y = vario_linear(h,c0,b)

% vario_linear - linear variogram model
% -------------------------------------
%
% y = vario_linear(h,c0,b)
%   = vario_linear(h,p)
%
% Input:
% ------
%  h - points of evaluation
%  c0,b - model parameters 
%  p - model parameters (p.c0,p.b)
%
% Output:
% -------
%  g - variogram values
%

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
% unpack parameters
%--

if (nargin < 3)
	b = c0.b;
	c0 = c0.c0;
end

%--
% compute function
%--

y = c0 + (b * h);
