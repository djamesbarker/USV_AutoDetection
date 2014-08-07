function data = get_widget_data(par, event, data)

% get_widget_data - get data for widget that handles event
% --------------------------------------------------------
%
% data = get_widget_data(par, event, data)
%
% Input:
% ------
%  par - widget parent
%  event - event data
%  data - parent state
%
% Output:
% -------
%  data - parent event data

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

%--------------------
% HANDLE INPUT
%--------------------

%--
% check event
%--

if ~ismember(event, get_widget_events)
	error('Unrecognized widget event.');
end

%--
% get parent data if needed
%--

if (nargin < 3) || isempty(data)
	data = get_browser(par);
end

%--------------------
% GET DATA
%--------------------

%--
% provide easy to use state data for widget
%--

% NOTE: some of these ideas will be integrated into state, so update is not required

sound = data.browser.sound;

% NOTE: is this currently done during context construction? in any case, it should!

sound.rate = get_sound_rate(sound);

page.start = data.browser.time;

page.duration = data.browser.page.duration;

page.channels = get_channels(data.browser.channels);

% NOTE: page we use in most parts of system does not include this field

page.freq = data.browser.page.freq;

if isempty(page.freq)
	page.freq = [0, 0.5 * sound.rate];
end

%--
% SELECTION
%--

%--
% pack state data
%--

data.sound = sound;

data.page = page;

data.selection = data.browser.selection;

[data.buffer, data.player] = get_player_buffer;

% TODO: provide structured spectrogram data, handles and options
		
data.spectrogram = data.browser.images;

%--
% page event specific data
%--

return;

% TODO: make this as dry as possible, 'events' should handle their own special requests

switch event
	
	case 'page'
		
	case 'timer'
	
	case 'play__start'
	
	case 'play__update'
		
	case 'play__stop'
		
	case 'selection__create'
		
	case 'selection__edit__start'
		
	case 'selection__edit__update'

	case 'selection__edit__stop'

end
