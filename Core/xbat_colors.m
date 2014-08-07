function color = xbat_colors(type)

% xbat_colors - get colors used in xbat interface
% -----------------------------------------------
%
% color = xbat_colors(type)
%
% Input:
% ------
%  type - specific color desired
%
% Output:
% -------
%  color - color structure of used colors or specific color vector

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
% $Revision: 6345 $
% $Date: 2006-08-29 18:58:37 -0400 (Tue, 29 Aug 2006) $
%--------------------------------

% make this code resemble other coonstructors when the color details are
% resolved

% %--
% % colors used in control group (handle this code using options to make the
% % code useful for general use
% %--
% 
% BLACK = [0, 0, 0];
% 
% MEDIUM_GRAY = [128, 128, 128] / 255;
% 
% LIGHT_GRAY  = [192, 192, 192] / 255;
% 
% WHITE = [255, 255, 255] / 255;
% 
% FIGURE_COLOR = get(0,'Defaultuicontrolbackgroundcolor');
% 
% %--
% % color updating code from browser_display
% %--
% 
% tmp = data.browser.grid.color;
% 			
% if ((sum(tmp) >= 0.8) | (max(tmp) >= 0.8))
% 	set(sli,'backgroundcolor',0.15 * ones(1,3) + 0.1);
% else
% 	set(sli,'backgroundcolor',get(0,'DefaultFigureColor') - 0.1);
% end 
% 
% %--
% % code from browser_view_menu to update figure color based on grid
% %--
% 
% %--
% % update figure color for light grid color
% %--
% 
% if ((sum(tmp) >= 0.8) | (max(tmp) >= 0.8))
% 	
% 	tmp = 0.15 * ones(1,3);
% 	if (get(h,'color') ~= tmp)
% 		set(h,'color',tmp);
% 		hs = findobj(h,'type','uicontrol');
% 		if (~isempty(hs))
% 			set(hs,'backgroundcolor',tmp + 0.1);
% 		end
% 	end
% 	
% else
% 	
% 	tmp = get(0,'DefaultFigureColor');
% 	if (get(h,'color') ~= get(0,'DefaultFigureColor'))
% 		set(h,'color',tmp);
% 		hs = findobj(h,'type','uicontrol');
% 		if (~isempty(hs))
% 			set(hs,'backgroundcolor',tmp - 0.1);
% 		end
% 	end
% 	
% end 

%-------------------------------------------------------
% CREATE TABLES
%-------------------------------------------------------

%--
% color schemes available
%--

schemes = { ...
	'default', ...
	'dark', ...
	'high' ...
};

%--
% color structure fieldnames
%--

% these are the different type of colors used in the system

color = struct( ...
	'figure', [], ...
	'text_fore', [], ...
	'text_highlight', [], ...
	'header_on', [], ...
	'header_off', [], ...
	'slider_fore', [], ...
	'slider_back', [] ...
};

%-------------------------------------------------------
% GET COLOR SCHEME
%-------------------------------------------------------

%--
% get current value and check
%--

color_scheme = get_env('xbat_color_scheme');
	
if ~isempty(color_scheme) && isempty(find(strcmp(color_scheme, scheme)))
	
	warning(['Unrecognized color scheme ''', color_scheme, ''' value. Value reset to ''default''.']);

end

%--
% set value of color scheme if empty
%--

if isempty(color_scheme)
	color_scheme = set_env('xbat_color_scheme', 'default');
end

%-------------------------------------------------------
% GET COLOR FROM SCHEME
%-------------------------------------------------------

switch color_scheme
	
	%--
	% default colors
	%--
	
	case 'default'
		
		color.figure = get(0,'defaultfigurebackgroundcolor');
		
% 		color.text_fore = 
% 		
% 		color.text_highlight = 
% 		
% 		color.header_on =
% 		
% 		color.header_off = 
% 		
% 		color.slider_fore = 
% 		
% 		color.slider_back = 
		
end
