function pal = control_group(h, fun, name, control, opt, pal)

% control_group - create a group of buttons in figure
% ---------------------------------------------------
%
% opt = control_group
%
% pal = control_group(h, fun, name, control, opt, pal)
%
% Input:
% ------
%  h - controlled figure handle
%  fun - callback function
%  name - name for control group
%  control - array of control structures
%  opt - control group options
%  pal - parent figure handle (default: create new figure)
%
% Output:
% -------
%  opt - control group options
%  pal - handles to parent figure

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
% $Revision: 6983 $
% $Date: 2006-10-10 17:10:48 -0400 (Tue, 10 Oct 2006) $
%--------------------------------

% TODO: help template generation

%-----------------------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------------------

%--
% get and possibly output default palette options
%--

if (nargin < 5) || isempty(opt)
	
	opt = palette_options;

	if (nargin < 1)
		pal = opt; return;
	end

end

%-----------------------------------------------------------------
% SETUP
%-----------------------------------------------------------------

%-----------------------------
% FONTS
%-----------------------------

% TODO: this needs to be handled by a separate function

%--
% store default font properties
%--

DEFAULT_UIFONT_UNITS = get(0, 'defaultuicontrolfontunits');

DEFAULT_FONT_UNITS = get(0, 'defaulttextfontunits');

set(0, 'defaultuicontrolfontunits', 'pixels')

set(0, 'defaulttextfontunits', 'pixels');

DEFAULT_FONT_SIZE = get(0, 'defaultuicontrolfontsize');

%--
% set font properties based on palette settings
%--

% TODO: include size option in palette options

value = get_palette_settings;

if isempty(value)
	error('Unable to get palette settings.');
end

set(0, 'defaultuicontrolfontsize', value.fontsize);

%----------------------------------------------
% PREPARE CONTROLS AND INGREDIENTS
%----------------------------------------------

% NOTE: rename to produce readable code

controls = control;

%--
% update headers to reflect palette options and set layout defaults
%--

controls = set_color_headers(controls, opt);

% TODO: default spacing for control preceding tabs

controls = set_layout_defaults(controls, opt);

%--
% compute control positions
%--

% NOTE: we compile the tabs structure for reuse

tabs = compile_tabs(controls);

% NOTE: positions computed simultaneously are efficient

[positions, tile] = compile_positions(controls, opt, tabs);

%--
% compute control labels
%--

labels = cell(size(controls));

for k = 1:length(controls)
	labels{k} = get_label(controls(k), opt);
end

%----------------------------------------------
% CREATE FIGURE
%----------------------------------------------

%--
% create figure if needed
%--

if (nargin < 6) || isempty(pal)
	pal = figure;
end

%--
% compute palette position
%--

set(pal, 'units', 'pixels'); 

pos2 = get(pal, 'position'); 

pos2(3) = opt.tilesize / tile.width; 

pos2(4) = opt.tilesize / tile.height;

%--
% set palette properties
%--

color = get_computed_color;

% HACK: this is to help with the missing 'alias' for palettes

% if (isempty(opt.label_fun))
% 	temp = name;
% else
% 	temp = opt.label_fun(name);
% end
% 
% temp = [' ', temp];

temp = name;

set(pal, ...
	'name', temp, ...
	'numbertitle', 'off', ...
	'tag', 'PALETTE', ...
	'visible', 'off', ...
	'color', color.FIGURE_COLOR, ...
	'backingstore', 'on', ...
	'doublebuffer', 'on', ...
	'dockcontrols', 'off', ...
	'position', pos2, ...
	'resize', 'off' ...
);

%----------------------------------------------
% FINISH CONTROL INGREDIENTS
%----------------------------------------------

%--
% compute callbacks and tooltip
%--
	
% NOTE: these require the palette handle directly or indirectly

callbacks = cell(size(controls)); tooltips = cell(size(controls));

for k = 1:length(controls)

	% TODO: there are callback problems for dialogs
	
	callbacks{k} = get_computed_callback(controls(k), fun, pal, h, opt);

	tooltips{k} = get_computed_tooltip(controls(k), callbacks{k});

end

%-----------------------------------------------------------------
% CREATE CONTROLS
%-----------------------------------------------------------------

%--
% initialize active control array
%--

active = cell(0); lastvalue = [];

%--
% loop over control array
%--

for k = 1:length(controls)

	%--------------------------------------
	% SETUP
	%--------------------------------------
	
	%--
	% clear previous handles
	%--
	
	clear handles;
	
	%--
	% name ingredients for convenience and clearer code
	%--
	
	control = controls(k);
	
	callback = callbacks{k};
	
	position = positions{k};
	
	label = labels{k};
	
	tooltip = tooltips{k};
	
	color = get_computed_color(control, pal);
	
