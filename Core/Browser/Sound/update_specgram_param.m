function data = update_specgram_param(par, data, update)

% update_specgram_param - adapt spectrogram parameters
% ----------------------------------------------------
%
% data = update_specgram_param(par, data, update)
%
% Input:
% ------
%  par - browser
%  data - state
%  update - update browser state
%
% Output:
% -------
%  data - updated browser state

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

%------------------
% HANDLE INPUT
%------------------

if nargin < 3
	update = 0;
end

if nargin < 1
	
	par = get_active_browser;
	
	if isempty(par)
		return; 
	end

end

if nargin < 2
	data = get_browser(par); update = 1;
else
	update = max(update, 0);
end

%------------------
% SETUP
%------------------

%--
% create persistent table of better fft sizes
%--

persistent BETTER_SIZES;

if isempty(BETTER_SIZES)
	BETTER_SIZES = better_fft_sizes(16, 4096);
end

%--
% get target size
%--

% NOTE: how do we know we have this? when do we store this?

size = get_env(['specgram_size_', md5(get(par, 'tag'))]);

%--
% extract variables for convenience
%--

param = data.browser.specgram;

page = data.browser.page;

sound = data.browser.sound;

%------------------
% ADAPT PARAMETERS
%------------------

%--
% adapt frequency resolution (computation)
%--

ix = find(BETTER_SIZES >= param.fft, 1); 

if isempty(ix)
	return;
end
	
param.fft = BETTER_SIZES(ix);
	
%--
% adapt time resolution
%--

if ~(param.hop_auto || param.sum_auto)
	param.sum_length = 1; return;
end

% NOTE: this uses 'hop_auto' and 'sum_auto' to see what to update

param = update_time_resolution(sound, page.duration, param, size);

%--
% update browser state variable
%--

data.browser.specgram = param;
	
data.browser.sound.specgram = param;

%------------------
% UPDATE BROWSER
%------------------

% NOTE: check if we need to update

if ~update
	return;
end

%--
% set browser state
%--

set(par, 'userdata', data);

%--
% check for spectrogram palette
%--

pal = get_palette(par, 'Spectrogram');

if ~isempty(pal)

	%--
	% update controls
	%--

	set_control(pal, 'Size', 'value', param.fft);

	set_control(pal, 'Advance', 'value', param.hop);

	%--
	% update window display
	%--

	window_plot([], pal, data); drawnow;

end

%--
% check for data template detector palette
%--

pal = get_palette(par, 'Data Template');

if ~isempty(pal)
	plot_clip(pal);
end
