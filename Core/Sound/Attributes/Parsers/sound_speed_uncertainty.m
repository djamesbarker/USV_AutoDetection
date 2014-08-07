function sound_speed_uncertainty = sound_speed_uncertainty(file)

% sound_speed_uncertainty - read sound_speed_uncertainty file
% -------------------------------------------
%
% vector = sound_speed_uncertainty(file)
%
% Inputs:
% -------
% file - file with path
%
% Outputs:
% --------
% vector - uncertainty of sound speed (x,y,z)

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
% create empty sound_speed_uncertainty struct
%--

sound_speed_uncertainty = [];

%--
% read geometry file lines
%--

lines = file_readlines(file);

if isempty(lines)
	return;
end

%--
% parse sound_speed_uncertainty file contents
%--

sound_speed_uncertainty.uncertainty = parse_sound_speed_uncertainty_file(lines);

end

%----------------------------
% SOUND_SPEED_UNCERTAINTY_CREATE
%----------------------------

function sound_speed_uncertainty = sound_speed_create

sound_speed_uncertainty.uncertainty = [];

end

%----------------------------
% PARSE_SOUND_SPEED_UNCERTAINTY_FILE
%----------------------------

function sound_speed_uncertainty = parse_sound_speed_uncertainty_file(lines)

sound_speed_uncertainty = sound_speed_create; 

%--
% get number of columns from first line
%--

cols = numel(strfind(lines{1}, ',')) + 1;

%--
% get units from second line
%--

units = lines{2};

%--
% create vector by reading line
%--

vector = strread(lines{3}, '%f', cols, 'delimiter', ',');
sound_speed_uncertainty.uncertainty = vector';
	
end