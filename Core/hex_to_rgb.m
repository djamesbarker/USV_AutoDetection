function rgb = hex_to_rgb(hex)

% hex_to_rgb - convert hexadecimal color strings to RGB matrix
% ------------------------------------------------------------
%
% rgb = hex_to_rgb(hex) 
%
% Input:
% ------
%  hex - cell array of hexadecimal color strings
%
% Output:
% -------
%  rgb - RGB matrix
%
% Example:
% --------
%  hex = rgb_to_hex(jet(16)); jet2 = hex_to_rgb(hex); jet(16) - jet2

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

%--
% check input is string or string cell array
%--

% TODO: factor and extend in 'is_hex' function

if ischar(hex) 
	hex = {hex};
end 

if ~iscellstr(hex)
	error('Hexadecimal color input must be a string cell array.');
end

%------------------
% GET RGB VALUES
%------------------

N = numel(hex); rgb = nan(N, 3);

for k = 1:N
	
	rgbk = simple_hex_to_rgb(hex{k});
	
	if ~isempty(rgbk)
		rgb(k, :) = rgbk;
	end
	
end


%-----------------------------------
% SIMPLE_HEX_TO_RGB
%-----------------------------------

function rgb = simple_hex_to_rgb(hex)

rgb = []; hex = upper(hex);

% NOTE: return when length is wrong or string contains improper characters

if (length(hex) ~= 6) || any(~ismember(hex, '012345789ABCDEF'))
	return;
end

rgb = [hex2dec(hex(1:2)), hex2dec(hex(3:4)), hex2dec(hex(5:6))] / 255;

