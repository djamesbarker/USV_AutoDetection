function sound = sound_attribute_update(sound, lib, save)

% sound_attribute_update - update sound attributes
% ------------------------------------------------
%
% sound = sound_attribute_update(sound, lib)
%
% Input:
% ------
%  sound - sound
%  lib - container library
%
% Output:
% -------
%  sound - updated sound

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

if nargin < 3 || isempty(save)
	save = 0;
end

if nargin < 2 || isempty(lib)
	lib = get_active_library;
end

%--
% update sound attributes
%--

% NOTE: we pack the input as context

context.sound = sound; context.library = lib;

sound.attributes = get_sound_attributes(context);


%--------------------------------------------
% OLD CODE
%--------------------------------------------

% NOTE: this is all for backwards compatability

value = get_sound_attribute(sound, 'date_time');

if ~isempty(value)
	sound.realtime = value.datetime;
end

value = get_sound_attribute(sound, 'sound_speed');

if ~isempty(value)
	sound.speed = value.speed;
end

value = get_sound_attribute(sound, 'sensor_calibration');

if ~isempty(value)
	sound.calibration = value.calibration;
end

sound.geometry = get_sound_attribute(sound, 'sensor_geometry');

% TIME STAMPS

time_stamps = get_sound_attribute(sound, 'time_stamps');

if isempty(sound.time_stamp)

	%--
	% fill in entire time stamps field if it doesn't exist.
	%--

	sound.time_stamp = time_stamps;

else

	%--
	% only update the table. Enable and collapse are config options.
	%--

	if isfield(time_stamps, 'table')
		sound.time_stamp.table = time_stamps.table;
	end

end
	
if save
	sound_save(lib, sound);
end

