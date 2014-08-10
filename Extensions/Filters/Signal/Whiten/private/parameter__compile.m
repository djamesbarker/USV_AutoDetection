function [parameter, context] = parameter__compile(parameter, context)

% WHITEN - parameter__compile

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

% NOTE: this is a context heavy compilation, we bail often!

%--
% check page context
%--

% NOTE: we cannot compile without page context

if ~isfield(context, 'page')
	return;
end

page = context.page;

% NOTE: we need the single channel pages when we compile for this filter

if length(page.channels) > 1
	return;
end

%--
% collect relevant data
%--

data = [];

if ~parameter.use_log
	
	%--
	% use page samples as data
	%--
	
% 	events = get_quiet_sections(page, context);
	
	% NOTE: in case of no log use page data as noise source
	
	% TODO: consider if we have and want to use a selection
	
	% TODO: consider a simple thresholding and closing selection of samples
		
	%--
	% check for page samples, read if necessary
	%--
	
	if isfield(page, 'samples')
		data = page.samples;
	else
		data = sound_read(context.sound, 'time', page.start, page.duration, page.channels);
	end
	
else
	
	%--
	% get page-relevant events
	%--
	
	event = get_noise_events(parameter, context);

	if isempty(event)
		return;
	end
	
	%--
	% get noise data from noise log events
	%--
	
	% NOTE: this reads and stores event samples
	
	event = event_sound_read(event, context.sound);
	
	% NOTE: columns are harder to concatenate than rows?
	
	data = event(1).samples;
	
	for k = 2:length(event)
		data = [data; event(k).samples];
	end
	
end

% NOTE: return if we were unable to collect data

if isempty(data)
	return;
end

%--
% get model from data and update parameter filter
%--

% NOTE: this is the background model filter

model.a = aryule(data, parameter.order);

% NOTE: mitigate filtering if using regularization
	
model.a = model.a .* ((1 - parameter.r) .^ (0:parameter.order));
	
model.b = 1;

% NOTE: our filter is actually the inverse filter

parameter.filter.b = model.a;

parameter.filter.a = model.b;

%--
% add lowpass filter if needed
%--

if parameter.lowpass
	
	%--
	% get lowpass filter from extension
	%--
	
	% NOTE: providing a better way to do this would be great
	
	ext = get_browser_extension('signal_filter', context.par, 'Lowpass');
	
	ext.parameter.max_freq = parameter.max_freq;
	
	nyq = 0.5 * get_sound_rate(context.sound);
	
	ext.parameter.transition = 0.25 * (nyq - parameter.max_freq);
	
	ext.parameter = ext.fun.parameter.compile(ext.parameter, context);
	
	%--
	% compose model and lowpass filters
	%--
	
	parameter.filter.b = conv(parameter.filter.b, ext.parameter.filter.b);
	
end
