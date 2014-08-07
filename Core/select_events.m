function select = select_events(logs,varargin)

% select_events - perform event selection from logs
% -------------------------------------------------
%
% select = select_events(logs,'field',range,...)
%
% Input:
% ------
%  logs - input log array
%  field - selection field
%  range - selection field value range
%
% Output:
% -------
%  select - selected event indices

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% TODO: handle logs and event arrays, use this in detector interface screen

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------
			
%--
% parse field range pairs
%--

[field,range] = get_field_value(varargin);

%--
% remove requested fields not in selection field list
%--

SEL_FIELDS = { ...
	'id', ...
	'level', ...
	'channel', ...
	'duration', ...
	'bandwidth', ...
	'start_time', ...
	'end_time', ...
	'min_freq', ...
	'max_freq', ...
	'page' ...
};

for k = length(field):-1:1	
	
	if (isempty(find(strcmp(lower(field{k}),SEL_FIELDS))))
		field{k} = [];
		range{k} = [];
	end
	
end
	
%---------------------------------------------
% SELECT ON EACH LOG
%---------------------------------------------

%--
% initialize selected events to empty
%--

select = cell(length(logs),1);

for j = 1:length(logs)
	
	%---------------------------------------------
	% SELECT ON ALL FIELDS
	%---------------------------------------------

	for k = 1:length(field)

		%---------------------------------------------
		% GET CURRENTLY SELECTED EVENTS
		%---------------------------------------------

		%--
		% first select all events in log
		%--
		
		if (k == 1)
			ix = 1:length(logs(j).event);
		end
		
		%--
		% move to next log if no events are selected
		%--

		if (isempty(ix))
			break;
		end

		%--
		% apply current selection indices
		%--

		events = logs(j).event(ix);
	
		%---------------------------------------------
		% PERFORM FIELD SELECTION
		%---------------------------------------------
			
		switch (lower(field{k}))

			%---------------------------------------------
			% EVENT FIELDS
			%---------------------------------------------
						
			%--
			% direct access event fields
			%--
			
			% NOTE: at the moment these are only numerical fields
			
			case ({ ...
				'id', ...
				'level', ...
				'channel' ...
			})
		
				value = struct_field(events,field{k});
				
			%--
			% time field, duration, and shortcuts
			%--
			
			case ('time')
				
				value = struct_field(events,'time');
				
			case ('start_time')
				
				value = struct_field(events,'id');
				value = value(:,1);
		
			case ('end_time')
				
				value = struct_field(events,'id');
				
			case ('duration')
				
				value = struct_field(events,'duration');
			
			%--
			% frequency field, bandwidth, and shortcuts
			%--
			
			case ('freq')
				
				value = struct_field(events,'freq');
				
			case ('min_freq')
				
				value = struct_field(events,'freq');
				value = value(:,1);
				
			case ('max_freq')
				
				value = struct_field(events,'freq');
				value = value(:,2);
				
			case ('bandwidth')
				
				value = struct_field(events,'bandwidth');
				
			%---------------------------------------------
			% COMPUTED EVENT FIELDS
			%---------------------------------------------
						
			case ('time_range') 
				
				value = struct_field(events,'time');
				
			case ('freq_band')
				
				value = struct_field(events,'freq');
				
			%---------------------------------------------
			% BROWSER SELECTION
			%---------------------------------------------
		
			%--
			% events displayed in page
			%--

			% NOTE: this branch is different from the others
			
			case ('page')

		end
		
		%---------------------------------------------
		% PERFORM SELECTION
		%---------------------------------------------
		
		% NOTE: parsing may be done by the select function
		
		[b,type] = parse_range(range{k});
				
		ix = select_range(value,b,type);
				
		%---------------------------------------------
		% DE-REFERENCE SELECTION INDICES
		%---------------------------------------------
		
		ix = ix(ix2);

	end
	
end


%---------------------------------------------
% PARSE_RANGE
%---------------------------------------------

function [b,type] = parse_range(range)

% parse_range - parse range for field values
% ------------------------------------------
%
% [b,type] = parse_range(range)
%
% Input:
% ------
%  range - range input
%
% Output:
% -------
%  b - range defining values
%  type - range type

% NOTE: 0-3 come from 'parse_interval', negative codes are defined here

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% NOTE: at the moment we only handle intervals and points
				
if (isstr(range{k}))

	% value interval selection

	[b,type] = parse_interval(range);

else

	tmp = range;

	%--
	% interpret vector as closed interval
	%--
	
	if ((length(tmp) == 2) && (tmp(2) > tmp(1)))

		% code for closed interval is 3 (from 'parse_interval')
		
		b = tmp;
		type = 3;

	%--
	% interpret scalar as single point
	%--
	
	elseif ((length(tmp) == 1))
		
		% single value code is -1
		
		b = tmp;
		type = -1;

	%--
	% interpret vector as list of values
	%--
		
	else
		
		% list of values code is -2
		
		b = range;
		t = -2;
		
	end

end


%---------------------------------------------
% PAGE_SELECTION
%---------------------------------------------

function ix = page_select(log,t,ch,page)

% page_select - perform page selection for a log
% -------------------------------------------------
%
% ix = page_select(log,t,ch,page)
%
% Input:
% ------
%  log - range input
%  t - start time of page
%  ch - channels displayed in page
%  page - page description
%
% Output:
% -------
%  ix - indices of log events in page

% NOTE: the required three input arguments suggest a different page description

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% return empty on invisible or empty logs
%--

if ((log.visible == 0) || (log.length == 0))
	ix = []; 
	return;
end

%---------------------------------------------
% PERFORM TIME SELECTION
%---------------------------------------------

% NOTE: select if start or end is within the page, or if event stradles page

t1 = t;
t2 = t + page.duration;

if (log.length > 1)
	t = struct_field(log.event,'time');
else
	t = struct_field(log.event(1),'time');
end

ix = find( ...
	((t(:,1) > t1) & (t(:,1) < t2)) | ...
	((t(:,2) > t1) & (t(:,2) < t2)) | ...
	((t(:,1) < t1) & (t(:,2) > t2)) ...
);

%---------------------------------------------
% PERFORM CHANNEL SELECTION
%---------------------------------------------

% NOTE: this uses an integer look up table for efficiency 

if (~isempty(ix))

	%--
	% convert channel indices to integers
	%--
	
	c = struct_field(log.event(ix),'channel');
	c = uint8(c);

	%--
	% consider zero offset
	%--
	
	T = zeros(1,nch + 1); 
	T(ch + 1) = 1;

	%--
	% select indices using look up table
	%--
	
	ix2 = find(lut_apply(c,T));

	%--
	% dereference selection indices
	%--
	
	if (~isempty(ix2))
		ix = ix(ix2);
	else
		ix = [];
	end

end
