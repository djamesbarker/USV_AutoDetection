function log = det_to_log(det,f)

% det_to_log - convert detection structure to log structure
% ---------------------------------------------------------
%
% log = det_to_log(det,f)
%
% Input:
% ------
%  det - detection structure
%  f - sound structure or sound type, 'file' or 'group'
%
% Output:
% -------
%  log - log structure

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
% create log
%--

log = log_create;

%--
% add sound to log
%--

if (isstruct(f))
	log.sound = f;
else
	log.sound = sound_create(f);
end

%--
% fill log with detection data
%--

rate = log.sound.samplerate;
dt = 1134 / rate;

for k = 1:length(det)
	
	event = event_create;
	event.channel = det(k).channel;
	event.time(1) = det(k).sample / rate;
	event.time(2) = event.time(1) + dt;
	event.duration = dt;
	event.freq = [0,4500];
	event.bandwidth = 4500;
	
	event.notes = num2str(det(k).value);
	
	log.event(k) = event;
	
end

log.length = length(det);

%--
% save log
%--

log_save(log);
