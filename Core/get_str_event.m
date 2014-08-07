function [event, name, m, ix] = get_str_event(par, str, data)

% get_str_event - get event corresponding to string
% -------------------------------------------------
%
% [event, name, m, ix] = get_str_event(par, str, data)
%
% Input:
% ------
%  par - browser handle
%  str - event string
%  data - browser state
%
% Output:
% -------
%  event - event
%  name - log name
%  m, ix - log and event index

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
% $Revision: 5656 $
% $Date: 2006-07-11 13:19:57 -0400 (Tue, 11 Jul 2006) $
%--------------------------------

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% get state of browser if needed
%--

if (nargin < 3) || isempty(data)
	data = get_browser(par);
end

%--------------------------------------------
% PARSE EVENT STRING
%--------------------------------------------

%--
% get log name from string and get log index
%--

[name, str] = strtok(str, '#'); name = name(1:(end - 1));

m = get_browser_log_index(par, name, data);

% NOTE: return empty if we did not find log

if isempty(m)
	event = []; ix = []; return;
end

%--
% get event id and index
%--

[id, str] = strtok(str, ':'); id = eval(id(3:end));

ix = find(id == struct_field(data.browser.log(m).event, 'id'));

% NOTE: return empty if we did not find event

if isempty(ix)
	event = []; return;
end

%--
% get event
%--

event = data.browser.log(m).event(ix);
