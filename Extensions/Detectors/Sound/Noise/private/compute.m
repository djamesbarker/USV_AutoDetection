function [event, context] = compute(page, parameter, context)

% NOISE - compute

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

event = empty(event_create);

%---------------------------------
% SETUP
%---------------------------------

%--
% get sound, rate, and duration
%--

sound = context.sound;

rate = get_sound_rate(sound);

ch = page.channels;

%--
% use filtered samples if available
%--

if ~isempty(page.filtered)
	page.samples = page.filtered;
end

%--
% get amplitude feature if available
%--

feature = [];

%--
% try to get it from the page
%--

if ~isempty(page.feature)
	
	ix = find(strcmp({page.feature.name}, 'Amplitude'));
	
	if ~isempty(ix)
		
		t = page.feature(ix).value.time;

		env = page.feature(ix).value.rms.value(:, ch);
		
	end
		
end

%--
% otherwise, use default parameters and compute it
%--
	
if isempty(feature)
	
	context.active.sound_feature = get_browser_extension( ...
		'sound_feature', context.par, 'Amplitude' ...
	);
	
	page = feature_sound_page(page, context);
		
	t = page.feature(1).value.time;

	env = page.feature(1).value.rms.value(:);	

end

%--
% if there's no feature, there's nothing to do
%--

if isempty(feature)
	return;
end

%------------------------------------
% COMPUTE
%------------------------------------

%--
% find low-energy blocks
%--

low_erg = [0; [env < parameter.threshold]; 0];

starts = t(find([diff(low_erg) > 0])) - page.start;

stops = t(find([diff(low_erg) < 0]) - 1) - page.start;

%--
% create events
%--

base = event_create;

for k = 1:length(starts)
	
	base.channel = page.channels;

	base.time = [starts(k), stops(k)];

	base.duration = stops(k) - starts(k);
	
	%--
	% skip short events
	%--
	
	if base.duration < parameter.min_length
		continue;
	end

	% NOTE: this detector sets arbitrary frequency bounds

	stop = 0.4 * rate;

	base.freq = [0, stop];

	base.bandwidth = stop;

	%--
	% add new event to event array
	%--

	event(end + 1) = base;
	
end

	
	
	









