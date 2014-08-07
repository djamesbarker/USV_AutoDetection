function pause_frac(t)

% pause_frac - more accurate pause function
% -----------------------------------------
%
% pause_frac(t)
%
% Input:
% ------
%  t - time in seconds

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
% $Revision: 1.0 $
% $Date: 2003-07-06 13:36:07-04 $
%--------------------------------

pause(t);

return;

% NOTE: this code was last tested on version 6

%--
% set global variable
%--

global PAUSE_FRAC_LOOP;

if (isempty(PAUSE_FRAC_LOOP))

	tic;
	for k = 1:10^4
		exp(pi);
	end
	t = toc;
	
	PAUSE_FRAC_LOOP = (10^4)/t;
	
end

%--
% separate whole and fractional seconds
%--

if (t >= 0)
	n = floor(t);
	f = t - n;
else
	n = 0;
	f = -1;
end

%--
% pause for full seconds and fraction
%--

if (n)
	pause(n);
end

if (f >= 0)
	for k = 1:floor(f * PAUSE_FRAC_LOOP)
		exp(pi);
	end
else
	pause;
end
