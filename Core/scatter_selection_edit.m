function scatter_selection_edit(mode,ctrl,m,ix)

% scatter_selection_edit- edit scatter selections
% -----------------------------------------------
%
%  scatter_selection_edit('start',ctrl)
%  scatter_selection_edit('move',ctrl)
%  scatter_selection_edit('stop',ctrl)
%
%  scatter_selection_edit('start',ctrl,m,ix)
%  scatter_selection_edit('move',ctrl,m,ix)
%  scatter_selection_edit('stop',ctrl,m,ix)
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
% $Revision: 5535 $
% $Date: 2006-07-03 14:00:31 -0400 (Mon, 03 Jul 2006) $
%--------------------------------

%--
% declare persistent variables
%--

persistent PTR;

persistent POINTER_NAMES;

persistent FIGURE_DATA SELECTION_HANDLES;

persistent AXES_XLIM AXES_YLIM MARGIN_X MARGIN_Y;

persistent EDIT_HANDLE EDIT_XDATA EDIT_YDATA;

persistent FLIP TEMP_EVENT;

persistent MOVE_FLAG;

persistent VALUE_TEXT;

persistent BUTTON_DOWN;

persistent SELECTION_TAGS;
	
%--
% switch on mode
%--

switch (mode)
	
%---------------------------------------------------------------
% START EDIT
%---------------------------------------------------------------

case ('start')
	
	%--
	% create persistent table of pointer names
	%--
	
	POINTER_NAMES = { ...
		'right', 'topr', 'top', 'topl', 'left', 'botl', 'bottom', 'botr', 'fleur' ...
	};
	
	%--
	% create persistent copy of relevant information from userdata
	%--
	
% 	FIGURE_DATA = get(gcbf,'userdata');

	%--
	% get selection handles based on their tags
	%--
	
	SELECTION_HANDLES = findobj(gcbf, 'tag', 'SCATTER_SELECTION');
	
	% NOTE: we sort handles based on userdata
	
	[SELECTION_TAGS, ix] = sort(cell2mat(get(SELECTION_HANDLES, 'userdata')));
	
	SELECTION_HANDLES = SELECTION_HANDLES(ix);
		
	%--
	% get axes limits
	%--
	
	AXES_XLIM = get(gca,'xlim'); AXES_YLIM = get(gca,'ylim');
	
	%--
	% set editing button motion and button up functions
	%--
		
	if (nargin < 3)
		
		set(gcbf,'WindowButtonMotionFcn',['scatter_selection_edit(''move'', ' int2str(ctrl) ');']);
		set(gcbf,'WindowButtonUpFcn',['scatter_selection_edit(''stop'', ' int2str(ctrl) ');']);
		
	else 
		
		set(gcbf,'WindowButtonMotionFcn', ...
			['scatter_selection_edit(''move'', ' int2str(ctrl) ',' int2str(m) ',' int2str(ix) ');']);
		set(gcbf,'WindowButtonUpFcn', ...
			['scatter_selection_edit(''stop'', ' int2str(ctrl) ',' int2str(m) ',' int2str(ix) ');']);
		
	end
	
	%--
	% temporarily disable axes button down function
	%--
	
	BUTTON_DOWN = get(gca,'buttondownfcn');
	
	set(gca,'buttondownfcn','');
	
	%--
	% get starting pointer
	%--
	
	PTR = get(gcbf,'pointer');
	
	%--
	% set pointer according to control point
	%--
	
	if (ctrl < 9)
		
		%--
		% boundary control point selection editing
		%--
		
		set(gcbf,'pointer',POINTER_NAMES{ctrl});
		
	else
		
		%--
		% selection movement editing
		%--
		
		% check for horizontal or vertical motion constraint
		
		tmp = double(get(gcbf,'currentcharacter'));
		
		if (isempty(tmp))
			tmp = double(' ');
		end
		
		switch (tmp)
			
		case (double('h'))
			set(gcbf,'pointer','left');
			
		case (double('v'))
			set(gcbf,'pointer','top');
			
		otherwise
			set(gcbf,'pointer','fleur');
			
		end	
		
	end

	%--
	% create persistent drag line representation of selection
	%--
	
	% the color should be obtained from somewhere
	
	color = [1 0 0];
	
	EDIT_XDATA = get(SELECTION_HANDLES(1),'xdata');
	EDIT_YDATA = get(SELECTION_HANDLES(1),'ydata');
			
	EDIT_HANDLE = line( ...
		'xdata',EDIT_XDATA, ...
		'ydata',EDIT_YDATA, ... 
		'linestyle',':', ...
		'color',color, ...
		'linewidth',0.5 ...
	);

	%--
	% create persistent variables for dynamic updating of labels
	%--

	FLIP = 0;
	TEMP_EVENT = data_event_create;
	
	%--
	% set move flag
	%--
	
	MOVE_FLAG = 0;

	%--
	% create persistent margin for selections
	%--
	
	% generally there are no margins, consider this behavior for the sound
	% browser selection as well
	
