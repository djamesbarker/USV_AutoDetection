function set_browser_sound(par, sound, data)

%--
% handle input
%--

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

if nargin < 3
	data = get_browser(par);
end

info = get_browser_info(par);

%--
% set slider time and duration for new sound
%--

time = map_time(data.browser.sound, 'record', 'slider', data.browser.time);

%--
% set browser fields
%--

set_browser(par, data, 'time', time, 'sound', sound);

%--
% close browser
%--

close(par);

%--
% reopen and set time
%--

par = open_library_sound(info.sound, get_library_from_name(info.library));

set_browser_time(par, time, 'record');