% 	aware = ~isempty(get_env('april'));
% 	
% 	if strncmp(date, '01-Apr', 6) && ~aware
% 		
% 		label = string_scramble(label); tooltip = string_scramble(tooltip);
% 		
% 	end

	%----------------------------------
	% CREATE LABEL
	%----------------------------------

	% NOTE: second part of condition hacks hiding labels without using label field
	
	if control.label && ~all(isspace(label))

		%--
		% align text according to layout
		%--
		
		switch control.layout

			case 'compact', align = 'right';

			otherwise, align = 'left';
				
		end

		%--
		% create text label
		%--
		
		handles.text = uicontrol(pal, ...
			'style', 'text', ...
			'units', 'normalized', ...
			'position', position.label, ...
			'foregroundcolor',color.text, ...
			'tag', control.name, ...
			'string', label, ...
			'horizontalalignment',align ...
		);
	
		uistack(handles.text, 'bottom');

	end
			
	%--------------------------------------
	% CREATE CONTROLS
	%--------------------------------------
	
	switch control.style
		
		%--------------------------------------
		% RATING CONTROL
		%--------------------------------------

		% NOTE: people love ratings ... little stars in particular
		
		case 'rating'
			
			%-----------------
			% AXES
			%-----------------
			
			% NOTE: consider light dislay of container axes and some margins
			
			pal_color = get(pal, 'color');
			
			handles.axes = axes( ...
				'parent', pal, ...
				'position', position.rating, ...
				'visible', 'on', ...
				'color', pal_color, ...
				'xcolor', pal_color, ...
				'ycolor', pal_color, ...
				'xlim', [0, 1], ...
				'ylim', [0, 1], ...
				'xticklabel', [], ...
				'yticklabel', [], ...
				'userdata', control.value, ...
				'tag', control.name ...
			);
		
			%-----------------
			% MARKERS
			%-----------------
			
			% NOTE: the markers reflect a value stored in the axes 
			
			% TODO: implement 'set' for this control type
			
			%--
			% set marker size
			%--
			
			switch control.marker
				
				case 'p', markersize = 11;
					
				otherwise, markersize = 8;
					
			end
			
			%--
			% compute marker positions
			%--
		
			x = linspace(0, 1, control.max);
			
			temp = get_size_in(handles.axes, 'in'); temp = temp(3);
			
			offset = (1.5 * markersize) / (2 * 72 * temp);
			
			x = (x ./ (1 + 2 * offset)) + offset;
			
			y = 0.5 * ones(size(x));
			
			%--
			% create markers
			%--
			
			handles.markers = [];
			
			for j = 1:control.max
				
				handles.markers(end + 1) = line(x(j), y(j), ...
					'parent', handles.axes, ...
					'linestyle', 'none', ...
					'clipping', 'off', ...
					'marker', control.marker, ...
					'markersize', markersize, ...
					'markeredgecolor', color.text, ...
					'tag', control.name ...
				);
			
			end
			
			%--
			% display value
			%--
			
			set(handles.markers, 'markerfacecolor', 'none');
			
			set(handles.markers(1:control.value), 'markerfacecolor', control.color);
			
			%--
			% set callback
			%--
			
			% NOTE: add handle to callback if needed

			if opt.handle_to_callback && ischar(callback)
				callback = strrep(callback, '__HANDLE__', num2str(handles.axes, 20));
			end
			
			% TODO: use control input to callback to control the setting of zero
			
			set(handles.markers, 'hittest', 'off');
			
			set(handles.axes, 'buttondownfcn', {@start_update_control, control, handles, callback});
			
		%--------------------------------------
		% SLIDER CONTROL
		%--------------------------------------

		% NOTE: slider control consists of slider, edit box, and text label

		case 'slider'

			%----------------------------------
			% SLIDER
			%----------------------------------

			%--
			% update active control arrays
			%--

			if control.active
				active{end + 1} = control.name;  lastvalue(end + 1) = control.value;
			end

			%--
			% create slider
			%--

			handles.slider = uicontrol(pal, ...
				'style', 'slider', ...
				'units', 'normalized', ...
				'position', position.slider, ...
				'background', color.slider.back, ...
				'tag', control.name, ...
				'userdata',control.type, ...
				'value', control.value, ...
				'min', control.min, ...
				'max', control.max, ...
				'sliderstep', control.sliderstep, ...
				'tooltipstring', tooltip ...
			);

			%----------------------------------
			% EDIT BOX
			%----------------------------------

			%--
			% create edit box
			%--

			handles.edit = uicontrol(pal, ...
				'style', 'edit', ...
				'units', 'normalized', ...
				'position', position.edit, ...
				'horizontalalignment', 'left', ...
				'background', color.edit.back, ...
				'tag', control.name ...
			);
			
			%--
			% add handle to callback if needed
			%--

			% TODO: this is common to controls using the string callback
			
			if opt.handle_to_callback && ischar(callback)
				mod_callback = strrep(callback, '__HANDLE__', num2str(handles.edit, 20));
			else
				mod_callback = callback;
			end

			%--
			% compute and set edit value string 
			%--

			value = get(handles.slider, 'value');

			switch control.type

				case 'integer', value = int2str(round(value));

				case 'time', value = sec_to_clock(value);

				otherwise, value = num2str(value);

			end

			set(handles.edit, 'string', value);
			
			%--
			% set edit callback
			%--

			set(handles.edit, 'callback', {@update_slider, control, handles, mod_callback});
			
			%--------------------------------
			% CALLBACK
			%--------------------------------
			
			%--
			% SLIDER
			%--
			
			%--
			% add handle to callback if needed
			%--
			
			slider_str = num2str(handles.slider, 20);

			if opt.handle_to_callback && ischar(callback)
				mod_callback = strrep(callback, '__HANDLE__', slider_str);
			else
				mod_callback = callback;
			end

			%--
			% set callback
			%--
			
			set(handles.slider, 'userdata', control.type);
			
			set(handles.slider, 'callback', {@update_slider, control, handles, mod_callback});
			
		%-----------------------------------------------------------------
		% FILE CONTROL
		%-----------------------------------------------------------------

		case 'file'

			%--
			% create file display
			%--
			
			% NOTE: the 'min' and 'max' properties are used to allow multiple lines

			handles.file = uicontrol(pal, ...
				'style', 'edit', ...
				'units', 'normalized', ...
				'position', position.file, ...
				'horizontalalignment','left', ...
				'background', color.file.back, ...
				'min', 0, ...
				'max', floor(control.lines), ...
				'tag', control.name, ...
				'string', control.string, ...
				'hittest', 'off', ...
				'tooltipstring', tooltip ...
			);
		
			%--
			% create browse button
			%--
			
			% NOTE: the 'min' and 'max' properties are used to allow multiple lines

			handles.browse = uicontrol(pal, ...
				'style', 'pushbutton', ...
				'units', 'normalized', ...
				'position', position.browse, ...
				'horizontalalignment','left', ...
				'tag', control.name, ...
				'string', 'Browse ...', ...
				'tooltipstring', tooltip ...
			);
		
			%--
			% set the button callback
			%--
			
			set(handles.browse, 'callback', {@file_browse_callback, control, handles});
			
		%-----------------------------------------------------------------
		% SCAN CONTROL
		%-----------------------------------------------------------------
		
		case 'scan'
			
			%--
			% create file display
			%--
			
			% NOTE: the 'min' and 'max' properties are used to allow multiple lines

			handles.file = uicontrol(pal, ...
				'style', 'listbox', ...
				'units', 'normalized', ...
				'position', position.file, ...
				'horizontalalignment','left', ...
				'background', color.file.back, ...
				'min', 0, ...
				'max', floor(control.lines), ...
				'tag', control.name, ...
				'string', control.string, ...
				'tooltipstring', tooltip ...
			);
		
			%--
			% create browse button
			%--
			
			% NOTE: the 'min' and 'max' properties are used to allow multiple lines

			handles.browse = uicontrol(pal, ...
				'style', 'pushbutton', ...
				'units', 'normalized', ...
				'position', position.browse, ...
				'horizontalalignment','left', ...
				'tag', control.name, ...
				'string', 'Edit ...', ...
				'tooltipstring', tooltip ...
			);
		
			%--
			% set the button callback
			%--
			
			if isempty(control.callback)
				control.callback = @scan_edit_dialog;
			end
			
			set(handles.browse, 'callback', control.callback);			
		
		%-----------------------------------------------------------------
		% EDIT CONTROL
		%-----------------------------------------------------------------

		case 'edit'

			%--
			% create control
			%--
			
			% NOTE: the 'min' and 'max' properties are used to allow multiple lines

			handles.edit = uicontrol(pal, ...
				'style', 'edit', ...
				'units', 'normalized', ...
				'position', position.edit, ...
				'horizontalalignment','left', ...
				'background', color.edit.back, ...
				'min', 0, ...
				'max', floor(control.lines), ...
				'tag', control.name, ...
				'string', control.string, ...
				'tooltipstring', tooltip ...
			);

			%--
			% set callback
			%--

			% NOTE: add handle to callback if needed

			if opt.handle_to_callback && ischar(callback)
				callback = strrep(callback, '__HANDLE__', num2str(handles.edit, 20));
			end

			set(handles.edit, 'callback', callback);
			
			set(handles.edit, 'callback', {@update_edit, control, handles, callback});

		%-----------------------------------------------------------------
		% POPUP CONTROL
		%-----------------------------------------------------------------
		
		case 'popup'

			%--
			% create control
			%--
			
			handles.edit = uicontrol(pal, ...
				'style', 'popup', ...
				'units', 'normalized', ...
				'position', position.popup, ...
				'horizontalalignment','left', ...
				'background', color.popup.back, ...
				'tag', control.name, ...
				'string', control.string, ...
				'value', control.value, ...
				'tooltipstring', tooltip ...
			);

			%--
			% set callback
			%--
			
			% NOTE: add handle to callback if needed
			
			if opt.handle_to_callback && ischar(callback)
				callback = strrep(callback, '__HANDLE__', num2str(handles.edit, 20));
			end

			set(handles.edit, 'callback', callback);

		%-----------------------------------------------------------------
		% LISTBOX CONTROL
		%-----------------------------------------------------------------

		case 'listbox'

			%--
			% create control
			%--

			handles.listbox = uicontrol(pal, ...
				'style', 'listbox', ...
				'units', 'normalized', ...
				'position', position.listbox, ...
				'horizontalalignment', 'left', ...
				'background', color.listbox.back, ...
				'tag', control.name, ...
				'string', control.string, ...
				'min', control.min, ...
				'max', control.max, ...
				'value', control.value, ...
				'tooltipstring', tooltip ...
			);

			%--
			% set callback
			%--
			
			% NOTE: add handle to callback if needed

			if opt.handle_to_callback && ischar(callback)
				mod_callback = strrep(callback, '__HANDLE__', num2str(handles.listbox, 20));
			else
				mod_callback = callback;
			end

			set(handles.listbox, 'callback', mod_callback);

			%-----------------------------------------------------------------
			% confirm buttons
			%-----------------------------------------------------------------

			% TODO: consider moving this functionality,to a new kind of control
			
			% NOTE: another possilbe types are link, and iconic display
			
			if control.confirm

				%-----------------------------------------------------------------
				% apply button
				%-----------------------------------------------------------------

				%--
				% create button
				%--

				handles.button = uicontrol(pal, ...
					'style', 'pushbutton', ...
					'units', 'normalized', ...
					'position', position.buttons{1}, ...
					'horizontalalignment','left', ...
					'tag', control.name, ...
					'string', 'Apply', ...
					'userdata', control.value, ...
					'tooltipstring', ['Apply ', lower(control.name), ' selection'] ...
				);

				%--
				% add handle to callback if needed
				%--

				if opt.handle_to_callback && ischar(callback)
					mod_callback = strrep(callback, '__HANDLE__', num2str(handles.button, 20));
				else
					mod_callback = callback;
				end

				%--
				% set callback
				%--

				set(handles.button, 'callback', mod_callback);

				% the button is turned off at creation

				set(handles.button, 'enable', 'off');

				%-----------------------------------------------------------------
				% cancel button
				%-----------------------------------------------------------------

				%--
				% create button
				%--

				handles.button = uicontrol(pal, ...
					'style', 'pushbutton', ...
					'units', 'normalized', ...
					'position', position.buttons{2}, ...
					'horizontalalignment','left', ...
					'tag', control.name, ...
					'string', 'Cancel', ...
					'value', control.value, ...
					'tooltipstring', ['Cancel ', lower(control.name), ' selection'] ...
				);

				%--
				% add handle to callback if needed
				%--

				if opt.handle_to_callback && ischar(callback)
					mod_callback = strrep(callback, '__HANDLE__', num2str(handles.button, 20));
				else
					mod_callback = callback;
				end

				%--
				% set callback
				%--

				set(handles.button, 'callback', mod_callback);

				% the button is turned off at creation

				set(handles.button, 'enable', 'off');

			end

		%-----------------------------------------------------------------
		% CHECKBOX CONTROL
		%-----------------------------------------------------------------

		% NOTE: checkbox control consists of single checkbox

		case 'checkbox'

			%-----------------------------------------------------------------
			% checkbox
			%-----------------------------------------------------------------

			%--
			% create checkbox
			%--

			handles.checkbox = uicontrol(pal, ...
				'style', 'checkbox', ...
				'units', 'normalized', ...
				'position', position.checkbox, ...
				'horizontalalignment','left', ...
				'tag', control.name, ...
				'string', label, ...
				'value', control.value, ...
				'tooltipstring', tooltip ...
			);

			%--
			% set callback
			%--
			
			% NOTE: add handle to callback if needed

			if (opt.handle_to_callback && ischar(callback))
				callback = strrep(callback,'__HANDLE__',num2str(handles.checkbox,20));
			end

			set(handles.checkbox,'callback',callback);

		%-----------------------------------------------------------------
		% SEPARATOR
		%-----------------------------------------------------------------

		% NOTE: separator control consists of an axes object

		% TODO: this branch is unnecessarily complex, distinctions are clear

		case 'separator'

			%-----------------------------------------------------------------
			% axes
			%-----------------------------------------------------------------

			%--
			% create axes
			%--
			
			handles.axes = axes( ...
				'parent', pal, ...
				'position', position.separator, ...
				'hittest', 'off', ...
				'xtick', [], ...
				'ytick', [], ...
				'xlim', [0,1], ...
				'ylim', [0,1], ...
				'xcolor', color.MEDIUM_GRAY, ...
				'ycolor', color.FIGURE_COLOR, ...
				'color', color.FIGURE_COLOR ...
			);

			%--
			% set string and convert to collapsible header separator
			%--

			switch control.type
				
				%------------------------
				% COLLAPSIBLE HEADER
				%------------------------
				
				case 'header'

					%--
					% resize and update other axes properties
					%--

					% TODO: evaluate whether the string property should be used for the tag

					set(handles.axes, ...
						'box', 'on', ...
						'hittest', 'on', ...
						'buttondownfcn', 'palette_toggle', ...
						'tag', control.name, ...
						'color', color.separator.back ...
					);
					
					% TODO: this needs to be fixed, at the moment the
					% string is constant and the name is random
					
					set(handles.axes, 'tag', control.string);
					
					hold(handles.axes, 'on');

					%--
					% add image to axes
					%--

					% NOTE: this will first provide a gradient display

					set_header_image(handles.axes, color.separator.back);

					%--
					% display header string and attach help if available
					%--

					if ~isempty(control.string)

						%--
						% create text object within header axes
						%--

						pad = max(opt.left, 1);

						handles.text = text((pad / (2 * opt.width)), 0.5, control.string);

						set(handles.text, ...
							'fontsize', 1.05 * get(0, 'defaultuicontrolfontsize') , ... % size now in pixels
							'tag', 'header_text', ...
							'hittest', 'off', ...
							'fontweight', 'bold' ...
						);

					end

					%--
					% display toggle indicator
					%--

					% NOTE: use control min property to set state of header, no

					if (control.min < 1)

						pad = max(opt.right, 1);

						handles.text = text(1 - (pad / (2 * opt.width)), 0.52, '-');

						set(handles.text, ...
							'tag', 'header_toggle', ...
							'hittest', 'off', ...
							'fontname', 'Courier', ...
							'fontsize', 1.8 * get(0,'defaultuicontrolfontsize'), ... % used to be fixed at 14 points
							'fontweight', 'normal', ...
							'color', color_to_rgb('Black'), ... % 'color',color_to_rgb('Red'), ...
							'horizontalalignment', 'right', ...
							'verticalalignment', 'middle' ...
						);

					else

						% NOTE: remove buttondown from axes

						set(handles.axes, 'buttondownfcn', '');

					end

				%------------------------
				% HIDDEN HEADER
				%------------------------

				% NOTE: this is a hack to end the scope of tabs
				
				case 'hidden_header'
					
					pad = max(opt.right, 1);
					 
					handles.text = text(1 - (pad / (2 * opt.width)), 0.52, '-');

					set(handles.text, ...
						'tag', 'header_toggle', ... 
						'visible', 'off', ... 
						'hittest', 'off' ...
					);
				
					% NOTE: this solved a problem where the header would show
					
					set(handles.axes, ...
						'visible', 'off', ...
						'hittest', 'off', ...
						'handlevisibility', 'off' ...
					);
					
				%------------------------
				% THIN SEPARATOR
				%------------------------
				
				otherwise
					
					%------------------------
					% LABELLED SEPARATOR
					%------------------------

					if ~isempty(control.string)

						%--
						% set axes tag
						%--

						set(handles.axes, 'tag', control.name);

						%--
						% create text object within separator axes
						%--

						% NOTE: we are not thinking of the display as the
						% name, it typically is
						
						str = ['  ', control.string, '  '];

						switch control.align

							case 'left'
								handles.text = text((opt.left * tile.width), 0, str);

							case 'center' 
								handles.text = text(0.5, 0, str);
								set(handles.text, 'horizontalalignment', 'center');

							case 'right'
								handles.text = text(1 - (opt.right * tile.width), 0, str);
								set(handles.text, 'horizontalalignment', 'right');

						end

						fs = get(0, 'defaultuicontrolfontsize');

						set(handles.text, ...
							'tag', control.name, ...
							'edgecolor', color.MEDIUM_GRAY, ...
							'backgroundcolor', color.FIGURE_COLOR, ...
							'fontsize', fs ...
						);

						if ~isempty(control.color)
							set(handles.text, 'backgroundcolor', (control.color + color.FIGURE_COLOR) / 2);
						end

					%------------------------
					% SIMPLE SEPARATOR
					%------------------------
						
					else

						set(handles.axes, 'tag', control.name);

					end
					
			end
			
		%-----------------------------------------------------------------
		% TABS
		%-----------------------------------------------------------------

		% NOTE: tab group is built using an axes and some rectangle objects

		case ('tabs')

			%--
			% modify position for tabs
			%--

			% NOTE: modify computed tab position, this should be moved to 'get_computed_position'

			position.tabs(1) = 0.005; position.tabs(3) = 0.99;

			%-----------------------------------------------------------------
			% axes
			%-----------------------------------------------------------------

			%--
			% create axes
			%--

			handles.axes = axes( ...
				'parent', pal, ...
				'position', position.tabs, ...
				'tag', control.name, ...
				'hittest', 'off', ...
				'xtick', [], ...
				'ytick', [], ...
				'xlim', [0, 1], ...
				'ylim', [0, 1], ...
				'xcolor', color.MEDIUM_GRAY, ...
				'ycolor', color.FIGURE_COLOR, ...
				'color', color.tabs.back ...
			);

			%--
			% create tabs
			%--

			% NOTE: for this control the tab field indicates the available tabs in the tabs control.

			% NOTE: for other controls this field indicates under which tab the control is visible

			axes(handles.axes);

			hold on;

			if ischar(control.tab)

				%--
				% single tab display
				%--

				% NOTE: this could be an alternative to the info display provided by the header

				handles.tab = rectangle( ...
					'position', [0 -0.5 0.5 1.5], ...
					'tag', control.tab, ...
					'facecolor', color.FIGURE_COLOR ...
				);

				set_rectangle_curvature(handles.tab, 10);
				
				handles.text = text(0.25, 0.25, control.tab);

				set(handles.text, ...
					'tag',control.tab, ...
					'horizontalalignment', 'center', ...
					'verticalalignment', 'baseline', ...
					'fontsize', get(0, 'defaultuicontrolfontsize'), ...
					'hittest', 'off' ...
				);

			else

				nt = length(control.tab);

				% TODO: set this so that the space is fixed in pixels say
				
				temp = get_size_in(handles.axes, 'pixels', 'pack');
				
				sep = 2 / temp.width;

				total = 0.9975 - sep * (nt - 1);
				
				wt = min(total / nt, 6 * tile.width);
				
				wt = total / round(total / wt); 

				for j = 1:nt

					%--
					% compute tab position
					%--

					tab_pos = [(j - 1)*(wt + sep), -0.5, wt, 1.5];

					%--
					% create tab using rectangle
					%--

					% TODO: develop a better way of setting curvature
					
					handles.tab(j) = rectangle( ...
						'position', tab_pos ...
					);

					set_rectangle_curvature(handles.tab(j), 10);
					
					set(handles.tab(j), ...
						'tag', control.tab{j}, ...
						'buttondownfcn', {@call_tab_select, pal, control.tab{j}}, ...
						'facecolor', color.FIGURE_COLOR ...
					);

					%--
					% create tab label using text
					%--

					if isempty(control.alias)
						handles.text(j) = text((j - 0.5) * (wt + sep), 0.25, control.tab{j});
					else
						handles.text(j) = text((j - 0.5) * (wt + sep), 0.25, control.alias{j});
					end
					
					set(handles.text(j), ...
						'tag', control.tab{j}, ...
						'horizontalalignment', 'center', ...
						'verticalalignment', 'baseline', ...
						'fontsize', get(0, 'defaultuicontrolfontsize'), ...
						'hittest', 'off' ...
					);

					%--
					% create tab bottom using line
					%--

					% NOTE: this is used to produce the visual tab effect

					handles.line(j) = line([tab_pos(1), tab_pos(1) + tab_pos(3)], [0, 0]);

					set(handles.line(j), ...
						'color', zeros(1, 3), ...
						'tag', control.tab{j} ...
					);

				end

			end

		%-----------------------------------------------------------------
		% AXES CONTROL
		%-----------------------------------------------------------------

		case 'axes'
			
			%--
			% create axes
			%--
			
			handles.axes = axes( ...
				'parent', pal, ...
				'position', position.axes, ...
				'box', 'on', ...
				'xticklabel', [], ...
				'yticklabel', [], ...
				'color', color.axes.back, ...
				'userdata', control.value, ...
				'tag', control.name ...
			);

			%--
			% set callback
			%--

			% NOTE: axes don't have a callback use buttondown
			
			% NOTE: add handle to callback if needed

			if opt.handle_to_callback && ischar(callback)
				callback = strrep(callback, '__HANDLE__', num2str(handles.axes, 20));
			end

			set(handles.axes, 'buttondownfcn', callback);

		%-----------------------------------------------------------------
		% BUTTONGROUP
		%-----------------------------------------------------------------

		% TODO: implement value storage for buttons in userdata perhaps
		
		case 'buttongroup'

			%------------------------
			% SINGLE BUTTON
			%------------------------

			if ischar(control.name)

				%--
				% create button
				%--

				handles.button = uicontrol(pal, ...
					'style', 'pushbutton', ...
					'units', 'normalized', ...
					'position', position.buttongroup, ...
					'horizontalalignment','left', ...
					'tag', control.name, ...
					'string', label, ...
					'tooltipstring', tooltip ...
				);

				%--
				% set callback
				%--

				% NOTE: add handle to callback if needed

				if opt.handle_to_callback && ischar(callback)
					callback = strrep(callback, '__HANDLE__', num2str(handles.button, 20));
				end
				
				set(handles.button, 'callback', callback);

			%------------------------
			% BUTTON ARRAY
			%------------------------

			else
				
				[m, n] = size(control.name);

				%--
				% create buttons
				%--
				
				for i = 1:m
					
					for j = 1:n

						%--
						% create button uicontrol
						%--
						
						handles.button(i,j) = uicontrol(pal, ...
							'style', 'pushbutton', ...
							'units', 'normalized', ...
							'position', position.buttongroup{i,j}, ...
							'tag', control.name{i,j}, ...
							'string', label{i,j}, ...
							'tooltipstring', tooltip{i,j} ...
						);
					
						%--
						% set callback
						%--

						this_callback = callback{i,j}; 
						
						this_button = handles.button(i,j);
						
						% NOTE: this handle injection is a pain

						if opt.handle_to_callback && ischar(this_callback)
							this_callback = strrep(this_callback, '__HANDLE__', num2str(this_button, 20));
						end
						
						set(this_button, 'callback', this_callback);
						
					end
					
				end

			end

		%-----------------------------------------------------------------
		% WAITBAR CONTROL
		%-----------------------------------------------------------------

		% NOTE: waitbar control consists of axes and patch, text label

		case 'waitbar'

			%--
			% update text to be findable in update
			%--
			
			set(handles.text, 'userdata', 'MESSAGE');
			
			%-----------------------------------------------------------------
			% waitbar axes
			%-----------------------------------------------------------------

			%--
			% create waitbar objects menu
			%--

			% NOTE: reserve color for the patch in the waitbar control

			handles.axes = axes( ...
				'parent', pal, ...
				'position', position.waitbar, ...
				'xlim', [0,1], ...
				'xtick', [], ...
				'ylim', [0,1], ...
				'ytick', [], ...
				'box', 'on', ...
				'color', color.waitbar.back, ...
				'tag', control.name ...
			);

			hold on;

			%-----------------------------------------------------------------
			% waitbar patch
			%-----------------------------------------------------------------

			% TODO: use 'get_computed_color' output here
			
			handles.patch = set_waitbar_image( ...
				handles.axes, [1 0 0], control.value ...
			);

			%--
			% store data in patch to estimate remaining time
			%--

			data = get(handles.patch, 'userdata');

			%-----------------------------
			
			data.duration = control.units;
			
			data.speed = [];

			data.relative_speed = [];
			
			data.start_time = clock;

			data.last_time = clock;

			data.last_value = 0;
			
			data.elapsed_time = 0;
			
			data.remaining_time = [];

			data.end_time = [];

			data.last_update = [];

			% NOTE: the update rate lets us drop calls to 'drawnow'
			
			data.update_rate = control.update_rate;

			%-----------------------------
			
			set(handles.patch, ...
				'tag', control.name, 'userdata', data ...
			);

			%-----------------------------------------------------------------
			% elapsed and remaining time labels
			%-----------------------------------------------------------------

			if control.confirm
				
				%--
				% create elapsed time
				%--

				handles.remaining = uicontrol(pal, ...
					'style', 'text', ...
					'units', 'normalized', ...
					'position', position.elapsed, ...
					'tag', control.name, ...
					'string', sec_to_clock(0), ...
					'userdata', 'ELAPSED_TIME', ...
					'horizontalalignment', 'left' ...
				);
			
				%--
				% create remaining time
				%--

				handles.remaining = uicontrol(pal, ...
					'style', 'text', ...
					'units', 'normalized', ...
					'position', position.remaining, ...
					'tag', control.name, ...
					'string', '(Estimating)', ...
					'userdata', 'REMAINING_TIME', ...
					'horizontalalignment', 'right' ...
				);

				%--
				% relative speed display
				%--

				% NOTE: this is not the right field, it should work for the moment

				if ~isempty(control.units)

					handles.relative = uicontrol(pal, ...
						'style', 'text', ...
						'units', 'normalized', ...
						'position', position.relative, ...
						'tag', control.name, ...
						'string', '(Estimating)', ...
						'userdata', 'RELATIVE_SPEED', ...
						'horizontalalignment', 'right' ...
					);

				end

			end
				
	end

	%--
	% attach help to control
	%--

	set_context_help(control, handles, opt);

