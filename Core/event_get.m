function [event,ix,file] = event_get(h,m,ix)

% event_get - get indexed events from log
% ---------------------------------------
%
% [event,ix,file] = event_get(h,m,ix)
%
% Input:
% ------
%  h - handle to browser figure (def: gcf)
%  m - index of log (def: active log)
%  ix - indices of desired events from log (def: all available events)
%
% Output:
% -------
%  event - event structure array
%  ix - index of events in log
%  file - log filename

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% set handle and get userdata
%--

if (~nargin | isempty(h))
    h = gcf;
end

data = get(h,'userdata');

%--
% set log index and get log
%--

if (nargin < 2)
	m = data.browser.log_active;
	if (~m)
		disp(' ');
		error('There are no open logs in current browser.');
	end
	log = data.browser.log(m);
else
	if (m <= length(data.browser.log))
		log = data.browser.log(m);
		file = log.file;
	else
		disp(' ');
		error('Log index exceeds number of open logs in browser.');
	end
end

%--
% set event indices
%--

if (nargin < 3)
    ix = 1:log.length;
end

%--
% get events from log
%--

if ((min(ix) > 0) & (max(ix) <= log.length))
    event = log.event(ix);
else
	if (log.length == 0)
		disp(' ');
		warning('There are no events in specified log, empty event returned.');
		event = event_create;
	else
		disp(' ');
    	warning('Event indices are out of range of specified log, empty event returned.');
		event = event_create;
	end
end
 
