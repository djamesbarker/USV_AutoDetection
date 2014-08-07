function g = selection_view_menu(h)

% selection_view_menu - create menu for selection view options
% ------------------------------------------------------------
%
% g = selection_view_menu(h)
%
% Input:
% ------
%  h - menu parent figure
%
% Output:
% -------
%  g - menu handles

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

% NOTE: that this kind of framework makes it easy to create dynamic menus

%----------------------------------------
% CREATE VIEW MENU ITEMS
%----------------------------------------

%--
% increase and decrease zoom
%--

% NOTE: using the '+' accelerator causes problems

menu(1) = menu_create( ...
	'name','increase', ...
	'alias','Increase', ...
	'accelerator','=', ...
	'callback', @selection_view_callback ...
);

menu(end + 1) = menu_create( ...
	'name','decrease', ...
	'alias','Decrease', ...
	'accelerator','-', ...
	'callback', @selection_view_callback ...
);

%--
% specific zoom values
%--

menu(end + 1) = menu_create( ...
	'name','1x', ...
	'alias','1x', ...
	'separator','on', ...
	'callback', @selection_view_callback ...
);

menu(end + 1) = menu_create( ...
	'name','2x', ...
	'alias','2x', ...
	'callback', @selection_view_callback ...
);

menu(end + 1) = menu_create( ...
	'name','3x', ...
	'alias','3x', ...
	'callback', @selection_view_callback ...
);

menu(end + 1) = menu_create( ...
	'name','4x', ...
	'alias','4x', ...
	'callback', @selection_view_callback ...
);

%--
% display elements
%--

% NOTE: there is an opporunity for extensible displays here

% menu(end + 1) = menu_create( ...
% 	'name','display', ...
% 	'alias','(Display)', ...
% 	'enable','off', ...
% 	'separator','on' ...
% );
% 
% menu(end + 1) = menu_create( ...
% 	'name','waveform', ...
% 	'alias','Waveform', ...
% 	'callback', @selection_view_callback ...
% );
% 
% menu(end + 1) = menu_create( ...
% 	'name','spectrum', ...
% 	'alias','Spectrum', ...
% 	'callback', @selection_view_callback ...
% );

%----------------------------------------
% CREATE VIEW MENU
%----------------------------------------

% NOTE: we need to create parent menu

g1 = uimenu(h, ...
	'tag','zoom', ...
	'label','Zoom' ...
);

g = menu_group(g1,menu);

%----------------------------------------
% DISPLAY STATE IN MENU
%----------------------------------------

state = get(h,'userdata');

% NOTE: the state display is redundant using the check and the zoom label

tmp = findobj(g,'tag',[int2str(state.zoom), 'x']);

set(g,'check','off'); set(tmp,'check','on');

set(g1,'label',['Zoom (', get(tmp,'tag'), ')']);


%---------------------------------------------------------------------
% SELECTION_VIEW_CALLBACK
%---------------------------------------------------------------------

% NOTE: putting this code here does not make it easily available for automation

% NOTE: the use or variable arguments after the obligatory inputs allows for arbitrary parameters

function selection_view_callback(obj,eventdata,varargin)

% selection_view_callback - callbacks for selection view
% ------------------------------------------------------
%
% selection_view_callback(obj,eventdata)
%
% Input:
% ------
%  obj - callback object handle (menu in this case)
%  eventdata - not used yet

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

% NOTE: the callback is selected using the menu 'name'

tag = get(obj,'tag'); 

switch (tag)
	
	%--
	% increase and decrease zoom level
	%--

	case ('increase')
		
		h = ancestor(obj,'figure');
		
		state = get(h,'userdata');
		
		if (state.zoom < 4)
			
			tag = [int2str(state.zoom + 1), 'x'];
			
			g = findobj(h,'type','uimenu','tag',tag);
			
			if (~isempty(g))
				selection_view_callback(g,[]);
			end
			
		end		
		
	case ('decrease')
		
		h = ancestor(obj,'figure');
		
		state = get(h,'userdata');
		
		if (state.zoom > 1)
			
			tag = [int2str(state.zoom - 1), 'x'];
			
			g = findobj(h,'type','uimenu','tag',tag);
			
			if (~isempty(g))
				selection_view_callback(g,[]);
			end
			
		end		
		
	%--
	% set zoom level
	%--
	
	case ({'1x','2x','3x','4x'})
		
		%--
		% update menu state display
		%--
		
		g = findobj(gcf,'type','uimenu');
		
		% NOTE: the state display is redundant using the check and the zoom label
		
		set(g,'check','off'); set(obj,'check','on');
		
		set(findobj(g,'tag','zoom'),'label',['Zoom (', tag, ')']);
		
		%--
		% update state
		%--
		
		h = ancestor(obj,'figure');
		
		state = get(h,'userdata');
		
		state.zoom = eval(tag(1));
		
		set(h,'userdata',state);
		
		%--
		% update display enforcing resize
		%--

		opt = selection_display;

		opt.resize = 1;

		selection_display(state.parent,[],opt);
		
		figure(h);
		
	% NOTE: the cases below will most likely involve the extension of the
	% selection display options, and will probably be moved to a separate
	% menu
	
	% NOTE: a rank approximation display would probably be useful as well,
	% this display may then be reused for all variety of clips, measurement
	% grids should also be provided and value displays on a status bar
	
	%--
	% toggle waveform display
	%--
	
	case ('waveform')
	
	%--
	% toggle spectrum display
	%--
	
	case ('spectrum')

end


% NOTE: the following menu functions prototype what the next menu framework may look like

%---------------------------------------------------------------------
% MENU_CREATE
%---------------------------------------------------------------------

function menu = menu_create(varargin)

% menu_create - create menu structure
% -----------------------------------
% 
% menu = menu_create
%
% Output:
% -------
%  menu - menu structure

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

persistent MENU_PERSISTENT;

if (isempty(MENU_PERSISTENT))
	
	%----------------------------------------
	% CREATE MENU STRUCTURE
	%----------------------------------------

	menu.name = [];

	menu.alias = [];

	menu.callback = [];

	menu.accelerator = '';

	menu.check = 'off';

	menu.enable = 'on';

	menu.separator = 'off';
	
else
	
	%--
	% copy persistent menu
	%--
	
	menu = MENU_PERSISTENT;
	
end

%----------------------------------------
% SET FIELDS IF PROVIDED
%----------------------------------------

if (length(varargin))
	menu = parse_inputs(menu,varargin{:});
end


%---------------------------------------------------------------------
% MENU_GROUP
%---------------------------------------------------------------------

function g = menu_group(h,menu)

% menu_group - attach menu group to parent
% ----------------------------------------
% 
% g = menu_group(h,menu)
%
% Input:
% ------
%  h - parent of menu group
%  menu - menu structure array
%
% Output:
% -------
%  g - menu handles

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

% NOTE: in this framework we use function handles for callbacks

%----------------------------------------
% CREATE MENUS
%----------------------------------------

for k = 1:length(menu)

	%--
	% create menu according to specifications
	%--
	
	g(k) = uimenu(h, ...
		'tag', menu(k).name, ...
		'label', menu(k).alias, ...
		'callback', menu(k).callback, ...
		'accelerator',menu(k).accelerator, ...
		'check', menu(k).check, ...
		'enable', menu(k).enable, ...
		'separator', menu(k).separator ...
	);
	
end
	
	
	
	
	
