function bandwidth = event_bandwidth(event)

% event_bandwidth - get event bandwidth in Hertz
% ----------------------------------------------
%
% bandwidth = event_bandwidth(event)
%
% Input:
% ------
%  event - event array
%
% Output:
% -------
%  bandwidth - event bandwidths

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
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

%--
% allocate and compute bandwidths
%--

bandwidth = zeros(size(event));

for k = 1:numel(event)

	switch (event.level)

		%--
		% simple event
		%--
		
		case (1)
			bandwidth(k) = diff(event.freq);
		
		%--
		% hierarchical event
		%--
		
		otherwise

			% NOTE: bandwidth for composite event is still not defined
			
	end
	
end
