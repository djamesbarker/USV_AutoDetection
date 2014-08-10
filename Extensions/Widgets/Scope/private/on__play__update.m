function [handles, context] = on__play__update(widget, data, parameter, context)

% SCOPE - on__play__update

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

%--
% get current scope time
%--

time = get_play_time(context.par); 

%--
% get scope samples from buffer
%--

% TODO: factor this into a helper

% NOTE: return if we can't get data to display

if isempty(data.buffer)
	handles = []; return;
end

rate = get(data.player, 'samplerate'); n = floor(parameter.duration * rate / data.buffer.speed);

buffer = data.buffer;
	
overflow = (buffer.ix + n - 1) - length(buffer.samples);

if overflow <= 0
	samples = buffer.samples(buffer.ix:(buffer.ix + n - 1), :);
else
	samples = [buffer.samples(buffer.ix:end, :); zeros(overflow, size(buffer.samples, 2))];
end

%--
% update scope display
%--

handles = update_scope_display(widget, time, parameter.duration, samples, context);

