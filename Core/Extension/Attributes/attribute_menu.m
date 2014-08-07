function handles = attribute_menu(par, lib, sound)

% attribute_menu - attach attribute menu to parent
% ------------------------------------------------
%
% handles = attribute_menu(par)
%
% Input:
% ------
%  par - parent handle
%
% Output:
% -------
%  handles - menu handles

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

%---------------------
% HANDLE INPUT
%---------------------

if nargin < 3 || isempty(sound)
    [sound, lib] = get_selected_sound;
end

%---------------------
% SETUP
%---------------------

label = get(par, 'label');

if ~strcmpi(label, 'Attributes')
	return;
end

%--
% remove current children and callback
%--

% NOTE: the callback set may fail if the parent was a figure

delete(allchild(par)); set(par, 'callback', []);

%--
% initialize handles
%--

handles = [];

%--
% get attributes
%--

ext = get_extensions('sound_attributes');

%---------------------
% CREATE MENU
%---------------------

% NOTE: return early creating informative menu

if isempty(ext)
	
	handles(end + 1) = uimenu(par, ...
		'label', '(No Attributes Found)', 'enable', 'off' ...
	);

	return;

end

if numel(sound) ~= 1
	
	handles(end + 1) = uimenu(par, ...
		'label', '(Multiple Sounds Selected)', 'enable', 'off' ...
	);

	return;	
	
end

%--
% separate attributes into existing and addable
%--

% NOTE: this function might load the values as well

sound = sound_attribute_update(sound, lib);

available = {sound.attributes.name}; addable = ext;

for k = length(ext):-1:1	
	
	if ~ismember(ext(k).name, available)
		ext(k) = [];
	else
		addable(k) = [];
	end
	
end
	
%--
% create menus for existing sound attributes
%--

% NOTE: this menu construction makes attributes behave as measures and others

for k = 1:length(ext)
	
	%--
	% create attribute display menu
	%--
	
	handles(end + 1) = uimenu(par, ...
		'label', [title_caps(ext(k).name), '  '], ...
		'tag', ext(k).name ...
	);

	value = get_sound_attribute(sound, ext(k).name);
	
	% NOTE: if a custom attribute display is not available use a generic
	
	if ~isempty(ext(k).fun.menu) && ~isempty(value)
		
		try
			ext(k).fun.menu(handles(end), value);
		catch
			extension_warning(ext(k), 'Menu creation failed.', lasterror);
		end
		
	else
		
		if ~isempty(value)
			struct_menu(handles(end), value);
		else
			uimenu(handles(end), 'label', 'EMPTY??');
        end
        
	end
	
	%--
	% create attribute editing menu 
	%--
	
	if k > 1
		set(handles(end), 'separator', 'on');
	end
	
	handles(end + 1) = uimenu(par, ...
		'label', 'Edit ...', ...
		'tag', ext(k).name, ...
		'callback', {@attribute_dispatch, ext(k)} ...
	);

end

if isempty(addable)
	return;
end

% NOTE: the tag is so that 'get_callback_context' partially works

add_menu = uimenu(par, ...
	'label', 'Add Attribute', ...
	'tag', 'add_attribute' ...
);
	
if ~isempty(handles)
	set(add_menu, 'separator', 'on');
end

handles(end + 1) = add_menu;

for k = 1:length(addable)
	
	handles(end + 1) = uimenu(add_menu, ...
		'label', [title_caps(addable(k).name), ' ...'], ...
		'tag', addable(k).name, ...
		'callback', {@attribute_dispatch, addable(k), 1} ...
	);
	
end

