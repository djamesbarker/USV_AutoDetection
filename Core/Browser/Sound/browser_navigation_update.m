function browser_navigation_update(par,data)

% browser_navigation_update - update navigation menus
% ---------------------------------------------------
%
% browser_navigation_update(par)
%
% Input:
% ------
%  par - browser handle

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
% $Revision: 1655 $
% $Date: 2005-08-25 10:08:38 -0400 (Thu, 25 Aug 2005) $
%--------------------------------

%-----------------------------------
% SETUP
%-----------------------------------

slider = get_time_slider(par); 

time = slider.value; 

page = data.browser.page;

sound = data.browser.sound;

top = get_menu(par,'View');

sibs = get(get_menu(top,'Navigate'),'children');

%-----------------------------------
% BACK NAVIGATION
%-----------------------------------

%--
% start of sound
%--

if (~time)
	state = 'off';
else
	state = 'on';
end 

%--
% update menubar menus
%--

set(get_menu(sibs,'First Page'),'enable',state);

set(get_menu(sibs,'Previous Page'),'enable',state);

%--
% update file navigation for multiple sound files
%--

if (~strcmpi(sound.type,'file'))
	set(get_menu(sibs,'Previous File'),'enable',state);
end

%-----------------------------------
% FORWARD NAVIGATION
%-----------------------------------

%--
% check for end of sound
%--

if (time + page.duration >= get_sound_duration(sound))
	state = 'off';
else
	state = 'on';
end

%--
% update menubar menus
%--

set(get_menu(sibs,'Last Page'),'enable',state);

set(get_menu(sibs,'Next Page'),'enable',state);

%--
% update file navigation for multiple file sounds
%--

if (~strcmpi(sound.type,'file'))
	set(get_menu(sibs,'Next File'),'enable',state);	
end

