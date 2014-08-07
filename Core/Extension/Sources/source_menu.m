function handles = source_menu(par, sound, ext);

% source_menu - create a menu for a source extension
% --------------------------------------------------
%
% handles = source_menu(par, sound, ext)
%
% Input:
% ------
%  par - parent menu
%  sound - the sound
%  ext - the source extension
%
% Output:
% -------
%  handles - handles to the created menu group

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

if isempty(par)
	return;
end

if nargin < 2 || isempty(sound)
    [sound, lib] = get_selected_sound;
end

%---------------------
% SETUP
%---------------------

%--
% get extension from sound
%--

if nargin < 3 || isempty(ext)
	
	if isfield(sound.output, 'source') && ~isempty(sound.output.source)
		ext = sound.output.source;
	else
		ext = [];
	end
end

%--
% initialize handles
%--

handles = [];

%---------------------
% CREATE MENU
%---------------------

% NOTE: return early creating informative menu

if isempty(ext)
	
	handles(end + 1) = uimenu(par, ...
		'label', '(No Sources Found)', 'enable', 'off' ...
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
% create menus for existing sound sources
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

	value = ext(k).parameter;
	
	% NOTE: if a custom attribute display is not available use a generic
	
	if isfield(ext(k).fun, 'menu') && ~isempty(ext(k).fun.menu) && ~isempty(value)
		
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
		'callback', {@source_dispatch, ext(k)} ...
	);

end

