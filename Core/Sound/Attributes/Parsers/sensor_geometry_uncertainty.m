function geometry_uncertainty = sensor_geometry_uncertainty(file)

% sensor_geometry - read sensor_geometry_uncertainty file
% -------------------------------------------
%
% table = sensor_geometry_uncertainty(file)
%
% Inputs:
% -------
% file - file with path
%
% Outputs:
% --------
% table - sensor geometry uncertainty table 

% Copyright (C) 2002-2007 Harold K. Figueroa (hkf1@cornell.edu)
% Copyright (C) 2005-2007 Matthew E. Robbins (mer34@cornell.edu)
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
% create empty geometry uncertainty struct
%--

geometry_uncertainty = [];

%--
% read geometry file lines
%--

lines = file_readlines(file);

if isempty(lines)
	return;
end

%--
% parse geometry file contents
%--

geometry_uncertainty = parse_geometry_uncertainty_file(lines);

%----------------------------
% GEOMETRY_UNCERTAINTY_CREATE
%----------------------------

function geometry_uncertainty = geometry_uncertainty_create

geometry_uncertainty.uncertainty = [];


%----------------------------
% PARSE_GEOMETRY_FILE
%----------------------------

function geometry_uncertainty = parse_geometry_uncertainty_file(lines)

geometry_uncertainty = geometry_uncertainty_create; 

%--
% get number of columns from first line
%--

cols = numel(strfind(lines{1}, ',')) + 1;
dim = cols/2;

%--
% get units from second line
%--

units = lines{2};

%--
% create table by reading lines
%--

rows = length(lines) - 2;

table = zeros(rows, dim, 2);

for row = 1:rows
	
	line = lines{row + 2};
	temp = strread(line, '', cols, 'delimiter', ',');
    for col = 1:dim
        for sign = 1:2
            table(row,col,sign) = temp(2*(col-1)+sign);
        end
    end
end

%--
% grab sensor geometry uncertainty data
%--

geometry_uncertainty.uncertainty = table;

