function duration = event_duration(event)

% event_duration - get event duration in seconds
% ----------------------------------------------
%
% duration = event_duration(event)
%
% Input:
% ------
%  event - event array
%
% Output:
% -------
%  duration - event durations

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

% TODO: implement event array case using 'struct_field'

% NOTE: the duration of a composite event should be set once?, think groups and containers

%--
% allocate and compute durations
%--

duration = zeros(size(event));

for k = 1:numel(event)

	switch (event.level)

		%--
		% simple event
		%--
		
		case (1)
			duration(k) = diff(event.time);
		
		%--
		% hierarchical event
		%--
		
		otherwise

			% NOTE: duration for composite event is still not defined
			
	end
	
end
