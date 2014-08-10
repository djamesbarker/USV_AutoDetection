function y = play_clip(pal)

% play - create and play signal for sound using parameters
% --------------------------------------------------------
%
% y = play_clip(pal)
%
% Input:
% ------
%  pal - palette handle

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
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

% TODO: set proper 'xlim' on display axes so that we can draw the play line
% on the display

% TODO: check for availability of 'clip'

%--
% get parameters and sound
%--

[ignore, templates] = control_update([], pal, 'templates');

par = get_field(get(pal, 'userdata'), 'parent');

data = get(par, 'userdata');

%--
% get clip and other relevant data
%--

rate = data.browser.sound.samplerate;

speed = data.browser.play.speed;

clip = templates.clip(templates.ix);

%--
% play clip
%--

ax = findobj(pal, 'tag', 'templates', 'type', 'axes');

%--------------------------------------------

%--
% create temp sound from clip
%--

temp_file = [tempname, '.wav'];

sound_file_write(temp_file, clip.data, clip.samplerate); 

temp = sound_create('file', temp_file);

p = sound_player( ...
	temp, 'time', 0, clip.event.duration, [], data.browser.play.speed, [], [0, ax, 1] ...
);

start(p);

% NOTE: something could go wrong here
delete(temp_file);

%--------------------------------------------

