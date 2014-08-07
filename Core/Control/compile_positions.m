function [pos, tile] = compile_positions(controls, opt, tabs)

% compile_positions - compile control positions
% ---------------------------------------------
%
% [pos, tile] = compile_positions(controls, opt, tabs)
%
% Input:
% ------
%  controls - control array
%  opt - palette options
%  tabs - compiled tabs 
%
% Output:
% -------
%  pos - control positions
%  tile - size of tile
%
% NOTE: output is in normalized units

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

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

%--
% compile tabs if needed
%--

% NOTE: empty tabs are significant

if (nargin < 3)
	tabs = compile_tabs(controls);
end

%--
% get default palette options
%--

if (nargin < 2) || isempty(opt)
	opt = control_group;
end

%-----------------------------------------------------
% SETUP
%-----------------------------------------------------

%--
% get palette height and content pane width in tile units
%--

height = get_palette_height(controls, tabs);

total_height = height + opt.top + opt.bottom; 

width = opt.width;

total_width = width + opt.left + opt.right;

%--
% get tile sizes in normalized units
%--

tile.height = 1 / total_height;

tile.width = 1 / total_width;

%-----------------------------------------------------
% COMPUTE POSITIONS
%-----------------------------------------------------

%--
% get control offsets
%--

% NOTE: offset consumes tabs and spacing position complexity

offset = get_control_offsets(controls, tabs);

%--
% compute positions
%--

% NOTE: we use 'out' for position array output to have more readable code

out = cell(0);

for k = 1:length(controls)
	
	%--
	% setup loop iteration
	%--
	
	control = controls(k); style = control.style;
	
	clear pos;
	
	%--------------------------------
	% DEFAULT LAYOUT
	%--------------------------------
	
	%--
	% compute control position
	%--
	
	pos.(style) = [ ...
		opt.left, ...
		offset(k) + control.label + control.lines, ...
		width * control.width, ...
		control.lines ...
	];
	
	%--
	% compute label position
	%--
	
	if control.label
		
		pos.label = [ ...
			opt.left, ...
			offset(k) + control.label - 0.02, ...
			width * control.width, ...
			1 ...
		];
		
		if strcmp(style, 'slider')
			pos.label = 0.5 * pos.label;
		end
		
% 		if strcmp(style, 'axes');
% 			pos.label(2) = pos.label(2) + 0.02;
% 		end
	
	end
	
	
	%--------------------------------
	% STYLE SPECIFIC LAYOUT
	%--------------------------------
	
	switch style
		
		%--
		% SEPARATOR
		%--
		
		case 'separator'
			
			% NOTE: separators span palette width
			
			pos.separator = [ ...
				0, ...
				offset(k) + control.label + control.lines, ...
				total_width, ...
				control.lines ...
			];
			
			switch control.type
				
				case 'header'

				case 'hidden_header', pos.separator(4) = 0.01;
					
				otherwise, pos.separator(4) = 0.01;
			
			end
			
		%--
		% TABS
		%--
		
		case 'tabs'
			
			% NOTE: tabs almost span palette width
			
			pos.tabs(1) = 0.005; pos.tabs(3) = 0.99 * opt.width;
			
		%--
		% LISTBOX
		%--
		
		case 'listbox'
			
			% TODO: move the position update to the 'control_create'
			
			if (control.confirm == 1)

				%--
				% listbox position
				%--

				lines = control.lines - 2;
				
				pos.listbox = [ ...
					opt.left, ...
					offset(k) + control.label + lines, ...
					width * control.width, ... 
					lines ...
				];

				%--
				% confirm button positions
				%--

				% TODO: these might require special handling in the align code
				
				button_height = 1.75;
				
				button_width = (width * control.width) / 2;

				pos.buttons{1} = [ ...
					opt.left, ...
					offset(k) + control.label + control.lines, ...
					button_width, ...
					button_height ...
				];
				
				pos.buttons{2} = [ ...
					opt.left + button_width, ...
					offset(k) + control.label + control.lines, ...
					button_width, ...
					button_height ...
				];

			end

		%--
		% BUTTONGROUP
		%--
		
		case 'buttongroup'
		
			% NOTE: buttons share space reserved for group
			
			name = control.name;
			
			if iscell(name) && (numel(name) > 1)

				%--
				% compute button sizes
				%--
				
				[row,col] = size(name);
				
				button_height = control.lines / row; 
				
				button_width = (width * control.width) / col;
				
				%--
				% compute button positions
				%--
				
				% TODO: move position split for grouped controls to function
				
				pos.buttongroup = cell(size(name));
				
				for i = 1:row
				for j = 1:col

					pos.buttongroup{i,j} = [ ...
						opt.left + (j - 1) * button_width, ...
						offset(k) + control.label + i * button_height, ...
						button_width, ...
						button_height ...
					];

				end
				end 

			end
			
		%--
		% SLIDER
		%--
		
		case 'slider'
			
			%--
			% produce simpler position for label and edit
			%--
			
			pos.label = [ ...
				opt.left, ...
				offset(k) + control.label - 0.02, ...
				0.55 * width * control.width, ...
				1 ...
			];
				
			% NOTE: label and edit share the same row
			
			pos.edit = pos.label;
			
			pos.edit(1) = opt.left + pos.label(3);
			
			pos.edit(3) = 0.45 * width * control.width;
			
		%--
		% FILE
		%--
		
		case 'file'
				
			%--
			% position label
			%--
			
			pos.label = [ ...
				opt.left, ...
				offset(k) + control.label - 0.02, ...
				0.66 * width * control.width, ...
				1 ...
			];
				
			% NOTE: label and browse nearly share the same row
			
			pos.browse = pos.label;
			
