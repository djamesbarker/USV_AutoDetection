function explain = explain_figure(par, ext, data)

% explain_figure - create explain figure
% --------------------------------------
%
% explain = explain_figure(par, ext, data)
%
% Input:
% ------
%  par - parent figure
%  ext - extension to explain
%
% Output:
% -------
%  explain - explain figure

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

%----------------------------
% HANDLE INPUT
%----------------------------

explain = [];

%--
% check browser input
%--

if ~is_browser(par)
	return;
end

%--
% get browser state if needed
%--

if nargin < 3 || isempty(data)
	data = get_browser(par);
end

%----------------------------
% BUILD TAG AND NAME
%----------------------------

% NOTE: consider passing the sound or getting sound name from parent tag

% NOTE: we may want to include the extension name in the figure name

%--
% get tag and name elements
%--

TAG_PREFIX = 'XBAT_EXPLAIN_DISPLAY';

NAME_PREFIX = 'Explain';

user = get_active_user; 

lib = get_active_library(user); 

sound.name = sound_name(data.browser.sound);

%--
% put tag and name together
%--

% NOTE: this tag is sufficient for a single explain figure, for multiple explain add extension name

tag = [TAG_PREFIX, '::', user.name, '::', lib.name, '::', sound.name];

name = [' ', NAME_PREFIX, '  -  ', ext.name, '  -  ', sound.name];

%----------------------------
% CREATE FIGURE
%----------------------------

%--
% ensure singleton condition
%--

% NOTE: we may need a clear function for existing figure, or layout should do it

explain = findobj('tag', tag);

if (explain)
	return;
end

%--
% compute explain position based on parent
%--

% NOTE: we place explain right under parent

MARGIN = 64;

position = get(par, 'position'); position(2) = position(2) - position(4) - MARGIN;

%--
% add parent to state
%--

clear data;

data.parent = par;

%--
% create new figure and set relevant properties
%--

explain = figure( ...
	'tag', tag, ...
	'name', name, ...
	'userdata', data, ...
	'dockcontrols', 'off', ...
	'doublebuffer', 'on', ...
	'numbertitle', 'off', ...
	'position', position ...
);

%----------------------------
% CREATE MENUS
%----------------------------

%--
% TOP LEVEL MENUS
%--

menu = { ...
	'file', ...
	'view' ...
};

handles = [];

for k = 1:length(menu)
	
	handles(end + 1) = uimenu(explain, ...
		'label', title_caps(menu{k}), 'tag', menu{k} ...
	);

end

%--
% CHILDREN MENU
%--

%--
% file menu children
%--

handle = findobj(handles, 'tag', 'file');

if ~isempty(handle)

	%--
	% declare menu properties
	%--
	
	command = { ...
		'save_figure', ...
		'save_figure_as', ...
		'export_figure', ...
		'page_setup', ... 
		'print_preview', ...
		'print', ...
		'close' ...
	};
	
	separator = zeros(size(command)); separator([4,7]) = 1; separator = bin2str(separator);
	
	ellipsis = ones(size(command)); ellipsis([1,7]) = 0;
	
	%--
	% build menu
	%--
	
	for k = 1:length(command)

		%--
		% compute label
		%--
		
		label = title_caps(command{k});
		
		if ellipsis(k)
			label = [label, ' ...'];
		end

		%--
		% create menu
		%--
		
		% TODO: add callback, callback will use tag instead of label, primitive control with alias
		
		handles(end + 1) = uimenu(handle, ...
			'separator', separator{k}, ...
			'callback', @explain_callback, ...
			'label', label, ...
			'tag', command{k} ...
		);
	
	end

end

%--
% view menu children
%--

% NOTE: when extension has controllable explain parameters we build menu

fun = ext.fun.explain;

if (~isempty(fun.parameter.control.create))
	
	
	%--
	% current parameter display menu
	%--
	
	% NOTE: this was designed to be a display menu, not control menu ?
	
	if (~isempty(fun.parameter.menu))
		
	end

	%--
	% edit menu
	%--
	
	% NOTE: we can always have an edit all

	% TODO: where do we get the context and the current value
	
% 	control = ext.fun.explain.parameter.control.create(context);
	
	
	
end


%---------------------------------------------------------
% EXPLAIN_CALLBACK
%---------------------------------------------------------

% NOTE: this could be used for all callbacks, or renamed and used for file only

function explain_callback(obj, evendata)

callback = menu_callback_context(obj);

switch (callback.control.name)
	
	case ('save_figure')
		
	case ('save_figure_as')
		
	case ('export_figure')
		
	case ('page_setup')
		
	case ('print_preview')
		
	case ('print')
		
	case ('close')
		
end


%---------------------------------------------------------
% MENU_CALLBACK_CONTEXT
%---------------------------------------------------------

function callback = menu_callback_context(obj)

%--
% object 
%--

callback.obj = obj;

callback.control.name = get(obj,'tag');

%--
% parent object
%--

callback.parent.handle = get(obj, 'parent');

callback.parent.type = get(callback.parent.handle, 'type');

switch (callback.parent.type)
	
	case ('uimenu')
		
		callback.parent.name = get(callback.parent.handle, 'tag');
		
		callback.parent.label = get(callback.parent.handle, 'label');
		
	% NOTE: the most likely parent is a figure, it could also be a context menu ?
	
	otherwise
		
		callback.parent.name = [];
		
		callback.parent.label = [];
		
end

%--
% parent figure
%--

callback.figure.handle = ancestor(obj, 'figure');

callback.figure.name = get(callback.figure.handle, 'name');

callback.figure.tag = get(callback.figure.handle, 'tag');
