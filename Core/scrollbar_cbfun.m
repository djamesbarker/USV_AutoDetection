function scrollbar_cbfun

% scrollbar_cbfun - callback function for scrollbar
% -------------------------------------------------

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
% set figure handle
%--

h = gcf;

%--
% get scrollbar value and update time
%--

data = get(h,'userdata');
data.browser.time = get(gcbo,'value');
set(h,'userdata',data);

%--
% update display
%--

browser_display(h,'update',data);

%--
% enable and disable navigation menus
%--

if (data.browser.time <= data.browser.page.duration / 1000)
	state = 'off';
else
	state = 'on';
end 

set(get_menu(h,'First Page',2),'enable',state);
set(get_menu(h,'Previous Page',2),'enable',state);

if (~strcmp(data.browser.sound.type,'File'))
	set(get_menu(h,'Previous File',2),'enable',state);
end

if (data.browser.time + data.browser.page.duration == data.browser.sound.duration)
	state = 'off';
else
	state = 'on';
end

set(get_menu(h,'Last Page',2),'enable',state);
set(get_menu(h,'Next Page',2),'enable',state);

if (~strcmp(data.browser.sound.type,'File'))
	set(get_menu(h,'Next File',2),'enable',state);
end

