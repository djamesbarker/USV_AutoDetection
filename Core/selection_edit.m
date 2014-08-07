function selection_edit(mode, ctrl, m, ix)

% selection_edit - edit selections and events
% -------------------------------------------
%
%  selection_edit('start', ctrl)
%
%  selection_edit('move', ctrl)
%
%  selection_edit('stop', ctrl)
%
%  selection_edit('start', ctrl, m, ix)
%  
%  selection_edit('move', ctrl, m, ix)
%  
%  selection_edit('stop', ctrl, m, ix)
%
% Input:
% ------
%  ctrl - control point used for editing
%  m - index of log in browser
%  ix - index of event in log

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
% $Revision: 7019 $
% $Date: 2006-10-13 16:38:44 -0400 (Fri, 13 Oct 2006) $
%--------------------------------

%---------------------------------------------------------------
% PERSISTENT VARIABLES
%---------------------------------------------------------------

%--
% edit display
%--

persistent PTR;

persistent POINTER_NAMES;

persistent FIGURE_DATA SELECTION_HANDLES;

persistent AXES_XLIM AXES_YLIM;

persistent SEL_XLIM SEL_YLIM;

persistent EDIT_HANDLE EDIT_XDATA EDIT_YDATA;

persistent FLIP TEMP_EVENT;

persistent MOVE_FLAG;

%--
% selection zoom display
%--

persistent SELECTION_FIGURE;

persistent OPT_START OPT_MOVE OPT_RESIZE;

%--
% switch on mode
%--

switch mode
	
%---------------------------------------------------------------
% START EDIT
%---------------------------------------------------------------

