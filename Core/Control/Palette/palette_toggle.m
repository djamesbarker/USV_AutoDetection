function palette_toggle(h, palette, control, value, data)

% palette_toggle - open and close sections of a control group
% -----------------------------------------------------------
%
% palette_toggle(h, palette, control, state, data)
%
% palette_toggle(g, control, state)
% 
% Input:
% ------
%  h - parent figure of palette
%  g - palette handle
%  palette - palette name
%  control - control name
%  value - desired state for toggle 'close' or 'open'
%  data - userdata of parent figure

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

% TODO: there is bug recognizing headers when they are not collapsible

% TODO: refactor this and add 'toggle_data' and 'toggle_move' functions

% NOTE: another way to implement headers may use the typical value store of
% axes based controls, the axes 'userdata' to store the relevant state

%------------------------------------------------------------------
% SET CONSTANTS
%------------------------------------------------------------------

% TODO: consider making these persistent

% TODO: make colors come from a color table in some way, configurable

%--
% color constants
%--

BLACK = [0, 0, 0];

MEDIUM_GRAY = [128, 128, 128] / 255;

LIGHT_GRAY  = [192, 192, 192] / 255;

FIGURE_COLOR = get(0,'Defaultuicontrolbackgroundcolor');

%--
% other constants
%--

HOFF = 10^6; 

TEXT_OFF = 1.1 * MEDIUM_GRAY; 

TEXT_ON = BLACK;

COLOR_OFF = (LIGHT_GRAY + FIGURE_COLOR) / 2;

%------------------------------------------------------------------
% HANDLE INPUT
%------------------------------------------------------------------

%----------------------------------
% GUI TOGGLE CALL
%----------------------------------

if (nargin < 1)
	
	%--
	% get container handles
	%--
	
	% NOTE: we get toggle axes, and palette handle
	
	parent = gcbo;
	
	g = gcbf;
	
	%--
	% get state from toggle axes contents
	%--
	
	child = get(parent,'children');
	
	toggle = findobj(child,'tag','header_toggle');
		
	text = findobj(child,'tag','header_text');
	
	image = findobj(child,'tag','header_image');
			
	% TODO: separate text and image here, do this by tagging in 'control_group' perhaps
	
	state = get(toggle,'string');
	
%----------------------------------
% PROGRAM TOGGLE CALL
%----------------------------------

elseif (nargin == 3)
	
	%--
	% rename input
	%--
	
	g = h;
	
	toggle = palette;
	
	value = control;

	%--
	% get other relevant state information and handles
	%--
	
	% NOTE: most of these handles are used to modify objects for visual effect
	
	parent = get(toggle,'parent');
	
	child = get(parent,'children');
	
	text = findobj(child,'tag','header_text');
	
	image = findobj(child,'tag','header_image');
	
	state = get(toggle,'string');
	
	% NOTE: return if we are in desired specified state or if state is empty
	
	if (isempty(value))
		return;
	end
			
	if ( ...
		(strcmp(value,'close') && strcmp(state,'+')) || ...
		(strcmp(value,'open') && strcmp(state,'-')) ...
	)
		return;
	end
	
else
	
	%--
	% get parent userdata if not provided
	%--
	
	if ((nargin < 5) || isempty(data))
		data = get(h,'userdata');
	end
	
	if ((nargin < 4) || isempty(value))
		value = '';
	end
	
	%--
	% get container handles
	%--
	
	g = get_palette(h,palette,data);
	
	if (isempty(g))
		return;
	end
	
	parent = findobj(g,'type','axes','tag',control);
	
	child = get(parent,'children');
	
	%--
	% get state indicator handles and state
	%--
	
	toggle = findobj(child,'tag','toggle');
	
	% return if toggle is not available
	
	if (isempty(toggle))
		return;
	end
	
	% logical subscripting
	
	text = child(child ~= toggle);
		
	state = get(toggle,'string');
	
	%--
	% return if we are in desired specified state
	%--
	
	if (~isempty(value))
		
		if ( ...
			(strcmp(value,'close') && strcmp(state,'+')) || ...
			(strcmp(value,'open') && strcmp(state,'-')) ...
		)
			return;
		end
		
	end
	
end

%--
% make sure that the resize function of the palette remains empty
%--

set(g,'resizefcn','');

%----------------------------------
% CHANGE STATE OF TAB
%----------------------------------

