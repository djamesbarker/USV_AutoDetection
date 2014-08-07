function out = time_stamps(file)

% time_stamps - read time_stamp file
% ----------------------------------
% table = time_stamps(file)
%
% Inputs:
% -------
% file - file with path
%
% Outputs:
% --------
% out - sound time stamp struct 

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
% Author: Matt Robbins
%--------------------------------
% $Revision$
% $Date$
%--------------------------------

out = [];

lines = file_readlines(file);

if isempty(lines)
	return;
end

%--
% get number of columns from first line
%--

header = lines{1};

t = {};

while (1)
	
	[t{end + 1} header] = strtok(header, ',');
	
	if isempty(header)
		break;
	end
	
end

%--
% get type from second line
%--

type = 'start_duration';

if strfind(lines{2}, 'stamp')
	type = 'stamp';
end
	
%--
% create table by reading lines
%--

cols = length(t);
rows = length(lines) - 2;

table = zeros(rows, cols);

for k = 1:rows
	
	line = lines{k + 2};
	
	if ~any(line == ':')
		table(k, :) = strread(line, '', cols, 'delimiter', ',');
        continue;
	end
		
	[clkstr, rem] = strtok(line, ',');

	for j = 1:cols

		table(k, j) = clock_to_sec(clkstr);

		[clkstr, rem] = strtok(rem, ','); 

	end
	
end

%--
% convert to time-stamp table from input type
%--

switch type
	
	case 'stamp'
		
	case 'start_duration'
		
		table = start_duration_to_stamps(table);
		
	otherwise
		
end

%--
% get expanded sessions
%--

sound.time_stamp.table    = table;
sound.time_stamp.enable   = 1; 
sound.time_stamp.collapse = 1;

sound.duration = table(end, 2);

sessions = get_sound_sessions(sound);

%--
% check for validity
%--

for k = 2:length(sessions)
	if sessions(k).start < sessions(k-1).end	
		warning('Invalid time stamp table: sessions must not overlap.');
        return;	
	end	
end

out.table = table; 

out.enable   = 0;
out.collapse = 0;

%-------------------------------------
% START_DURATION_TO_STAMPS
%-------------------------------------

function table = start_duration_to_stamps(table)

record_time = cumsum([0; table(:,2)]);
record_time(end) = [];

real_time = table(:, 1);
% real_time(end + 1) = real_time(end) + table(end,2);

table = [record_time, real_time];




	
	
	
