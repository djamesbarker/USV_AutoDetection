function pal = update_find_events(par, str, data)

% update_find_events - perform find events callback in event palette
% ------------------------------------------------------------------
%
% pal = update_find_events(par, str, data)
%
% Input:
% ------
%  pal - palette handle
%  par - palette parent figure
%  str - string to use in search (def: [], leave as is)
%  data - parent userdata
%
% Output:
% -------
%  pal - event palette handle

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
% $Revision: 5800 $
% $Date: 2006-07-19 15:49:48 -0400 (Wed, 19 Jul 2006) $
%--------------------------------

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% get parent state if needed
%--

if (nargin < 3) || isempty(data)
	data = get_browser(par);
end

%--
% set string
%--

if nargin < 2
	str = [];
end

%--------------------------
% UPDATE FIND EVENTS
%--------------------------

%--
% try to get event palette
%--

pal = get_palette(par, 'Event', data);

if isempty(pal)
	return;
end

%--
% get find events handles
%--

handles = get_control(pal, 'find_events', 'handles');

%--
% update control string if needed
%--

if ischar(str)
	set(handles.uicontrol.edit , 'string', str); refresh(pal);
end

%--
% execute callback
%--

browser_controls(par, 'find_events', handles.uicontrol.edit);