% 	if (ctrl < 9)
% 		MARGIN_X = 0.025 * diff(AXES_XLIM);
% 		MARGIN_Y = 0;
% 	else 
% 		MARGIN_X = ((EDIT_XDATA(2) - EDIT_XDATA(1)) / 2) + (0.025 * diff(AXES_XLIM));
% 		MARGIN_Y = (EDIT_YDATA(3) - EDIT_YDATA(2)) / 2;
% 	end
	
	%--
	% refresh figure
	%--
		
	% taken from the refresh function
	
	tmp = get(gcbf,'color');
	set(gcbf,'color',[0 0 0],'color',tmp);
	
%---------------------------------------------------------------
% EDIT MOVE
%---------------------------------------------------------------

case ('move')
	
	%--
	% set move flag
	%--
	
	MOVE_FLAG = 1;
	
	%--
	% get current point in axes
	%--
	
	p = get(gca,'CurrentPoint');
	p = p(1,1:2);
	
	%--
	% return if we are out of the axes time bounds considering margins
	%--
		
% 	if ((p(1) <= AXES_XLIM(1) + MARGIN_X) | (p(1) >= AXES_XLIM(2) - MARGIN_X))
% 		return;
% 	end
	
	%--
	% update event box display switching on control point being moved
	%--
	
	switch (ctrl)
		
		case (1)
			
			%--
			% east control point
			%--
			
			EDIT_XDATA(2:3) = p(1);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA);
			
		case (2)
			
			%--
			% north-east control point
			%--
			
			EDIT_XDATA(2:3) = p(1);
			EDIT_YDATA(3:4) = p(2);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
			
		case (3)
			
			%--
			% north control point
			%--
			
			EDIT_YDATA(3:4) = p(2);
			set(EDIT_HANDLE,'ydata',EDIT_YDATA);
			
		case (4)
			
			%--
			% north-west control point
			%--
			
			EDIT_XDATA([1,4,5]) = p(1);
			EDIT_YDATA(3:4) = p(2);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
			
		case (5)
			
			%--
			% west control point
			%--
			
			EDIT_XDATA([1,4,5]) = p(1);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA);
			
		case (6)
			
			%--
			% south-west control point
			%--
			
			EDIT_XDATA([1,4,5]) = p(1);
			EDIT_YDATA([1,2,5]) = p(2);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
			
		case (7)
			
			%--
			% south control point
			%--
			
			EDIT_YDATA([1,2,5]) = p(2);
			set(EDIT_HANDLE,'ydata',EDIT_YDATA);
			
		case (8)
			
			%--
			% south-east control point
			%--
			
			EDIT_XDATA(2:3) = p(1);
			EDIT_YDATA([1,2,5]) = p(2);
			set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
	
		case (9)
			
			%--
			% center control point
			%--
			
			switch (get(gcf,'pointer'))
				
				%--
				% horizontal motion
				%--
				
				case ('left')
					EDIT_XDATA = EDIT_XDATA + (p(1) - (EDIT_XDATA(1) + EDIT_XDATA(2)) / 2);
					set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
				
				%--
				% vertical motion
				%--
				
				case ('top')
					EDIT_YDATA = EDIT_YDATA + (p(2) - (EDIT_YDATA(2) + EDIT_YDATA(3)) / 2);
					set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
					
				%--
				% unconstrained motion
				%--
				
				case ('fleur')
					EDIT_XDATA = EDIT_XDATA + (p(1) - (EDIT_XDATA(1) + EDIT_XDATA(2)) / 2);
					EDIT_YDATA = EDIT_YDATA + (p(2) - (EDIT_YDATA(2) + EDIT_YDATA(3)) / 2);
					set(EDIT_HANDLE,'xdata',EDIT_XDATA,'ydata',EDIT_YDATA);
					
			end	
			
	end
	
	%--
	% update grid lines if displayed
	%--