end

%-----------------------------------------------------------------
% SAVE PALETTE STATE
%-----------------------------------------------------------------

% NOTE: we can move this to the set application data framework

%--
% get figure userdata
%--

data = get(pal, 'userdata');

%--
% add control group fields to userdata
%--

% TODO: this should be factored, and used at least in 'widget_figure'

data.name = name;			% palette name

data.parent = h;			% parent figure

data.children = [];			% children figure handles

data.control = controls;		% controls contained in palette

data.opt = opt;				% palette display options

data.created = clock;

%-- LAYOUT --

data.tabs = tabs;			% compiled tabs

% data.headers = headers;	% compiled headers

%--
% active controls
%--

% NOTE: this palette level data enables active control behavior

data.active.name = active;		   % active control names

data.active.lastvalue = lastvalue; % active control last value

%--
% set palette userdata and make visible
%--

set(pal, 'userdata', data);

set(pal, 'visible', 'on');

%--
% initialize tabs
%--

% NOTE: visible palette resolves a problem selecting a tab on invisible palettes

for k = 1:length(tabs)
	tab_select([], pal, tabs(k).tab.name{1});
end

%--
% set initial states
%--

for k = 1:length(controls)

	control = controls(k);
	
	if isempty(control.initialstate)
		continue; 
	end 
	
	switch control.initialstate

		case '__DISABLE__'
			
			if ~iscell(control.name)
				
				set_control(pal, control.name, 'enable', 0);
				
			else
				
				for k = 1:length(control.name)
					set_control(pal, control.name{k}, 'enable', 0);
				end
				
			end
			
		case '__HIDE__', set_control(pal, control.name, 'visible', 0);
		
	end
	
