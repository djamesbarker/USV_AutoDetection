function hex = rgb_to_hex(rgb)

% rgb_to_hex - convert RGB matrix to hex strings
% ----------------------------------------------
%
% hex = rgb_to_hex(rgb)
%
% Input:
% ------
%  rgb - RGB matrix
%
% Output:
% -------
%  hex - cell array of hexadecimal color strings
%
% Example:
% --------
%  hex = rgb_to_hex(jet)

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

%------------------
% HANDLE INPUT
%------------------

% TODO: factor to and extend in 'is_rgb' function

%--
% check input size
%--

[r, c] = size(rgb);

if c ~= 3
	error('RGB matrix must have three columns');
end

%--
% check input range
%--

[a, b] = fast_min_max(rgb);

if (a < 0) || (b > 1)
	error('RGB matrix must have values between zero and one.'); 
end

%------------------
% GET HEX STRINGS
%------------------

%--
% convert interval values to 8-bit integers
%--

rgb = round(255 * rgb);

%--
% perform string conversion
%--

hex = cellstr([dec2hex(rgb(:, 1)), dec2hex(rgb(:, 2)), dec2hex(rgb(:, 3))]);

