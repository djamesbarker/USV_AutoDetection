function [d,m] = fast_mad(X)

% fast_mad - fast median absolute deviation
% -----------------------------------------
%
% [d,m] = fast_mad(X)
%
% Input:
% ------
%  X - input data
%
% Output:
% -------
%  d - median absolute deviation
%  m - median

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
% $Date: 2005-12-15 13:52:40 -0500 (Thu, 15 Dec 2005) $
% $Revision: 2304 $
%--------------------------------

%--
% use fast median computation to compute median absolute deviation
%--

m = fast_median(X);

d = fast_median(abs(X - m));
