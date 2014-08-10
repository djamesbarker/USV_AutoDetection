function [event,context] = compute(page,parameter,context)

% AMPLITUDE ACTIVITY - compute

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

%---------------------------------
% SETUP
%---------------------------------

%--
% get sound, rate, and duration
%--

sound = context.sound;

rate = get_sound_rate(sound);

duration = get_sound_duration(sound);

%--
% use filtered samples if available
%--

if ~isempty(page.filtered)
	page.samples = page.filtered;
end

%---------------------------------
% SCAN BLOCKS
%---------------------------------

event = empty(event_create);

state = 0;

%--
% convert scan start and duration to samples
%--

x = 1;

dx = length(page.samples);

%--
% compute samples per block and number of blocks
%--

dxp = round(parameter.block * rate);

m = dx / dxp;

%--
% loop over blocks
%--

for k = 0:(m - (2 * parameter.window + 1))

	%---------------------------------
	% GET SAMPLES
	%---------------------------------

	if (k == 0)

		%--
		% set sample start and duration
		%--

		xk = x;

		dxk = dxp * (2 * parameter.window + 1);

		%--
		% read samples into window and separate decision block
		%--

		window = abs(page.samples(xk:(xk + dxk)));

		block = window((parameter.window * dxp):((parameter.window + 1) * dxp) - 1,:);

	else

		%--
		% set sample reading start and duration
		%--

		xk = x + ((k + (2 * parameter.window)) * dxp);

		dxk = dxp;

		%--
		% read samples into window and separate decision block
		%--

		window = [window(dxp + 1:end,:); abs(page.samples(xk:(xk + dxk)))];

		block = window((parameter.window * dxp):((parameter.window + 1) * dxp) - 1,:);

	end

	%---------------------------------
	% MAKE DECISION FOR BLOCK
	%---------------------------------

	%--
	% compute percentile value in window and fraction of block that exceeds this
	%--

	value = fast_rank(window, parameter.percent); % percentile value in window
	
	concentration = sum(block > value) / dxp; % fraction exceeding percentile in decision block

	%--
	% set threshold depensing on detection state
	%--

	if (state)
		threshold = parameter.relax * parameter.fraction;
	else
		threshold = parameter.fraction;
	end

	%---------------------------------
	% RECORD RESULT AS EVENT
	%---------------------------------

	%--
	% block is signal
	%--

	if (concentration > threshold)

		%--
		% extend detection
		%--

		if state

			%--
			% update time selection
			%--

			event(end).time(2) = event(end).time(2) + parameter.block;

			event(end).duration = event(end).duration + parameter.block;

		%--
		% new detection
		%--

		else

			%--
			% set detection state
			%--

			state = 1;
			
			%--
			% new event
			%--
			
			base = event_create;

			base.channel = page.channels;

			start = (k + parameter.window) * parameter.block;

			base.time = [start, start + parameter.block];

			base.duration = parameter.block;

			% NOTE: this detector sets arbitrary frequency bounds

			stop = 0.4 * rate;

			base.freq = [0, stop];

			base.bandwidth = stop;

			%--
			% add new event to event array
			%--

			event(end + 1) = base;

		end

	%--
	% block is not signal
	%--

	else

		%--
		% we are done with this event we can now refine
		%--
		
		if state && parameter.refine
			
			event(end) = event_refine(event(end), sound, rate, duration);

		end

		%--
		% set detection state
		%--
		
		state = 0;

	end


end


%---------------------------------------------
% EVENT_REFINE
%---------------------------------------------

function event = event_refine(event, sound, rate, duration)

% event_refine - tighten event using energy distribution
% ------------------------------------------------------
%
% event = event_refine(event, rate, duration)
%
% Input:
% ------
%  event - input event
%  rate - sound rate
%  duration - sound duration
%
% Output:
% -------
%  event - refined event

%--
% measure time frequency quartiles
%--

% TODO: configure measurement using context

event = quartiles_measurement('batch', sound, event, quartiles_measurement);

if isempty(event.measurement)
	return;
end

%--
% refine event using time frequency quartiles
%--

value = event.measurement.value;

if ~isempty(value)

	%--
	% refine time extent
	%--

	q1 = value.time_q1; 
	
	q3 = value.time_q3; 
	
	off = 1.5 * value.time_iqr;

	time1 = event.time;
	
	event.time = [max(q1 - off, 0), min(q3 + off, duration)];

	time2 = event.time;
	
	event.duration = diff(event.time);

	%--
	% refine frequency extent
	%--

	q1 = value.freq_q1;

	q3 = value.freq_q3;

	off = 1.5 * value.freq_iqr;

	event.freq = [max(q1 - off, 0), min(q3 + off, rate / 2)];

	event.bandwidth = diff(event.freq);

	%--
	% clear computed measurement since it is no longer valid
	%--

	event.measurement = measurement_create;

end
