function [time, freq, channel] = log_info_update(varargin)

% log_info_update - update log extent information fields
% ------------------------------------------------------
%
% [time, freq, channel] = log_info_update(log)
%                       = log_info_update(log, event)
%
% Input:
% ------
%  event - log event array
%
% Output:
% -------
%  time - time span of log
%  freq - freq span of log
%  channel - channel span of log

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
% handle input
%--

if (length(varargin) == 1)
	log = varargin{1}; mode = 'full';
else
	log = varargin{1}; event = varargin{2}; mode = 'update';
end

%--
% compute according to mode
%--

switch mode
	
	%--
	% full computation of time, frequency, and channel span
	%--
	
	% this computation is used when an event is deleted and the first time
	% that this information is requested and does not exist
	
	case 'full'
		
		%--
		% compute time span
		%--
		
		tmp = struct_field(log.event, 'time');
		
		time = [min(tmp(:, 1)), max(tmp(:, 2))];
		
		%--
		% compute freq span
		%--
		
		tmp = struct_field(log.event,'freq');
		
		freq = [min(tmp(:, 1)), max(tmp(:, 2))];
		
		%--
		% compute channel span
		%--
		
		tmp = struct_field(log.event, 'channel'); 
		tmp = unique(tmp);
		channel = tmp(:)';

	%--
	% update computation of time frequency, and channel span
	%--
	
	% this update approach works upon editing of an event and addition of
	% an event. in the case of event deletions, the full update must be
	% computed
	
	case 'update'
		
		%--
		% check for empty time and frequency
		%--
		
		if isempty(log.time)
			[time, freq, channel] = log_info_update(log); return;
		end
		
		%--
		% update time span
		%--
		
		tmp = [log.time; event.time];
		
		time = [min(tmp(:, 1)), max(tmp(:, 2))];
		
		%--
		% update frequency span
		%--
		
		tmp = [log.freq; event.freq];
		
		freq = [min(tmp(:, 1)), max(tmp(:, 2))];
		
		%--
		% update channel span
		%--
		
		tmp = [log.channel, event.channel];
		tmp = unique(tmp);
		channel = tmp(:)';
		
end
