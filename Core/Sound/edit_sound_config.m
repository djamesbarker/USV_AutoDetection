function sound = edit_sound_config(sound,lib)

% edit_sound_config - sound configuration editing
% -----------------------------------------------
%
% sound = edit_sound_config(sound,lib)
%
% Input:
% ------
%  sound - sound to edit
%  lib - parent library (def: active library)
%
% Output:
% -------
%  sound - edited sound

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
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1380 $
% $Date: 2005-07-27 18:37:56 -0400 (Wed, 27 Jul 2005) $

% Bug fix: Chris Pelkie 2011-01-31
% Changed Please close , name, to Please close, sound_name(sound)
%--------------------------------

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set default active library
%--

if nargin < 2
	lib = get_active_library;
end

%--
% check whether sound is open
%--

if numel(sound) ~= 1
	return;
end

if sound_is_open(sound)

	str = sprintf([ ...
		'Open sounds cannot be configured.\n', ...
		'Please close ''', sound_name(sound), ''' before configuring.' ...
		]);

	warn_dialog(str, 'Configure'); return;

end

%--
% update sound attributes
%--

sound = sound_attribute_update(sound, lib);

%---------------------------------
% EDIT SOUND CONFIG
%---------------------------------

% TODO: check that sound is closed, otherwise prompt to close and reopen

%--
% present edit configuration dialog
%--

out = sound_config_dialog(sound);

values = out.values;

if isempty(values)
	return;
end

out = sound_load(lib,sound_name(sound)); sound = out.sound;

%--
% update properties
%--

sound.output.class = lower(values.class{1});

if (values.resample && (sound.samplerate ~= values.samplerate))
	sound.output.rate = values.samplerate;
else
	sound.output.rate = [];
end

% sound.time_stamp.enable = values.enable_time_stamps;
% 
% sound.time_stamp.collapse = values.collapse_sessions;

%--
% update tags and notes
%--

sound = set_tags(sound, values.tags);

sound.notes = values.notes;
	
%--
% save sound in library
%--

% NOTE: we may consider discarding parts of the state

sound_save(lib,sound,out.state);
