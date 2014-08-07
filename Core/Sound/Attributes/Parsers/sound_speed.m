function table = sound_speed(file)

% sound_speed - get speed of sound attribute
% ------------------------------------------
% table = sound_speed(file)
%
% Inputs:
% -------
% file - file with path
%
% Outputs:
% --------
% table - table of (possibly time-varying) sound speed

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

%--
% get units from second line
%--


%--
% create table by reading lines
%--

cols = length(t); rows = length(lines) - 2;

table = zeros(rows, cols);

for k = 1:rows
	
	table(k,:) = strread(lines{k + 2}, '', cols, 'delimiter', ',');
	
end

