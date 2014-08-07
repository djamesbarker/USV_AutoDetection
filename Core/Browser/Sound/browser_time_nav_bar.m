function h = browser_time_nav_bar(g)

% browser_time_nav_bar - time navigation buttons for browser
% ----------------------------------------------------------
%
% h = browser_time_nav_bar(g)
%
% Input:
% ------
%  g - handle to figure to control
%
% Output:
% -------
%  h - handle to toolbar figure

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
% set figure to control and ensure that it has image_menu
%--

if (nargin < 1)
	g = gcf;
end

%--
% create toolbar
%--

h = figure;

T = {'Move backwards in time (Ctrl+B)', ...
	'Move forward in time (Ctrl+F)', ...
	'Change page duration and overlap' ...
};

button_group(h, ...
	'browser_sound_menu', ...
	'Time Navigation', ...
	{'Previous Page','Next Page','Page Options ...'}, ...
	[],{'B','F',''},g,T);

%--
% close toolbar when controlled figure is closed
%--

close_fun = get(g,'CloseRequestFcn');
set(g,'CloseRequestFcn',['delete(' num2str(h) '); ' close_fun]);
