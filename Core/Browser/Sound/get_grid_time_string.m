function str = get_grid_time_string(grid,time,realtime)

% get_grid_time_string - get time string according to grid
% --------------------------------------------------------
%
% str = get_grid_time_string(grid,time,realtime)
%
% Input:
% ------
%  grid - grid options
%  time - time
%  realtime - date offset
%
% Output:
% -------
%  str - time string according to grid

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
% $Revision: 4695 $
% $Date: 2006-04-20 11:22:26 -0400 (Thu, 20 Apr 2006) $
%--------------------------------

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% set default empty realtime
%--

if nargin < 3
	realtime = []; 
end

%--
% handle multiple times recursively
%--

if numel(time) > 1
	
	str = cell(size(time));
	
	for k = 1:numel(time)
		str{k} = get_grid_time_string(grid,time(k),realtime);
	end 
	
	return; 

end

%------------------------------
% COMPUTE TIME STRINGS
%------------------------------

%--
% compute time string based on grid settings, time, and realtime
%--

% TODO: consider a 'get_grid_label_types'

switch grid.time.labels
	
	case 'seconds'
		
		% NOTE: the rounding preserves two decimal digits if needed
		
		str = [num2str(round(100 * time) / 100), ' sec'];
		
	case 'clock'
		
		% original XBAT no padded time
        % str = sec_to_clock(time);
        % zero pad times less than 10:00:00
		str = sec_to_clock(time);
        if time < 36000
            str = ['0' str];
        end
		
	case 'date and time'
		
		if isempty(realtime)
			str = sec_to_clock(time);
		else
			str = datestr(offset_date(realtime, time));
		end
		
end
