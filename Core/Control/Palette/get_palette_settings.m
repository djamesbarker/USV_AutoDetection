function value = get_palette_settings

% get_palette_settings - get name and tile and font settings
% ----------------------------------------------------------
%
% value = get_palette_settings
%
% Output:
% -------
%  value - palette settings

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
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%-----------------------------------------------
% SETUP
%-----------------------------------------------

% TODO: environment variables should follow some conventions

%--
% get palette size environment variable
%--

pal_size = get_env('palette_size');

if isempty(pal_size)	
	pal_size = set_env('palette_size', 'smaller');
end

%--
% get palette sounds environment variable
%--

pal_sounds = get_env('palette_sounds');

if isempty(pal_sounds)
	pal_sounds = set_env('palette_sounds', 'on');
end

%-----------------------------------------------
% PACK PALETTE SETTINGS
%-----------------------------------------------

%--
% pack palette size and sounds variables
%--

value.size = pal_size;

value.sounds = strcmpi(pal_sounds, 'on');

%--
% compute palette properties based on size
%--

% NOTE: the font and tilesize values below are hand selected

switch pal_size
	
	case {'smallest', -2}
		
		value.fontsize = 10; 
		
		value.tilesize = 16;
		
	case {'smaller', -1}
		
		value.fontsize = 11;
		
		value.tilesize = 19;
			
	case {'small', 0}

		value.fontsize = 12.5;
		
		value.tilesize = 21;
		
	case {'medium', 1}
		
		value.fontsize = 13;
		
		value.tilesize = 23;
		
	case {'large', 2}
		
		value.fontsize = 14;
		
		value.tilesize = 25;
		
	case {'larger', 3}
		
		value.fontsize = 15;
		
		value.tilesize = 27;
		
	otherwise
		
		value = [];
		
end

try
	if ~isempty(value)
		value.dpi = get(0, 'ScreenPixelsPerInch');
	end
end
