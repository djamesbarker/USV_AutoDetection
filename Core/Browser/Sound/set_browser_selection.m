function set_browser_selection(par, event, m, ix) 

% set_browser_selection - set browser selection
% ---------------------------------------------
%
% set_browser_selection(par, event, m, ix)
%
% Input:
% ------
%  par - browser
%  event - selection event
%  m - log index
%  ix - event index

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
% check browser input
%--

if ~is_browser(par)
	return;
end

%--
% set selection
%--

% NOTE: in this case the function works as an alias

if (nargin < 3) || isempty(m)
	browser_bdfun(par, event); 
end

%--
% set event selection
%--

if (nargin < 4) || isempty(ix)
	
	if isempty(event.id) || isempty(m)
		return;
	end

	data = get_browser(par);
	
	ix = find(event.id == [data.browser.log(m).event.id], 1);
	
	if isempty(ix)
		return;
	end
	
end

event_bdfun(par, m, ix);
