function y = fast_median(X,Z)

% fast_median - fast median value computation
% -------------------------------------------
% 
% y = fast_median(X,Z)
%
% Input:
% ------
%  X - input image
%  Z - computation mask (def: [])
%
% Output:
% -------
%  y - median value

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
% $Revision: 5032 $
% $Date: 2006-05-19 15:45:54 -0400 (Fri, 19 May 2006) $
%--------------------------------

%----------------------
% HANDLE INPUT
%----------------------

%--
% set mask and apply mask if needed
%--

if (nargin < 2)
	Z = [];
end

if (~isempty(Z))
	ix = find(Z); X = X(ix);
end

%--
% consider special cases
%--

% NOTE: this duplicates the functionality of 'median'

if isempty(X) || any(isnan(X))
	y = nan; return;
end

%----------------------
% COMPUTE MEDIAN (MEX)
%----------------------

y = fast_median_(X);