switch (state)
	
	%--------------------------------------------------------------
	% CLOSE TAB
	%--------------------------------------------------------------
	
	case ('-')
		
		%--------------------------------------------------------------
		% CHECK FOR TOGGLE DATA
		%--------------------------------------------------------------
		
		data = get(g,'userdata');
		
		if (~isfield(data,'toggle'))
			flag = 1;
		else
			flag = 0;
		end
		
		%--------------------------------------------------------------
		% CREATE TOGGLE DATA 
		%--------------------------------------------------------------

		if (flag)
			
			%----------------------------------
			% SET PIXEL UNITS FOR CHILDREN
			%----------------------------------
			
			%--
			% get all objects and their type
			%--
			
			obj = findall(g);
			
			type = get(obj,'type');
			
			%--
			% remove objects for which units is not a property
			%--
			
			% NOTE: I don't remember creating an 'hggroup' object
			
			types = { ...
				'uicontextmenu', ...
				'uimenu', ...
				'line', ...
				'patch', ...
				'image', ...
				'rectangle', ...
				'hggroup' ...
			};
			
			ix = [];
			
			for k = 1:length(types)
				
				kix = find(strcmp(type,types{k}));
				
				if (~isempty(kix))
					ix = [ix; kix(:)];
				end
				
			end
		
			obj(ix) = [];
			
			%--
			% set remaining object units to pixels
			%--

			set(obj,'units','pixels');
			
			%----------------------------------
			% SORT TOGGLES BY POSITION
			%----------------------------------
			
			%--
			% get parent axes positions
			%--
			
			tog = findobj(obj,'flat','tag','header_toggle');
					
			if (length(tog) > 1)
				
				par = cell2mat(get(tog,'parent')); post = get(par,'position');
				
			else
				
				par = get(tog,'parent'); post = {get(par,'position')};
				
			end
			
			%--
			% sort in descending vertical position
			%--
			
			for k = 1:length(post)
				tmp(k) = post{k}(2);
			end
			
			[ignore,ix] = sort(tmp);
						
			ix = fliplr(ix);
		
			tog = tog(ix);
			
			par = par(ix);
			
			%----------------------------------
			% GET TOGGLE CHILDREN INFO
			%----------------------------------
			
			pos = get(obj,'position');
			
			nt = length(tog);
			
			for k = 1:length(tog)
			
				%--
				% get position of current and next toggle if it exists
				%--
				
				if (k < nt)
					
					posc = get(par(k),'position');
					posn = get(par(k + 1),'position');
					
					data.toggle(k).toggle = tog(k);
					data.toggle(k).parent = par(k);
					data.toggle(k).head = posc(4);
					data.toggle(k).body = (posc(2) - posn(2)) - posc(4);
					
					data.toggle(k).color = get(par(k),'color');
					
				else
					
					posc = get(par(k),'position');
					posn = [];	
					
					data.toggle(k).toggle = tog(k);
					data.toggle(k).parent = par(k);
					data.toggle(k).head = posc(4);
					data.toggle(k).body = posc(2);
					
					data.toggle(k).color = get(par(k),'color');
					
				end
			
				%--
				% select objects between current and next toggle
				%--
			
				j = 1;
				
				if (k < nt)

					for i = 1:length(obj)
						
						if ( ...
							(strcmp(get(obj(i),'type'),'uicontrol') || strcmp(get(obj(i),'type'),'axes')) && ...
							(pos{i}(2) < posc(2)) && ...
							(pos{i}(2) > posn(2)) ...
						)	
					
							data.toggle(k).child(j) = obj(i);
							data.toggle(k).pos{j} = pos{i};
							j = j + 1;
							
						end
						
					end
								
				else

					for i = 1:length(pos)
						
						if ( ...
							(strcmp(get(obj(i),'type'),'uicontrol') || strcmp(get(obj(i),'type'),'axes')) && ...
							(pos{i}(2) < posc(2)) ...
						)
					
							data.toggle(k).child(j) = obj(i);
							data.toggle(k).pos{j} = pos{i};
							j = j + 1;
							
						end
						
					end
									
				end
			
			end
			
			%----------------------------------
			% RELATIVE CHILDREN POSITION
			%----------------------------------
		
			for k = 1:nt
				
				for j = 1:length(data.toggle(k).child)
					
					part = 0;
					for i = (k + 1):nt
						part = part + (data.toggle(i).body + data.toggle(i).head);
					end
															
					data.toggle(k).pos{j}(2) = data.toggle(k).pos{j}(2) - part;
										
				end
				
			end
			
			%----------------------------------
			% STORE TOGGLE DATA
			%----------------------------------
			
			set(g,'userdata',data);
						
		end
		
		%----------------------------------
		% CHANGE STATE
		%----------------------------------
		
		% NOTE: part of this is state the other part is visual
		
		set(toggle,'string','+');
						
		off_color = (2 * COLOR_OFF + get(parent,'color')) / 3;
		
		set(parent, ...
			'color', off_color ...
		);
	
		set_header_image(parent,off_color);
				
		set(text, ...
			'color', TEXT_OFF, ...
			'hittest', 'off' ...
		);
	
		%----------------------------------
		% MOVE OBJECTS TO PRODUCE TOGGLE
		%----------------------------------
		
		%--
		% determine which toggle
		%--
		
		ixc = find(struct_field(data.toggle,'toggle') == toggle);
		
		%--
		% shift objects that belong to this toggle
		%--
		
		for k = 1:length(data.toggle(ixc).child)
				
			posk = get(data.toggle(ixc).child(k),'position');
			
			posk(1) = posk(1) + HOFF;

			set(data.toggle(ixc).child(k),'position',posk);
						
		end

		%----------------------------------
		% RESIZE FIGURE
		%----------------------------------
							
		posf = get(g,'position');

		posf(4) = posf(4) - data.toggle(ixc).body;
		posf(2) = posf(2) + data.toggle(ixc).body;
		
		set(g,'position',posf);
		
		%----------------------------------
		% POSITION VISIBLE OBJECTS
		%----------------------------------
		
		% NOTE: this means whether they belong to an open or closed toggles
		
		%--
		% get tab states
		%--
		
		nt = length(data.toggle);
		
		for k = 1:nt
			visible(k) = strcmp(get(data.toggle(k).toggle,'string'),'-');
		end
						
		%--
		% reposition objects
		%--
		
		for k = 1:nt
			
			%--
			% reposition toggle parents
			%--
			
			part = visible(k) * data.toggle(k).body;
			
			for j = (k + 1):nt
				part = part + data.toggle(j).head + (visible(j) * data.toggle(j).body);
			end 
						
			posk = get(data.toggle(k).parent,'position');
			
			posk(2) = part;
			
			set(data.toggle(k).parent,'position',posk);
						
			%--
			% reposition visible children 
			%--
			
			if (visible(k))
				
				for j = 1:length(data.toggle(k).child)
					
					part = 0;
					
					for i = (k + 1):nt
						part = part + data.toggle(i).head + (visible(i) * data.toggle(i).body);
					end 
					
					posj = data.toggle(k).pos{j};
					posj(2) = posj(2) + part;
					
					set(data.toggle(k).child(j),'position',posj);
										
				end
				
			end
			
		end
		
		%----------------------------------
		% PLAY SOUND
		%----------------------------------
		
		toggle_sound('close');
		
	%----------------------------------
	% OPEN TAB
	%----------------------------------
	
	case ('+')
		
		%----------------------------------
		% GET TOGGLE DATA
		%----------------------------------
		
		data = get(g,'userdata');
		
		%--
		% determine which toggle
		%--
		
		ixc = find(struct_field(data.toggle,'toggle') == toggle);
		
		%----------------------------------
		% RESIZE FIGURE
		%----------------------------------
		
		posf = get(g,'position');
				
		posf(4) = posf(4) + data.toggle(ixc).body;
		
		posf(2) = posf(2) - data.toggle(ixc).body;
		
		% NOTE: this is test code to handle palettes that are too tall for the screen
		
		screen_size = get(0,'screensize');
		
		if (posf(4) >= screen_size(4))
			
			% TODO: display message, use environment variable control
			
			rgb = get(parent, 'color');
			
			set_header_image(parent, ([1 0.5 0] + 2 * rgb) / 3); 
			 
			pause(0.1);
			
			set_header_image(parent ,rgb);
	
			return;
			
		end
		
		set(g,'position',posf);
		
		%----------------------------------
		% CHANGE STATE
		%----------------------------------
		
		set(toggle,'string','-');
		
		on_color = data.toggle(ixc).color;
		
		set_header_image(parent,on_color);
		
		set(text, ...
			'color',TEXT_ON, ...
			'hittest','off' ...
		);
		
		set(parent,'color',on_color);
		
		%----------------------------------
		% MOVE OBJECTS TO PRODUCE TOGGLE
		%----------------------------------
		
		%--
		% shift objects that belong to this toggle
		%--
		
		for k = 1:length(data.toggle(ixc).child)
			
			posk = get(data.toggle(ixc).child(k),'position');
			
			posk(1) = posk(1) - HOFF;
			
			set(data.toggle(ixc).child(k),'position',posk);
			
		end
		
		%----------------------------------
		% POSITION VISIBLE OBJECTS
		%----------------------------------

		%--
		% get tab states
		%--
		
		nt = length(data.toggle);
		
		for k = 1:nt
			visible(k) = strcmp(get(data.toggle(k).toggle,'string'),'-');
		end
				
		%--
		% reposition objects
		%--
		
		for k = 1:nt
			
			%--
			% reposition toggle parents
			%--
			
			part = visible(k) * data.toggle(k).body;
			
			for j = (k + 1):nt
				part = part + data.toggle(j).head + (visible(j) * data.toggle(j).body);
			end
			
			posk = get(data.toggle(k).parent,'position');
			
			posk(2) = part;
			
			set(data.toggle(k).parent,'position',posk);
						
			%--
			% reposition visible children
			%--
			
			if (visible(k))
				
				for j = 1:length(data.toggle(k).child)
					
					part = 0;
					
					for i = (k + 1):nt
						part = part + data.toggle(i).head + (visible(i) * data.toggle(i).body);
					end 
									
					posj = data.toggle(k).pos{j};
					
					posj(2) = posj(2) + part;
					
					set(data.toggle(k).child(j),'position',posj);
				
										
				end
				
			end
			
		end
		
		%----------------------------------
		% PLAY SOUND
		%----------------------------------
		
		toggle_sound('open');
				
end
