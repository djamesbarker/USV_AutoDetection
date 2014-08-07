function color = control_colors

% control_colors - colors used in rendering controls
% --------------------------------------------------
%
% color = control_colors
%
% Output:
% -------
%  color - structure with control color information

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
% $Revision: 1902 $
% $Date: 2005-10-04 15:58:03 -0400 (Tue, 04 Oct 2005) $
%--------------------------------

%----------------------------------------------
% PERSISTENT COPY
%----------------------------------------------

persistent PERSISTENT_CONTROL_COLORS;

if (~isempty(PERSISTENT_CONTROL_COLORS))
	
	color = PERSISTENT_CONTROL_COLORS; return;
	
end

%----------------------------------------------
% SET COLOR CONSTANTS
%----------------------------------------------

% NOTE: highlight color is applied to background

%--
% generic colors
%--

BLACK = [0 0 0]; WHITE = [1 1 1];

MEDIUM_GRAY = (BLACK + WHITE) ./ 2;

LIGHT_GRAY  = (BLACK + 2 * WHITE) ./ 3; 

%--
% matlab colors
%--

FIGURE_COLOR = get(0,'DefaultUicontrolBackgroundColor');

%--
% specific colors
%--

% NOTE: this color is used to highlight various objects

HIGH_COLOR = [1 1 0.8];

LCD_COLOR = [214, 219, 191] ./ 255;

%----------------------------------------------
% SET CONTROL COLORS
%----------------------------------------------

%--
% axes, listboxes, and menus
%--

back = LCD_COLOR; fore = BLACK; high = (LCD_COLOR + HIGH_COLOR) ./ 2;

types = {'axes','listbox','popupmenu'};

color = add_type_colors([],types,back,fore,high);

%--
% edit boxes 
%--

back = WHITE; fore = BLACK; high = HIGH_COLOR;

types = {'edit'};

color = add_type_colors(color,types,back,fore,high);

%--
% sliders
%--

% NOTE: we are using the complement of the highlight color for the sliders

back = LIGHT_GRAY; fore = BLACK; high = (2 * LIGHT_GRAY + (1 - HIGH_COLOR)) ./ 3;

types = {'slider'};

color = add_type_colors(color,types,back,fore,high);

%--
% set persistent control colors
%--

PERSISTENT_CONTROL_COLOR = color;


%----------------------------------------------
% TYPE COLORS
%----------------------------------------------

% NOTE: we add control type colors to color structure

function color = add_type_colors(color,types,back,fore,high)

%--
% handle input
%--

% NOTE: allow simple empty, use it to clear variable

if (isempty(color))
	clear color;
end

% TODO: add color checking here, consider allowing names

%-- 
% add fields to color structure for given control types
%--

for k = 1:length(types)
	
	color.(types{k}).back = back; 
	color.(types{k}).fore = fore;
	color.(types{k}).high = high;
	
end 


