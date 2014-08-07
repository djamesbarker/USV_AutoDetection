function [time, duration] = get_file_times(sound, file)

% get_file_times - get file related times
% ---------------------------------------
%
% [time, duration] = get_file_times(sound, file)
%
% Input:
% ------
%  sound - sound
%  file - sound file
%
% Output:
% -------
%  time - file start sound time
%  duration - file duration in sound

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

%---------------------
% HANDLE INPUT
%---------------------

%--
% check file input and handle multiple file input recursively
%--

if (nargin > 1)
	
	% check
	
	if ~ischar(file) && ~iscellstr(file)
		error('File input must be a string or string cell array.');
	end
	
	% recursion
	
	if iscell(file)
		
		time = zeros(size(file)); duration = zeros(size(file));
		
		for k = 1:numel(file)
			[time(k), duration(k)] = get_file_times(sound, file{k});
		end
		
		return;
		
	end
	
end


%--
% single sound files are special
%--

if ischar(sound.file)
	
	time = 0; duration = get_sound_duration(sound); return;
	
end 

%---------------------
% GET FILE TIMES
%---------------------

%--
% get file boundary times in REAL TIME
%--

% NOTE: use native sound samplerate because we are using native samples.

time = [0; sound.cumulative(1:end)] / sound.samplerate;

% NOTE: consider sessions if required

time = map_time(sound, 'real', 'record', time);

%--
% get file durations
%--

duration = diff(time);

% NOTE: return if there is no selection

if (nargin < 2)
	return;
end

%--
% select input file start time
%--

ix = find(strcmp(file, sound.file));

if isempty(ix)
	error('Input file is not part of sound files.');
end

time = time(ix); duration = duration(ix);



