function update_logs_event_id

% update_logs_event_id - add event_id field to logs
% -------------------------------------------------

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

% TODO: make this into a general log update function and rename

%--
% get unique libraries
%--

% NOTE: this gets all libraries currently linked through a user

libs = get_unique_libraries;

%--
% create temporary log to get new structure
%--

% NOTE: this log should have the 'event_id' field

temp = temp_log;

%--
% loop over libraries
%--

for k = 1:length(libs)
	
	str = libs(k).path;
	
	disp(' '); 
	disp(str_line(length(str)));
	disp(str);
	disp(str_line(length(str)));
	
	%--
	% get library log names
	%--
	
	logs = get_library_logs('file',libs(k));
	
	if (isempty(logs))
		continue;
	end
	
	%--
	% loop over logs
	%--
	
	for j = 1:length(logs)
		
		%--
		% load log
		%--
		
		log = log_load(logs{j});
		
		%--
		% update log
		%--
		
		if (isfield(log,'event_id'))
			disp(logs{j}); 
			continue;
		end
		
		log.event_id = 1;
		
		log = orderfields(log,temp); 
		
		%--
		% save log
		%--
		
		log_save(log);
		
		disp(['* ', logs{j}]);
		
	end
	
end

disp(' ');
