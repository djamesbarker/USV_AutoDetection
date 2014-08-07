function out = get_type_and_constraints(column, value)

% get_type_and_constraints - get type and constraint information
% --------------------------------------------------------------
%
% out = get_type_and_constraints(column, value)
%
% Input:
% ------
%  column - column name
%  value - column instance values
%
% Output:
% -------
%  out - struct output

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

% TODO: use a sequence of values to infer types

%--
% get base type and constraints
%--

out.constraints = get_constraints(column);

out.type = get_type(value);

%--
% handle conventional cases more forcefully
%--

% NOTE: if a column is a key, try to consider it as an integer

if ~isempty(strfind(out.constraints, 'KEY'))
	
	if isempty(value) || all(round(value) == value)
		out.type = 'INTEGER';
	end
	
end

% NOTE: if a column is a creation date try to consider it as a datetime

% NOTE: something like this should be optional, since it may require further conversion code when we insert

% if ismember(column, {'created', 'modified', 'timestamp'})
% 	out.type = 'DATETIME';
% end


%-----------------------------------------------------
% GET_CONSTRAINTS
%-----------------------------------------------------

function str = get_constraints(column)

% get_constraints - get constraints based on naming conventions
% -------------------------------------------------------------
%
% str = get_constraints(column)
%
% Input:
% ------
%  column - field name
%
% Output:
% -------
%  str - constraint description

%--
% initialize constraints and normalize column name
%--

str = cell(0); column = lower(column);

%--
% consider not null conventions
%--

not_null_words = {'created', 'timestamp', 'author'};
	
if ismember(column, not_null_words)
	str{end + 1} = 'NOT NULL';
end

%--
% consider key conventions
%--

if strcmp(column, 'id')
	
	str{end + 1} = 'NOT NULL PRIMARY KEY'; 
	
else
			
	key_words = {'_id'};

	for k = 1:length(key_words)
		
		if ~isempty(strfind(column, key_words{k}))
			str{end + 1} = 'NOT NULL FOREIGN KEY'; break;
		end
		
	end
	
end

%--
% concatenate constraints
%--

str = strcat(str, {' '}); str = [str{:}]; str(end) = [];


%-----------------------------------------------------
% GET_TYPE
%-----------------------------------------------------

function type = get_type(value)

% get_type - get type description for value
% -----------------------------------------
%
% type = get_type(value)
%
% Input:
% ------
%  value - content of struct field
%
% Output:
% -------
%  type - fragment describing value type

% TODO: add date types to this function

%--
% DEFAULT
%--

% NOTE: return empty for container and object types

type = '';

%--
% NUMERIC
%--

if isnumeric(value)
	
	% NOTE: array contents are stored as blobs, then restored with casting
	
	if numel(value) > 1
		type = 'BLOB'; return;
	end
	
	if isfloat(value)
		type = 'REAL'; return;
	end

	if isinteger(value)
		type = 'INTEGER'; return;
	end
	
	type = 'BLOB';
	
end

%--
% LOGICAL
%--

if islogical(value)
	
	if numel(value) > 1
		type = 'BLOB'; return;
	end
	
	type = 'BOOLEAN'; return;
	
end

%--
% STRINGS
%--

if ischar(value)
	
	type = 'VARCHAR';
	
	% NOTE: we try to convert the string to a date to check for datetime
	
	if ~isempty(value)
		try
			datenum(value); type = 'DATETIME';
		catch
			% NOTE: there is nothing to catch
		end
	end
	
	return;
	
end

if iscellstr(value)
	type = 'TEXT'; return;
end
