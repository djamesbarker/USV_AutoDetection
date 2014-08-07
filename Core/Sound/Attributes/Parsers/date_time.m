function time = date_time(file)

% date_time - get starting date and time for sound
% ------------------------------------------------
%
% table = date_time(file)
%
% Inputs:
% -------
% file - file with path
%
% Outputs:
% --------
% date - matlab-format date vector

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

lines = file_readlines(file);

if isempty(lines)
	return
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

% TODO: get units from second line

%--
% create date number by reading lines
%--

cols = length(t); 

if cols > 1 
	time = []; return;
end

N = numel(datevec(now));

time = strread(lines{3}, '', N, 'delimiter', ',');

try 
	time = datenum(time);
catch
	str = ['File ''date_time.csv'' does not seem to be valid.']; warn_dialog(str, 'Configure');
	time = []; return;
end



