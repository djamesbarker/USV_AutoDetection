function sound = new_sound_dialog(lib)

% new_sound_dialog - create a new sound
% -------------------------------------
% sound = new_sound_dialog(lib)
%
% Input:
% ------
%  lib - the library to which to add the sound
%  
% Output:
% -------
%  sound - the new sound

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

%
% Chris Pelkie fixed a couple annoying typos in dialog boxes 2011-01-31
%
%--
% handle input
%--

if ~nargin
	lib = get_active_library;
end

%--
% create controls
%--

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', 'Sound' ...
);

types = title_caps(union(sound_types, 'folder'));

control(end + 1) = control_create( ...
	'name', 'type', ...
	'style', 'popup', ...
	'string', types, ...
	'value', 1, ...
	'onload', 1 ...
);

control(end + 1) = control_create( ...
	'name', 'info', ...
	'style', 'listbox', ...
	'lines', 4, ...
	'value', [], ...
	'min', 0, ...
	'max', 5 ...
);

% control(end + 1) = control_create( ...
% 	'name', 'name', ...
% 	'style', 'edit', ...
% 	'initialstate', '__DISABLE__' ...
% );

opt = dialog_group;

opt.width = 12;

opt.header_color = get_extension_color('root');

%--
% create dialog
%--

result = dialog_group('New ...', control, opt, @new_sound_callback);
	
if ~strcmp(result.action, 'ok')
	return;
end

type = lower(result.values.type{1});

err = [];

switch type

	case {'file', 'file stream', 'variable', 'recording'}
		
		sound = [];
		
		try
			
			sound = sound_create(type);	
			
			if isempty(sound) && isstruct(sound)
				err = 'No sound files were found in this folder.'; 
			end
			
		catch
			
			err = lasterr;
			
			if strcmp(type, 'file stream')
				
				err = { ...
					err(strfind(err, 'Files'):end), ...
					'Try adding these files as a ''folder''' ...
				};		
			
			end
			
		end	
		
		%--
		% add sound to library
		%--		
		
		if ~isempty(sound)
			add_sounds(sound, lib);
		end				

	case 'folder'
		
		p = get_env('xbat_sound_data_path'); 
		
		if isempty(p) || ~exist(p,'dir')
			p = set_env('xbat_sound_data_path', pwd);
		end
		
		%--
		% get library root directory
		%--
		
		p = uigetdir(p, 'Select folder containing sound files');
	
		if ~p
			return;
		end
			
		%--
		% consider filesep at the end of the drive selection
		%--

		while p(end) == filesep
			p = p(1:end - 1);
		end

		set_env('xbat_sound_data_path', p);

		%--
		% get sounds in folder and add them to the library
		%--

		sounds = get_folder_sounds(p, 1, {@add_sounds, lib, 0});	
		
		if isempty(sounds)
			err = 'No files were found in this folder.';
		end
		
		get_library_sounds([], 'refresh');
		
	otherwise
		
		error(['unrecognized sound type ''', type, '''.']);
			
end

if ~isempty(err)
    
    if ischar(err)
        err = {err};
    end
    
    err = {['Unable to create ''', type, ''' type sound:'], err{:}};
    
	warn_dialog(err, 'Warning', 'modal');			
end

xbat_palette('find_sounds');
		


%---------------------------------------
% NEW_SOUND_CALLBACK
%---------------------------------------

function result = new_sound_callback(obj, eventdata) %#ok<INUSD>

%--
% get callback context
%--

result = [];

[control, pal] = get_callback_context(obj);

pal = pal.handle;

type = get_control(pal, 'type', 'value'); type = lower(type{1});

str = {''};

switch type
	
	case 'file'
		
		str = {...
			'Single-file sound' ...
		};
	
		set_control(pal, 'name', 'enable', 0);

	case 'file stream'
		
		str = { ...
			'Multi-file sound contained in a', ...
			'directory.  All files must have', ...
			'matching sample rate and number', ...
			'of channels.' ...
		};
		
		set_control(pal, 'name', 'enable', 0);
		
	case 'folder'
		
		str = { ...
			'Multiple Sounds.  The directory', ...
			'is recursively scanned for files', ...
			'and subfolders are added as', ...
			'multiple sounds, or as', ...
			'filestreams if possible.' ...
		};

    set_control(pal, 'name', 'enable', 0);
		
	case 'variable' 
		
		str = { ...
			'A workspace variable.  If you', ...
			'have sound data in a variable,', ...
			'you may browse it as if it were', ...
			'a sound file on disk.' ...
		};
	
		set_control(pal, 'name', 'enable', 0);
				
	case 'synthetic'
		
		str = { ...
			'Create an empty sound to which', ...
			'data may be added by applying', ...
			'''source'' and ''filter''', ...
			'extensions.' ...
		};
	
		set_control(pal, 'name', 'enable', 1);
	
	case 'recording'
		
		str = { ...
			'Create an empty sound to which', ...
			'data may be added by acquiring', ...
			'it using the MATLAB data acquisition', ...
			'toolbox.' ...
		};
	
		set_control(pal, 'name', 'enable', 1);
			
end

han = get_control(pal, 'info', 'handles');

set(han.obj, 'string', str, 'value', []);



