function preset_menu(par, ext)

% preset_menu - create preset menu for extension
% ------------------------------------------
%
% preset_menu(par, ext)
%
% Input:
% ------
%  par - menu parent
%  ext - extension (def: get from parent figure)

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

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% get extension from parent figure
%--

% NOTE: typically 'par' and 'pal' are the same

pal = ancestor(par, 'figure');

if nargin < 2
	
	% NOTE: this seems to happen in two places, here and 'preset_compile'
	
	[value, ext] = is_extension_palette(pal);
	
	if ~value
		error('Unable to get extension from palette.');
	end
	
end

%--
% check if extension has presets
%--

if ~has_presets(ext)
	return;
end 

%--------------------------
% SETUP
%--------------------------

%--
% clear former menu if needed
%--

top = findobj(par, 'type', 'uimenu', 'tag', 'TOP_PRESET_MENU');

if ~isempty(top)
	delete(allchild(top));
end

%--------------------------
% CREATE PRESET MENU
%--------------------------

%--
% create top menu if needed
%--

if isempty(top)
	top = uimenu(par, 'label', 'Presets', 'tag', 'TOP_PRESET_MENU');
end 

%--
% create command menus
%--

% TODO: develop a browse command, to search preset collection

uimenu(top, ...
	'label', 'Save ...', ...
	'callback', {@save_preset_callback, par, ext} ...
);

uimenu(top, ...
	'enable', 'on', ...
	'label', 'Load ...', ...
	'callback', {@load_preset_callback, pal, ext} ...
);

%--
% create preset menus
%--

names = file_ext(get_preset_files(ext));

name = [];

if isfield(ext.parameter, 'preset_name')
	name = ext.parameter.preset_name;
end

if isempty(names)
	
	uimenu(top, ...
		'label', '(No Presets Found)', ...
		'enable', 'off', ...
		'separator', 'on' ...
	);

else
	
	uimenu(top, ...
		'label', '(Presets)', ...
		'separator', 'on', ...
		'enable', 'off' ...
	);

	named = [];

	for k = 1:length(names)
		
		if strcmpi(names{k}, name)
			label = ['*', names{k}];
		else
			label = names{k};
		end
		
		named(end + 1) = uimenu(top, ...
			'label', label, ...
			'callback', {@open_preset_callback, pal, ext} ...
		);
	end

% 	set(named(1), 'separator', 'on');
	
end

uimenu(top, ...
	'label', 'Refresh', ...
	'separator', 'on', ...
	'callback', {@refresh_menu_callback, par, ext} ...
);

uimenu(top, ...
	'label', 'Show Files ...', ...
	'separator', 'off', ...
	'callback', {@show_files_callback, ext} ...
);


%-------------------------------------
% SAVE_PRESET_CALLBACK
%-------------------------------------

function save_preset_callback(obj, eventdata, par, ext) 

%--
% compile preset
%--

pal = ancestor(par, 'figure');

preset = preset_compile(pal);

%--
% present dialog to save session
%--

info = save_preset_dialog(preset);

% NOTE: return if no session was saved

if isempty(info)
	return;
end 

%--
% rebuild preset menu
%--

preset_menu(par, ext);


%-------------------------------------
% LOAD_PRESET_CALLBACK
%-------------------------------------

function load_preset_callback(obj, eventdata, pal, ext) 

%--
% load preset through dialog
%--

preset = load_preset_dialog(ext);

if isempty(preset)
	return;
end 
	
%--
% load preset into browser
%--

par = get_palette_parent(pal);

if isempty(par)
	return;
end 

% TODO: get system extension and update with some preset fields

preset.ext.parameter.preset_name = preset.name;

set_browser_extension(par, preset.ext);

menu_par = get_menu(pal,'Presets');

preset_menu(menu_par, preset.ext);


%-------------------------------------
% OPEN_PRESET_CALLBACK
%-------------------------------------

function open_preset_callback(obj, eventdata, pal, ext) 

%--
% load preset from file
%--

name = get(obj, 'label');

name = strrep(name, '*', '');

preset = preset_load(ext, name);

%--
% load preset into browser
%--

par = get_palette_parent(pal);

if isempty(par)
	return;
end 

% TODO: get system extension and update with some preset fields

preset.ext.parameter.preset_name = preset.name;

set_browser_extension(par, preset.ext);


menu_par = get_menu(pal,'Presets');

preset_menu(menu_par, preset.ext);


%--------------------------------------
% REFRESH_MENU_CALLBACK
%--------------------------------------

function refresh_menu_callback(obj, eventdata, par, ext)

preset_menu(par, ext);


%-------------------------------------
% SHOW_FILES_CALLBACK
%-------------------------------------

function show_files_callback(obj, eventdata, ext)

show_file(preset_dir(ext));
