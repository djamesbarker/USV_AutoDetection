function [handles, context] = on__play__update(widget, data, parameter, context)

% SPECTRUM - on__play__update

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

handles = [];

ax = spectrum_axes(widget);

%--
% update time display
%--

time = get_play_time(context.par); 

set(get(ax, 'title'), 'string', sec_to_clock(time));

%--
% update current spectrum
%--

im = data.browser.images;

if iscell(im)
	im = im{1};
end

im = im(1);

slice = get_spectrogram_slices(im, time);

if isempty(slice)
	return;
end

%--
% update display
%--

nyq = get_sound_rate(context.sound) / 2;

play_line(ax, ...
	'xdata', linspace(0, nyq, numel(slice)), ...
	'ydata', slice ...
);

