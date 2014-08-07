function set_browser_history(par, elapsed, data)

% set_browser_history - update browser history store
% --------------------------------------------------
%
% set_browser_history(par,elapsed,data)
%
% Input:
% ------
%  par - browser handle
%  elapsed - elapsed display time
%  data - browser userdata

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
% $Revision: 4580 $
% $Date: 2006-04-14 17:24:52 -0400 (Fri, 14 Apr 2006) $
%--------------------------------

%--------------------
% HANDLE INPUT
%--------------------

%--
% check browser handle
%--

if ~is_browser(par)
	error('Input is not browser handle.');
end

%--
% check elapsed time
%--

if (elapsed <= 0)
	error('Elapsed time must be positive.');
end

%--
% get data if needed
%--

if (nargin < 3) || isempty(data)
	data = get(par, 'userdata');
end

%--------------------
% SET HISTORY
%--------------------

%--
% get point in history for browser
%--

history = history_create( ...
	'elapsed', elapsed ...
);

opt = struct_update; opt.flatten = 0;

history = struct_update(history, data.browser, opt); 

%--
% pack point in history of browser
%--

point.par = par; point.tag = get(par, 'tag'); 

point.history = buffer_create(32, history);

%--
% store point in history
%--

global BROWSER_HISTORY;

if isempty(BROWSER_HISTORY)
	
	BROWSER_HISTORY = point;
	
else
	
	% TODO: delete browser history when browser has changed, use tag
	
	[value, ix] = get_browser_history(par); 
	
	if isempty(value)
		
		BROWSER_HISTORY(end + 1) = point;
		
	else
		
		% NOTE: we add the current point to the history buffer
		
		buf = BROWSER_HISTORY(ix).history;
		
		buf = buffer_add(buf, buffer_current(point.history));
		
		BROWSER_HISTORY(ix).history = buf;
		
	end
	
end
