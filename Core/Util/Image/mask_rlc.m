function r = mask_rlc(Z)

% mask_rlc - run length code for masks
% ------------------------------------
%
% r = mask_rlc(Z)
%
% Input:
% ------
%  Z - input mask
%
% Output:
% -------
%  r - run length code for input mask

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
% get size of mask and put in column vector form
%--

[m,n] = size(Z);

c = Z(:);

%--
% compute run-length code for mask
%--

r = [m; n; c(1); diff([0; find([diff(c); 1])])];
