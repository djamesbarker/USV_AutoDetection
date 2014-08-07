function value = extension_menus(pal, ext)

% extension_menus - add extension menus to palettes
% -------------------------------------------------
%
% value = extension_menus(pal)
%
% Input:
% ------
%  pal - palette handle
%
% Output:
% -------
%  value - extension menus indicator

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

%--
% check palette is extension palette and get extension
%--

if nargin < 2
	[value, ext] = is_extension_palette(pal);
else
	value = is_extension_palette(pal);
end

%--
% add extension menus
%--

if value
	
	%--
	% add extension user menus
	%--
	
	% TODO: first simple dialog only implementation, then menu editing as well
	
	preset_menu(pal, ext);
	
	parameter_menu(pal, ext);
	
	help_menu(pal, ext);
	
	% EXPERIMENTAL CODE
	
	% NOTE: the state query required for the state is relatively expensive
	
	if ext.active && ~is_widget(ext)
		
		par = get_palette_parent(pal);

		if ~isempty(par)
			toggle_menu(pal, ext, get_extension_active_state(par, ext));
		end
		
	end
	
	%--
	% add extension developer menus
	%--
	
	pal_menu(pal, '', ext.subtype);
	
end


%-------------------------------------------
% GET_EXTENSION_ACTIVE_STATE
%-------------------------------------------

function state = get_extension_active_state(par, ext, data)

%--
% get browser state if needed
%--

if nargin < 3
	data = get_browser(par);
end

%--
% get active extension of relevant type and test
%--

active = data.browser.(ext.subtype).active;

if isempty(active)
	state = 0;
else
	state = strcmp(active, ext.name);
end


%-------------------------------------------
% PARAMETER_MENU
%-------------------------------------------

function parameter_menu(pal, ext)

%--
% check we are a widget, and that we can have presets
%--

% NOTE: having presets is a backwards proxy for controllable parameters

if ~is_widget(ext) || ~has_presets(ext)
	return;
end

% TODO: consider using the parameter menu function in the API for this

uimenu(pal, ...
	'label', 'Configure ...', ...
	'callback', {@edit_widget_parameters, pal, ext} ...
);


%-------------------------------------------
% EDIT_WIDGET_PARAMETERS
%-------------------------------------------

function edit_widget_parameters(obj, eventdata, widget, ext)

%--
% get parameters from widget
%--

ext = get_widget_extension(widget);

parameter = ext.parameter;

%--
% present parameter editing dialog
%--

% TODO: figure out how to load the parameters into the dialog

%--
% update extension parameters in widget
%--

ext.parameter = parameter;

set_widget_extension(widget, ext);

