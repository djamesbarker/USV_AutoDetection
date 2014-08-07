function new_extension_menu(par)

% new_extension_menu - create menu to create new extensions
% ---------------------------------------------------------
%
% new_extension_menu(par)
%
% Input:
% ------
%  par - menu parent

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

% NOTE: consider using a single 'File' menu on the XBAT palette

%----------------------
% SETUP
%----------------------

%--
% refresh all browser menus if we are not given a parent
%--

% NOTE: this is not meant to be exposed

if ~nargin
	iterate(get_xbat_figs('type', 'sound')); return;
end
		
%--
% clear former menu if needed
%--

top = findobj(par, 'type', 'uimenu', 'tag', 'TOP_EXTENSION_MENU');

if ~isempty(top)
	delete(allchild(top));
end

%----------------------
% CREATE MENUS
%----------------------

%--
% create top menu if needed
%--

if isempty(top)
	top = uimenu(par, 'label', 'EXT', 'tag', 'TOP_EXTENSION_MENU');
end 

%--
% create command menus
%--

new = uimenu(top, ...
	'label', 'New' ...
);

% new = top;

%--
% create new_extension menus
%--

types = get_extension_types;

if isempty(types)
	
	uimenu(new, ...
		'label', '(No Extension Types Found)', ... 
		'enable', 'off', ...
		'separator', 'on' ...
	);

else

	uimenu(new, ...
		'label', 'Extension ...', ...
		'callback', {@new_extension_callback, '', par} ...
	);

	uimenu(new, ...
		'label', '(Types)', ...
		'separator', 'on', ...
		'enable', 'off' ...
	);

	named = [];

	for k = 1:length(types)
		named(end + 1) = uimenu(new, ...
			'label', [title_caps(types{k}), ' ...'], ...
			'callback', {@new_extension_callback, types{k}, par} ...
		);
	end

% 	set(named(1), 'separator', 'on');

end

uimenu(top, ...
	'label', 'Refresh', ...
	'separator', 'on', ...
	'callback', {@refresh_menu_callback, par} ...
);

uimenu(top, ...
	'label', 'Show Files ...', ...
	'separator', 'off', ...
	'callback', @show_files_callback ...
);


%--------------------------------------
% SAVE_EXTENSION_CALLBACK
%--------------------------------------

function new_extension_callback(obj, eventdata, type, par)

%--
% present dialog to create new extension
%--

new_extension_dialog(type, par);


%--------------------------------------
% REFRESH_MENU_CALLBACK
%--------------------------------------

function refresh_menu_callback(obj, eventdata, par)

% TODO: refresh extension types

new_extension_menu(par);


%--------------------------------------
% SHOW_FILES_CALLBACK
%--------------------------------------

function show_files_callback(obj, eventdata)

root = fileparts(which('signal_filter'));

show_file(root);



