function attribute = sensor_calibration(file)

% sensor_calibration - read sensor_calibration file
% ----------------------------------
% attribute = sensor_calibration(file)
%
% Inputs:
% -------
% file - file with path
%
% Outputs:
% --------
% attribute - sensor calibration attribute

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
% get reference from second line
%--

[ignore, reference] = strread(lines{2}, '%s%f', 'delimiter', ',');

%--
% create table by reading lines
%--

rows = length(lines) - 3;

calibration = zeros(rows, 1);

for k = 1:rows
	
	line = lines{k + 3};
	
	calibration(k) = strread(line, '%f', 1, 'delimiter', ',');
	
end

attribute.calibration = calibration;

attribute.reference = reference;

