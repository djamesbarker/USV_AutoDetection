function f = sound_create(type, p, opt)

% sound_create - create XBAT sound structure
% ------------------------------------------
%
% opt = sound_create
%
%   f = sound_create(type, in, opt)
%
% Input:
% ------
%  type - sound type
%  in - sound source input
%  opt - sound create options
%
% Output:
% -------
%  f - sound structure

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
% $Revision: 6913 $
% $Date: 2006-10-04 17:42:47 -0400 (Wed, 04 Oct 2006) $
%--------------------------------

% NOTE: eventually we could point to a file that configures recording

%-------------------------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------------------------

%--
% set and possibly return default options
%--

% NOTE: at the moment only attribute search is an options

if nargin < 3

	opt.attributes = 1;
	
	if nargin < 1
		f = opt; return;
	end
	
end

%--
% output empty sound on empty type
%--

if nargin && isempty(type)
	f = sound_create_in; return;
end

%--
% check and normalize sound type
%--

[ignore, type] = is_sound_type(type);

if isempty(type)
	error('Unrecognized sound type.');
end

%--
% get sound source info through dialog
%--

if nargin < 2

	switch type
		
		%--
		% get sound files
		%--
		
		case {'file', 'file stream'}
			
			%--
			% get sound files
			%--

			[fn, pn] = uiget_sound_files(type);

			% NOTE: return empty on cancel

			if isempty(pn) || isequal(pn, 0)
				f = []; return;
			end

			%--
			% pack output into file path strings
			%--

			% NOTE: the cell output condition only happens for type 'file'

			if iscell(fn)
				for k = 1:length(fn)
					p{k} = [pn, fn{k}];
				end
			else
				p = [pn, fn];
			end
			
		case 'stack'
			
			%--
			% there are no files, "p" is an array of sounds
			%--
			
			% NOTE: this is where you could present a dialog to pick sounds
			% from a library or something...
			
			p = [];
			
		%--
		% configure recording
		%--
		
		case 'recording'
		
			% TODO: consider how this value could be used for recording
			
			% NOTE: the configuration values could be obtained from a file

			p = [];
						
			result = recording_dialog;

			recording = result.values;

			if isempty(recording)
				f = []; return;
			end

			% NOTE: append random identifier for input object
			
			recording.id = ['XBAT_ANALOG_INPUT_', int2str(1000000*rand)];
			
		%--
		% configure synthetic source
		%--
			
		case {'synthetic', 'variable'}	
			
			p = [];
			
	end

end

%--
% handle creation of multiple file sounds recursively
%--

