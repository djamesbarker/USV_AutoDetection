function Y = lut_log(X,Z)

% lut_log - fast computation of log
% ---------------------------------
%
% Y = lut_log(X,Z)
%
% Input:
% ------
%  X - input image
%  Z - mask image (def: [])
%
% Output:
% -------
%  Y - output image

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
% set mask
%--

if (nargin < 2)
	Z = [];
end

%--
% get limits
%--

c = fast_min_max(X);

%--
% create and apply lut
%--

Y = lut_apply(X,lut_fun('log',c,1024),c,Z);
