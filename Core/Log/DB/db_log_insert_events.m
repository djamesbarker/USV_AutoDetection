function [count, elapsed] = db_log_insert_events(db_log, event, mode)

% db_log_add_events - add events to db log
% ----------------------------------------
%
% [count, elapsed] = db_log_insert_events(db_log, event)
%
% Input:
% ------
%  db_log - database log
%  event - event array
%
% Output: 
% -------
%  count - inserted
%  elapsed - elapsed time for insert

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
% set default mode
%--

if (nargin < 3) || isempty(mode)
	mode = 'wrapped';
end

%--
% get content of events table from event
%--

% NOTE: basic events are stripped of meta-data and non-supported fields

basic = get_basic_event(event(:)); 

%--
% insert events
%--

% NOTE: this switch is mainly here for development

start = clock;

switch mode
	
	% NOTE: we use parametrized SQL and parameter binding
	
	case 'parametrized'	
		
		sql = [ ...
			'INSERT OR REPLACE INTO events VALUES ', value_str(length(fieldnames(basic))), ';' ...
		];

		parameters = struct2cell(basic);
		
		sqlite(db_log.events, 'prepared', sql, struct2cell(basic));

	% NOTE: create statement collection and execute in one wrapped single-transaction call
	
	case 'wrapped'

		sql = cell(length(basic) + 2, 1);

		sql{1} = 'BEGIN;';
		
		for k = 1:length(basic)
			sql{k + 1} = [ ...
				'INSERT OR REPLACE INTO events VALUES ', value_str(basic(k)), ';' ...
			];
		end
		
		sql{end} = 'COMMIT;';

		sqlite(db_log.events, 'exec', sql);

	% NOTE: use same calls as in 'wrapped' but with a prepared call for each
	
	case 'prepared'

		for k = 1:length(basic)
			
			sql = [ ...
				'INSERT OR REPLACE INTO events VALUES ', value_str(basic(k)), ';' ...
			];
		
			sqlite(db_log.events, 'prepared', sql);

		end
		
end

count = length(basic); 

elapsed = etime(clock, start);



%--
% insert measures
%--

% NOTE: we may have to create the corresponding databases here

% sqlite(db_log.measures{k}, str);

%--
% insert annotations
%--

% NOTE: we may have to create the corresponding databases here

% sqlite(db_log.annotations{k}, str);


if ~nargout
	disp(['  ', int_to_str(count), ' events inserted in ', sec_to_clock(elapsed)]); clear count;
end


%------------------------------
% VALUE_STR
%------------------------------

function str = value_str(obj, fields)

%--
% create parameter value string
%--

if ~isstruct(obj) && (numel(obj) == 1) && (obj == floor(obj))
	
	str = '(';
	
	for k = 1:obj
		str = [str, '?,'];
	end
	
	str(end) = ')';

	return;
	
end

%--
% get object fieldnames
%--

if nargin < 2
	fields = fieldnames(obj);
end

%--
% handle multiple inputs recursively
%--

if numel(obj) > 1
	
	str = cell(size(obj));
	
	for k = 1:numel(obj)
		str{k} = value_str(obj(k), fields);
	end
	
	return;
	
end

%--
% create insert statement for each object
%--

str = '(';

for k = 1:length(fields)

	%--
	% get column value
	%--
	
	value = obj.(fields{k});

% 	if ismember(fields{k}, {'time', 'freq'})
% 		value = value(1);
% 	end
	
	%--
	% get column value string
	%--
	
	if isempty(value)
		
		part = 'NULL';
	
	elseif isnumeric(value)
		
		% NOTE: we are only handling scalar numric fields here!
		
		if (value(1) == floor(value(1)))
			part = int_to_str(value(1));
		else
			part = num2str(value(1));
		end	
		
	% TODO: implement escaping of strings!
	
	elseif ischar(value)
		
		part = ['''', value, ''''];
		
	elseif iscellstr(value)	
		
		if length(value) > 1
			part = strcat(value, ';');
		else
			part = value;
		end 

		part = ['''', part{:}, ''''];
		
	end

	%--
	% concatenate value string
	%--
	
	str = [str, part, ','];

end

str(end) = ')';


%------------------------------
% GET_BASIC_EVENT
%------------------------------

function basic = get_basic_event(event)

%--
% collect potential fields to remove
%--

meta_data = {'annotation', 'detection', 'measurement', 'userdata'};

not_supported = {'level', 'children', 'parent'};

remove = {meta_data{:}, not_supported{:}};

%--
% check fields
%--

for k = length(remove):-1:1
	
	if ~isfield(event, remove{k})
		remove(k) = [];
	end
	
end

%--
% remove fields
%--

basic = rmfield(event, remove);

