function slider = update_time_slider(par, data)

% update_time_slider - update browser time slider
% -----------------------------------------------
%
% slider = update_time_slider(par, data)
%
% Input:
% ------
%  par - parent handle
%  data - parent state
%
% Output:
% -------
%  slider - updated time slider

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

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% check browser input
%--

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

%--
% get parent state if needed
%--

if (nargin < 2) 
	data = get(par, 'userdata');
end

%--
% get parts of state for convenience
%--

sound = data.browser.sound; page = data.browser.page; time = data.browser.time;

%----------------------------
% UPDATE SLIDER
%----------------------------

%--
% update max to reflect page duration
%--

slider_len = get_sound_duration(sound) - page.duration;

set_time_slider(par, 'max', slider_len);

%--
% update increment to reflect page duration
%--

slider_inc = (1 - page.overlap) * page.duration * [1, 5];

slider_inc = min(slider_inc, slider_len);

set_time_slider(par, 'slider_inc', slider_inc);

%--
% update time
%--

set_time_slider(par, 'value', time);

%--
% output fresh slider struct
%--

slider = get_time_slider(par);
