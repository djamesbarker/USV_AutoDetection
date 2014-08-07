function flag = set_selection_controls(h,event,mode,data)

% set_selection_controls - update selection palette on selection change
% ---------------------------------------------------------------------
%
% set_selection_controls(h,event,mode,data)
%
% Input:
% ------
%  h - parent figure
%  event - selection event
%  mode - update mode 'start' or 'move'
%  data - parent userdata
%
% Output:
% -------
%  flag - update success flag

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% NOTE: at the moment the flag output is not very informative

%----------------------------------------------------------------------
% CREATE PERSISTENT HANDLE VARIABLES
%----------------------------------------------------------------------

persistent TIME_START TIME_SLIDER TIME_MODE;

persistent FREQ_MIN FREQ_SLIDER FREQ_MODE;

%----------------------------------------------------------------------
% HANDLE INPUT
%----------------------------------------------------------------------

%--
% get userdata if needed
%--

if ((nargin < 4) || isempty(data))
	data = get(h,'userdata');
end

%--
% get palette
%--

pal = get_palette(h,'Selection',data);

% NOTE: quick return if there are no controls to update

if (isempty(pal))	
	flag = 0; return; 
end 

%--
% set mode if needed
%--

% NOTE: the default does more work, but ensures proper display

if ((nargin < 3) || isempty(mode))
	mode = 'start';
end

%--
% get selection event if needed
%--

if ((nargin < 2) || isempty(event))
	event = data.browser.selection.event;
end

% NOTE: quick return on empty selection

if (isempty(event))
	flag = 0; return;
end

%----------------------------------------------------------------------
% MODE SWITCH
%----------------------------------------------------------------------

switch (mode)
	
	%----------------------------------------------------------------------
	% START
	%----------------------------------------------------------------------
	
	% NOTE: this sets range and value properties of controls
	
	case ('start')
		
		% NOTE: we really don't need all control values, this is just cleaner 

		values = get_control_values(pal);
		
		%--------------------------------------------------------
		% TIME CONTROLS
		%--------------------------------------------------------

		%--
		% get time controls handles and mode
		%--
		
		TIME_START = findobj(control_update([],pal,'start_time'),'style','slider');

		TIME_SLIDER = findobj(control_update([],pal,'time_slider'),'style','slider');

		TIME_MODE = 2^(1 - strcmp(values.time_mode{1},'Duration'));

		%--
		% get axes limits using event channel
		%--
		
		% NOTE: this assumes the event axes tag is the channel index
		
		ax = findobj(h,'type','axes','tag',int2str(event.channel));
		
		xl = get(ax,'xlim');
		
		%--
		% set start time control range and value
		%--

		% TODO: integrate margin variables

		set(TIME_START, ...
			'min',xl(1), ...
			'max',xl(2), ...
			'value',event.time(1) ...
		);

		slider_sync(TIME_START); 

		%--
		% set duration or end time range and value
		%--
		
		if (TIME_MODE == 1) % duration 

			set(TIME_SLIDER, ...
				'min',0, ...
				'max',data.browser.page.duration, ...
				'value',diff(event.time) ...
			);

		else % end time 

			set(TIME_SLIDER, ...
				'min',xl(1), ...
				'max',xl(2), ...
				'value',event.time(2) ...
			);

		end
		
		slider_sync(TIME_SLIDER);
		
		%--------------------------------------------------------
		% FREQUENCY CONTROLS
		%--------------------------------------------------------

		% NOTE: the frequency limits do not change as the time limits do
		
		%--
		% get frequency controls handles and mode
		%--

		FREQ_MIN = findobj(control_update([],pal,'min_freq'),'style','slider');

		FREQ_SLIDER = findobj(control_update([],pal,'freq_slider'),'style','slider');

		FREQ_MODE = 2^(1 - strcmp(values.freq_mode{1},'Bandwidth'));
		
		%--
		% set min frequency control
		%--

		set(FREQ_MIN,'value',event.freq(1));

		slider_sync(FREQ_MIN); 
		
		%--
		% set bandwidth or max frequency control
		%--
		
		if (FREQ_MODE == 1)
			set(FREQ_SLIDER,'value',diff(event.freq));
		else
			set(FREQ_SLIDER,'value',event.freq(2));
		end
		
		slider_sync(FREQ_SLIDER);
		
	%----------------------------------------------------------------------
	% MOVE
	%----------------------------------------------------------------------
	
	% NOTE: this only updates the values of the controls
	
	case ('move')

		%--------------------------------------------------------
		% TIME CONTROLS
		%--------------------------------------------------------

		%--
		% set start time control
		%--

		set(TIME_START,'value',event.time(1));

		slider_sync(TIME_START);

		%--
		% set duration or end time control
		%--

		if (TIME_MODE == 1)
			set(TIME_SLIDER,'value',diff(event.time));
		else
			set(TIME_SLIDER,'value',event.time(2));
		end

		slider_sync(TIME_SLIDER);

		%--------------------------------------------------------
		% FREQUENCY CONTROLS
		%--------------------------------------------------------

		%--
		% set min frequency control
		%--

		set(FREQ_MIN,'value',event.freq(1));

		slider_sync(FREQ_MIN);

		%--
		% set bandwidth or max frequency control
		%--

		if (FREQ_MODE == 1)
			set(FREQ_SLIDER,'value',diff(event.freq));
		else
			set(FREQ_SLIDER,'value',event.freq(2));
		end

		slider_sync(FREQ_SLIDER);
		
end
