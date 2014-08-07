function page = read_sound_page(sound, page, channels)

% read_sound_page - read scan page from sound
% -------------------------------------------
%
% page = read_sound_page(sound, page, channels)
%
% Input:
% ------
%  sound - sound
%  page - scan page
%  channels - channels
%
% Output:
% -------
%  page - sound page (contains samples and channels information)

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

%-------------------
% HANDLE INPUT
%-------------------

%--
% set default to read all channels
%--

if (nargin < 3)
	channels = [];
end

%-------------------
% READ SOUND PAGE
%-------------------

%--
% add channels to page
%--

page.channels = channels;

%--
% read page samples and add to page, also add sample rate
%--

page.samples = sound_read(sound, 'time', page.start, page.duration, page.channels);

page.rate = get_sound_rate(sound);