% 	if (FIGURE_DATA.browser.selection.grid == 1)
			
		%--
		% create indicator of flip state of selection
		%--
		
		FLIP = 0;
		
		if (EDIT_XDATA(1) > EDIT_XDATA(2))
			FLIP = FLIP + 1;
		end
			
		if (EDIT_YDATA(2) > EDIT_YDATA(3))
			FLIP = FLIP + 2;
		end
		
		%--
		% update temporary event for dynamic updating of labels
		%--
		
		if (FLIP == 0 | FLIP == 2)
			TEMP_EVENT.x = [EDIT_XDATA(1), EDIT_XDATA(2)];
		else
			TEMP_EVENT.x = [EDIT_XDATA(2), EDIT_XDATA(1)];
		end
			
		if (FLIP == 0 | FLIP == 1)
			TEMP_EVENT.y = [EDIT_YDATA(2), EDIT_YDATA(3)];
		else
			TEMP_EVENT.y = [EDIT_YDATA(3), EDIT_YDATA(2)];
		end
		
		% set bounds considering out ot axes motion
		
		if (TEMP_EVENT.y(1) < AXES_YLIM(1))
			TEMP_EVENT.y(1) = AXES_YLIM(1);
		end
		
		if (TEMP_EVENT.y(2) > AXES_YLIM(2))
			TEMP_EVENT.y(2) = AXES_YLIM(2);
		end
		
		if (TEMP_EVENT.x(1) < AXES_XLIM(1))
			TEMP_EVENT.x(1) = AXES_XLIM(1);
		end
		
		if (TEMP_EVENT.x(2) > AXES_XLIM(2))
			TEMP_EVENT.x(2) = AXES_XLIM(2);
		end
		
		%--
		% update grid lines considering flipping
		%--
		
		if (FLIP == 0 | FLIP == 2)
			xl = [AXES_XLIM(1) EDIT_XDATA(1) nan EDIT_XDATA(2) AXES_XLIM(2)];
		else
			xl = [AXES_XLIM(1) EDIT_XDATA(2) nan EDIT_XDATA(1) AXES_XLIM(2)];
		end 
		
		if (FLIP == 0 | FLIP == 1)
			yl = [AXES_YLIM(1) EDIT_YDATA(2) nan EDIT_YDATA(3) AXES_YLIM(2)];
		else
			yl = [AXES_YLIM(1) EDIT_YDATA(3) nan EDIT_YDATA(2) AXES_YLIM(2)];
		end
		
		tmp = ones(1,5);
		
		set(SELECTION_HANDLES(3),'xdata',EDIT_XDATA(1) * tmp,'ydata',yl);
		set(SELECTION_HANDLES(4),'xdata',EDIT_XDATA(2) * tmp,'ydata',yl);
		
		set(SELECTION_HANDLES(5),'xdata',xl,'ydata',EDIT_YDATA(2) * tmp);
		set(SELECTION_HANDLES(6),'xdata',xl,'ydata',EDIT_YDATA(3) * tmp);

		%--
		% update labels if displayed
		%--
		