case 'start'
	
	%--
	% create persistent table of pointer names
	%--
		
	if isempty(POINTER_NAMES)
		
		%------------------------------------------------------
		% pointer list for the various control points
		%------------------------------------------------------
		
		POINTER_NAMES = { ...
			'right', 'topr', 'top', 'topl', 'left', 'botl', 'bottom', 'botr', 'fleur' ...
		};
	
		%------------------------------------------------------
		% selection display update options
		%------------------------------------------------------
		
		% NOTE: the default options only resize
		
		opt = selection_display;
		
		%--
		% edit start options
		%--
		
		OPT_START = opt; 
		
		OPT_START.show = 1;
		
		%--
		% edit move options
		%--
		
		OPT_MOVE = opt;
		
		OPT_MOVE.resize = 0;
		
		%--
		% edit resize options
		%--
		
		OPT_RESIZE = opt;
		
	end
	
	%--
	% create persistent copy of relevant information from userdata
	%--
	
	FIGURE_DATA = get(gcbf, 'userdata');
	
	SELECTION_HANDLES = FIGURE_DATA.browser.selection.handle;
	
	set(SELECTION_HANDLES(7:10), 'clipping', 'on');
	
	%--
	% get axes limits
	%--
	
	AXES_XLIM = get(gca, 'xlim');
	
	AXES_YLIM = get(gca, 'ylim');
	
	%--
	% set editing button motion and button up functions
	%--
		
	% TODO: separate cases into functions and use function handles
	
	if (nargin < 3)
		
		%--
		% set selection editing callbacks
		%--

		set(gcbf, ...
			'WindowButtonMotionFcn', {@selection_edit_callback, 'move', ctrl}, ...
			'WindowButtonUpFcn', {@selection_edit_callback, 'stop', ctrl} ...
		);
	
	else 
		
		%--
		% set event selection editing callbacks
		%--

		set(gcbf, ...
			'WindowButtonMotionFcn', {@selection_edit_callback, 'move', ctrl}, ...
			'WindowButtonUpFcn', {@selection_edit_callback, 'stop', ctrl, m, ix} ...
		);
	
	end
	
	%--
	% get starting pointer
	%--
	
	PTR = get(gcbf, 'pointer');
	
	%--
	% set pointer according to control point
	%--
	
	if (ctrl < 9)
		
		%--
		% boundary control point selection editing
		%--
		
		set(gcbf, 'pointer', POINTER_NAMES{ctrl});
	
	else
		
		%--
		% selection movement editing
		%--
		
		% NOTE: check for horizontal or vertical motion constraint
		
		tmp = double(get(gcbf, 'currentcharacter'));

		if isempty(tmp)
			tmp = double(' ');
		end

		switch tmp

			case double('h'), set(gcbf, 'pointer', 'left');

			case double('v'), set(gcbf, 'pointer', 'top');

			otherwise, set(gcbf, 'pointer', 'fleur');

		end

	end

	%--
	% create persistent drag line representation of selection
	%--
	
	% NOTE: this same dragline could be used to replace the rubber band box
	
	EDIT_XDATA = get(SELECTION_HANDLES(1), 'xdata');
	
	EDIT_YDATA = get(SELECTION_HANDLES(1), 'ydata');
			
	EDIT_HANDLE = line( ...
		'xdata', EDIT_XDATA, ...
		'ydata', EDIT_YDATA, ... 
		'color', FIGURE_DATA.browser.selection.color, ...
		'linestyle', ':', ...
		'linewidth', 0.5 ...
	);


	%--
	% find and store session boundaries that we can't cross
	%--
	
	sessions = get_sound_sessions(FIGURE_DATA.browser.sound);
	
	borders = get_session_borders(sessions, EDIT_XDATA);
	
	SEL_XLIM = AXES_XLIM;
	
	if ~isempty(borders)
		SEL_XLIM = [max(borders(1), SEL_XLIM(1)), min(borders(2), SEL_XLIM(2))];
	end
	
	SEL_YLIM = AXES_YLIM;
	
	if strcmpi(POINTER_NAMES{ctrl}, 'fleur')

		half_width = 0.5 * abs(diff(fast_min_max(EDIT_XDATA)));

		SEL_XLIM = [ ...
			SEL_XLIM(1) + half_width, SEL_XLIM(2) - half_width ...
		];

		half_height = 0.5 * abs(diff(fast_min_max(EDIT_YDATA)));
		
		SEL_YLIM = [ ...
			SEL_YLIM(1) + half_height, SEL_YLIM(2) - half_height ...
		];
		
	end

	%--
	% create persistent variables for dynamic updating of labels
	%--

	 % NOTE: watch out for the frequency scaling
	
	FLIP = 0;
	
	TEMP_EVENT = event_create( ...
		'channel', FIGURE_DATA.browser.selection.event.channel, ...
		'time', [EDIT_XDATA(1), EDIT_XDATA(2)], ...
		'freq', [EDIT_YDATA(2), EDIT_YDATA(3)] ...
	);

	%--
	% handle axes frequency scaling
	%--
	
	if strcmp(FIGURE_DATA.browser.grid.freq.labels, 'kHz')
		TEMP_EVENT.freq = 1000 * TEMP_EVENT.freq;
	end
	
	%--
	% set move flag
	%--
	
	MOVE_FLAG = 0;
	
	%--
	% update selection controls
	%--
	
	set_selection_controls(gcbf, TEMP_EVENT, 'start', FIGURE_DATA);
	
	%--------------------
	
	%--
	% see if the selection display figure exists
	%--
	
	SELECTION_FIGURE = get_xbat_figs('parent', gcbf, 'type', 'selection');
	
	%--
	% create persistent copy of selection zoom handles and state
	%--
		
	% NOTE: the SELECTION_FIGURE input may be empty, however the output should not
	
	SELECTION_FIGURE = selection_display(gcbf, TEMP_EVENT, OPT_START, FIGURE_DATA, SELECTION_FIGURE);
	
	%--------------------
	
	%--
	% update widgets
	%--
	
	update_widgets(gcbf, 'selection__edit__start');
	
	%--
	% refresh figure
	%--
	
	% NOTE: this code is taken from the built-in refresh function
	
	tmp = get(gcbf, 'color');
	
	set(gcbf, 'color', [0 0 0], 'color', tmp);
	
%---------------------------------------------------------------
% MOVE EDIT
%---------------------------------------------------------------

