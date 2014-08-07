function preset = load_preset_dialog(ext)

% load_preset_dialog - allow user to select from available presets to load
% ------------------------------------------------------------------------
%
% preset = load_preset_dialog(ext)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  preset - loaded preset

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

%------------------------
% HANDLE INPUT
%------------------------

%--
% get presets
%--

files = get_preset_files(ext); names = file_ext(files);

% NOTE: there is nothing to load return

if isempty(names)
	preset = []; return; 
end

%------------------------
% CREATE DIALOG
%------------------------

%--
% create controls
%--

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', ['Preset  (', ext.name, ')'] ...
);

control(end + 1) = control_create( ...
	'name', 'name', ... 
	'style', 'popup', ...
	'onload', 1, ...
	'string', names, ...
	'value', 1 ...
);

control(end + 1) = control_create( ...
	'name', 'info', ...
	'style', 'listbox', ...
	'max', 2, ...
	'lines', 3 ...
);

%--
% configure dialog
%--

opt = dialog_group; 

opt.width = 12;

opt.text_menu = 1;

% TODO: consider a helper that gets the parent color and add parent input

opt.header_color = get_extension_color(ext.subtype);

%--
% present dialog
%--

out = dialog_group('Load ...', control, opt, {@load_preset_callback, ext});

% NOTE: if dialog was cancelled or aborted return

values = out.values;

if isempty(values)
	preset = []; return;
end

%--
% load preset
%--

% NOTE: the name value is packed in a cell

preset = preset_load(ext, values.name{1});


%------------------------------------
% LOAD_SESSION_CALLBACK
%------------------------------------

function load_preset_callback(obj, eventdata, ext)

%--
% get callback context
%--

[control, pal] = get_callback_context(obj);

%--
% handle control by name
%--

switch control.name
	
	case 'name'
		
		%--
		% get preset name and info handles
		%--
		
		name = get_control(pal.handle, 'name', 'value');
		
		handles = get_control(pal.handle, 'info', 'handles');

		%--
		% load preset and update info control
		%--
		
		preset = preset_load(ext, name{1});

		% TODO: we really want a preset info string function

		set(handles.obj, ...
			'string', preset_info_str(preset), ...
			'value', [] ...
		);
		
	case 'info'

end


%------------------------------------
% LOAD_SESSION_CALLBACK
%------------------------------------

function S = preset_info_str(preset)

% TODO: use a somewhat generic 'struct_info_str' for the preset

S = cell(0); 


