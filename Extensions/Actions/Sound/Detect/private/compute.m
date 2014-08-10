function [result, context] = compute(sound, parameter, context)

% DETECT - compute

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

result = [];

%--
% get detector and preset
%--

ext = get_extension('sound_detector', parameter.detector{1});

preset = preset_load(ext, parameter.preset{1});

preset.ext.control.explain = 0;

%--
% turn off time stamps
%-- 

% NOTE: in the branch this is not necessary because scans happen in real
% time, but here it is because they still happen in record time.

sound.time_stamp = [];

%--
% create new log
%--

log_name = parameter.output;

log_name = token_replace(log_name, '%', ...
	'SOUND_NAME', sound_name(sound), ...
	'PRESET_NAME', parameter.preset{1}, ...
	'DETECTOR_NAME', ext.name, ...
	'TIME', datestr(now, 'yyyymmdd_HHMMSS') ...
);

log = new_log(log_name, context.user, context.library, sound);

%--
% scan into log
%--

% NOTE: detector_scan saves the log so we don't need to

log = detector_scan(preset.ext, sound, [], [], log);

%--
% delete detector waitbar
%--

name = [preset.ext.name, ' - ', sound_name(sound)];

pal = find_waitbar(name);

delete(pal);

%-----------------------------------------------
% TOKEN_REPLACE
%-----------------------------------------------

function str = token_replace(str, sep, varargin)

[field, value] = get_field_value(varargin);

for k = 1:length(field)
	
	tok = [sep, field{k}, sep];
	
	str = strrep(str, tok, value{k});
	
end
