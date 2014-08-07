function selection_edit_callback(obj, eventdata, state, sel, opt)

% selection_edit_callback - selection control point callback
% ----------------------------------------------------------
%
% selection_edit_callback(obj, eventdata, state, sel, opt)
%
% Input:
% ------
%  obj, eventdata - matlab callback input
%  state - edit state
%  sel - selection
%  opt - selection options

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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

% TODO: implement 'direct' edit behavior as well as 'ghost' edit behavior

% NOTE: the 'direct' behavior updates selection handles, add input to 'selection_draw'

%----------------------------
% SETUP
%----------------------------

persistent EDIT_SELECTION EDIT_OPT EDIT_AXES EDIT_FIGURE;

persistent GHOST_LINE;

%----------------------------
% CALLBACK
%----------------------------

switch state
	
	%----------------------------
	% START
	%----------------------------
	
	case 'start'
	
		%--
		% set persistent stores
		%--
		
		EDIT_SELECTION = sel;
		
		EDIT_AXES = get(EDIT_SELECTION.handles.obj, 'parent'); 
		
		EDIT_FIGURE = get(EDIT_AXES, 'parent');
		
		% NOTE: we get axes selection options if needed

		if isempty(opt)
			EDIT_OPT = get_axes_selection_options(EDIT_AXES); 
		end
		
		%--
		% turn editing on
		%--
		
		set(EDIT_FIGURE, ...
			'windowbuttonmotionfcn', {@selection_edit_callback, 'move', EDIT_SELECTION, opt}, ...
			'windowbuttonupfcn', {@selection_edit_callback, 'stop', EDIT_SELECTION, opt} ...
		);
	
		%--
		% create edit display
		%--
		
		[x, y] = selection_coords('patch', EDIT_SELECTION, EDIT_AXES);
		
		GHOST_LINE = line( ...
			'parent', EDIT_AXES, ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle', EDIT_OPT.grid.linestyle, ...
			'color', EDIT_OPT.color ...
		);
	
		%--
		% perform start callback
		%--
		
		if ~isempty(EDIT_OPT.callback.edit.start)
			eval_callback(EDIT_OPT.callback.edit.start, obj, eventdata, EDIT_SELECTION, EDIT_OPT);
		end 
		
	%----------------------------
	% MOVE
	%----------------------------
	
	case 'move'
		
		%--
		% update selection 
		%--
		
		EDIT_SELECTION = selection_edit_update(EDIT_AXES, EDIT_SELECTION, EDIT_OPT);
		
		%--
		% update edit display
		%--

		[x, y] = selection_coords('patch', EDIT_SELECTION, EDIT_AXES);
		
		set(GHOST_LINE, ...
			'xdata', x, 'ydata', y ...
		);
		
		if ~isempty(EDIT_SELECTION.handles.grid.x)
			
			[x, y] = selection_coords('grid__x', EDIT_SELECTION, EDIT_AXES);
			
			set(EDIT_SELECTION.handles.grid.x, ...
				'xdata', x, 'ydata', y ...
			);
		
			uistack(EDIT_SELECTION.handles.grid.x, 'top');
			
		end
		
		if ~isempty(EDIT_SELECTION.handles.grid.y)
			
			[x, y] = selection_coords('grid__y', EDIT_SELECTION, EDIT_AXES);
			
			set(EDIT_SELECTION.handles.grid.y, ...
				'xdata', x, 'ydata', y ...
			);
		
			uistack(EDIT_SELECTION.handles.grid.y, 'top');
		
		end
		
		%--
		% perform move callback
		%--
		
		if ~isempty(EDIT_OPT.callback.edit.move)
			eval_callback(EDIT_OPT.callback.edit.move, obj, eventdata, EDIT_SELECTION, EDIT_OPT);
		end
		
	%----------------------------
	% STOP
	%----------------------------
	
	case 'stop'
		
		%--
		% turn editing off
		%--
		
		set(EDIT_FIGURE, ...
			'windowbuttonmotionfcn', [], ...
			'windowbuttonupfcn', [] ...
		);
	
		%--
		% delete edit display
		%--
	
		delete(GHOST_LINE); GHOST_LINE = [];
	
		%--
		% standardize and redraw selection
		%--
		
		EDIT_SELECTION = selection_standardize(EDIT_SELECTION);
		
		selection_draw(EDIT_AXES, EDIT_SELECTION, opt);
		
		%--
		% perform stop callback
		%--
		
		if ~isempty(EDIT_OPT.callback.edit.stop)
			eval_callback(EDIT_OPT.callback.edit.stop, obj, eventdata, EDIT_SELECTION, EDIT_OPT);
		end
		
end