if iscellstr(p) && strcmp(type, 'file')
	
	opt.attributes = 0; % NOTE: disable searching for attributes for efficiency
	
	%--
	% try to generate a sound for each file
	%--
	
	f = [];
	
	for k = 1:length(p)

		try
			if isempty(f)
				f = sound_create('file', p{k}, opt);
			else
				f(end + 1) = sound_create('file', p{k}, opt);
			end
		catch
			disp(['WARNING: Unable to create sound from file ''', p{k}, '''.']);			
		end

	end

	return;

end

%-------------------------------------------------------------------
% CREATE SOUND
%-------------------------------------------------------------------

%--
% parse input location to match uigetfile output
%--

if ~isempty(p) && ischar(p)
	
	if strcmpi(type, 'File')
		[p, f1, f2] = fileparts(p); fn = [f1, f2];
	end
	
	p = [p, filesep];	
	
end

%--
% create sound structure depending on type
%--

switch lower(type)

	%--------------------------------
	% FILE
	%--------------------------------
	
	case 'file'

		%--
		% get sound file info and sound attributes
		%--
					
		info = get_file_info(p, fn);
		
		if ischar(info)
			f = empty(sound_create_in); disp(info); return;
		end
		
		if isempty(info)
			f = empty(sound_create_in); return;
		end
		
		format_info = [info.info];
		
		if isfield(format_info, 'bitrate')	
			info.bitrate = format_info.bitrate;
		end	
		
		if isfield(format_info, 'vbr')
			info.vbr = format_info.vbr;	
		end				

		%--
		% create and fill sound
		%--

		f = sound_create_in( ...
			'type',			type, ...
			'path',			p, ...
			'file',			fn, ...
			'info',			info, ...
			'samplerate',	info.samplerate, ...
			'samples',		info.samples, ...
			'channels',		info.channels, ...
			'samplesize',	info.samplesize, ...
			'format',		info.format ...
		);
	
		f = sound_attribute_update(f);

	%--------------------------------
	% FILE STREAM
	%--------------------------------

	% NOTE: alphabetical order of file name indicates stream position
	
	% NOTE: sound files in directory should have consistent extensions
	
	case 'file stream'

		%--
		% get sound files
		%--
		
		[f, ext] = get_format_files(p);

		if isempty(ext)
			
			f = empty(sound_create_in); 
			
			return; 
			
		end
		
		% NOTE: select the first extension encountered
		
		f = f.(ext{1}); 
				
		%--
		% get sound file info and sound attributes
		%--

		[info, pal, err] = get_file_info(p, f);
			
		if isempty(info)
			
			f = empty(sound_create_in); 
			
			if ~isempty(err)
				error(err);
			end
			
			return;
			
		end
		
		%--
		% get file samples array
		%--
		
		samples = cell2mat({info.samples}');
		
		%--
		% add file info fields
		%--
		
		% NOTE: these contain aggregate information for all files in stream
		
		info_stored.bytes = sum([info.bytes]);
		
		% NOTE: this info field contains format-specific file info
		
		format_info = [info.info];
		
		if isfield(format_info, 'bitrate')	
			info_stored.bitrate = [format_info.bitrate] * (samples / sum(samples));
		end	
		
		if isfield(format_info, 'vbr')
			info_stored.vbr = any([format_info.vbr]);	
		end
	
		%--
		% create and fill sound
		%--
	
		f = sound_create_in( ...
			'type',			type, ...
			'path',			p, ...
			'file',			f, ...
			'info',			info_stored, ...
			'samplerate',	info(1).samplerate, ...
			'samples',		samples, ...
			'channels',		info(1).channels, ...
			'samplesize',	info(1).samplesize, ...
			'format',		info(1).format ...
		);
	
		f = sound_attribute_update(f);
			
		%--
		% close waitbar
		%--

		delete(pal);
		
	%--------------------------------------------------------
	% STACK
	%--------------------------------------------------------
	
	case ('stack')
		
		sounds = p;
		
		if isempty(sounds)
			f = sound_create_in();
			return;
		end
		
		%--
		% sample rate is maximum sample rate of sounds
		%--
		
		samplerate = max([sounds.samplerate]);
		
		for k = 1:length(sounds)
			
			if (sounds(k).samplerate ~= samplerate)
				sounds(k).output.rate = samplerate;
			end
			
		end
				
		% NOTE: this one will need to take advantage of shifts when we
		% implement them
		
		duration = max([sounds.duration]);
		
		samples = duration * samplerate;
		
		channels = length(sounds);	
		
		f = sound_create_in( ...
			'type', type, ...
			'path', [], ...
			'file', [], ...
			'info', sounds, ...
			'samplerate', samplerate, ...
			'samples', samples, ...
			'duration', duration, ...
			'channels', channels ...
		);
				
	%--------------------------------------------------------
	% recording
	%--------------------------------------------------------
	
	% TODO: allow logging to DAQ file or convert this to standard audio formats

	case 'recording'
				
		%--
		% get sound source info and sound attributes
		%--
		
		[info, format] = get_recording_info(recording); % NOTE: this may become a separate function
		
		%--
		% create and fill sound
		%--
		
		% TODO: figure out samplesize
		
		f = sound_create_in( ...
			'type',			info.type, ...
			'path',			info.path, ...
			'file',			info.file, ...
			'input',		recording, ...
			'samplerate',	info.samplerate, ...
			'samples',		info.samples, ...
			'channels',		info.channels, ...
			'format',		format.name ...
		);
	
	%-----------------------------------------------------------
	% synthetic source
	%-----------------------------------------------------------
	
	case 'synthetic'
		
		samples = ext.parameter.duration * ext.parameter.rate;
		
		f = sound_create_in( ...
			'type', type, ...
			'input', ext, ...
			'path', '', ...
			'file', temp_name, ...
			'samplerate', ext.parameter.rate, ...
			'samples', samples, ...
			'duration', ext.parameter.duration, ...
			'channels', ext.parameter.channels ...
		);	
	
	%-----------------------------------------------------------
	% variable
	%-----------------------------------------------------------
	
	case 'variable'
		
		[name, rate] = get_workspace_dialog;
		
		try
			p = evalin('base', name);
		catch
			f = []; return;
		end
		
		channels = min(size(p)); samples = max(size(p));	
		
		f = sound_create_in( ...
			'type', type, ...
			'path', 'base', ...
			'file', name, ...
			'samplerate', rate, ...
			'samples', samples, ...
			'channels', channels ...	
		);
		
	
end

%--------------------------------
% DISPLAY PERSISTENCE FIELDS
%--------------------------------

% TODO: setup default computation and presets for some of these fields

%--
% page view settings field
%--

% f.view = view_create;

%--
% spectrogram settings field
%--

% f.specgram = specgram_parameter;


%--------------------------------------------------
% SOUND_CREATE_IN
%--------------------------------------------------

function sound = sound_create_in(varargin)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6913 $
% $Date: 2006-10-04 17:42:47 -0400 (Wed, 04 Oct 2006) $
%--------------------------------

% TODO: reconsider field ordering

%------------------------
% CREATE STRUCT
%------------------------

%--
% source fields
%--

sound.type = [];

sound.format = [];

sound.path = [];

sound.file = [];

sound.info = [];

% NOTE: these refer to how samples come into and are read from the sound

sound.input = []; % NOTE: contents defined in recording_dialog.m

sound.output = sound_file_read; 

%--
% time fields
%--

sound.samplerate = [];

sound.samples = [];	

sound.cumulative = [];

sound.duration = [];		

sound.realtime = [];

sound.time_stamp = [];

%--
% channel fields
%--

sound.channels = [];

% NOTE: these are channel related sound attributes

sound.calibration = [];	

sound.geometry = [];

sound.speed = [];

sound.attributes = [];

%--
% format fields
%--

sound.samplesize = [];

%--
% display
%--

% NOTE: these help with persistence of displays

sound.view = view_create;

sound.specgram = specgram_parameter;

%--
% admin and metadata fields
%--

sound.created = now;

sound.modified = [];	

sound.notes = [];

sound.tags = [];

sound.userdata = [];

%------------------------
% FILL STRUCT
%------------------------

% NOTE: this code is closer to a proper constructor

if length(varargin)
	
	%--
	% set fields directly
	%--
	
	sound = parse_inputs(sound, varargin{:});
	
	%--
	% set certain fields as computations
	%--
	
	if isempty(sound.cumulative)
		sound.cumulative = cumsum(sound.samples);
	end
	
	if isempty(sound.duration)
		sound.duration = sound.cumulative(end) / sound.samplerate;
	end
	
	%--
	% set default values for some fields
	%--
	
% 	if (isempty(sound.geometry))
% 		sound.geometry = default_geometry(sound.channels);
% 	end
% 
% 	if (isempty(sound.calibration))
% 		sound.calibration = zeros(sound.channels,1);
% 	end

	%--
	% check some fields for consistency
	%--
	
	% TODO: write some value tests here
	
end


%------------------------------------------------------------------------
% GET_RECORDING_INFO
%------------------------------------------------------------------------

function [info,format] = get_recording_info(recording)

% get_recording_info - get recording source info
% --------------------------------------------
%
% [info,format] = get_recording_info(recording)
%
% Input:
% ------
%  recording - recording configuration structure
%
% Output:
% -------
%  info - recording info
%  format - file format of output files, this is a supported format

% NOTE: this function computes standard sound file header info as well as filenames

%--
% output file info
%--

% TODO: we may record to a single file as well

info.type = 'file stream';

info.path = create_dir([recording.path, filesep, recording.name, filesep]);

if (isempty(info.path))
	error('Unable to create recording output file directory.');
end

%--
% rate and channels info
%--

info.samplerate = recording.samplerate;

info.channels = length(recording.channels);

if (isempty(info.channels))
	error('No channels selected.');
end

%--
% samples info 
%--

% NOTE: we need to compute number of files and file durations

file_duration = time_to_seconds(recording.file_length{1});

[N,last_duration] = div_rem(recording.duration,file_duration);

file_durations = file_duration * ones(N,1);

if (last_duration)
	file_durations(end + 1) = last_duration;
end

%----------------------

info.samples = file_durations * recording.samplerate;	

%--
% get file extension from format
%--

format = get_formats([],'name',recording.format{1});

if (isempty(format))
	error('Unable to find requested output file format.');
end

ext = format(1).ext{1};

%--
% file names
%--

% NOTE: file names are based on sound name and time stamps

name = [strrep(recording.name,' ','_'), '_'];

time_stamps = strrep(sec_to_clock(cumsum([0; file_durations(1:end-1)])),':','');

info.file = strcat(name,time_stamps);
	
% NOTE: remove decimal positions produced by sec_to_clock

for k = 1:length(info.file)
	info.file{k}(end - 2:end) = [];
end

info.file = strcat(info.file,['.', ext]);

info.file = info.file(:);



%----------------------------
% GET_WORKSPACE_DIALOG
%----------------------------

function [name, rate] = get_workspace_dialog

name = [];

vars = evalin('base', 'whos');

names = {vars.name};

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'string', 'Variables' ...
);

if isempty(names)
	state = '__DISABLE__'; names = {'(No Variables Found)'};
else
	state = '__ENABLE__';
end

control(end + 1) = control_create( ...
	'name', 'name', ...
	'style', 'popup', ...
	'string', names, ...
	'value', 1, ...
	'initialstate', state ...
);


control(end + 1) = control_create( ...
	'name', 'rate', ...
	'style', 'slider', ...
	'min', 1, ...
	'max', 1000000, ...
	'value', 8000 ...
);

opt = dialog_group;

opt.width = 12;

result = dialog_group('Select Variable', control, opt);

if ~strcmp(result.action, 'ok')
	return;
end

name = result.values.name{1};

rate = result.values.rate;





