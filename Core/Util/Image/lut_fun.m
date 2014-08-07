function [T,b] = lut_fun(f,b,N,p)

% lut_fun - create a look up table for a function
% -----------------------------------------------
%
% [T,b] = lut_fun(f,b,N,p)
%
% Input:
% ------
%  f - function name, inline function, or function handle to evaluate
%  b - lower and upper limits for look up
%  N - size of look up table (def: 256)
%  p - function specific parameters
%
% Output:
% -------
%  T - look up table
%  b - lower and upper limits for look up

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
% $Date: 2004-12-12 23:04:02 -0500 (Sun, 12 Dec 2004) $
% $Revision: 252 $
%--------------------------------

%-----------------------------
% HANDLE INPUT
%-----------------------------

%--
% set default size of table
%--

% NOTE: this table length can be slightly faster for uint8 valued images

if (nargin < 3)
	N = 256;
end

%-----------------------------
% CREATE TABLE
%-----------------------------

%--
% create grid points
%--

x = linspace(b(1),b(2),N);

%--
% compute function on table grid
%--

% NOTE: this function may now take function handles as well

if (nargin > 3)
	T = feval(f,x,p);
else
	T = feval(f,x);
end

