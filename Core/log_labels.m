function [time,freq] = log_labels(h,log)

% log_labels - construct label strings for log information menu
% -------------------------------------------------------------
%
% [time,freq] = log_labels(h,log)
%
% Input:
% ------
%  h - handle to figure
%  log - log to create labels for 
%
% Output:
% -------
%  time - time strings
%  freq - frequency strings

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
% get userdata
%--

data = get(h,'userdata');

%--
% create strings if possible
%--

if (isempty(log.time))
	for k = 1:3
		time{k} = '';
		freq{k} = '';
	end
	return;
end

%--
% time strings
%--

if (strcmp(data.browser.grid.time.labels,'clock'))
	
	%--
	% realtime strings
	%--
	
	if (data.browser.grid.time.realtime & ~isempty(data.browser.sound.realtime))
		
		offset = datevec(data.browser.sound.realtime);
		offset = offset(4:6) * [3600, 60, 1]';
		
		time{1} = sec_to_clock(log.time(1) + offset);
		time{2} = sec_to_clock(log.time(2) + offset);
		time{3} = [num2str(log.duration,3) ' sec'];
		
	%--
	% clock strings
	%--
	
	else
		
		time{1} = sec_to_clock(log.time(1));
		time{2} = sec_to_clock(log.time(2));
		time{3} = [num2str(log.duration,3) ' sec'];
		
	end
	
else
	
	%--
	% second strings
	%--
	
	time{1} = [num2str(log.time(1)) ' sec'];
	time{2} = [num2str(log.time(2)) ' sec'];
	time{3} = [num2str(log.duration,3) ' sec'];
	
end

%--
% frequency strings
%--

if (strcmp(data.browser.grid.freq.labels,'Hz'))
	
	%--
	% Hz strings
	%--
	
	freq{1} = [num2str(log.freq(1),6) ' Hz'];
	freq{2} = [num2str(log.freq(2),6) ' Hz'];
	freq{3} = [num2str(log.bandwidth,6) ' Hz'];
	
else
	
	%--
	% kHz strings
	%--
	
	freq{1} = [num2str(log.freq(1) / 1000,4) ' kHz'];
	freq{2} = [num2str(log.freq(2) / 1000,4) ' kHz'];
	freq{3} = [num2str(log.bandwidth / 1000,4) ' kHz'];

end
