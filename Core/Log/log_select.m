function [event, ix] = log_select(log,varargin)

% log_select - select events from a log
% -------------------------------------
% 
%  [ix,id] = log_select(log,field_1,value_1,...,field_k,value_k)
%
% Input:
% ------
%  log - input log
%  field_k - field available for selection
%  value_k - value or interval for field selection
%
% Output:
% -------
%  ix - selected event indices
%  id - selected event id's

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
% create persistent table of available fields
%--

persistent PERSISTENT_FIELDS;

% get all event fields

if isempty(PERSISTENT_FIELDS)
	PERSISTENT_FIELDS = fieldnames(event_create);
end 

[field, value] = get_field_value(varargin, PERSISTENT_FIELDS);

if isempty(field)
	event = []; return;
end

%--
% weed out events
%--

event = log.event;

if isempty(event)
	return;
end

for k = 1:length(field)
	
	ix = 1:length(event);
	
	if isscalar(event(1).(field{k}))
		
		val = struct_field(event, field{k});
		
		ix = [val == value{k}];
		
	elseif iscellstr(event(1).(field{k}))
		
		val = {event.(field{k})};
		
		for j = length(val):-1:1
			
			if isempty(intersect(val{j}, value{k}))
				ix(j) = [];
			end
			
		end
		
	elseif ischar(event(1).(field{k}))
		
		ix = find(strcmp({event.(field{k})}, value{k}));
		
	end
	
	event = event(ix);
	
end

if islogical(ix)
	ix = find(ix);
end


% get available annotations and measurements
% --
% (this will enable us to select events that have these events and
% annotations)


% get fields for annotations and measurements
% --
% this will enable us to select based on the field values of the
% annotations or measurement

%--
% parse fields and values
%--

