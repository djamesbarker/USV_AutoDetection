function S = log_event_str(log, data, fields, visible)

% log_event_str - create event strings for log
% --------------------------------------------
%
% S = log_event_str(log, data, fields, visible)
% 
%   = log_event_str(tags, data, fields)
%
% Input:
% ------
%  log - log structure
%  tags - tags of page displayed events
%  data - parent browser state
%  fields - fields to be used to create string
%  visible - consider visibility flag (def: 0)
%
% Output:
% -------
%  S - event strings, one per event

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

% NOTE: the need for a copy of the sound is a duplication related problem

% NOTE: this function trades precise formatting of the strings for speed

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 7019 $
% $Date: 2006-10-13 16:38:44 -0400 (Fri, 13 Oct 2006) $
%--------------------------------

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% set default visibility flag
%--

if (nargin < 4) || isempty(visible)
	visible = 0;
end

%--
% set fields if needed
%--

if (nargin < 3) || isempty(fields)
	
	fields = { ...
		'score', ...
		'label', ...
		'channel', ...
		'start_time' ...
	};

end

%--------------------------------------
% SPECIAL OUTPUT CONDITIONS
%--------------------------------------

%--
% log array input
%--

if ~isstr(log)
	
	%--
	% handle multiple logs recursively
	%--

	n = length(log);

	if (n > 1)

		S = cell(0);
		
		for k = 1:n
			S = [S; log_event_str(log(k), data, fields, visible)];
		end

		return;

	end 

	%--
	% return empty for empty logs
	%--

	% NOTE: this deals with the placeholder event problem

	if ~log.length
		S = cell(0); return;
	end

	%--
	% return empty for invisible logs if we care
	%--

	if visible && ~log.visible
		S = cell(0); return;
	end
	
%--
% tag sequence input
%--

% NOTE: this is used when displaying page visible events

else
	
	% NOTE: rename input for convenience
	
	tags = log;
	
	%--
	% return for empty tags
	%--
	
	if isempty(tags)
		S = cell(0); return;
	end
	
	%--
	% parse tags and create temporary logs
	%--
	
	[m,ix] = strtok(tags, '.'); ix = ix(2:end);

	% TODO: evaluate string to integer in some way
	
	if (length(M) == 1)
		
	else
		
	end
	
end

%--------------------------------------
% GENERATE LOG EVENT STRINGS 
%--------------------------------------

%--
% get relevant data from browser state
%--

sound = data.browser.sound;

grid = data.browser.grid;

%--
% select only displayed channels
%--

if visible
	
	% NOTE: it makes sense to use visibility filtering all the time
	
	%--
	% check for hidden channels
	%--
	
	dch = get_channels(data.browser.channels);
	
	if (length(dch) < data.browser.sound.channels)
		
		%--
		% get event channels and check which are visible
		%--
		
		ch = struct_field(log.event, 'channel');
		
		ix = zeros(size(ch));
		
		for k = 1:length(dch)
			ix = ix | (ch == dch(k));
		end
		
		%--
		% select displayed channels events
		%--
		
		log.event = log.event(ix);

		log.length = length(ix);
	
	end
	
end

%--
% generate event string for log
%--

% NOTE: this part of the string is invariant to the fields input

% S = strcat(file_ext(log.file), {' # '}, int_to_str(struct_field(log.event,'id')), {' -'});

S = strcat(file_ext(log.file), {' # '}, int_to_str(struct_field(log.event, 'id')), {':  '});

%--
% loop over fields included in string
%--

for k = 1:length(fields)
	
	%--
	% handle event fields according to content
	%--
	
	% NOTE: putting strings in cell arrays preserves whitespace in 'strcat'
	
	switch fields{k}

		%------------------------------
		% CODE
		%------------------------------
		
		% NOTE: this is part of making simple annotation a standard rather than an extensible annotation
		
		case 'score'
			
			% prepare fractional percent score string
			
			score = struct_field(log.event, 'score');
			
			score = round(1000 * score) / 10;
			
			score = strcat(num2str(score), '%');
			
			% concatenate
			
			S = strcat(S, score);
			
		%------------------------------
		% LEVEL
		%------------------------------
		
		case 'level'
			
			S = strcat(S, {'L = '}, int_to_str(struct_field(log.event, 'level')));
			
		%------------------------------
		% LABEL
		%------------------------------
		
		case 'label'
			
			% TODO: use a marked tag as the label '*label tag1 tag2'
			
			% NOTE: allow a single marked tag
			
			T = cell(size(S));
			
			for j = 1:length(log.event)
				
				if ~isempty(log.event(j).annotation.name)
					T{j} = log.event(j).annotation.value.code;
				else
					T{j} = '';
				end
				
			end
						
			S = strcat(S, T);
			
		%------------------------------
		% CHANNEL
		%------------------------------
		
		case 'channel'
			
			S = strcat(S, {'Ch = '}, int_to_str(struct_field(log.event, 'channel')));
			
		%------------------------------
		% TIME
		%------------------------------
		
		case 'start_time'
			
			%--
			% extract start time from event array
			%--
						
			t = struct_field(log.event, 'time'); t = t(:, 1);
			
			t = map_time(sound, 'real', 'record', t);

			start_time = get_grid_time_string(grid, t, sound.realtime);
			
			%--
			% append time string to event string
			%--
			
			S = strcat(S, {'T = '}, start_time);

	end
	
	%--
	% separate fields using comma
	%--
	
	if (k < length(fields))
		S = strcat(S, {',  '}); 
	end
		
end

%--
% remove orphaned commas
%--

% NOTE: there must be a better way

S = strrep(S, ':  ,', ': ');

S = strrep(S, ',  ,', ',');