end

%--
% set palette_kpfun
%--

if isempty(h)
	set(pal,'keypressfcn','palette_kpfun;');
else
	set(pal,'keypressfcn',['palette_kpfun(' int2str(h) ');']);
end

%--
% reset default font size for uicontrol objects
%--

% check for resetting of default uicontrol font size as well

set(0, 'defaultuicontrolfontunits', DEFAULT_UIFONT_UNITS);

set(0, 'defaulttextfontunits', DEFAULT_FONT_UNITS);

set(0, 'defaultuicontrolfontsize', DEFAULT_FONT_SIZE);

%---------------------------------------------
% get handles of live uicontrol objects
%---------------------------------------------

h1 = findobj(pal, 'type', 'uicontrol');

h2 = findobj(h1, 'style', 'text');

h1 = setdiff(h1, h2);

%--
% remove tooltips if preferred
%--

tips = get_env('palette_tooltips');

if ~isempty(tips) && strcmp(tips, 'off')
	set(h1, 'tooltipstring', '');
end

%--
% update checkbox positions
%--

% NOTE: compute figure aspect ratio we can then get the
% horizontal normalized equivalent of a line

aspect = get(pal, 'position');

aspect = aspect(4) / aspect(3);

h2 = findobj (h1, 'style', 'checkbox');

