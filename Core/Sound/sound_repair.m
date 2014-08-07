function sound = sound_repair(sound)

% sound_repair - reassign files to sound
% --------------------------------------
%
% sound = sound_repair(sound)
%
% Input:
% ------
%  sound - sound to repair
%
% Output:
% -------
%  sound - repaired sound or empty

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

%----------------------------------------------------------
% GET SOUND FILES TO ASSIGN
%----------------------------------------------------------

old_path = sound.path;

old_name = file_parent(old_path, 0);

%--
% get location of file or files
%--

%--
% ask to repair sound
%--

str = { ...
	['Unable to find sound files for ', sound_name(sound), '.'], ...
	' Would you like to locate them?' ...
};

out = quest_dialog(double_space(str), ' Missing Sound Files', 'Cancel');

% return on cancel

if ~ischar(out) || ~strcmp(out, 'Yes')
	sound = []; return;
end

[f, p] = uiget_sound_files(sound);

% NOTE: return empty on cancel

if isempty(p) || isequal(p, 0)
	sound = []; return;
end

if p(end) ~= filesep
	p(end + 1) = filesep;
end

if isempty(f)
	
	f = sound.file; 
	
	if iscellstr(f)
		f = f{1};
	end
	
end

%--
% get file stream files
%--

if ~strcmpi(sound.type, 'file')
	
	if ~strcmp(file_parent(p, 0), old_name)
		
		error_str = { ...
			'Sound was not repaired.', ...
			'File stream folder names must match the sound name.', ...
			'please copy files to a folder named', ...
			['"', old_name, '".'] ...
		};
		
		warn_dialog(error_str, 'Invalid Sound Folder Name');
	
		sound = []; return;
		
	end
	
	%--
	% try to get format handler 
	%--
    
	format = get_file_format(f);

	%--
	% get same format files
	%--
	
	files = get_format_files(p, format); 
	
	%--
	% put files sound sorted order
	%--
	
	[ignore, ext] = file_ext(f);
	
	files = files.(lower(ext));
	
end

%----------------------------------------------------------
% COMPARE OLD AND NEW FILES
%----------------------------------------------------------

switch lower(sound.type)
	
	%-------------------------------
	% FILE
	%-------------------------------
	
	case 'file'
		
        if iscell(f)
            f = f{1};
        end
        
		%--
		% get and check selected file info
		%--
        
		info = sound_file_info([p, f]);
				
		% NOTE: return empty if we don't match
		
		if ( ...
			(info.samplerate ~= sound.samplerate) | ...
			(info.samples ~= sound.samples) | ...
			(info.channels ~= sound.channels) | ...
			(info.samplesize ~= sound.samplesize) ...
		)
			sound = []; 
			
			disp('files don''t match.  delete and re-add the sound.'); return;
			
		end
			
		%--
		% update file location
		%--

		sound.path = p; sound.file = f;
			
	%-------------------------------
	% FILE STREAM
	%-------------------------------
	
	case 'file stream'
		
		%--
		% check the number of files
		%--
		
		if length(sound.file) ~= length(files)
			sound = []; disp('number of files does not match.'); return;
		end
		
		%--
		% check the info of the files
		%--
		
		for k = 1:length(files)
		
			%--
			% get and check selected sound file info
			%--
			
			info = sound_file_info([p, files{k}]);
			
			% NOTE: return empty if we don't match
			
			if ( ...
				(info.samplerate ~= sound.samplerate) | ...
				(info.samples ~= sound.samples(k)) | ...
				(info.channels ~= sound.channels) | ...
				(info.samplesize ~= sound.samplesize) ...
			)
				sound = []; disp('files don''t match.  delete and re-add the sound.'); 
				
				return;
				
			end
			
		end
				
		%--
		% update file location
		%--
				
		sound.path = p; sound.file = files;		
		
end

sound_save(get_active_library, sound); 

return;

% % NOTE: update sound file with new file locations
% 
% sound = repaired; 
% 
% if isempty(lib)
% 
% 	% TODO: get library from file
% 
% 	libs = get_unique_libraries;
% 
% 	candidates = strcat({libs.path}, sound_name(sound));
% 
% 	ix = find(strcmp(fileparts(file), candidates));
% 
% 	% NOTE: the empty should produce a warning
% 
% 	if ~isempty(ix)
% 		lib = libs(ix);
% 	else
% 		lib = get_active_library;
% 	end
% 
% end


% FIXME: this is a temporary fix. write a general sound repair function

% NOTE: this exception handles new sounds

try
	
	if ((sound.view.time + sound.view.page.duration) > get_sound_duration(sound))

		%--
		% display warning
		%--

		warning('There was a problem with the saved sound, part of the state may be lost.');

		%--
		% rename fields for convenience
		%--

		t = sound.view.time;

		dt = sound.view.page.duration;

		dur = sound.duration;

		%--
		% update time and if needed page duration
		%--

		% NOTE: this part is very ugly, this needs to be revised

		t = dur - (1.1 * dt);

		if (t < 0)
			t = 0;
			dt = dur - 0.1;
		end

		%--
		% update sound fields
		%--

		sound.view.time = t; 

		sound.view.page.duration = dt;

	end
	
end