% 			pos.label(2) = pos.label(2) + 0.75;
			
			%--
			% position browse
			%--
			
			pos.browse(1) = opt.left + 0.55 * width * control.width;
			
			pos.browse(3) = 0.45 * width * control.width;
			
			pos.browse(2) = pos.file(2) - 0.10;
			
			pos.browse(4) = 1.5;
			
			% NOTE: we push file display down a bit 
			
			pos.file(2) = pos.file(2) - 1.75;
			
			pos.file(4) = pos.file(4) - 1.75;
			
		%--
		% WAITBAR
		%--

		case 'waitbar'
	
			%--
			% compute elapsed and remaining time positions
			%--
			
			if control.confirm
			
				half = 0.5 * width * control.width;
				
				%--
				% elapsed time
				%--
				
				pos.elapsed = [ ...
					opt.left, ...
					offset(k) + control.label + control.lines + 1.25, ...
					half, ...
					1 ...
				];
				
				%--
				% remaining time
				%--
				
				pos.remaining = [ ...
					opt.left + half, ...
					offset(k) + control.label + control.lines + 1.25, ...
					half, ...
					1 ...
				];
				
				%--
				% relative speed
				%--
				
				% TODO: shorten label in this case
				
				if control.label

					pos.relative = [ ...
						opt.left + 1.5 * half, ...
						offset(k) + control.label, ...
						0.5 * half, ...
						1 ...
					];

				end
			
			end

	end
	
	%--
	% get aligned and proper positions
	%--
	
	pos = align_offset(pos, control, width);
	
	pos = get_proper_positions(pos, tile);
	
	%--
	% add position to output
	%--
	
	out{end + 1} = pos;
	
end

%--
% return positions
%--

pos = out; 


%-------------------------------------------------------------
% GET_PALETTE_HEIGHT
%-------------------------------------------------------------

function height = get_palette_height(controls, tabs)

% get_palette_height - get palette height in tile units
% -----------------------------------------------------
%
% height = get_palette_height(controls, tabs)
%
% Input:
% ------
%  controls - control array
%  tabs - compiled tabs
%
% Output:
% -------
%  height - palette height in tiles

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

if (nargin < 2)
	tabs = compile_tabs(controls);
end

%--------------------------------
% COMPUTE HEIGHT
%--------------------------------

%--
% compute total height of controls
%--

height = 0;

for control = controls
	height = height + get_height(control);
end

%--
% compute tabs correction
%--

if ~isempty(tabs)
	
	for k = 1:length(tabs)
		height = height - sum(tabs(k).tab.height) + max(tabs(k).tab.height);
	end
	
end


%-------------------------------------------------------------
% GET_CONTROL_OFFSETS
%-------------------------------------------------------------

function offset = get_control_offsets(controls, tabs)

