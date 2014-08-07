function result = migrate_dialog

%--
% create controls
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

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', 'XBAT' ...
);

control(end + 1) = control_create( ...
	'name', 'type', ...
	'alias', 'content', ...
	'style', 'popup', ...
	'string', migrate_types, ...
	'value', 1 ...
);

control(end + 1) = control_create( ...
	'name', 'source', ...
	'style', 'file', ...
	'type', 'dir', ...
	'lines', 5, ...
	'string', xbat_root, ...
	'space', 1 ...
);

%--
% create dialog and filter result
%--

opt = dialog_group; opt.header_color = get_extension_color('root');

result = dialog_group('Migrate', control, opt, @migrate_dialog_callback);

if strcmp(result.action, 'ok') && strcmp(result.values.type, 'All')
	result.values.type = {'Users'};
end
	
		
function result = migrate_dialog_callback(obj, eventdata)

result = [];

[control, pal] = get_callback_context(obj); 

switch control.name
	
	case 'type'
	
		han = get_control(pal.handle, 'source', 'handles');
		
		if ~isfield(han, 'uicontrol')
			return;
		end
		
		if ~isfield(han.uicontrol, 'pushbutton')
			return;
		end
		
		cback = get(han.uicontrol.pushbutton, 'callback');
		
		value = get_control(pal.handle, control.name, 'value');
		
		if strcmpi(value{1}, 'Log')
			cback{2}.type = 'file';
		else
			cback{2}.type = 'dir';
		end
		
		set(han.uicontrol.pushbutton, 'callback', cback);
				
end

