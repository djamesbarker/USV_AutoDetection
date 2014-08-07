function [info, file] = save_preset_dialog(preset, type)

% save_preset_dialog - create preset menu
% --------------------------------------
%
% [info, file] = save_preset_dialog(preset, type)
%
% Input:
% ------
%  preset - preset to save
%  type - preset type
%
% Output:
% -------
%  info - preset file info
%  file - preset file

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

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% set default preset type
%--

if nargin < 2
	type = '';
end

%-----------------------
% CREATE CONTROLS
%-----------------------

control = empty(control_create);

%-----------------
% INFO
%-----------------

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', ['Preset  (', preset.ext.name, ')'] ...
);

%--
% name
%--

% NOTE: the number of lines along with the dialog group options produce a square

control(end + 1) = control_create( ...
	'name', 'name', ...
	'space', 1, ...
	'onload', 1, ...
	'style', 'edit', ...
	'type', 'filename' ...
);

%--
% tags
%--

control(end + 1) = control_create( ...
	'name', 'tags', ...
	'style', 'edit', ...
	'space', 0.75, ...
	'color', ones(1,3) ...
);

%--
% notes
%--

control(end + 1) = control_create( ...
	'name', 'notes', ...
	'style', 'edit', ...
	'color', ones(1,3), ...
	'lines', 3 ...
);

%----------------------------------
% CREATE DIALOG
%----------------------------------

%--
% configure dialog options
%--

opt = dialog_group;

opt.width = 12;

opt.header_color = get_extension_color(preset.ext.subtype);

opt.text_menu = 1;

name = 'Save ...';

%--
% create dialog
%--

out = dialog_group(name, control, opt, @save_preset_callback);

if strcmpi(out.action, 'cancel')
	info = []; file = ''; return;
end

values = out.values;

%--
% update preser and return
%--

[info, file] = preset_save(preset, values.name, type, values.tags, values.notes);


%----------------------------------
% SAVE_PRESET_CALLBACK
%----------------------------------

function save_preset_callback(obj, eventdata)

[control, pal] = get_callback_context(obj);

switch control.name
	
	case 'name'
		
		set_control(pal.handle, 'OK', 'enable', proper_filename(get(obj, 'string')));
		
	case 'tags'
		
		value = tags_to_str(str_to_tags(get_control(pal.handle, 'tags', 'value')));
		
		set_control(pal.handle, 'tags', 'value', value);
		
	case 'notes'
	
end

