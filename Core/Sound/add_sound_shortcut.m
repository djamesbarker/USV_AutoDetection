function add_sound_shortcut(lib,sound)

% add_sound_shortcut - add shortcut to sound data
% -----------------------------------------------
%
% add_sound_shortcut(lib,sound)
%
% Input:
% ------
%  lib - parent library
%  sound - library sounds

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

% TODO: figure out what to output for confirmation

% TODO: allow sounds to be referred to by name as well

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set default all sounds in library
%--

if (nargin < 2)
	sound = get_library_sounds(lib);
end

%--
% return quickly when there are no sounds
%--

if (isempty(sound))
	return;
end

%--
% check for a variety of sound inputs
%--

% NOTE: maybe this should be part of 'get_library_sounds'

switch (class(sound))
	
	case ('char')
		
		%--
		% get library sound by name
		%--
		
		sound = get_library_sound(lib,'name',sound);

	case ('cell')

		%--
		% get multiple library sounds by name
		%--

		if (~iscellstr(sound))
			error('Cell input must be a cell array of sound names.');
		end
		
		names = sound; sound = [];
		
		for k = 1:length(names)
			
			temp = get_library_sound(lib,'name',names{k});
			
			if (~isempty(temp))
				if (isempty(sound))
					sound = temp;
				else
					sound(end + 1) = temp;
				end
			end
			
		end
	
	case ('struct')
		
		%--
		% handle multiple sound recursively
		%--
		
		if (numel(sound) > 1)
			
			for k = 1:length(sound)
				add_sound_shortcut(lib,sound(k));
			end
			
			return;
			
		end
		
end

%--
% return quickly when there are no sounds
%--

if (isempty(sound))
	return;
end

%--
% add 'shortcut' to sound depending on sound type
%--

% TODO: develop consolidation later, this would copy files into the library

% NOTE: consolidation will affect what we do here

root = [lib.path, sound_name(sound)];

switch (lower(sound.type))

	%--
	% single sound file
	%--

	% NOTE: create a 'Data' directory in the sound that contains a shortcut to the file

	case ('file')

		link_path = create_dir([root, filesep, 'Data']);

		if (isempty(link_path))
			error('Unable to create parent for shortcut.');
		end
		
		% NOTE: it is not clear that the file has this extension

		link_file = [sound.file, '.lnk'];

		if (~exist([link_path, filesep, link_file],'file'))
			create_shortcut( ...
				[sound.path, sound.file], link_path, sound.file ...
			);
		end

	%--
	% multiple file sound
	%--

	% NOTE: create a shortcut to the directory containing the sound files

	case ('file stream');

		% NOTE: perhaps the check should be part of 'create_shortcut'
		
		if (~exist([root, filesep, 'Data.lnk'],'file'))
			create_shortcut(sound.path, root, 'Data');
		end

end
