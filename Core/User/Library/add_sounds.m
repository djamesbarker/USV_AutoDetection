function flag = add_sounds(sound, lib, opt)

% add_sounds - add sound to library
% --------------------------------
%
% flag = add_sounds(sound, lib)
%
% Input:
% ------
%  sound - sound to add system
%  lib - library to add sounds to (def: active library)
%
% Output:
% -------
%  flag - save confirmation flag

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

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set default option to refresh
%--

if nargin < 3
	opt = 1;
end

%--
% set library if needed
%--

if (nargin < 2) || isempty(lib)
	lib = get_active_library;
end

%--
% handle multiple sounds recursively
%--

if length(sound) > 1
	
	%--
	% create waitbar
	%--
	
	h = add_sounds_wait(lib);
	
	%--
	% loop over sounds to add
	%--
		
	N = length(sound);
	
	for k = 1:N
			
		%--
		% try to add sound to library
		%--
		
		flag(k) = add_sounds(sound(k), lib, 0);
		
		%--
		% update waitbar
		%--

		if (flag(k) == 1)
			msg = ''' added to ''';
		else
			msg = ''' already exists in ''';
		end
		
		%--
		% if waitbar has been deleted, just return.  this cancels the add
		%--
		
		try
			waitbar_update(h, 'PROGRESS', ...
				'value', k/N, ...
				'message', ['''', sound_name(sound(k)), msg, lib.name, ''''] ...
			);
		catch
			return;
		end
		
	end

	%--
	% report sounds added
	%--
		
	str = [int2str(sum(flag == 1)), ' sounds added to ''', lib.name, ''' library'];
	
	waitbar_update(h, 'PROGRESS', ...
		'value', 1, ...
		'message', str ...
	);

	%--
	% refresh library cache and delete waitbar
	%--
	
	get_library_sounds(lib, 'refresh');
	
	pause(0.5); 
	
	delete(h); return;
	
end

%-----------------------------------
% ADD SOUND TO LIBRARY
%-----------------------------------
	
%--
% get sound name
%--

name = sound_name(sound);

%--
% return if sound seems to exist
%--

% NOTE: return if sound seems to exist

if exist([lib.path, name], 'dir')
	flag = 0; return;
end

%--
% create required directories
%--

% NOTE: create all by creating the deepest nested directory

backup = create_dir([lib.path, filesep, name, filesep, 'Logs', filesep, '__BACKUP']);

if isempty(backup)
	error('Failed to create required library directories.');
end


% TODO: create '__XBAT' directory if needed, otherwise create shortcut to
% it in the library sound


% NOTE: hide backup on PC, consider making this is an environment variable

% if (ispc)
% 	fileattrib(backup,'+h');
% end

%--
% save sound to file and create sound shortcut
%--

sound_save(lib, sound, [], opt);

add_sound_shortcut(lib, sound);

%--
% set addition indicator
%--

flag = 1;
	

%------------------------------------------------------------------------
% ADD_SOUNDS_WAIT
%------------------------------------------------------------------------

function h = add_sounds_wait(lib)

% add_sounds_wait - create add so9nds waitbar
% -------------------------------------------
%
% h = add_sounds_wait(sound)
%
% Input:
% ------
%  sound - sound structure

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 4298 $
% $Date: 2006-03-17 18:03:18 -0500 (Fri, 17 Mar 2006) $
%--------------------------------

%-------------------------------------------------
% DEFINE WAITBAR CONTROLS
%-------------------------------------------------

%--
% progress waitbar
%--

control = control_create( ...
	'name', 'PROGRESS', ...
	'alias', 'Add Sounds ...', ...
	'style', 'waitbar', ...
	'confirm', 1, ...
	'lines', 1.1, ...
	'space', 0.5 ...
);

%-------------------------------------------------
% CREATE WAITBAR
%-------------------------------------------------

name = ['Add Folder ...'];

h = waitbar_group(name, control);
