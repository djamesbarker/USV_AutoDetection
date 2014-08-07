function duration = set_browser_time(par, duration, data)

% set_browser_time - set browser page-start time
% ----------------------------------------------
%
% set_browser_time(par, duration)
%
% Input:
% ------
%  par - parent browser handle
%  duration - duration
%
% Output:
% -------
%  duration - resulting duration

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

%--------------------------------
% HANDLE INPUT
%--------------------------------

if isempty(par)
	
	par = get_active_browser;
	
	if isempty(par)
		return;
	end
	
end

%-------------------------------
% SET DURATION
%-------------------------------

set_browser_page(par, [], 'duration', duration);
