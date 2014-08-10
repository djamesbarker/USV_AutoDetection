function table = get_schedule_from_files(sound, pat)

% get_schedule_from_files - get recording schedule from sound files
% -----------------------------------------------------------------
%
% table = get_schedule_from_files(sound)
%
% Input:
% ------
%  sound - the sound
%
% Output:
% -------
%  table - time stamp table

% Copyright (C) 2002-2007 Harold K. Figueroa (hkf1@cornell.edu)
% Copyright (C) 2005-2007 Matthew E. Robbins (mer34@cornell.edu)
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

if nargin < 2
	pat = datetime_pattern_dialog('yyyymmdd_HHMMSS');
end

%--
% setup
%--

table = [0, 0];

if ~strcmpi(sound.type, 'file stream')
	return;
end

rate = sound.samplerate;

%--
% get file boundary times (recording time)
%--

start_times = [0 ; sound.cumulative(1:end-1)] ./ rate;

%--
% get file boundary times (real time if possible)
%--

time = file_times_from_names(file_ext(sound.file), pat);

%--
% return table
%--

% NOTE: if file names do not include date and time, we have to assume that
% they are contiguous.

if isempty(time)
	return;
end

table = [start_times, time(:)];

%--
% remove trivial time stamps
%--

table = trim_schedule(table);


%------------------------------
% DATETIME_PATTERN_DIALOG
%------------------------------

function pat = datetime_pattern_dialog(pat)

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'string', 'Pattern' ...
);

control(end + 1) = control_create( ...
	'name', 'pattern', ...
	'style', 'edit', ...
	'string', pat ...
);

out = dialog_group('Edit ...', control);

if ~strcmpi(out.action, 'OK')
	return;
end

pat = out.values.pattern;
	

