function out = sound_load(varargin)

% sound_load - load contents of library sound file
% ------------------------------------------------
%
% out = sound_load(file)
%
%     = sound_load(lib, name)
%
% Input:
% ------
%  file - sound file
%  lib - library to load sound from (def: active library)
%  name - name of sound
%
% Output:
% -------
%  out - sound file contents struct

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
% $Revision: 6471 $
% $Date: 2006-09-11 18:06:40 -0400 (Mon, 11 Sep 2006) $
%--------------------------------

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% handle variable input
%--

switch length(varargin)

	% file input
	
	case 1, lib = []; name = []; file = varargin{1};
	
	% library and sound name input
	
	case 2, 
		lib = varargin{1}; name = varargin{2}; file = get_library_sound_file(lib, name);
		
	% pass all on recursive call
	
	case 3,
		lib = varargin{1}; name = varargin{2}; file = varargin{3};
		
	% error
	
	otherwise
		error('Input must be either sound file location, or library and name.');
		
end

%--
% handle multiple sounds recursively
%--

if iscellstr(file)
	
	for k = 1:length(file)
		out(k) = sound_load(lib, name, file{k});
	end
	
	return; 
	
end

%--
% check for file existence
%--

if ~exist(file, 'file')
	[ignore, name] = fileparts(file); error(['Unable to find ''', name, ''' sound file in library.']);
end

%-----------------------------------
% LOAD SOUND
%-----------------------------------

%--
% load sound file variables
%--

% TODO: rename 'snd' to 'sound', this requires a change in 'sound_save' as well

[out, fail] = mat_load(file, 'sound', 'state');

if isempty(fail)
	sound = out.sound;
end

%--
% handle missing sound variables
%--

if ismember('sound', fail)
		
	% NOTE: this loads old sound files and does not update them
	
	%---------------------------------
	% BC CODE
	%---------------------------------
	
	[old, fail] = mat_load(file, 'snd', 'state');
	
	if ~ismember('snd', fail)
		sound = old.snd;
	else
		error('File does not contain sound variable.');
	end	
	
end

% NOTE: return empty state when state is not available

if ismember('state', fail)
	out.state = [];
end

%--
% update sound structure 
%--

out.sound = update_sound(sound, lib, file); 


%---------------------------------
% UPDATE_SOUND
%---------------------------------

% NOTE: this will work while updates to the sound structure remain simple

function sound = update_sound(sound, lib, file)

%--
% update struct using current constructor
%--

% NOTE: this allows for updating sound without conflict with stored sounds

opt = struct_update; opt.flatten = 0;

sound = struct_update(sound_create(''), sound, opt);












