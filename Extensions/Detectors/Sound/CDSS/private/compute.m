function [event, context] = compute(page, parameter, context)

% CDSS - compute

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

% TODO: add duration and bandwidth range controls, possibly other controls

% TODO: create model based selection criteria, how much energy can we
% account for with the model ... this requires faster models

event = empty(event_create); 

%---------------------------------------
% SETUP
%---------------------------------------

%--
% create base event
%--

base = event_create;

%--
% rename filtered samples for convenience
%--

if ~isempty(page.filtered)
	page.samples = page.filtered;
end

%---------------------------------------
% DETECT
%---------------------------------------

%--
% compute page spectrogram and resolution
%--

[X, freq] = fast_specgram(page.samples, [], 'power', context.sound.specgram);

[dt, df] = specgram_resolution(context.sound.specgram, get_sound_rate(context.sound));

% NOTE: this time step seems more accurate

dt = page.duration / (size(X, 2) - 1);

bins = size(X, 1);

%--
% compute spectrogram components
%--

ext = get_browser_extension('image_filter', context.par, 'Components');

% NOTE: this is a component labelled image

Y = apply_image_filter(X, ext);

%--
% get component spectrogram
%--

% NOTE: this contains spectrogram values at the components

Z = (Y > 0) .* X;

%--
% get component events 
%--

component = empty(component_create);

% NOTE: this allows faster component search using only non-zeros

[R, C, V] = find(Y); label = unique(V);

for k = 1:length(label)
	
	%--
	% get label row and column indices and limits
	%--
	
	ix = find(V == label(k)); r = fast_min_max(R(ix)); c = fast_min_max(C(ix));
	
	%--
	% filter events using component qualities
	%--
	
	if (diff(r) * dt < 0.05)
		continue;
	end
	
	%--
	% get component elements
	%--
	
	% NOTE: get component image, use label as id to connect to event
	
	component(end + 1).id = label(k);
	
	% NOTE: remove points belonging to other components
	
	ZC =  Z(r(1):r(2), c(1):c(2)) .* (Y(r(1):r(2), c(1):c(2)) == label(k));
	
	component(end).line = component_line(ZC);
	
	component(end).image = ZC;
	
	component(end).amplitude = sqrt(sum(ZC, 1) / bins);
	
	%--
	% pack component event
	%--
	
	% NOTE: we store the label in the event id
	
	base.id = label(k);
	
	base.channel = page.channels;
	
	base.time = dt * (c - 1);
	
	base.duration = diff(base.time);
	
	base.freq = df * (r - 1);
	
	base.bandwidth = diff(base.freq);
	
	event(end + 1) = base;
	
	%--
	% stick event in component
	%--
	
	component(end).event = base;

end

%------------------------------
% EXPLAIN
%------------------------------
	
%--
% gather explain
%--

data.time = [page.start, page.start + page.duration];

data.dt = dt; data.df = df;

data.spectrogram = X;

data.component_spectrogram = Z;

data.signal_amplitude = sqrt(sum(X, 1) / bins);

data.component_amplitude = sqrt(sum(Z, 1) / bins);

%----------------------------

data.event = event; 

data.component = component;

%--
% pack explain
%--

context.explain.data = data;


%------------------------------------------------------------------------
% COMPONENT_CREATE
%------------------------------------------------------------------------

function component = component_create

component.id = []; 

component.line = []; 

component.image = [];

component.model = [];

component.amplitude = [];


%------------------------------------------------------------------------
% COMPONENT_LINE
%------------------------------------------------------------------------

function y = component_line(Z)

%--
% get column peak indices
%--

[ignore, y] = max(Z, [], 1);

y = y(:)';

%--
% filter frequency line
%--

% NOTE: this form of padding should be integrated into filtering

n = 2;

y = [y(1) * ones(1, n), y, y(end) * ones(1, n)];

y = median_filter(y(:)', ones(1, 2*n + 1));

y = y(n + 1:end - n);


%------------------------------------------------------------------------
% GET_EVENT_CONTOUR
%------------------------------------------------------------------------

function contour = get_event_contour(page, event, parameter)

% get_event_contour - get freqency contour for event
% --------------------------------------------------
%
% contour = get_event_contour(page, event, parameter)
%
% Input:
% ------
%  page - event page
%  event - event
%  parameter - parameter
%
% Output:
% -------
%  contour - event contour

%--
% get event samples
%--

ix = round(page.rate * event.time); ix(1) = max(ix(1),1); ix(2) = min(ix(2),length(page.samples));

X = page.samples(ix(1):ix(2));

%--
% compute event spectrogram
%--

opt = fast_specgram; opt.hop = 0.025;

[B, freq, time] = fast_specgram(X, page.rate, 'power', opt);

%--
% filter event spectrogram
%--

ext = components;

B = ext.fun.compute(B, [], []);

%--
% get points of interest
%--

contour.time = time + event.time(1);

type = 'peak';

switch (type)

	case ('test')
		
		contour.freq = max_mean(B, 1, freq);
		
	case ('peak')

		[ignore, fix] = max(B, [], 1);

		contour.freq = freq(fix)';

	case ('mean')

		B = B * diag(1 ./ sum(B,1)); freq = freq(:)' * B;

		contour.freq = freq;

end


%------------------------------------------------------------------------
% MAX_MEAN
%------------------------------------------------------------------------

function value = max_summary(type, B, n, grid)

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% check summary type
%--

types = {'mean', 'median'};

if ~ismember(type, types)
	error('Unrecognized summary type.');
end 

%----------------------------
% COMPUTE MAX SUMMARY
%----------------------------

%---
% get range for image
%--

b = fast_min_max(B);

%--
% get top column maxima
%--

for k = 1:(2 * n + 1)
	
	%--
	% get max value from each column
	%--
	
	[weight(k,:), vix] = max(B, [], 1);
	
	value(k,:) = grid(vix);
	
	%--
	% set current column max to min
	%--
	
	for j = 1:length(vix)
		B(vix(j),j) = b(1);
	end
	
end

%--
% compute max summary
%--

switch type
	
	case ('mean')
		weight = weight * diag(1 ./ sum(weight, 1)); value = sum(weight .* value, 1);

	case ('median')
		value = sort(value, 1); value = value(n + 1,:);
		
end


% %-------------------
% % AMPLITUDE
% %-------------------
% 
% rows = round(page.rate * parameter.block); 
% 
% cols = ceil(length(page.samples) / rows);
% 
% page.samples(end:(rows * cols)) = 0;
% 
% % NOTE: this computes a sequence of RMS amplitude estimates
% 
% blocks = reshape(page.samples, rows, cols);
% 
% select = blocks > 0; blocks = blocks.^2;
% 
% feature = sum(blocks, 1) ./ rows; feature = sqrt(feature);
% 
% feature_up = sum(blocks .* select, 1) ./ sum(select, 1); feature_up = sqrt(feature_up);
% 
% feature_down = sum(blocks .* ~select, 1) ./ sum(~select, 1); feature_down = sqrt(feature_down);


% %-------------------
% % DECISION
% %-------------------
% 
% %--
% % threshold feature
% %--
% 
% detection = double(feature > parameter.threshold);
% 
% if parameter.dilate
% 	
% 	SE = ones(1, 2 * parameter.width + 1);
% 	
% 	detection = morph_dilate(detection, SE);
% 
% end
% 
% %--
% % find threshold defined event boundaries
% %--
% 
% edges = diff([0, detection, 0]);
% 
% start = find(edges > 0); stop = find(edges < 0) + 1;

