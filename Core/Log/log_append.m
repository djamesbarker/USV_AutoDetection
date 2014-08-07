function log = log_append(log,events)

% log_append - append events to log
% ---------------------------------
%
% log = log_append(log,events,context)
%
% Input:
% ------
%  log - log
%  events - event to append
%  context - context
%
% Output:
% -------
%  log - updated log

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

%----------------------------------
% SETUP
%----------------------------------

%--
% validate events
%--

[events, reject, why] = validate_events(events,log.sound);

if ~isempty(reject)
	
	message = { ...
		'Some or all of the events from ', ...
		['"', log_name(log), '"'], ...
		'are incompatible with the log sound ', ...
		['"', sound_name(log.sound), '" '], ...
		['because they have incompatible:'] ...
	};
	
	warn_dialog({message{:}, why{:}}, 'Problem Appending Log Events', 'modal');
	
	% TODO: display some message
	
end

%----------------------------------
% APPEND EVENTS
%----------------------------------

id = log.curr_id;

for k = 1:length(events)
	
	event = events(k); event.id = id; id = id + 1; 
	
	if isempty(event.author)
		event.author = log.author;
	end
	
	log.event(end + 1) = event;

end

%--
% update information fields and save
%--

log.curr_id = id; log.length = length(log.event); log.modified = now;

if (log.autosave)
	log.saved = 1; log_save(log);
end

%----------------------------------
% APPEND SUMMARY
%----------------------------------

% TODO: compile append summary from events and context
