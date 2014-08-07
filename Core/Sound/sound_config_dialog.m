function out = sound_config_dialog(sound)

% sound_config_dialog - configurable sound options dialog
% -----------------------------------------------------
%
% out = sound_config_dialog(sound)
%
% Input:
% ------
%  sound - sound to edit
%
% Output:
% -------
%  out - dialog output

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
	sound = get_selected_sound;
end

if numel(sound) ~= 1
	return;
end

%--
% create sound name header
%--

control(1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'space', 0.1, ...
	'min', 1, ...
	'string', sound_name(sound) ...
);

%--
% create tabs
%--

tabs = {'Basic', 'Sources'};

% NOTE: the format tab is for format specific configuration options

format_test = 0;

if format_test
	tabs{end + 1} = 'Format';
end

control(end + 1) = control_create( ...
	'name','config_tabs', ...
	'style','tabs', ...
	'lines',1.25, ...
	'tab',tabs ...
);

%---------------------
% TAGS AND NOTES
%---------------------

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'tab', tabs{1}, ...
	'align', 'right', ...
	'string', 'Info' ...
);

control(end + 1) = control_create( ...
	'name', 'tags', ...
	'style', 'edit', ...
	'string', sound.tags, ...
	'tab', tabs{1}, ...
	'space', 0.75, ...
	'color', ones(1,3) ...
);

str = sound.notes;

control(end + 1) = control_create( ...
	'name', 'notes', ...
	'style', 'edit', ...
	'string', sound.notes, ...
	'tab', tabs{1}, ...
	'color', ones(1,3), ...
	'lines', 4, ...
	'space', 1.5 ...
);

%---------------------
% CLASS
%---------------------

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'tab', tabs{1}, ...
	'align', 'right', ...
	'string', 'Data Type and Rate' ...
);

types = upper(get_sound_output_types);

value = find(strcmpi(types, sound.output.class));

if isempty(value)
	value = 1;
end

%--
% create controls
%--

control(end + 1) = control_create( ...
	'name', 'class', ...
	'alias','datatype', ...
	'style', 'popup', ...
	'tab', tabs{1}, ...
	'space',1.5, ...
	'string', types, ...
	'value', value ...
);	

%---------------------
% SAMPLERATE
%---------------------

%--
% get current rate
%--

if ~isempty(sound.output.rate)
	value = sound.output.rate; state = 1; status = '__ENABLE__';
else
	value = sound.samplerate; state = 0; status = '__DISABLE__';
end

%--
% create controls
%--

control(end + 1) = control_create( ...
    'name','samplerate', ...
    'style','slider', ...
	'tab', tabs{1}, ...
	'space',1, ...
    'min', 100, ...
    'max', 96000, ...
    'value', value, ...
	'initialstate', status ...
);

control(end + 1) = control_create( ...
	'name', 'resample', ...
	'style', 'checkbox', ...
	'tab', tabs{1}, ...
	'value', state ...
);

%-----------------------
% SOURCES
%-----------------------

sources = get_extensions('source');

control(end + 1) = control_create( ...
	'name', 'available_sources', ...
	'style', 'listbox', ...
	'tab', tabs{2}, ...
	'lines', 3, ...
	'space', 0.75, ...
	'string', {sources.name}, ...
	'value', [], ...
	'onload', 1, ...
	'min', 1, ...
	'max', 3 ...
);

control(end + 1) = control_create( ...
	'name', {'add', 'rem'}, ...	
	'alias', {'+', '-'}, ...
	'style', 'buttongroup', ...
	'tab', tabs{2}, ...
	'width', 1/3, ...
	'align', 'right', ...
	'lines', 1.5, ...
	'space', -0.25 ...
);

if isfield(sound.output, 'source') && ~isempty(sound.output.source)
	current_names = {sound.output.source(:).name};
else
	current_names = {};
end

control(end + 1) = control_create( ...
	'name', 'sound_sources', ...
	'style', 'listbox', ...
	'tab', tabs{2}, ...
	'lines', 3, ...
	'string', current_names, ...
	'value', [], ...
	'min', 1, ...
	'max', 3 ...
);

%-----------------------------------------------------
% CREATE DIALOG
%-----------------------------------------------------

%--
% configure dialog options
%--

opt = dialog_group;

opt.width = 14;

opt.header_color = get_extension_color('root');

%--
% create dialog
%--

name = 'Configure';

out = dialog_group(name, control, opt, {@dialog_callback, sound});


%---------------------------------------------------------
% DIALOG_CALLBACK
%---------------------------------------------------------

function result = dialog_callback(obj,eventdata,sound)

result = [];

[control,par] = get_callback_context(obj); 

lib = get_active_library;

to_add = get_control(par.handle, 'available_sources', 'value');

to_remove = get_control(par.handle, 'sound_sources', 'value');

han = get_control(par.handle, 'sound_sources', 'handles');

%--
% display source menu
%--

out = sound_load(lib,sound_name(sound)); sound = out.sound;

menu = uicontextmenu; 

source_menu(menu, sound);

set(han.obj, ...
	'UIContextMenu', menu ...
);

if isfield(sound.output, 'source') && ~isempty(sound.output.source)
	current_names = {sound.output.source(:).name};
else
	current_names = {};
end

if ~strcmp(control.name, 'sound_sources')
	set(han.obj, ...
		'string', current_names, ...
		'value', [] ...
	);
end

%--
% perform control-specific action
%--

switch control.name
	
	%--
	% source datatype control
	%--
	
	case 'class'

		values = get_control_values(par.handle);
		
	%--
	% resample state control
	%--
	
	case 'resample'
		
		values = get_control_values(par.handle);
		
		if values.resample
			
			control_update([],par.handle,'samplerate', '__ENABLE__');
			
		else
			
			% NOTE: we set the samplerate display to the native samplerate
			
			control_update([],par.handle,'samplerate',sound.samplerate);
			
			control_update([],par.handle,'samplerate', '__DISABLE__');
			
		end
	
	%--
	% resample rate control
	%--
	
	case 'samplerate'
		
		slider_sync(obj,control.handles);	
		
		values = get_control_values(par.handle);
		
		control_update([],par.handle,'samplerate',round(values.samplerate));
		
	case 'add'
		
		if isempty(to_add)
			return;
		end
		
		for k = 1:length(to_add)
			
			ext = get_extension('source', to_add{k});
			
			if ~isfield(sound.output, 'source') || isempty(sound.output.source)
				sound.output.source = ext; continue;
			end
			
			if ~ismember(to_add{k}, {sound.output.source(:).name})
				sound.output.source(end + 1) = ext;
			end		
			
		end	
		
		set(han.obj, ...
			'string', union(current_names, to_add), ...
			'value', [] ...
		);
		
	case 'rem'
		
		if isempty(to_remove)
			return;
		end
		
		set(han.obj, 'string', setdiff(current_names, to_remove), 'value', []);
		
		if ~isfield(sound.output, 'source') || isempty(sound.output.source)
			return;
		end
		
		for k = 1:length(to_remove)
			
			ix = find(strcmp({sound.output.source(:).name}, to_remove{k}));
			
			sound.output.source(ix) = [];
			
		end		
		
	
end

sound_save(lib,sound,out.state);
