function geometry = sensor_geometry(file)

% sensor_geometry - read sensor_geometry file
% -------------------------------------------
%
% table = time_stamps(file)
%
% Inputs:
% -------
% file - file with path
%
% Outputs:
% --------
% table - sensor geometry table 

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
% create empty geometry struct
%--

geometry = [];

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

geometry = parse_geometry_file(lines);

%----------------------------
% GEOMETRY_CREATE
%----------------------------

function geometry = geometry_create

geometry.local = [];

geometry.global = [];

geometry.offset = [];

geometry.ellipsoid = [];


%----------------------------
% PARSE_GEOMETRY_FILE
%----------------------------

function geometry = parse_geometry_file(lines)

geometry = geometry_create; 

%--
% get number of columns from first line
%--

cols = numel(strfind(lines{1}, ',')) + 1;

%--
% get units from second line
%--

units = lines{2};

%--
% create table by reading lines
%--

rows = length(lines) - 2;

table = zeros(rows, cols); ref = [];

for k = 1:rows
	
	line = lines{k + 2};
	
	%--
	% reference channel is denoted by '*' at the beginning of the line
	%--
	
	if line(1) == '*'
		line = line(2:end); ref = k;
	end
	
	table(k, :) = strread(line, '', cols, 'delimiter', ',');
	
end

%--
% x/y
%--

if strcmpi(units(1), 'x')
	
	if size(table,2) < 3
		table = [table, zeros(size(table, 1), 3 - size(table, 2))];
	end
	
	geometry.local = table; return;
	
end

%--
% check for toolbox
%--

% if isempty(which('m_ll2xy'))
% 	
% 	disp(' ');
% 	disp('WARNING: m_map is not available.  Unable to use lat-lon geometry.');
% 	disp(' ');
% 	
% 	geometry = [];  return;
% 	
% end

if ~has_toolbox('m_map')
	geometry = []; return;
end

%--
% lat - lon, grab global (lat / lon) data
%--

geometry.global = table;

%--
% compute local (UTM) coordinates using M_Map
%--

min_max_lat = fast_min_max(table(:, 1));

min_max_lon = fast_min_max(table(:, 2));

[ignore, ellipsoid] = strread(units, '%s%s', 'delimiter', ','); ellipsoid = ellipsoid{1};

m_proj('utm', 'longitude', min_max_lon, 'latitude', min_max_lat, 'ellipsoid', ellipsoid);

[x y] = m_ll2xy(table(:, 2), table(:, 1));

%--
% compute offset of reference position
%--

if ~isempty(ref)
	offset = [x(ref), y(ref)];
else
	offset = [mean(x), mean(y)];
end

x = x - offset(1); y = y - offset(2);

%--
% store in local geometry
%--

geometry.local = [x(:), y(:), zeros(length(x), 1)];

geometry.offset = offset;

geometry.ellipsoid = ellipsoid;



