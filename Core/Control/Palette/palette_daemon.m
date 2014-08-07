function daemon = palette_daemon

% palette_daemon - create a timer object to handle palette display
% ----------------------------------------------------------------
%
% daemon = palette_daemon
%
% Output:
% -------
%  daemon - timer object

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
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

% NOTE: this code enforces a singleton condition

%--
% look for timer
%--

daemon = timerfind('name','XBAT Palette Daemon');

%--
% create and configure timer if needed
%--

if (isempty(daemon))

	% TODO: extend timer to verbose timer by routing callbacks
	
	daemon = timer;

	set(daemon, ...
		'name', 'XBAT Palette Daemon', ...
		'timerfcn', @update_palette_display, ...
		'executionmode', 'fixedDelay', ...
		'period', 0.25 ...
	);

end


%---------------------------------------------------
% UPDATE_PALETTE_DISPLAY
%---------------------------------------------------

function update_palette_display(obj,evendata)

% update_palette_display - callback to update palette display
% -----------------------------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%--------------------------------------------------------------------------
% PALETTE VISIBILITY
%--------------------------------------------------------------------------

persistent INIT_FIG CURRENT_FIGURE;

%--
% check for open figures, get current figure if possible
%--

if (isempty(get(0,'children')))
	return;
end

h = get_active_browser;

%--
% create persistent current figure and control stores
%--

if (isempty(INIT_FIG))
	INIT_FIG = 1; CURRENT_FIGURE = h;
end

%--
% act on figure initialization or change
%--

if (INIT_FIG || ~isequal(h,CURRENT_FIGURE))
		
	%--
	% get figure info from tag
	%--
		
	info = parse_tag(get(h,'tag'));
	
	%--
	% update palette visibility
	%--

	% NOTE: turn off double click, code does not distinguish program and GUI calls
		
	% NOTE: trivial exception handler keeps double click on
		
	if (strcmp(info.type,'XBAT_SOUND_BROWSER'))

		double_click('off');
		
		try
			browser_palettes(h,'Show');
		end
		
		double_click('on'); 
				
	end
	
	%--
	% update persistent stores
	%--

	INIT_FIG = 0; CURRENT_FIGURE = h;

end

%--------------------------------------------------------------------------
% CURRENT CONTROL HIGHLIGHT
%--------------------------------------------------------------------------

% NOTE: this feature is not currently stable

return;


persistent INIT_CONTROL;

global CURRENT_CONTROL;

%--
% return if neither palette or dialog is focus
%--

if (~(is_palette(h) || is_dialog(h)))
	highlight(CURRENT_CONTROL,'fade'); return;
end

%--
% get control under pointer, return if we hover no control
%--

control = over_control;

if (isempty(control))
	highlight(CURRENT_CONTROL,'fade'); return;
end

%--
% return if neither palette or dialog is parent of hover control
%--

h = ancestor(control.handle,'figure');

if (~(is_palette(h) || is_dialog(h)))
	highlight(CURRENT_CONTROL,'fade'); return;
end

%--
% return for disabled hover control
%--

if (~control.axes && strcmp(get(control.handle,'enable'),'off'))
	highlight(CURRENT_CONTROL,'fade'); return;
end

%--
% return if control colors are not defined for this style
%--

colors = control_colors;

if (control.axes)
	style = 'axes';
else
	style = get(control.handle,'style');
end 

if (~isfield(colors,style))
	highlight(CURRENT_CONTROL,'fade'); return; 
end

%--
% store persistent current control handle
%--

if (isempty(CURRENT_CONTROL))
	INIT_CONTROL = 1; CURRENT_CONTROL = control.handle;
else
	INIT_CONTROL = 0;
end

%--
% update current control highlight
%--

if (INIT_CONTROL || ~isequal(control.handle,CURRENT_CONTROL))
		
	%--
	% update old and new highlight
	%--
	
	% NOTE: order matters here, it affects focus
	
	highlight(CURRENT_CONTROL,'off');
	
	highlight(control.handle,'on');
	
	%--
	% update persistent stores
	%--
	
	INIT_CONTROL = 0; CURRENT_CONTROL = control.handle;
	
%--
% refresh current control highlight
%--

elseif (isequal(control.handle,CURRENT_CONTROL))

% 	highlight(obj,'on');

end


%-----------------------------------------------
% OVER_CONTROL
%-----------------------------------------------

function control = over_control
		
% over_control - get control we are hovering
% ------------------------------------------
%
% control = over_control
%
% Output:
% -------
%  control - control handle and axes value

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%--
% get control or axes we are hovering
%--

obj = overobj('uicontrol');

if (~isempty(obj))
	
	style = get(obj,'style');
	
	% NOTE: only consider 'edit' and 'sliders' as hover controls
	
	switch (style)
		
		case ('edit')
			
		case ('slider'), control = []; return;
			
		otherwise, control = []; return;
	
	end
	
end

% NOTE: we are not considering hover axes anymore

% if (isempty(obj))
% 	obj = overobj('axes');
% end

% NOTE: return simple empty when not over control

if (isempty(obj))
	control = []; return;
end

%--
% check that object belongs to control and whether it's an axes
%--

[value,flag_axes] = in_control(obj);

%--
% return handle and axes test if needed
%--

if (value)
	control.handle = obj; control.axes = flag_axes;
else 
	control = [];
end


%-----------------------------------------------
% IN_CONTROL
%-----------------------------------------------

function [value,flag] = in_control(obj)

% in_control - test if object is part of control
% ----------------------------------------------
%
% [value,flag] = in_control(obj)
%
% Input:
% ------
%  obj - object handle
% 
% Output:
% -------
%  value - result of test
%  flag - indicate whether control is an axes control

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%--
% create persistens color distances
%--

