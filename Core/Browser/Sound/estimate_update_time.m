function t = estimate_update_time(browser)

% estimate_update_time - estimate browser display update time
%------------------------------------------------------------
%
% t = estimate_update_time(browser)
%
% Input:
% ------
% browser - handle to browser
%
% Output:
% -------
% t - time in seconds to update display

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
% Author: Matt Robbins
%--------------------------------
% $Revision$
% $Date$
%--------------------------------


%--
% handle input
%--

if ((nargin < 1) || (isempty(browser)))
	browser = gcf;
end
	
%--
% get browser data
%--

data = get_browser(browser);

%----------------------------
% SPECTROGRAM CREATION TIME
%----------------------------

dt = data.browser.page.duration;

fs = get_sound_rate(data.browser.sound);

% NOTE: speed is in units of samples per second

speed = get_env('mean_specgram_speed');  % NOTE: something like this might be a good idea

if isempty(speed)
	% NOTE: Magic Numbers are our friends!
	speed = 200000;
end
	
base = dt*fs/speed;	

%----------------------------
% FILTERING
%----------------------------

filter = 0;

%----------------------------
% ACTIVE DETECTION
%----------------------------

detect = 0;

t = base + filter + detect;
