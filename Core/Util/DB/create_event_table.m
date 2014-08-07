function [str, lines] = create_event_table(force)

% create_event_table - create table for events
% --------------------------------------------
%
% [str, lines] = create_event_table(force)
%
% Input:
% ------
%  force - drop existing table if needed
%
% Output:
% -------
%  str - statement string
%  lines - statement lines 

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
% set no force default
%--

opt = create_table;

if ~nargin
	force = 0;
end 

opt.force = force;

% opt.hint = 0;

%--
% create prototype event with type hint data
%--

prototype = prototype_event;

%--
% generate create table sql
%--

[str, lines] = create_table(prototype, 'events', opt);


%------------------------
% PROTOTYPE EVENT
%------------------------

function prototype = prototype_event

%--
% create event
%--

prototype = event_create;

%--
% remove fields
%--

not_supported = {'level', 'children', 'parent'};

not_needed = {'annotation', 'detection', 'measurement', 'userdata'};

remove = {not_needed{:}, not_supported{:}};

for k = 1:length(remove)
	
	if isfield(prototype, remove{k})
		prototype = rmfield(prototype, remove{k});
	end
	
end

%--
% provide type hints for remaining fields
%--

field = fieldnames(prototype);

int = int32(1); time = datestr(now);

for k = 1:length(field)

	switch field{k}

		case {'author', 'tags'}
			value = 'varchar';
			
		case 'notes'
			value = {'text'};
			
		case {'id', 'channel', 'rating'}
			value = int;
			
		case {'created', 'modified'}
			value = time;
			
		case 'samples'
			value = 1:10;
			
		otherwise
			value = 1;
	end
	
	prototype.(field{k}) = value;
	
end