colors = control_colors;

persistent SEP_BACK_HIGH;

if (isempty(SEP_BACK_HIGH))
	SEP_BACK_HIGH = max(abs(colors.axes.high  - colors.axes.back));
end

%--
% set reasonable default values
%--

value = 0; flag = 0;

%--
% check for name in tag
%--

% NOTE: return on empty name, all controls have names stored in tag

name = get(obj,'tag');

if (isempty(name))
	return;
end
		
%--
% check whether object is part of control
%--

switch (get(obj,'type'))
	
	%--
	% controls are controls
	%--
	
	case ('uicontrol'), value = 1;
	
	%--
	% axes are sometimes controls
	%--
		
	case ('axes')
		
		% NOTE: we skip axes test if control is not palette or dialog
		
		par = get(obj,'parent'); 
		
		if (~(is_palette(par) || is_dialog(par)))
			return;
		end
		
		%--
		% color test for controls
		%--
		
		% NOTE: this makes sense since after all highlight is color based
						
		color = get(obj,'color');
				
		sep_back = max(abs(color - colors.axes.back));
		
		sep_high = max(abs(color - colors.axes.high));
				
		sep = min(sep_back,sep_high);
		
		if (sep <= SEP_BACK_HIGH)
			value = 1; flag = 1;
		end
		
end


%-----------------------------------------------
% HIGHLIGHT
%-----------------------------------------------

function highlight(obj,state)

% highlight - update highlight display state of control
% -----------------------------------------------------
%
% highlight(obj,state)
%
% Input:
% ------
%  obj - object to highlight
%  state - state update

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

global CURRENT_CONTROL;

%--
% setup persistent steal state
%--

persistent STEAL_FOCUS;

if (isempty(STEAL_FOCUS))
	STEAL_FOCUS = 0;
end

%--
% return quickly if handle is empty or not valid
%--

if (isempty(obj) || ~ishandle(obj) || strcmp(get(obj,'beingdeleted'),'on'))
	STEAL_FOCUS = 0; return;
end

%--
% get control colors and style
%--

colors = control_colors; 

switch (get(obj,'type'))
	
	case ('axes')
		style = 'axes'; prop = 'color';
		
	otherwise
		style = get(obj,'style'); prop = 'backgroundcolor';
		
end

%--
% update highlight state
%--

switch (state)
	
	%--------------------------
	% ON
	%--------------------------
	
	case ('on')
		
		%--
		% return if control is highlighted
		%--
		
		% NOTE: style retrieves from the structure
		
		sep = max(abs(get(obj,prop) - colors.(style).high));
		
		if (sep < 0.001)
			return;
		end
		
		%--
		% highlight control
		%--
				
		set(obj,prop,colors.(style).high);
		
		% NOTE: give focus and alert thief
		
		focus(obj); STEAL_FOCUS = 1;
		
		% db_disp([get(obj,'tag'), ': on']);
		
	%--------------------------
	% OFF
	%--------------------------
	
	case ('off')
		
		%--
		% turn off highlight
		%--
		
		set(obj,prop,colors.(style).back);
		
		% NOTE: unfocus and rest thief
		
		unfocus(obj); STEAL_FOCUS = 0;
		
		% db_disp([get(obj,'tag'), ': off']);
		
	%--------------------------
	% DECAY
	%--------------------------
	
	case ('fade')
		
		%--
		% fade and stealing are related, return
		%--
		
		if (~STEAL_FOCUS)
			return;
		end
		
		%--
		% fade highlight display
		%--

		% NOTE: this is a simple delayed fade, less resource intensive
		
		value = colors.(style).back;
		
		set(obj,prop,value);

		%--
		% steal focus
		%--
		
		% NOTE: we let the label steal the focus if available
			
		par = get(obj,'parent');

		label = findobj(par, ...
			'tag',get(obj,'tag'),'style','text' ...
		);

		if (~isempty(label))
			focus(label);
		end

		% NOTE: thief is done, nothing left to steal

		STEAL_FOCUS = 0; CURRENT_CONTROL = [];

		% db_disp([get(obj,'tag'), ': fade is done']);
									
end


%-----------------------------------------------
% FOCUS
%-----------------------------------------------

function focus(obj)

% focus - set focus on object
% ---------------------------
%
% focus(obj)
%
% Input:
% ------
%  obj - object handle

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

% NOTE: focus functions are typically named as the object type

switch (get(obj,'type'))
	
	case ('axes'), axes(obj);
	
	case ('figure'), figure(obj);
	
	case ('uicontrol')
		
		switch (get(obj,'style'))
			
			% NOTE: focusing the popupmenu hides the highlight so don't focus
			
			case ('popupmenu'), return;
				
			otherwise, uicontrol(obj);
				
		end
	
end


%-----------------------------------------------
% UNFOCUS
%-----------------------------------------------

function unfocus(obj)

% unfocus - steal focus from control object
% -----------------------------------------
%
% unfocus(obj)
%
% Input:
% ------
%  obj - object that we want to steal focus from

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

% NOTE: we are only unfocusing controls

if (~strcmp(get(obj,'type'),'uicontrol'))
	return;
end

%--
% get control parent
%--

par = ancestor(obj,'figure');

if (isempty(par))
	return;
end

visible = get(par,'visible');

% NOTE: deal with orphaned focus rather than flash figure

if (strcmp(visible,'off'))
	return;
end

%--
% create invisible temporary control, focus on it, and destroy it
%--

temp = uicontrol(par,'visible','off'); 

uicontrol(temp); 

delete(temp);
