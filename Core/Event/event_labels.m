function [time, freq] = event_labels(event, sound, opt)

% event_time_labels - compute event time labels
% ---------------------------------------------
%
% [time, freq] = event_time_labels(event, sound, opt)
%
%          opt = event_time_labels
%
% Input:
% ------
%  event - event
%  sound - parent sound
%  opt - display option
%
% Output:
% -------
%  time - time labels
%  freq - frequency labels

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

%--------------------------------
% Author: Harold Figueroa, Matt Robbins
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set and possibly output options
%--

if (nargin < 3) || isempty(opt)
	
	%--
	% set default options
	%--
	
	opt.time = 'clock'; 
	
	opt.freq = 'kHz';

	%--
	% output options
	%--
	
	if ~nargin
		time = opt; return;
	end
	
end

%--
% get start of recording time from sound
%--

origin = sound.realtime;

% NOTE: roll back 'date' display if origin is not available

if isempty(origin) && strncmp('date', opt.time, 4)
	opt.time = 'clock';
end

%--
% handle multiple inputs recursively
%--

if numel(event) > 1
	
	%--
	% handle variable output
	%--
	
	switch nargout
		
	case 1
		for k = 1:numel(event)
			time{k} = event_labels(event(k), sound, opt);
		end

	case 2
		for k = 1:numel(event)
			[time{k}, freq{k}] = event_labels(event(k), sound, opt);
		end
			
	end
	
	return;

end

%---------------------------------------
% COMPUTE LABELS
%---------------------------------------

%-----------------------
% TIME LABELS
%-----------------------

event.duration = event_duration(event);

%--
% compute based on time option
%--

% NOTE: these match the grid display mode names

switch opt.time
	
	%--
	% SECONDS
	%--
	
	case 'seconds'
		
		time{1} = num2str(event.time(1));
		
		time{2} = num2str(event.time(2));
		
		time{3} = num2str(event.duration);
	
		time = strcat(time, {' '}, 'sec');
		
	%--
	% CLOCK
	%--
	
	case 'clock'
		
		time{1} = sec_to_clock(event.time(1));
		
		time{2} = sec_to_clock(event.time(2));
		
		if (event.duration < 60)
			time{3} = [num2str(event.duration), ' sec'];
		else
			time{3} = sec_to_clock(event.duration);
		end
		
	%--
	% DATE AND TIME
	%--
	
	case {'date','date and time'}
			
		% TODO: these should be computed using 'get_sound_datetime'
		
		time{1} = datestr(offset_date(origin, event.time(1)), 0);
		
		time{2} = datestr(offset_date(origin, event.time(2)), 0);
		
		if (event.duration < 60)
			time{3} = [num2str(event.duration), ' sec'];
		else
			time{3} = sec_to_clock(event.duration);
		end
		
	%--
	% ERROR
	%--
	
	otherwise, error(['Unrecognized time grid display option ''', opt, '''.']);
		
end

%-----------------------
% FREQUENCY LABELS
%-----------------------

if nargout > 1
	
	%--
	% rescale frequencies for kilohertz display
	%--

	if strcmp(opt.freq, 'kHz')
		event.freq = event.freq / 1000;
	end
	
	%--
	% build labels 
	%--
	
	freq{1} = num2str(event.freq(1), 6);
			
	freq{2} = num2str(event.freq(2), 6);

	% NOTE: this should be a computed field
	
	freq{3} = num2str(event_bandwidth(event), 6);
	
	%--
	% add units
	%--
	
	% NOTE: the option contains the units
	
	freq = strcat(freq, {' '}, opt.freq);

end


