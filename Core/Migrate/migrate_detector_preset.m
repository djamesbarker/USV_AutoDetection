function preset = migrate_detector_preset(file)

%--
% handle input
%--

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

if ~nargin
	[file, path] = uigetfile2; file = fullfile(path, file);
end

if ischar(file)
	old_preset = load(file); old_preset = old_preset.preset;
else
	old_preset = file;
end

opt = struct_update; opt.flatten = 0;

ext = get_extension('sound_detector', 'Data Template');

%--
% get spectrogram parameters from stored sound in old preset
%--

sound = update_sound(old_preset.sound);

ext.parameter.specgram = sound.specgram;

ext.parameter = struct_update(ext.parameter, old_preset.parameter, opt);

ext.parameter.templates = update_templates(old_preset.parameter.templates);

%--
% create new preset
%--

preset = preset_create;

preset = struct_update(preset, old_preset, opt);

preset.ext = ext;

%--
% save it
%--

preset_save(preset);


%----------------------------------
% UPDATE TEMPLATES
%----------------------------------

function templates = update_templates(old_templates)

templates = old_templates;

opt = struct_update; opt.flatten = 0;

%--
% loop over clips
%--

clip = empty(clip_create);

for k = 1:length(old_templates.clip)
	
	event = update_event(old_templates.clip(k).event, 1);	
	
	clip(end + 1) = struct_update(clip_create, old_templates.clip(k));
	
	% NOTE: the definition of clip mode has changed
	
	if clip(end).mode == 2
		clip(end).mode = 1;
	elseif clip(end).mode == 1
		clip(end).mode = 2;
	end
	
	clip(end).event = event;
	
end

templates.clip = clip;

templates.curr_id = templates.length + 1;


	


	
	
	
	
	
	








