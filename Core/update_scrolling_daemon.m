function flag = set_scrolling_time(obj,par,time)

% set_scrolling_time - update scrolling daemon time table
% -------------------------------------------------------
%
% flag = set_scrolling_time(obj,par,time)
%
% Input:
% ------
%  obj - daemon timer object
%  par - browser figure handle
%  time - time to set as current time
%
% Output:
% -------
%  flag - update success flag

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
% check that figure still exists
%--

% NOTE: it is possible to do garbage collection here

if (isempty(find(par == get(0,'children'))))
	
	flag = 0;
	return;
	
	% TODO: perhaps display some warning, and choose special flag
	
end

%--
% get timer if needed
%--

if (isempty(obj))
	
	obj = timerfind('name','XBAT Scrolling Daemon');
	
	if (isempty(obj))
		
		flag = 0;
		return;
		
		% TODO: perhaps display some warning, and choose special flag
		
	end
	
end

%--
% update timer handle scroll time table
%--


	


