function [handles, context] = on__selection__create(widget, data, parameter, context)

% SPECTRUM - on__selection__create

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

im = data.browser.images; im = im(1);

%--
% get spectrogram slices
%--

slices = get_spectrogram_slices(im, data.selection.event.time);

%--
% update display
%--

ax = spectrum_axes(widget); nyq = get_sound_rate(context.sound) / 2;

if ~isempty(ax)
	
	%--
	% display spectrum
	%--
	
	selection_line(ax, ...
		'color', data.selection.color, ...
		'xdata', linspace(0, nyq, size(slices, 1)), ...
		'ydata', mean(slices, 2) ...
	);

	%--
	% display frequency guides
	%--
	
	[low, high] = frequency_guides(ax, ...
		'color', context.display.grid.color ...
	);
	
	set(low, ...
		'xdata', data.selection.event.freq(1) * ones(1, 2), ...
		'ydata', get(ax, 'ylim') ...
	);

	set(high, ...
		'xdata', data.selection.event.freq(2) * ones(1, 2), ...
		'ydata', get(ax, 'ylim') ...
	);

end
