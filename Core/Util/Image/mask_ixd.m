function Z = mask_ixd(ix)

% mask_ixd - decode mask index code
% ---------------------------------
%
% Z = mask_ixd(ix)
%
% Input:
% ------
%  ix - index code for mask
%
% Output:
% -------
%  Z - mask image

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
% allocate mask
%--

m = ix(1,1);
n = ix(1,2);

Z = zeros(m,n);

%--
% fill mask using code
%--

j = ix(2:end,1) + m*(ix(2:end,2) - 1);

Z(j) = 1;
