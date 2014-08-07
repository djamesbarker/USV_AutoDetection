function update_navigate_palette(par, data)

% update_navigate_palette
% ----------------------
% 
% update_navigate_palette(par)
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

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% get browser state if needed
%--

if (nargin < 2) || isempty(data)
	data = get_browser(par);
end

%--
% check for navigate palette
%--

% NOTE: the palette is typically closed so this code is often skipped

pal = get_palette(par, 'Navigate', data);

if isempty(pal)
	return;
end

%----------------------------
% UPDATE NAVIGATE CONTROLS
%----------------------------

sound = data.browser.sound; 

%---------------
% TIME
%---------------

slider = get_time_slider(par);

set_control(pal, 'Time', 'value', slider.value);

%---------------
% FILE
%---------------

%--
% get current file
%--

% NOTE: we get the sound time using the slider time to get the file

[file, ix] = get_current_file(sound, slider.value);

%--
% set file navigation controls
%--

set_control(pal, 'File', 'value', file);

if ix == 1
	set_control(pal, 'Prev File', 'enable', 'off');
else
	set_control(pal, 'Prev File', 'enable', 'on');
end

if ix == length(sound.file)
	set_control(pal, 'Next File', 'enable', 'off');
else
	set_control(pal, 'Next File', 'enable', 'on');
end

%-------------------
% SESSION
%-------------------

ix = get_current_session(sound, slider.value);

if isempty(ix)
	
	set_control(pal, 'Prev Time-Stamp', 'enable', 'off');
	
	set_control(pal, 'Next Time-Stamp', 'enable', 'off');
	
	return;
	
end

set_control(pal, 'time_stamp', 'index', ix);

if ix == 1
	set_control(pal, 'Prev Time-Stamp', 'enable', 'off');
else
	set_control(pal, 'Prev Time-Stamp', 'enable', 'on');
end

if ix == length(get_sound_sessions(sound))
	set_control(pal, 'Next Time-Stamp', 'enable', 'off');
else
	set_control(pal, 'Next Time-Stamp', 'enable', 'on');
end
	