% get_control_offsets - get control offsets in tile units
% -------------------------------------------------------
%
% offset = get_control_offsets(controls,tabs)
%
% Input:
% ------
%  controls - control array
%  tabs - compiled tabs
%
% Output:
% -------
%  height - palette height in tiles

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

if (nargin < 2)
	tabs = compile_tabs(controls);
end

%---------------------------------
% COMPUTE OFFSETS
%---------------------------------

% NOTE: first control has no offset

offset(1) = 0;

%--
% use recursion to compute offsets
%--

if isempty(tabs)

	%--
	% accumulate offsets
	%--
	
	% NOTE: when there are no tabs offset is simply accumulated
	
	for k = 2:length(controls)
		offset(k) = offset(k - 1) + get_height(controls(k - 1));
	end

else

	% NOTE: when there are tabs we track the tabs state to compute offset
	
	%--
	% checkpoint at start and get initial state
	%--
	
	checkpoint = 0;
	
	state = get_tabs_state(controls(1), tabs); 
	
	%--
	% accumulate offsets considering tabs
	%--
	
	for k = 2:length(controls)
		
		%--
		% get current state
		%--
		
		current = get_tabs_state(controls(k), tabs);
		
		%--
		% simple update within same tab
		%--
		
		if isequal(state,current)
			offset(k) = offset(k - 1) + get_height(controls(k - 1)); continue;
		end
		
		%--
		% checkpoint on tabs enter or exit
		%--
		
		if isempty(state.tabs) || isempty(current.tabs)
			
			%--
			% enter tabs
			%--
			
			if isempty(state.tabs)
				
				% NOTE: on enter tabs the previous control is the tabs
				
				checkpoint = max(offset) + get_height(controls(k - 1));
				
			%--
			% exit tabs
			%--
			
			else
				
				%--
				% get offsets produced by tabs children
				%--
				
				this_tabs = tabs(find(strcmp({tabs.name},state.tabs)));
				
				ix = this_tabs.child.ix;
				
				for j = 1:length(ix)
					child_offset(j) = offset(ix(j)) + get_height(controls(ix(j)));
				end
				
				%--
				% set checkpoint as maximum child produced offset
				%--
				
				checkpoint = max(child_offset);
				
			end
			
		end
		
		%--
		% compute offset and update state
		%--
		
		% NOTE: this happens on the change of tab, including null to first tab
		
		offset(k) = checkpoint; state = current;
	
	end

end


%-------------------------------------------------------------
% GET_TABS_STATE
%-------------------------------------------------------------

function state = get_tabs_state(control, tabs)

% get_tabs_state - get control tabs and tab
% -----------------------------------------
%
% state = get_tabs_state(control, tabs)
%
% Input:
% ------
%  control - control array
%  tabs - compiled tabs
%
% Output:
% -------
%  state - control tabs state

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

if (nargin < 2)
	tabs = compile_tabs(control);
end

%--------------------------------
% COMPUTE STATE
%--------------------------------

% TODO: pass strincg compare function as input and use throughout

% NOTE: this function could be changed if we want to be strict

fun = @strcmpi;

%--
% handle tabs control input
%--

if fun(control.style, 'tabs')
	state.tabs = ''; state.tab = ''; return;
end

%--
% handle non-tab controls
%--

if isempty(control.tab)
	state.tabs = ''; state.tab = ''; return;
end

%--
% check that there are tabs to declare
%--

