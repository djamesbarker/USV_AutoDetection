function color = cdss_display_colors

%--
% color name colors
%--

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

% TODO: create a function to produce the standard color table as struct

color.white = [1 1 1]; color.black = [0 0 0];

color.dark_gray = 0.25 * color.white;

color.gray = 0.5 * color.white;

color.light_gray = 0.75 * color.white;

base = 0.8 * eye(3); 

color.red = base(1,:); color.green = base(2,:); color.blue = base(3,:);

color.orange = [220, 110, 20] / 255;

%--
% specific display colors
%--

color.component = color.red;

color.model = color.blue;

color.knots = color.orange;

color.signal = color.light_gray;
