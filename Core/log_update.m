function [flag, ix] = log_update(par, pos, events)

% log_update - update open log
% ----------------------------
%
% flag = log_update(par, pos, events)
%
% Input:
% ------
%  par - handle to browser figure (def: gcf)
%  pos - log position (def: active log)
%  events - events to append (def: selection event)
%
% Output:
% -------
%  flag - update flag

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

% TODO: lots of work use perhaps only for selection logging ??

flag = 0;

%------------------------
% HANDLE INPUT
%------------------------

%--
% check parent input and get parent state
%--

if ~is_browser(par)
	error('Parent input is not browser handle.');
end

data = get_browser(par);

%--
% check for open logs
%--

% NOTE: the active log is empty only when there are no open logs

if ~data.browser.log_active
	error('There are no open logs in current browser.');
end

%--
% set and check log index
%--

if (nargin < 2) || isempty(pos)
	pos = data.browser.log_active;
end	

if pos > length(data.browser.log)
	error('Log index exceeds number of open logs in browser.');
end
	
%--
% get selection event
%--

if (nargin < 3) || isempty(events)
	events = data.browser.selection.event;
end

% NOTE: return if there is nothing to update

if isempty(events)
	return;
end

%------------------------
% UPDATE LOG
%------------------------

%--
% get active user
%--

user = get_active_user; sound = data.browser.sound; log = data.browser.log(pos);

%--
% append events to log
%--

id = log.curr_id;

for event = events

	time = event.time;

	%--
	% map start time to absolute recording time
	%--
	
	start_time = map_time(sound, 'record', 'slider', time(1)); 
	
	time = [start_time, start_time + diff(time)];
	
	event.time = time;

	%--
	% append event
	%--
	
	% NOTE: we auto increment id
	
	event.id = id; id = id + 1;
	
	event.author = user.name;
	
	log.event(end + 1) = event;

end

%--
% update information fields and save
%--

log.curr_id = id;

log.length = length(log.event);
	
ix = log.length;

log.modified = now;

if (log.autosave)
	log.saved = 1; log_save(log);
end

%--
% update browser log
%--

data.browser.log(pos) = log;

set(par,'userdata',data);

flag = 1;
