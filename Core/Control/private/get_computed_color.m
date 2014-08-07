function color = get_computed_color(control, pal)

% get_computed_color - compute control colors
% -------------------------------------------
%
% color = get_computed_color(control, pal)
%
% Input:
% ------
%  control - control
%  pal - control palette
%
% Output:
% -------
%  color - color struct

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
% $Revision: 3397 $
% $Date: 2006-02-03 19:55:30 -0500 (Fri, 03 Feb 2006) $
%--------------------------------

% TODO: implement preferences for colors, including high contrast colors

% TODO: consider preference input using palette options

% TODO: move to object names rather than literal names for named colors

%----------------------------------------
% SETUP
%----------------------------------------

%--
% named colors
%--

color.BLACK = [0, 0, 0];

color.MEDIUM_GRAY = [128, 128, 128] / 255;

color.LIGHT_GRAY  = [192, 192, 192] / 255;

color.WHITE = [255, 255, 255] / 255;

color.LCD_COLOR = [214, 219, 191] ./ 255;

%--
% palette color
%--

% NOTE: default uicontrol background is the expected palette figure color

if ((nargin < 2) || isempty(pal))
	color.FIGURE_COLOR = get(0,'DefaultUicontrolBackgroundColor');
else
	color.FIGURE_COLOR = get(pal,'Color');
end

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% return generic colors
%--

if ((nargin < 1) || isempty(control))
	return;
end

%----------------------------------------
% CONTROL COLOR
%----------------------------------------

style = control.style;

%--
% set black as default text color
%--

color.text = color.BLACK;

%--
% set control background directly
%--

if ~isempty(control.color)
	
	switch (style)
		
		% NOTE: the slider is a composite control, hence the structured color
		
		case ('slider')
			
			color.slider.back = control.color; color.edit.back = color.WHITE;
			
		otherwise
			
			if ~ischar(control.color)
				
				color.(style).back = control.color; 
				
			else
				
				switch control.color
					
					case '__TRANSPARENT__'
						color.(style).back = color.FIGURE_COLOR;	
						
					case '__LCD__'
						color.(style).back = color.LCD_COLOR;
						
				end
				
			end
			
	end
	
	return; 
	
end

%--
% set background color information based on control style
%--

switch (style)
	
	case ({'axes','listbox','popup','waitbar'})
		color.(style).back = color.LCD_COLOR;
		
	case ('edit')
		color.(style).back = color.WHITE;
	
	case ('separator')
		color.(style).back = (color.LIGHT_GRAY + color.FIGURE_COLOR) / 2;
		
	% NOTE: the slider is a composite control, hence the structured color
	
	case ('slider')
		color.slider.back = color.LIGHT_GRAY; color.edit.back = color.WHITE;
		
	otherwise
		color.(style).back = color.FIGURE_COLOR;

end
