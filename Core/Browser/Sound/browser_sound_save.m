function flag = browser_sound_save(par, data)

% browser_sound_save - save browser sound to file
% -----------------------------------------------
%
% flag = browser_sound_save(par, data)
%
% Input:
% ------
%  par - parent browser
%  data - browser userdata
%
% Output:
% -------
%  flag - save confirmation

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
% $Revision: 1174 $
% $Date: 2005-07-13 16:54:00 -0400 (Wed, 13 Jul 2005) $
%--------------------------------

% TODO: this functions is archaic and needs updating

%-------------------------------------------
% HANDLE INPUT
%-------------------------------------------

%--
% check handle
%--

if ~is_browser(par)
	error('Input is not a browser handle.');
end

%--
% get figure userdata if needed and tag
%--

if (nargin < 2) || isempty(data)
	data = get(par, 'userdata');
end

tag = get(par, 'tag');

%-------------------------------------------
% GET BROWSER STATE
%-------------------------------------------

%--
% get sound, and library and user information
%--

snd = data.browser.sound;

% NOTE: we parse tag to get user and library info

info = parse_tag(tag);

%--
% update browser display related field in sound structure
%--

snd = sound_update(snd, data);

%--
% get browser display state
%--

state = get_browser_state(par, data);

%-------------------------------------------
% SAVE SOUND AND BROWSER STATE
%-------------------------------------------

%--
% compute location to save file to
%--

% NOTE: check user still exists

user = get_users('name', info.user);

if isempty(user)
	disp(['WARNING: User ''', info.user, ''' is longer available.']); flag = 0; return;
end

% NOTE: we get library to save to through user reference

lib_info = parse_tag(info.library, filesep, {'author', 'name'});

lib = get_libraries(user, ...
	'name', lib_info.name, ...
	'author', lib_info.author ...
);

% lib = get_active_library;

name = sound_name(snd);

snd_file = [lib.path, name, filesep, name, '.mat'];

%--
% check that the sound currently exists
%--

% NOTE: this check is vestigial, this should be handled more notably

tmp = get_library_sounds(lib, 'name', name);

%--
% update sound file
%--

% NOTE: we store the sound and browser state to the sound file

if ~isempty(tmp) && (length(tmp) == 1)
	
	try
		save(snd_file, 'snd', 'state'); flag = 1;
	catch
		disp(['WARNING: Sound ''', name, ''' update in library ''', lib.name, ''' failed.']); flag = 0;
	end
	
%--
% try to add sound to library
%--

else
		
	% NOTE: we can just output the flag of this operation
	
	flag = add_sounds(snd);
	
end 
