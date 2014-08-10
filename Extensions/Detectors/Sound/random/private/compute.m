function [event, context] = compute(page, parameter, context)

% RANDOM - compute

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

start = page.start + rand * page.duration;

duration = parameter.min_length + rand * (parameter.max_length - parameter.min_length);

new_event = event_create;

new_event.time = [start, start + duration];

new_event.freq = [100, page.rate/4];

new_event.score = rand;

new_event.channel = floor(1 + rand * context.sound.channels);

if rand > parameter.probability
	event(end + 1) = new_event;
end
