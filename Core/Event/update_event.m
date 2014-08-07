function [events, cancel] = update_event(old_event, silent)

% update_event - update event(s) to new structure form
% ----------------------------------------------------
% events = update_event(old_event)
%
% Input:
% ------
%  old_event - array of old events
%
% Output:
% -------
%  events - new events

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

if nargin < 2
	silent = 0;
end

%--
% setup
%--

cancel = 0;

opt = struct_update; opt.flatten = 0;

events = empty(event_create);

%--
% update events
%--

for k = 1:length(old_event)	
	
	event = struct_update(event_create, old_event(k), opt);
	
	%--
	% get annotation data
	%--
	
	if ~isempty(event.annotation) 
		
		if isfield(event.annotation(1).value, 'code')
			event = set_tags(event, str_to_tags(event.annotation(1).value.code));
		end
		
		if isfield(event.annotation(1).value, 'notes')
			event.notes = {event.annotation(1).value.notes};
		end		
		
	end
	
	%--
	% get detection score if possible
	%--
	
	if ~isempty(event.detection)
		
		if isfield(event.detection(1).value, 'corr')
			event.score = event.detection(1).value.corr;
		end
		
	end
	
	%--
	% write updated event to output array
	%--
	
	events(end + 1) = event;
	
	%--
	% update waitbar and check for cancellation
	%--
	
	if silent
		continue;
	end
	
	[ignore, result] = migrate_wait('Events');

	if ~isempty(result)
		cancel = strcmp(result, 'cancel'); return;
	end

end

