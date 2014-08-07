function color = get_extension_color(ext)

% get_extension_color - get extension palette color
% -------------------------------------------------
%
% color = get_extension_color(ext)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  color - color for various components

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
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

% TODO: collect colors for other extension types in this function

% NOTE: look at 'control_colors' as well

%------------------------------------
% HANDLE INPUT
%------------------------------------

%--
% get extension type from input
%--

switch class(ext)

	case 'char', type = ext;

	case 'struct'

		if ~isfield(ext, 'subtype')
			error('Input struct must be extension struct.');
		end

		type = ext.subtype;

end

%--
% check input extension type
%--

if ~is_extension_type(type) && ~strcmp(type, 'root')
	error('Input must be extension or extension type.');
end
	
%------------------------------------
% GET EXTENSION COLOR
%------------------------------------

%--
% declare constant base color
%--

light_gray = [192, 192, 192] / 255;	

%--
% get extension type color
%--

switch (type)
	
	case 'sound_browser_palette'
		color = (2 * light_gray + 4 * [1 1 0.1]) / 6; 
		
	case 'image_filter'
		color = (2 * light_gray + 4 * [1 0.75 0.1]) / 6;
		
	case 'signal_filter'
		color = (2 * light_gray + 4 * [1 0.2 0.0]) / 6;
		
	case 'sound_feature'
		color = fliplr(0.9 * (2 * light_gray + 3 * [0.5 0.8 0.15]) / 5);
		
	case 'sound_detector'
		color = 0.9 * (2 * light_gray + 3 * [0.5 1 0.15]) / 5;
		
	case 'root'
		color = [0.4 0.4 0.7] + 0.2;
		
	otherwise
		color = light_gray;
		
end
