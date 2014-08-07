function [sounds, states] = get_library_sounds(lib, varargin)

% get_library_sounds - get available sounds in library
% ----------------------------------------------------
%
% [sounds, states] = get_library_sounds(lib, 'field', value, ...)
%
% Input:
% ------
%  lib - library structure (def: active library)
%  field - sound field name
%  value - sound field value
%
% Output:
% -------
%  sounds - available sounds
%  states - corresponding browser states

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
% HANDLE INPUT
%--------------------------------

%--
% set library to active library
%--

if (nargin < 1) || isempty(lib)
	lib = get_active_library;
end

%--
% check for refresh
%--

if length(varargin) && isequal(varargin{1}, 'refresh')
	refresh = 1; varargin = varargin(2:end);
else
	refresh = 0;
end

%--------------------------------
% GET LIBRARY SOUNDS
%--------------------------------

persistent PERSISTENT_LIBRARY_SOUNDS PERSISTENT_LIBRARY_STATES;

%--
% check for persistent specific library table
%--

% NOTE: the library path is an adequate identifier

field = ['M', md5(lib.path)];

if ~isempty(PERSISTENT_LIBRARY_SOUNDS)

	% NOTE: if the field is missing we need to create the cache
	
	if ~isfield(PERSISTENT_LIBRARY_SOUNDS, field)
		refresh = 1;
	end
	
end

%--
% get library sounds from file system
%-

if isempty(PERSISTENT_LIBRARY_SOUNDS) || refresh
	
	%--
	% get directories within library root
	%--
	
	child = dir(lib.path); 
	
	child = child(3:end);

	%--
	% loop over library children getting sounds
	%--

	sounds = []; states = [];

	for k = 1:length(child)

		%--
		% skip over backup and subversion directories
		%--

		% NOTE: this is not a comprehensive solution

		if strcmp(child(k).name, '__BACKUP') || strcmp(child(k).name, '.svn')
			continue;
		end

		%--
		% each directory corresponds to a sound
		%--

		if child(k).isdir

			%--
			% try to load sound file contents
			%--

			% NOTE: we could use 'get_field' with default to handle the error

			try
				out = sound_load(lib, child(k).name); 
			catch
				xml_disp(lasterror); continue;
			end

			%--
			% get sound and state info
			%--

			if isempty(sounds)
				sounds = out.sound;
			else
				sounds(end + 1) = out.sound;
			end

			% NOTE: we store states in cell array to handle empty state case

			if isempty(states)
				states{1} = out.state;
			else
				states{end + 1} = out.state;
			end

		end

	end
	
	%--
	% store results in persistent table
	%--
	
	PERSISTENT_LIBRARY_SOUNDS.(field) = sounds;
	
	PERSISTENT_LIBRARY_STATES.(field) = states;
	
else
	
	%--
	% extract results from persistent table
	%--
	
	sounds = PERSISTENT_LIBRARY_SOUNDS.(field);
	
	states = PERSISTENT_LIBRARY_STATES.(field);
	
end

%---------------------------------------------------------------
% SELECT FROM AVAILABLE SOUNDS
%---------------------------------------------------------------

%--
% return if there are no selection criteria
%--

% if isempty(varargin)
% 	return;
% end

%--
% extract selection field value pairs
%--

[field, value] = get_field_value(varargin);

%--
% loop over selection fields, then loop over sounds and delete misses
%--

for j = 1:length(field)
	
	%--
	% name is a computed field
	%--
	
	if strcmp(field{j}, 'name')

		% NOTE: for multiple values and sounds this can be slow 
		
		for k = length(sounds):-1:1
			if ~any(strcmp(sound_name(sounds(k)), value{j}))
				sounds(k) = [];
			end
		end
		
	%--
	% other fields are data fields
	%--
	
	elseif isfield(sounds(1), field{j})
		
		for k = length(sounds):-1:1
			if ~isequal(sounds(k).(field{j}), value{j})
				sounds(k) = [];
			end
		end
		
	end
	
end

%---------------------------------------------------------------
% DISPLAY SOUNDS
%---------------------------------------------------------------

if ~nargout && ~refresh
	
	name = get_library_name(lib);
	
	disp(' ');
	str = [' LIBRARY: ', name];
	disp(str);
	disp([' ', str_line(length(str) - 1)]);

	for k = 1:length(sounds)
		disp([ ...
			' ', int2str(k), '.  <a href="matlab:open_library_sound(''', ...
			sound_name(sounds(k)), ''',''', name, ''');">', sound_name(sounds(k)), '</a>' ...
		]);
	end
	disp(' ');
	if length(sounds) > 1
		disp(['(', sound_info_str(sounds), ')']);
	end
	
	disp(' ');
	
	clear sounds;
	
end


