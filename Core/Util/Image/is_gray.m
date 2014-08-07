function t = is_gray(X)

% is_gray - check for grayscale image
% -----------------------------------
%
% t = is_gray(X)
%
% Input:
% ------
%  X - input image
%
% Output:
% -------
%  t - grayscale indicator

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
% check dimensions and positivity
%--

if ((ndims(X) == 2) & ~(any(X(:) < 0)))
	t = 1;
else
	t = 0;
end
