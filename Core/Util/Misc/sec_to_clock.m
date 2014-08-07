function str = sec_to_clock(t,n)

% sec_to_clock - convert seconds to time string
% ---------------------------------------------
%
% str = sec_to_clock(t,n)
%
% Input:
% ------
%  t - time in seconds
%  n - fractional second digits (def: 2)
%
% Output:
% -------
%  str - time string

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
% $Revision: 4794 $
% $Date: 2006-04-25 14:54:27 -0400 (Tue, 25 Apr 2006) $
%--------------------------------

%---------------------------------------------
% MEX COMPUTATION
%---------------------------------------------

%--
% compute clock string using mex
%--

% NOTE: we are not using precision right now

str = sec_to_clock_(t);

%--
% remove trailing zeros if needed
%--

% original XBAT code was < 0.005
% but CRP 2011012 commented this out to preserve up to six decimal zeros
% to keep the time column width consistent

% for k = 1:length(str)
% 	
% 	if (abs(t(k) - floor(t(k))) < 0.005)
% 		str{k}(end - 2:end) = [];
% 	end
% 	
% end

%--
% output string
%--

% NOTE: we output a string for a single time

if (length(str) == 1)
	str = str{1};
end