% 		if (FIGURE_DATA.browser.selection.label == 1)
% 			
% 			%--
% 			% create time and frequency label strings using temporary event
% 			%
% 			%--
% 			
% 			[time,freq] = selection_labels(gcbf,TEMP_EVENT,FIGURE_DATA);
% 			
% 			%--
% 			% update grid labels considering flipping
% 			%--
% 			
% 			% time labels
% 							
% 			if (FLIP == 0 | FLIP == 2)
% 				
% 				tmp = get(SELECTION_HANDLES(7),'position');		
% 				tmp(1) = EDIT_XDATA(1) - 0.0375;
% 				set(SELECTION_HANDLES(7),'position',tmp,'string',time{1});
% 					
% 				tmp = get(SELECTION_HANDLES(8),'position');
% 				tmp(1) = EDIT_XDATA(2) + 0.0375;
% 				set(SELECTION_HANDLES(8),'position',tmp,'string',time{4});
% 				
% 			else
% 				
% 				tmp = get(SELECTION_HANDLES(7),'position');		
% 				tmp(1) = EDIT_XDATA(2) - 0.0375;
% 				set(SELECTION_HANDLES(7),'position',tmp,'string',time{1});
% 					
% 				tmp = get(SELECTION_HANDLES(8),'position');
% 				tmp(1) = EDIT_XDATA(1) + 0.0375;
% 				set(SELECTION_HANDLES(8),'position',tmp,'string',time{4});
% 
% 			end
% 		
% 			% frequency labels
% 			
% 			tt1 = TEMP_EVENT.x(1) - FIGURE_DATA.browser.x;
% 			tt2 = (FIGURE_DATA.browser.x + FIGURE_DATA.browser.page.dx) - TEMP_EVENT.x(2);
% 			
% 			mar = (0.0375 * (yl(end) - yl(1))) / FIGURE_DATA.browser.page.dx;
% 			
% 			if (tt1 <= tt2)
% 				
% 				tmp = get(SELECTION_HANDLES(9),'position');
% 				tmp(1) = xl(end) - 0.0375;
% 				
% 				if (FLIP == 0 | FLIP == 1)
% 					tmp(2) = EDIT_YDATA(2) - mar;
% 				else
% 					tmp(2) = EDIT_YDATA(3) - mar;
% 				end
% 				
% 				set(SELECTION_HANDLES(9), ...
% 					'position',tmp,'string',freq{1}, ...
% 					'HorizontalAlignment','right', ...
% 					'VerticalAlignment','top' ...
% 				);
% 				
% 				tmp = get(SELECTION_HANDLES(10),'position');
% 				tmp(1) = xl(end) - 0.0375;
% 				
% 				if (FLIP == 0 | FLIP == 1)
% 					tmp(2) = EDIT_YDATA(3) + mar;
% 				else
% 					tmp(2) = EDIT_YDATA(2) + mar;
% 				end
% 				
% 				set(SELECTION_HANDLES(10), ...
% 					'position',tmp,'string',freq{4}, ...
% 					'HorizontalAlignment','right', ...
% 					'VerticalAlignment','bottom' ...
% 				);
% 	
% 			else
% 				
% 				tmp = get(SELECTION_HANDLES(9),'position');
% 				tmp(1) = xl(1) + 0.0375;
% 				
% 				if (FLIP == 0 | FLIP == 1)
% 					tmp(2) = EDIT_YDATA(2) - mar;
% 				else
% 					tmp(2) = EDIT_YDATA(3) - mar;
% 				end
% 				
% 				set(SELECTION_HANDLES(9), ...
% 					'position',tmp,'string',freq{1}, ...
% 					'HorizontalAlignment','left', ...
% 					'VerticalAlignment','top' ...
% 				);
% 				
% 				tmp = get(SELECTION_HANDLES(10),'position');
% 				tmp(1) = xl(1) + 0.0375;
% 				
% 				if (FLIP == 0 | FLIP == 1)
% 					tmp(2) = EDIT_YDATA(3) + mar;
% 				else
% 					tmp(2) = EDIT_YDATA(2) + mar;
% 				end
% 
% 				set(SELECTION_HANDLES(10), ...
% 					'position',tmp,'string',freq{4}, ...
% 					'HorizontalAlignment','left', ...
% 					'VerticalAlignment','bottom' ...
% 				);
% 				
% 			end
% 			
% 		end
	
% 	end 
	
	%--
	% refresh figure
	%--
	
	% taken from refresh without various checks
	
% 	tmp = get(gcbf,'color');
% 	set(gcbf,'color',[0 0 0],'color',tmp);

%---------------------------------------------------------------
% STOP EDIT
%---------------------------------------------------------------

