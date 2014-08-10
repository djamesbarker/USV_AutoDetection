function handles = view__display(par, feature, parameter, context)

% AMPLITUDE - view__display

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
% SETUP
%-------------------

% NOTE: this offset computation removes visible gaps in feature display

% feature.time(end) = 2 * feature.time(end) - feature.time(end - 1);

%--
% compute common time sequence for patch display
%--

x = [feature.time, fliplr(feature.time)]';

%--
% get some colors
%--

% NOTE: these will be parameters eventually

color.max = 0.85 * ones(1, 3);
	
color.abs = [0.75, 0, 0];

color.wave = [0, 0.75, 0];
	
%-------------------
% DISPLAY
%-------------------

%--
% alias page and initialize handles
%--

page = context.page;

handles = [];

%--
% loop over page channels
%--

for k = 1:length(page.channels)
	
	%--
	% get and update axes
	%--
	
	ax = findobj(par, 'type', 'axes', 'tag', int2str(page.channels(k)));
	
	% NOTE: there is no place to display channel information, continue;
	
	if isempty(ax)
		continue; 
	end
	
	% TODO: make the setting of the 'ylim' more intelligent, non-contractive
	
	set(ax, ...
		'xlim', [page.start, page.start + page.duration], ...
		'ylim', 1.25 * [min(feature.max.value(:, 1, k)), max(feature.max.value(:, 2, k))] ...
	);

	%--
	% display waveform if necessary
	%--
	
	if ~isempty(feature.wave)
			
		target_length = 1000;

		if length(feature.wave) < target_length
			feature.wave = resample(feature.wave, target_length, length(feature.wave));
		end
		
		L = length(feature.wave);

		t = linspace(page.start, page.start + page.duration, L); 

		handles(end + 1) = line(t', feature.wave);	

		set(handles(end), ...
			'parent', ax, ...
			'color', 0.5 * ones(1, 3) ...
		);
	
		continue;

	end

	%--
	% display min and max sequences
	%--

	y = [feature.max.value(:, 1, k); flipud(feature.max.value(:, 2, k))];
	
	handles(end + 1) = patch(x, y, color.max);
	
	set(handles(end), ...
		'parent', ax, ...
		'facecolor', 0.85 * ones(1, 3), ...
		'edgecolor', 0.5 * ones(1, 3) ...
	);
	
	%--
	% display RMS sequence
	%--
	
	% NOTE: this is a single positive sequence, present it as symmetric

	y = [-feature.rms.value(:, k); flipud(feature.rms.value(:, k))];
	
	handles(end + 1) = patch(x, y, color.max);
	
	set(handles(end), ...
		'parent', ax, ...
		'facecolor', 0.70 * [0.7 0.7 1], ...
		'edgecolor', 0.70 * [0 0 1] ...
	);

	%--
	% display positive and negative mean sequences
	%--
	
	y = [feature.abs.value(:, 1, k); flipud(feature.abs.value(:, 2, k))];
	
	handles(end + 1) = patch(x, y, color.max);
	
	set(handles(end), ...
		'parent', ax, ...
		'facecolor', 0.85 * [0.7 0.7 1], ...
		'edgecolor', 0.85 * [0 0 1] ...
	);
		
end
