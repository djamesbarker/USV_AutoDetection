function result = parameter__control__callback(callback, context)

% DETECT - parameter__control__callback

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

result = [];

switch callback.control.name
	
	case 'detector'

		%--
		% get detector extension
		%--
		
		detector = get_control(callback.pal.handle, 'detector', 'value');
		
		ext = get_extensions('sound_detector', 'name', detector{1});
		
		%--
		% get preset names
		%--
		
		presets = {};
		
		if ~isempty(ext)
			presets = get_preset_names(ext);
		end
		
		% NOTE: this may happen under various conditions
		
		if isempty(presets)
			presets = {'(No Presets Found)'};
		end

		%--
		% update presets control
		%--
		
		handles = get_control(callback.pal.handle, 'preset', 'handles');
		
		set(handles.obj, 'string', presets, 'value', []);
		
	case 'preset'
		
		% TODO: this will update the preset info controls in the future
		
	case 'output'
		
		% TODO: allow for some tokens
		
end

%--
% update state of OK button
%--

% NOTE: consider having a type validation callback and extending validation

handles = get_control(callback.pal.handle, 'output', 'handles');

set_control(callback.pal.handle, 'OK', ...
	'enable', proper_filename(get(handles.obj, 'string')) ...
);