if isempty(tabs)
	error(['Control ''', control.name, ''' declares tab, but there are no tabs.']);
end

%--
% handle tab controls
%--

for k = 1:length(tabs)
	
	%--
	% try to find controls in 'tabs' tabs
	%--
	
	ix = find(fun(tabs(k).tab.name, control.tab));
	
	if isempty(ix)
		continue;
	end
	
	%--
	% get state info from indices
	%--
	
	% NOTE: tabs contains tabs control index, this field is useful
	
	state.tabs = tabs(k).name; state.tab = tabs(k).tab.name(ix); break;
	
end


%-------------------------------------------------------------
% GET_PROPER_POSITIONS
%-------------------------------------------------------------

function pos = get_proper_positions(pos, tile)

% get_proper_positions - make positions in a position struct proper
% -----------------------------------------------------------------
%
% pos = get_proper_positions(pos, tile)
%
% Input:
% ------
%  pos - positions struct
%  tile - tile size
%
% Output:
% -------
%  pos - proper positions struct

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

% NOTE: this pattern applies a function to struct fields that may contain cells 

%--
% configure mapper
%--

fun = @get_proper_position; args = {tile};

%--
% map struct fields and leaf cells
%--

style = fieldnames(pos);

for j = 1:length(style)
	
	if ~iscell(pos.(style{j}))
		
		pos.(style{j}) = fun(pos.(style{j}), args{:});
		
	else
		
		for k = 1:numel(pos.(style{j}))
			pos.(style{j}){k} = fun(pos.(style{j}){k}, args{:});
		end
		
	end
	
end


%-------------------------------------------------------------
% GET_PROPER_POSITION
%-------------------------------------------------------------

function pos = get_proper_position(pos, tile)

% get_proper_position - get proper position from simpler expression
% -----------------------------------------------------------------
%
% pos = get_proper_position(pos, tile)
%
% Input:
% ------
%  pos - simple position expression
%  tile - size of tiles in normalized units
%
% Output:
% -------
%  pos - proper position

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

%--
% scale positions using tile and height input
%--

pos(1) = pos(1) * tile.width;
	
% NOTE: complement of the normalized horizontal displacement

pos(2) = 1 - (pos(2) * tile.height);

pos(3) = pos(3) * tile.width;

pos(4) = pos(4) * tile.height;
	

%-------------------------------------------------------------
% GET_COMPACT_LENGTHS
%-------------------------------------------------------------

function comp = get_compact_lengths

% get_compact_lengths - output compact layout length constants
% ------------------------------------------------------------
%
% comp = get_compact_lengths
%
% Output:
% -------
%  comp - compact layout length constants

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

%--
% set compact layout constants
%--

comp.offset = 2/10;

comp.label = 3.75/10; 

comp.slider = 5/10; 

comp.slider_edit = 3/10; 

comp.popup = 8.5/10;


%-------------------------------------------------------------
% ALIGN_OFFSET
%-------------------------------------------------------------

function pos = align_offset(pos, control, width)

% align_offset - offset positions for alignment
% ---------------------------------------------
%
% pos = align_offset(pos, control, width)
%
% Input:
% ------
%  pos - initial positions
%  control - control
%  width - palette width
%
% Output:
% -------
%  pos - offset positions

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3398 $
% $Date: 2006-02-04 13:13:16 -0500 (Sat, 04 Feb 2006) $
%--------------------------------

% NOTE: we work with the intermediate position in tile units

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% return quickly when no alignment is needed
%--

% NOTE: there is no margin to align

if (control.width == 1)
	return;
end 

% NOTE: no change for left alignment, this is the default

if (strcmpi(control.align,'left'))
	return;
end

%------------------------------------------
% OFFSET POSITIONS FOR ALIGNMENT
%------------------------------------------

%--
% get styles of elements to position
%--

styles = fieldnames(pos);

%--
% compute margin based on initial positions
%--

% NOTE: we need all the control positions here to compute the offset

control_width = zeros(1,length(styles));

for k = 1:length(styles)
	
	switch (styles{k})
		
		case ('buttongroup')
			
			if (iscell(pos.buttongroup))
				
				control_width(k) = 0;

				for j = 1:size(pos.buttongroup,2)
					control_width(k) = control_width(k) + pos.buttongroup{1,j}(3);
				end
				
			else
				
				control_width(k) = pos.(styles{k})(3);
				
			end
			
		otherwise
			
			control_width(k) = pos.(styles{k})(3);
			
	end
	
end

offset = width - max(control_width);

%--
% apply offset to initial positions
%--

% NOTE: this is the simplest part we just offset the left position

for j = 1:length(styles)
	
	style = styles{j};
	
	if (~iscell(pos.(style)))
		
		switch (control.align)

			case ('center')
				pos.(style)(1) = pos.(style)(1) + (0.5 * offset);

			case ('right')
				pos.(style)(1) = pos.(style)(1) + offset;

		end
		
	else
		
		for k = 1:numel(pos.(style))
			
			switch (control.align)

				case ('center')
					pos.(style){k}(1) = pos.(style){k}(1) + (0.5 * offset);

				case ('right')
					pos.(style){k}(1) = pos.(style){k}(1) + offset;

			end
			
		end
		
	end
	
end