case ('stop')
	
	%--
	% set empty button motion and button up functions
	%--
	
	set(gcbf,'WindowButtonMotionFcn','');
	set(gcbf,'WindowButtonUpFcn','');
	
	%--
	% reset axes button down function
	%--
	
	set(gca,'buttondownfcn',BUTTON_DOWN);
	
	%--
	% set pointer back to arrow pointer
	%--
	
	set(gcbf,'Pointer',PTR);
	
	%--
	% check move flag in order to update
	%--
	
	if (MOVE_FLAG)
		
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
		% set selection bounds to boundary if needed
		%--
		
		% y bounds
		
		if (EDIT_YDATA(1) < AXES_YLIM(1))
			EDIT_YDATA([1,2,5]) = AXES_YLIM(1);
		end
		
		if (EDIT_YDATA(3) > AXES_YLIM(2))
			EDIT_YDATA([3,4]) = AXES_YLIM(2);
		end
		
		% x bounds
		
		if (EDIT_XDATA(1) < AXES_XLIM(1))
			EDIT_XDATA([1,4,5]) = AXES_XLIM(1);
		end
		
		if (EDIT_XDATA(2) > AXES_XLIM(2))
			EDIT_XDATA([2,3]) = AXES_XLIM(2);
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
			% save event in edit array
			%--
			
			% NOT IMPLEMENTED YET
			
	% 		FIGURE_DATA.browser.edit = scatter_selection_edit_update(FIGURE_DATA,event,m,ix);
	% 		
	% 		set(get_menu(FIGURE_DATA.browser.edit_menu.edit,'Undo Edit'),'enable','on');
	
			%--
			% update time and frequency related fields
			%--
			
			event.x = [EDIT_XDATA(1), EDIT_XDATA(2)];
			
			if (strcmp(FIGURE_DATA.browser.grid.y.labels,'kHz'))
				event.y = 1000 * [EDIT_YDATA(2), EDIT_YDATA(3)];
			else
				event.y = [EDIT_YDATA(2), EDIT_YDATA(3)];
			end
			
			event.dx = diff(event.x);
			event.dy = diff(event.y);
			
			%--
			% update modification date
			%--
			
			event.modified = now;
			
			%--
			% recompute measurements if needed
			%--
			
			for k = 1:length(event.measurement)
				tmp = event.measurement(k);
				if (~isempty(tmp.fun))
					event = feval(tmp.fun,'batch',FIGURE_DATA.browser.sound,event,tmp);
				end
			end
			
			%--
			% update event, log, and userdata
			%--
			
			FIGURE_DATA.browser.log(m).event(ix) = event;
			
			[tt,ff] = log_info_update(FIGURE_DATA.browser.log(m),event);
			
			FIGURE_DATA.browser.log(m).x = tt;
			FIGURE_DATA.browser.log(m).dx = diff(tt);
			
			FIGURE_DATA.browser.log(m).y = ff;
			FIGURE_DATA.browser.log(m).dy = diff(ff);
			
			FIGURE_DATA.browser.log(m).modified = now;
	
			set(gcbf,'userdata',FIGURE_DATA);
			
			%--
			% update log information menu
			%--
			
			log_menu_update('edit',FIGURE_DATA,m,ix);
			
			%--
			% update display
			%--
			
			delete(findall(gcbf,'tag',[int2str(m) '.' int2str(ix)]));
			
			event_view('sound',gcbf,m,ix);
			event_bdfun(gcbf,m,ix);
			
		%--
		% selection event editing
		%--
		
		else
			
			%--
			% copy selection event
			%--
			
% 			event = FIGURE_DATA.browser.selection.event;
			
			event = TEMP_EVENT;
			
			%--
			% save event in edit array
			%--
			
			% NOT IMPLEMENTED YET
			
	% 		FIGURE_DATA.browser.edit = scatter_selection_edit_update(FIGURE_DATA,event);
	% 		
	% 		set(get_menu(FIGURE_DATA.browser.edit_menu.edit,'Undo Edit'),'enable','on');
	
			%--
			% update selection event
			%--
	
			event.x = [EDIT_XDATA(1), EDIT_XDATA(2)];
			event.y = [EDIT_YDATA(2), EDIT_YDATA(3)];
			
			event.dx = diff(event.x);
			event.dy = diff(event.y);
			
			%--
			% create label strings for event
			%--
			
% 			[time,freq] = selection_labels(gcbf,event,FIGURE_DATA); 
			
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
			