case 'move'
	
	%--
	% set move flag
	%--
	
	MOVE_FLAG = 1;
	
	%--
	% get current point in axes
	%--
	
	p = get(gca, 'CurrentPoint'); p = p(1, 1:2);
	
	%--
	% handle boundary conditions during motion
	%--
			
	tol = 0.01;
	
	if (p(1) <= SEL_XLIM(1) + tol)
		p(1) = SEL_XLIM(1) + tol;
	end
	
	if (p(1) >= SEL_XLIM(2) - tol) 
		p(1) = SEL_XLIM(2) - tol;
	end
	
	tol = 0;
	
	if (p(2) <= SEL_YLIM(1) + tol)
		p(2) = SEL_YLIM(1) + tol;
	end
	
	if (p(2) >= SEL_YLIM(2) - tol) 
		p(2) = SEL_YLIM(2) - tol;
	end
	
	%---------------------------------------------------------------
	% UDPATE DISPLAY ACCORDING TO CONTROL
	%---------------------------------------------------------------
	
	switch ctrl
		
		%--
		% EAST control point
		%--
		
		case 1
			EDIT_XDATA(2:3) = p(1);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA);
			
		%--
		% NORTH-EAST control point
		%--
		
		case 2
			EDIT_XDATA(2:3) = p(1);
			EDIT_YDATA(3:4) = p(2);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
			
		%--
		% NORTH control point
		%--
		
		case 3
			EDIT_YDATA(3:4) = p(2);
			set(EDIT_HANDLE,'ydata',EDIT_YDATA);
			
		%--
		% NORTH-WEST control point 
		%--
		
		case 4
			EDIT_XDATA([1,4,5]) = p(1);
			EDIT_YDATA(3:4) = p(2);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
			
		%--
		% WEST control point
		%--
		
		case 5
			EDIT_XDATA([1,4,5]) = p(1);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA);
			
		%--
		% SOUTH-WEST control point
		%--
		
		case 6
			EDIT_XDATA([1,4,5]) = p(1);
			EDIT_YDATA([1,2,5]) = p(2);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
		
		%--
		% SOUTH control point
		%--
		
		case 7
			EDIT_YDATA([1,2,5]) = p(2);
			set(EDIT_HANDLE,'ydata',EDIT_YDATA);
		
		%--
		% SOUTH-EAST control point
		%--
		
		case 8
			EDIT_XDATA(2:3) = p(1);
			EDIT_YDATA([1,2,5]) = p(2);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
	
		%--
		% CENTER control point
		%--
		
		case 9

			% TODO: updatehow these mode are accesed and whether they are needed
			
			switch get(gcf, 'pointer')
				
				% horizontal motion	
				
				case 'left'
					EDIT_XDATA = EDIT_XDATA + (p(1) - (EDIT_XDATA(1) + EDIT_XDATA(2)) / 2);
					set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
				
				% vertical motion
				
				case 'top'
					EDIT_YDATA = EDIT_YDATA + (p(2) - (EDIT_YDATA(2) + EDIT_YDATA(3)) / 2);
					set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
					
				% unconstrained motion
				
				case 'fleur'
					EDIT_XDATA = EDIT_XDATA + (p(1) - (EDIT_XDATA(1) + EDIT_XDATA(2)) / 2);
					EDIT_YDATA = EDIT_YDATA + (p(2) - (EDIT_YDATA(2) + EDIT_YDATA(3)) / 2);
					set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
					
			end	
			
	end
	
	%---------------------------------------------------------------
	% COMPUTE SELECTION FLIP STATE
	%---------------------------------------------------------------

	FLIP = 0;

	%--
	% add horizontal flip bit
	%--
	
	if (EDIT_XDATA(1) > EDIT_XDATA(2))
		FLIP = FLIP + 1;
	end

	%--
	% add vertical flip bit
	%--
	
	if (EDIT_YDATA(2) > EDIT_YDATA(3))
		FLIP = FLIP + 2;
	end

	%---------------------------------------------------------------
	% UPDATE TEMPORARY EVENT
	%---------------------------------------------------------------

	%--
	% update based on horizontal flip
	%--
	
	if (FLIP == 0 || FLIP == 2)
		TEMP_EVENT.time = [EDIT_XDATA(1), EDIT_XDATA(2)];
	else
		TEMP_EVENT.time = [EDIT_XDATA(2), EDIT_XDATA(1)];
	end

	%--
	% update based on vertical flip
	%--
	
	if (FLIP == 0 || FLIP == 1)
		TEMP_EVENT.freq = [EDIT_YDATA(2), EDIT_YDATA(3)];
	else
		TEMP_EVENT.freq = [EDIT_YDATA(3), EDIT_YDATA(2)];
	end

	%--
	% set frequency bounds considering out of axes motion
	%--
	
	if (TEMP_EVENT.freq(1) < AXES_YLIM(1))
		TEMP_EVENT.freq(1) = AXES_YLIM(1);
		flag1 = 1;
	else
		flag1 = 0;
	end

	if (TEMP_EVENT.freq(2) > AXES_YLIM(2))
		TEMP_EVENT.freq(2) = AXES_YLIM(2);
		flag2 = 1;
	else
		flag2 = 0;
	end

	OPT_MOVE.resize = max(flag1, flag2);
	
	%--
	% handle axes frequency scaling
	%--
	
	if strcmp(FIGURE_DATA.browser.grid.freq.labels, 'kHz')
		TEMP_EVENT.freq = 1000 * TEMP_EVENT.freq;
	end
		
	%---------------------------------------------------------------
	% UPDATE GRID LINES IF NEEDED
	%---------------------------------------------------------------

	if (FIGURE_DATA.browser.selection.grid == 1)

		%-----------------------------
		% update grid lines
		%-----------------------------
		
		if (FLIP == 0 || FLIP == 2)
			xl = [AXES_XLIM(1) EDIT_XDATA(1) nan EDIT_XDATA(2) AXES_XLIM(2)];
		else
			xl = [AXES_XLIM(1) EDIT_XDATA(2) nan EDIT_XDATA(1) AXES_XLIM(2)];
		end 
		
		if (FLIP == 0 || FLIP == 1)
			yl = [AXES_YLIM(1) EDIT_YDATA(2) nan EDIT_YDATA(3) AXES_YLIM(2)];
		else
			yl = [AXES_YLIM(1) EDIT_YDATA(3) nan EDIT_YDATA(2) AXES_YLIM(2)];
		end
		
		tmp = ones(1,5);
		
		set(SELECTION_HANDLES(3),'xdata',EDIT_XDATA(1) * tmp,'ydata',yl);
		
		set(SELECTION_HANDLES(4),'xdata',EDIT_XDATA(2) * tmp,'ydata',yl);
		
		set(SELECTION_HANDLES(5),'xdata',xl,'ydata',EDIT_YDATA(2) * tmp);
		
		set(SELECTION_HANDLES(6),'xdata',xl,'ydata',EDIT_YDATA(3) * tmp);

		%-----------------------------
		% update labels if displayed
		%-----------------------------
		
		if (FIGURE_DATA.browser.selection.label == 1)
			
			%--
			% create time and frequency label strings using temporary event
			%--
			
			[time, freq] = selection_labels(gcbf, TEMP_EVENT, FIGURE_DATA);
			
			%-----------------------------
			% update grid labels 
			%-----------------------------
			
			%--
			% time labels
			%--
			
			if (FLIP == 0 || FLIP == 2)
				
				tmp = get(SELECTION_HANDLES(7),'position');		
				tmp(1) = EDIT_XDATA(1) - 0.0375;
				set(SELECTION_HANDLES(7),'position',tmp,'string',time{1});
					
				tmp = get(SELECTION_HANDLES(8),'position');
				tmp(1) = EDIT_XDATA(2) + 0.0375;
				set(SELECTION_HANDLES(8),'position',tmp,'string',time{4});
				
			else
				
				tmp = get(SELECTION_HANDLES(7),'position');		
				tmp(1) = EDIT_XDATA(2) - 0.0375;
				set(SELECTION_HANDLES(7),'position',tmp,'string',time{1});
					
				tmp = get(SELECTION_HANDLES(8),'position');
				tmp(1) = EDIT_XDATA(1) + 0.0375;
				set(SELECTION_HANDLES(8),'position',tmp,'string',time{4});

			end
		
			%--
			% frequency labels
			%--
			
			tt1 = TEMP_EVENT.time(1) - FIGURE_DATA.browser.time;
			tt2 = (FIGURE_DATA.browser.time + FIGURE_DATA.browser.page.duration) - TEMP_EVENT.time(2);
			
			mar = (0.0375 * (yl(end) - yl(1))) / FIGURE_DATA.browser.page.duration;
			
			if (tt1 <= tt2)
				
				tmp = get(SELECTION_HANDLES(9),'position');
				tmp(1) = xl(end) - 0.0375;
				
				if (FLIP == 0 || FLIP == 1)
					tmp(2) = EDIT_YDATA(2) - mar;
				else
					tmp(2) = EDIT_YDATA(3) - mar;
				end
				
				set(SELECTION_HANDLES(9), ...
					'position',tmp,'string',freq{1}, ...
					'HorizontalAlignment','right', ...
					'VerticalAlignment','top' ...
				);
				
				tmp = get(SELECTION_HANDLES(10),'position');
				tmp(1) = xl(end) - 0.0375;
				
				if (FLIP == 0 || FLIP == 1)
					tmp(2) = EDIT_YDATA(3) + mar;
				else
					tmp(2) = EDIT_YDATA(2) + mar;
				end
				
				set(SELECTION_HANDLES(10), ...
					'position',tmp,'string',freq{4}, ...
					'HorizontalAlignment','right', ...
					'VerticalAlignment','bottom' ...
				);
	
			else
				
				tmp = get(SELECTION_HANDLES(9),'position');
				tmp(1) = xl(1) + 0.0375;
				
				if (FLIP == 0 || FLIP == 1)
					tmp(2) = EDIT_YDATA(2) - mar;
				else
					tmp(2) = EDIT_YDATA(3) - mar;
				end
				
				set(SELECTION_HANDLES(9), ...
					'position',tmp,'string',freq{1}, ...
					'HorizontalAlignment','left', ...
					'VerticalAlignment','top' ...
				);
				
				tmp = get(SELECTION_HANDLES(10),'position');
				tmp(1) = xl(1) + 0.0375;
				
				if (FLIP == 0 || FLIP == 1)
					tmp(2) = EDIT_YDATA(3) + mar;
				else
					tmp(2) = EDIT_YDATA(2) + mar;
				end

				set(SELECTION_HANDLES(10), ...
					'position',tmp,'string',freq{4}, ...
					'HorizontalAlignment','left', ...
					'VerticalAlignment','bottom' ...
				);
				
			end
			
		end
	
	end 
	
	%--
	% update selection controls
	%--
	
	set_selection_controls(gcbf, TEMP_EVENT, 'move', FIGURE_DATA);
	
	%--
	% refresh figure
	%--
	
	% NOTE: taken from refresh without various checks
	
	tmp = get(gcbf,'color');
	
	set(gcbf,'color',[0 0 0],'color',tmp);
	
	%--
	% update selection display
	%--
	
	% NOTE: the selection display window is not resized when moving

	if (ctrl == 9)
		selection_display(gcbf, TEMP_EVENT, OPT_MOVE, FIGURE_DATA, SELECTION_FIGURE);
	else
		selection_display(gcbf, TEMP_EVENT, OPT_RESIZE, FIGURE_DATA, SELECTION_FIGURE);
	end
	
	%--
	% update widgets
	%--
	
	update_widgets(gcbf, 'selection__edit__update');
	
