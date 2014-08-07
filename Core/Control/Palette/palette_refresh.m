function palette_refresh(pal)

%--------------------------
% HANDLE INPUT
%--------------------------

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

if ~is_palette(pal)
	return; 
end

%--------------------------
% SETUP
%--------------------------

data = get(pal, 'userdata');

%--------------------------
% REFRESH
%--------------------------

%--
% hide palette
%--

% NOTE: this may not be needed

set(pal, 'visible', 'off');

state = get_palette_state(pal, data);

%--
% update palette position and control positions
%--

% NOTE: this whole section is in development

data.control(end).show = ~data.control(end).show;

[position, tile] = compile_positions(data.control, data.opt);

set_palette_size(pal, opt, tile);

position_controls(pal, position);

%--
% display
%--

set_palette_state(pal, state);

set(pal, 'visible', 'on');

drawnow;


%--------------------------
% SET_PALETTE_SIZE
%--------------------------

function set_palette_size(pal, opt, tile)

set(pal, 'units', 'pixels'); 

pos = get(pal, 'position'); 

pos(3) = opt.tilesize / tile.width; 

pos(4) = opt.tilesize / tile.height;

set(pal, 'position', pos);


%--------------------------
% POSITION_CONTROLS
%--------------------------

function position_controls(pal, control, position, opt, tile)


for k = 1:length(control)
		
	%--
	% get control handles
	%--
	
	handles = get_control(pal, control(k).name, 'handles');
	
	if isempty(handles.all)
		continue;
	end
	
	%--
	% set display state of control elements
	%--
	
	show = bin2str(control(k).show);
	
	set(handles.all, 'visible', show, 'hittest', show);
	
	if ~control(k).show
		continue;
	end
	
	%--
	% position control elements
	%--
	
	if control(k).label
		
	end
	
	% TODO: match handle to position, field naming is not perfect
	
	set(handle,
		'units', 'normalized', ...
		'position', position ...
	);
	
end