for k = 1:length(h2)

	ext = get(h2(k), 'extent');
	
	pos = get(h2(k), 'position');

	% add 1.5 lines (measured in horizontal units) to the width of the text (extent)

	pos(3) = (ext(3) + 1.5 * aspect * ext(4));

	set(h2(k), 'position', pos);

end

%--
% set buttondown to show parent
%--

set(pal, 'buttondown', @show_family);

%--
% add extension menus if needed
%--

% NOTE: this calls sets the tag for extension palettes

if isfield(opt, 'ext')
	extension_menus(pal, opt.ext);
else
	extension_menus(pal);
end

%--
% perform onload callbacks
%--

onload = cell2mat({controls.onload}');

if any(onload)
	
	%--
	% get indices and values of controls to execute on load
	%--
	
	% NOTE: sort the onload value, this will indicate order in the future
	
	[ix, val] = find(onload);
	
	[ignore, pix] = sort(val);
	
	ix = ix(pix);
	
	%--
	% perform callbacks in order
	%--
	
	for k = 1:length(ix)
		control_callback([], pal, controls(ix(k)).name);
	end
	
end


%-------------------------------------------------------------
% TAB_SELECT
%-------------------------------------------------------------

function call_tab_select(obj, eventdata, pal, tab)

% call_tab_select - perform tab selection related updates
% --------------------------------------------------
%
% call_tab_select(obj, eventdata, pal, tab);
%
% Input:
% ------
%  obj, eventdata - mathworks callback input
%  pal - palette handle
%  tab - tab name

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6983 $
% $Date: 2006-10-10 17:10:48 -0400 (Tue, 10 Oct 2006) $
%--------------------------------

%--
% play sound if needed
%--

if strcmp(get_env('palette_sounds'), 'on')
	tab_sound;
end

%--
% select tab
%--

tab_select([], pal, tab);


%-----------------------------------------------------
% TIME_LABEL_CHANGE
%-----------------------------------------------------

function time_label_change(obj, eventdata, g)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6983 $
% $Date: 2006-10-10 17:10:48 -0400 (Tue, 10 Oct 2006) $
%--------------------------------

%--
% get waitbar tag and waitbar name
%--

tag = get(g,'tag');

pal = get(g,'parent');

%--
% change time label mode
%--

switch get(g,'userdata')

	case 'REMAINING_TIME'
		set(g, 'userdata', 'ELAPSED_TIME');

	case 'ELAPSED_TIME'
		set(g, 'userdata', 'REMAINING_TIME');

end

%--
% request waitbar display update
%--

waitbar_update(pal, tag, 'value', []);


%----------------------------------------------------------
% PALETTE_OPTIONS
%----------------------------------------------------------

function opt = palette_options

% palette_options - get default option struct for palette
% -------------------------------------------------------
%
% opt = palette_options
%
% Output:
% -------
%  opt - palette options struct

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6983 $
% $Date: 2006-10-10 17:10:48 -0400 (Tue, 10 Oct 2006) $
%--------------------------------

% TODO: add palette size input as alternative to environment default

%--
% get size of tiles from environment variable
%--

% NOTE: medium size is the default, tilesize of 24 pixels

tmp = get_palette_settings;

if ~isempty(tmp)
	opt.tilesize = tmp.tilesize;
else
	opt.tilesize = 24; % this branch should not be encountered
end

%--
% other options are simply set here, these are more variable than tilesize
%--

opt.width = 10; 	% maximum width of control in tiles

opt.top = 1; 		% top margin in tiles

opt.bottom = 1.5; 	% bottom margin in tiles

opt.left = 1; 		% left margin in tiles

opt.right = 1; 		% right margin in tiles

opt.space = 1; 		% control spacing in tiles

%--
% option to process names when no alias is present
%--

% NOTE: develop get text style internationalization framework

opt.get_text = 1;

% TODO: develop a cell with leading handle framework for this

opt.label_fun = @title_caps;

%--
% header color
%--

opt.header_color = [];

%--
% option to include handle as part of callback
%--

% NOTE: this is superseded by function handle callbacks

opt.handle_to_callback = 0;

%--
% option to include palette name as part of callback
%--

% NOTE: this could make writing control switches for palettes easier

opt.palette_to_callback = 0;



%----------------------------------------------------------
% UPDATE_CONTROL_LAYOUT
%----------------------------------------------------------

function control = set_layout_defaults(control, opt)

% set_layout_defaults - set control layout defaults
% -------------------------------------------------
%
% control = set_layout_defaults(control, opt)
%
% Input:
% ------
%  control - input control array
%  opt - palette options 
%
% Output:
% -------
%  control - modified control array with default layout options

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6983 $
% $Date: 2006-10-10 17:10:48 -0400 (Tue, 10 Oct 2006) $
%--------------------------------

%--
% loop over control array
%--

for k = 1:length(control)

	%--
	% set default spacing when empty
	%--

	% NOTE: space refers to bottom margin

	if isempty(control(k).space)
		control(k).space = opt.space;
	end

	%--
	% compute default layout values based on control style
	%--

	switch control(k).style
		
		%------------------
		% CHECKBOX
		%------------------
		
		case 'checkbox'
			
			control(k).label = 0; control(k).lines = 1;

		%------------------
		% SEPARATOR
		%------------------
		
		case 'separator'
			
			% NOTE: separators have no label
			
			control(k).label = 0;
		
			%--
			% update based on separator type
			%--

			switch control(k).type

				case 'header'
					control(k).lines = 1.25;

				case 'hidden_header'
					control(k).lines = 0; control(k).space = 0; control(k).min = 1;

				otherwise
					control(k).lines = 0;

			end

		%------------------
		% BUTTONGROUP
		%------------------
		
		case 'buttongroup'
			
			if isempty(control(k).string)
				control(k).label = 0;
			end
			
		%------------------
		% LISTBOX
		%------------------
		
		case 'listbox'

			% TODO: look for the use of this feature and remove
			
			if ~isempty(control(k).confirm)
				control(k).lines = control(k).lines + 2;
			end
			
		%------------------
		% TAB
		%------------------
		
		case 'tabs'
			
			% NOTE: tabs are the height as headers and have no label

			control(k).label = 0; control(k).lines = 1.25;
			
		%------------------
		% WAITBAR
		%------------------
		
		% TODO: update this default layout to simply add confirm height
		
		% NOTE: this will require we layout older waitbars
		
		case 'waitbar'
		
			if control(k).confirm
				control(k).space = max(control(k).space, 1.75);
			end
			
	end

end

%----------------------------------------------------------
% UPDATE_CONTROL_COLOR
%----------------------------------------------------------

function control = set_color_headers(control, opt)

% set_color_headers - set palette header colors
% ---------------------------------------------
%
% control = set_color_headers(control, opt)
%
% Input:
% ------
%  control - input control array
%  opt - palette options 
%
% Output:
% -------
%  control - modified control array with updated colors

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6983 $
% $Date: 2006-10-10 17:10:48 -0400 (Tue, 10 Oct 2006) $
%--------------------------------

%--
% update separator color if needed
%--

if ~isempty(opt.header_color)
	
	%--
	% get separator indices
	%--
	
	ix = find(strcmp(struct_field(control, 'style'), 'separator'));
	
	%--
	% update empty separator colors with header color option
	%--
	
	for k = 1:length(ix)
		
		if isempty(control(ix(k)).color)
			control(ix(k)).color = opt.header_color;
		end
		
	end

end

%----------------------------------------------------------
% START_UPDATE_CONTROL, STOP_UPDATE_CONTROL
%----------------------------------------------------------

% NOTE: this approach does not work well with the builtin sliders

% TODO: we can implement active controls here using this approach

%------------------
% START
%------------------

function start_update_control(obj, eventdata, control, handles, callback)

%--
% set motion callback
%--

pal = ancestor(obj, 'figure'); 

set(pal, ...
	'windowbuttonmotionfcn', {@update_control, control, handles} ... 
);

%--
% set stop callback
%--

stop = {@stop_update_control, control, handles, callback};

switch control.style
	
	case 'rating'
		set(pal, 'windowbuttonupfcn', stop);

	case 'slider'
		set(handles.slider, 'callback', stop);
		
end

%--
% check for update
%--

switch control.style
	
	case 'slider', slider_sync(obj, eventdata, control, handles);
		
end


%------------------
% STOP
%------------------

function stop_update_control(obj, eventdata, control, handles, callback)

%--
% update control one last time and execute callback
%--

update_control(obj, eventdata, control, handles, callback);

%--
% reset control callback
%--

if strcmp(control.style, 'slider')
	set(handles.slider, 'callback', {@start_update_control, control, handles, callback});
end

%--
% reset figure motion and stop callbacks
%--

pal = ancestor(obj, 'figure');

set(pal, ...
	'windowbuttonmotionfcn', [], 'windowbuttonupfcn', [] ...
);


%----------------------------------------------------------
% UPDATE_CONTROL
%----------------------------------------------------------

function update_control(obj, eventdata, control, handles, callback)

% TODO: generalize to other controls

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% set no callback default
%--

if nargin < 5
	callback = [];
end

%-------------------------
% COMPLEX CONTROL
%-------------------------

%--
% sync display and value of rating control
%--

switch control.style
	
	case 'rating'
		rating_sync(obj, eventdata, control, handles);
		
	case 'slider'
		slider_sync(obj, eventdata, control, handles);
		
end

%-------------------------
% EVALUATE CALLBACK
%-------------------------

%--
% return if there is no callback
%--

if isempty(callback)
	return;
end

%--
% evaluate given control callback
%--

% TODO: consider text callbacks typically these should not be needed

if ischar(callback)
	try
		eval(callback);
	catch
		xml_disp(lasterror);
	end
else
	eval_callback(callback, obj, eventdata);
end		


%----------------------------------------------------------
% RATING_SYNC
%----------------------------------------------------------

function update = rating_sync(obj, eventdata, control, handles)

%--
% evaluate value by looking at pointer and marker positions
%--

point = get(handles.axes, 'currentpoint'); point = point(1);

markers = cell2mat(get(handles.markers, 'xdata'));

% NOTE: we evaluate to the closest marker, unless we are less than all markers

[ignore, ix] = min(abs(markers - point));

if ix > 1
	ix = 1:ix;
elseif all(markers > point)
	ix = [];
end

% NOTE: the 'markers less than point' rule does not have the right feel

% ix = find(markers <= point);

%--
% enforce the minimum control value
%--

if control.min > length(ix)
	ix = 1:control.min;
end

%--
% update display and control value
%--

set(handles.markers, 'markerfacecolor', 'none');
			
set(handles.markers(ix), 'markerfacecolor', control.color);

update = ~isequal(get(handles.axes), length(ix));

set(handles.axes, 'userdata', length(ix));



%----------------------------------------------------------
% UPDATE_EDIT
%----------------------------------------------------------

function update_edit(obj, eventdata, control, handles, callback)

%--
% validate non-empty edit value using type
%--

value = get(handles.edit, 'string'); update = 1;

if ~isempty(value)
	
	switch control.type

		case 'filename', update = proper_filename(value);
			
		case 'time', update = proper_time_string(value);

	% 	case 'email', update = proper_email(value)
	% 		
	% 	case 'url', update = proper_url(value)

	end

end

% NOTE: validation uses different flash colors, it does not rollback or prevent callback

if ~update
	control_flash(obj, 'backgroundcolor', [1, 0.6, 0.6]);
else
	control_flash(obj);
end

%--
% evaluate given control callback
%--

eval_control_callback(callback, obj, eventdata)


%----------------------------------------------------------
% UPDATE_SLIDER
%----------------------------------------------------------

function update_slider(obj, eventdata, control, handles, callback)

%--
% update slider display
%--

update = slider_sync(obj);

if ~update
	return;
end

control_flash(obj);

%--
% evaluate given control callback
%--

eval_control_callback(callback, obj, eventdata)


%----------------------------------------------------------
% EVAL_CONTROL_CALLBACK
%----------------------------------------------------------

function eval_control_callback(callback, obj, eventdata)

%--
% return if no callback
%--

if isempty(callback)
	return;
end

%--
% evaluate callback
%--

% TODO: consider text callbacks typically these should not be needed

% NOTE: string callback does not contain any variables, we could use 'safer_eval'

if ischar(callback)	
	try
		eval(callback);
	catch
		xml_disp(lasterror);
	end
else	
	eval_callback(callback, obj, eventdata);
end	


%----------------------------------------------------------
% FILE_BROWSE_CALLBACK
%----------------------------------------------------------

function file_browse_callback(obj, eventdata, control, handles)


switch control.type
	
	case 'dir'
		file = uigetdir(); path = '';
		
	otherwise
		[file, path] = uigetfile2();
		
end

if ~file
	return;
end

set(handles.file, 'string', fullfile(path, file));