% 			%--
% 			% update grid labels
% 			%--
% 			
% 			% time labels
% 			
% 			tmp = get(SELECTION_HANDLES(7),'position');		
% 			tmp(1) = EDIT_XDATA(1) - 0.0375;
% 			set(SELECTION_HANDLES(7),'position',tmp,'string',time{1});
% 				
% 			tmp = get(SELECTION_HANDLES(8),'position');
% 			tmp(1) = EDIT_XDATA(2) + 0.0375;
% 			set(SELECTION_HANDLES(8),'position',tmp,'string',time{4});
% 	
% 			% frequency labels
% 			
% 			tt1 = event.x(1) - FIGURE_DATA.browser.x;
% 			tt2 = (FIGURE_DATA.browser.x + FIGURE_DATA.browser.page.dx) - event.x(2);
% 			
% 			mar = (0.0375 * (yl(end) - yl(1))) / FIGURE_DATA.browser.page.dx;
% 			
% 			if (tt1 <= tt2)
% 				
% 				tmp = get(SELECTION_HANDLES(9),'position');
% 				tmp(1) = xl(end) - 0.0375;
% 				tmp(2) = EDIT_YDATA(2) - mar;
% 				
% 				set(SELECTION_HANDLES(9), ...
% 					'position',tmp,'string',freq{1}, ...
% 					'HorizontalAlignment','right', ...
% 					'VerticalAlignment','top' ...
% 				);
% 				
% 				tmp = get(SELECTION_HANDLES(10),'position');
% 				tmp(1) = xl(end) - 0.0375;
% 				tmp(2) = EDIT_YDATA(3) + mar;
% 				
% 				set(SELECTION_HANDLES(10), ...
% 					'position',tmp,'string',freq{4}, ...
% 					'HorizontalAlignment','right', ...
% 					'VerticalAlignment','bottom' ...
% 				);
% 	
% 			else
% 				
% 				tmp = get(SELECTION_HANDLES(9),'position');
% 				tmp(1) = xl(1) + 0.0375;
% 				tmp(2) = EDIT_YDATA(2) - mar;
% 				
% 				set(SELECTION_HANDLES(9), ...
% 					'position',tmp,'string',freq{1}, ...
% 					'HorizontalAlignment','left', ...
% 					'VerticalAlignment','top' ...
% 				);
% 				
% 				tmp = get(SELECTION_HANDLES(10),'position');
% 				tmp(1) = xl(1) + 0.0375;
% 				tmp(2) = EDIT_YDATA(3) + mar;
% 				
% 				set(SELECTION_HANDLES(10), ...
% 					'position',tmp,'string',freq{4}, ...
% 					'HorizontalAlignment','left', ...
% 					'VerticalAlignment','bottom' ...
% 				);
% 				
% 			end
		
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
		
			% get starting point for control points
			
			tmp = find(SELECTION_TAGS == 11) - 1;
						
			for k = 1:9
				set(SELECTION_HANDLES(tmp + k),'xdata',ctrl(k,1),'ydata',ctrl(k,2));
			end
			
% 			%--
% 			% update menu labels containing selection information
% 			%--
% 			
% 			L = { ...
% 				['Start Time:  ' time{1}], ...
% 				['End Time:  ' time{2}], ...
% 				['Duration:  ' time{3}], ...
% 				['Min Freq:  ' freq{1}], ...
% 				['Max Freq:  ' freq{2}], ...
% 				['Bandwidth:  ' freq{3}], ...
% 			};
% 		
% 			for k = 0:(length(L) - 1)
% 				set(SELECTION_HANDLES(end - k),'label',L{end - k});
% 			end
% 			
% 			%--
% 			% update userdata
% 			%--
% 			
% 			FIGURE_DATA.browser.selection.event = event;		
% 			set(gcbf,'userdata',FIGURE_DATA);
% 			
% 			%--
% 			% turn on clipping for static labels
% 			%--
% 			
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

	% taken from refresh without various checks
	
	tmp = get(gcbf,'color');
	set(gcbf,'color',[0 0 0],'color',tmp);
	
	%--
	% reset current character
	%--
	
	set(gcbf,'currentcharacter',' ');
	
end