%---------------------------------------------------------------
% STOP EDIT
%---------------------------------------------------------------

case ('stop')
	
	%--
	% set empty button motion and button up functions
	%--
	
	set(gcbf,'WindowButtonMotionFcn', '');
	
	set(gcbf,'WindowButtonUpFcn', '');
	
	%--
	% set pointer back to arrow pointer
	%--
	
	set(gcbf, 'Pointer', PTR);
	
	%--
	% check move flag in order to update
	%--
	
	if MOVE_FLAG
		
		%--
		% update EDIT_XDATA and EDIT_YDATA if selection was flipped
		%--
	
		if (EDIT_XDATA(1) > EDIT_XDATA(2))
			t1 = EDIT_XDATA(2);
			t2 = EDIT_XDATA(1);
			EDIT_XDATA = [t1,t2,t2,t1,t1];
		end
			
		if (EDIT_YDATA(2) > EDIT_YDATA(3))
			f1 = EDIT_YDATA(3);
			f2 = EDIT_YDATA(2);
			EDIT_YDATA = [f1,f1,f2,f2,f1];
		end
		
		%--
		% set selection frequency bounds to boundary if needed
		%--
		
		if (EDIT_YDATA(1) < AXES_YLIM(1))
			EDIT_YDATA([1,2,5]) = AXES_YLIM(1);
		end
		
		if (EDIT_YDATA(3) > AXES_YLIM(2))
			EDIT_YDATA([3,4]) = AXES_YLIM(2);
		end
		
		%--
		% logged event editing
		%--
		
		if (nargin > 2)
			
			%--
			% copy edited event
			%--
			
			event = FIGURE_DATA.browser.log(m).event(ix);
			
			%--
			% update time and frequency related fields
			%--
			
			event.time = [EDIT_XDATA(1), EDIT_XDATA(2)];
			
			if strcmp(FIGURE_DATA.browser.grid.freq.labels, 'kHz')
				event.freq = 1000 * [EDIT_YDATA(2), EDIT_YDATA(3)];
			else
				event.freq = [EDIT_YDATA(2), EDIT_YDATA(3)];
			end
			
			event.duration = diff(event.time);
			
			event.bandwidth = diff(event.freq);
			
			event.time(1) = map_time(FIGURE_DATA.browser.sound, 'record', 'slider', event.time(1));
			
			event.time(2) = event.time(1) + event.duration;
			
			%--
			% update modification date
			%--
			
			event.modified = now;
			
			%--
			% recompute measurements if needed
			%--
			
			recompute = FIGURE_DATA.browser.measurement.recompute;
			
			if ~isempty(recompute)
				
				for k = 1:length(event.measurement)

					%--
					% check if we need to recompute this measure
					%--
					
					obj = event.measurement(k);

					if ~ismember(obj.name, recompute)
						continue;
					end
					
					%--
					% try to recompute measure
					%--
					
					try
						event = feval(obj.fun, 'batch', FIGURE_DATA.browser.sound, event, obj);
					catch
						% TODO: eventually call extension warning
					end

				end
				
			end
			
			%--
			% update event, log, and userdata
			%--
			
			FIGURE_DATA.browser.log(m).event(ix) = event;
	
			set(gcbf, 'userdata', FIGURE_DATA);
			
			%--
			% update display
			%--
			
			delete(findall(gcbf, 'tag', [int2str(m) '.' int2str(ix)]));
			
			event_view('sound', gcbf, m, ix);
			
			event_bdfun(gcbf, m, ix);
			
		%--
		% selection event editing
		%--
		
		else
			
			%--
			% copy selection event
			%--
			
			event = FIGURE_DATA.browser.selection.event;
			
			%--
			% save event in edit array
			%--
			
			% NOT IMPLEMENTED YET
			
	% 		FIGURE_DATA.browser.edit = selection_edit_update(FIGURE_DATA,event);
	% 		
	% 		set(get_menu(FIGURE_DATA.browser.edit_menu.edit,'Undo Edit'),'enable','on');
	
			%--
			% update selection event
			%--
	
			event.time = [EDIT_XDATA(1), EDIT_XDATA(2)];
			
			if (strcmp(FIGURE_DATA.browser.grid.freq.labels,'kHz'))
				event.freq = 1000 * [EDIT_YDATA(2), EDIT_YDATA(3)];
			else
				event.freq = [EDIT_YDATA(2), EDIT_YDATA(3)];
			end
			
			event.duration = diff(event.time);
			event.bandwidth = diff(event.freq);
			
			%--
			% create label strings for event
			%--
			
			[time,freq] = selection_labels(gcbf,event,FIGURE_DATA); 
			
			%--
			% update patch and line positions
			%--
			
			set(SELECTION_HANDLES(1:2),'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
		
			%--
			% update grid lines
			%--
	
			xl = [AXES_XLIM(1) EDIT_XDATA(1) nan EDIT_XDATA(2) AXES_XLIM(2)];
			yl = [AXES_YLIM(1) EDIT_YDATA(2) nan EDIT_YDATA(3) AXES_YLIM(2)];
			tmp = ones(1,5);
			
			set(SELECTION_HANDLES(3),'xdata',EDIT_XDATA(1) * tmp,'ydata',yl);
			set(SELECTION_HANDLES(4),'xdata',EDIT_XDATA(2) * tmp,'ydata',yl);
			
			set(SELECTION_HANDLES(5),'xdata',xl,'ydata',EDIT_YDATA(2) * tmp);
			set(SELECTION_HANDLES(6),'xdata',xl,'ydata',EDIT_YDATA(3) * tmp);
			
			%--
			% update grid labels
			%--
			
			% time labels
			
			tmp = get(SELECTION_HANDLES(7),'position');		
			tmp(1) = EDIT_XDATA(1) - 0.0375;
			set(SELECTION_HANDLES(7),'position',tmp,'string',time{1});
				
			tmp = get(SELECTION_HANDLES(8),'position');
			tmp(1) = EDIT_XDATA(2) + 0.0375;
			set(SELECTION_HANDLES(8),'position',tmp,'string',time{4});
	
			% frequency labels
			
			tt1 = event.time(1) - FIGURE_DATA.browser.time;
			tt2 = (FIGURE_DATA.browser.time + FIGURE_DATA.browser.page.duration) - event.time(2);
			
			mar = (0.0375 * (yl(end) - yl(1))) / FIGURE_DATA.browser.page.duration;
			
			if (tt1 <= tt2)
				
				tmp = get(SELECTION_HANDLES(9),'position');
				tmp(1) = xl(end) - 0.0375;
				tmp(2) = EDIT_YDATA(2) - mar;
				
				set(SELECTION_HANDLES(9), ...
					'position',tmp,'string',freq{1}, ...
					'HorizontalAlignment','right', ...
					'VerticalAlignment','top' ...
				);
				
				tmp = get(SELECTION_HANDLES(10),'position');
				tmp(1) = xl(end) - 0.0375;
				tmp(2) = EDIT_YDATA(3) + mar;
				
				set(SELECTION_HANDLES(10), ...
					'position',tmp,'string',freq{4}, ...
					'HorizontalAlignment','right', ...
					'VerticalAlignment','bottom' ...
				);
	
			else
				
				tmp = get(SELECTION_HANDLES(9),'position');
				tmp(1) = xl(1) + 0.0375;
				tmp(2) = EDIT_YDATA(2) - mar;
				
				set(SELECTION_HANDLES(9), ...
					'position',tmp,'string',freq{1}, ...
					'HorizontalAlignment','left', ...
					'VerticalAlignment','top' ...
				);
				
				tmp = get(SELECTION_HANDLES(10),'position');
				tmp(1) = xl(1) + 0.0375;
				tmp(2) = EDIT_YDATA(3) + mar;
				
				set(SELECTION_HANDLES(10), ...
					'position',tmp,'string',freq{4}, ...
					'HorizontalAlignment','left', ...
					'VerticalAlignment','bottom' ...
				);
				
			end
		
			%--
			% update control point positions
			%--
			
			xc = (EDIT_XDATA(1) + EDIT_XDATA(2)) / 2;
			yc = (EDIT_YDATA(2) + EDIT_YDATA(3)) / 2;
			
			ctrl = [ ...
				EDIT_XDATA(2), yc; ...
				EDIT_XDATA(2), EDIT_YDATA(3); ...
				xc, EDIT_YDATA(3); ...
				EDIT_XDATA(1), EDIT_YDATA(3); ...
				EDIT_XDATA(1), yc; ...
				EDIT_XDATA(1), EDIT_YDATA(1); ...
				xc, EDIT_YDATA(1); ...
				EDIT_XDATA(2), EDIT_YDATA(1); ...
				xc, yc ...
			];
		
			for k = 1:9
				set(SELECTION_HANDLES(10 + k),'xdata',ctrl(k,1),'ydata',ctrl(k,2));
			end
			
			%--
			% update menu labels containing selection information
			%--
			
			L = { ...
				['Start Time:  ' time{1}], ...
				['End Time:  ' time{2}], ...
				['Duration:  ' time{3}], ...
				['Min Freq:  ' freq{1}], ...
				['Max Freq:  ' freq{2}], ...
				['Bandwidth:  ' freq{3}], ...
			};
		
			for k = 0:(length(L) - 1)
				set(SELECTION_HANDLES(end - k),'label',L{end - k});
			end
			
			%--
			% update userdata
			%--
			
			FIGURE_DATA.browser.selection.event = event;		
			set(gcbf,'userdata',FIGURE_DATA);
			
			%--
			% turn on clipping for static labels
			%--
			
% 			set(SELECTION_HANDLES(7:10),'clipping','on');
			
		end

	end
	
	%--
	% delete drag line
	%--
	
	delete(EDIT_HANDLE);
	
	%--
	% refresh figure
	%--

	% NOTE: this code is taken from refresh without various checks
	
	tmp = get(gcbf,'color');
	
	set(gcbf,'color',[0 0 0],'color',tmp);
	
	%--
	% update widgets
	%--
	
	update_widgets(gcbf, 'selection__edit__stop');
	
	% NOTE: calling this event provides non-live selection update!
	
	update_widgets(gcbf, 'selection__create');
	
	%--
	% reset current character
	%--
	
	% NOTE: this should be useful in other places
	
	set(gcbf,'currentcharacter',' ');
	
end




% NOTE: this function could use 'varargin' after 'eventdata'

function selection_edit_callback(obj, eventdata, mode, ctrl, m, ix)

if (nargin < 5)
	selection_edit(mode, ctrl);
else
	selection_edit(mode, ctrl, m, ix)	
end
