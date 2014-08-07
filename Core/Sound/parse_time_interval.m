function interval = parse_time_interval(str)

% parse_time_interval - parse an interval string using clock_to_sec
% -----------------------------------------------------------------
%
% interval = parse_time_interval(str)
%
% Input:
% ------
%  str - string
%
% Output:
% -------
%  interval - interval struct

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
% Author: Matt Robbins
%--------------------------------
% $Revision$
% $Date$
%--------------------------------

if ~iscell(str)
	str = {str};
end

for k = 1:length(str)
	
	session_str = str{k}; session_str([1, end]) = '';
	
	start_str = strtok(session_str); stop_str = fliplr(strtok(fliplr(session_str)));
	
	start(k) = clock_to_sec(start_str); stop(k) = clock_to_sec(stop_str);
	
end

interval.start = start; interval.stop = stop; interval.end = stop;
	
	
	
	
