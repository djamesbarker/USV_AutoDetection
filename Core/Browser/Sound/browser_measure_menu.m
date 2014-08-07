function out = browser_measure_menu(par, str)

% browser_measure_menu - browser measurement function menu
% --------------------------------------------------------
%
% out = browser_measure_menu(par, str)
%
% Input:
% ------
%  par - browser
%  str - command string (def: 'Initialize')
%
% Output:
% -------
%  out - command output

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

%---------------------
% HANDLE INPUT
%---------------------

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% try to get default browser
%--

if (nargin < 1) || isempty(par)
	par = get_active_browser;
end

out = [];

if ~is_browser(par)
	return;
end

%---------------------
% SETUP
%---------------------

%--
% get browser state
%--

data = get_browser(par);

%--
% get measurement information
%--

% NOTE: get old extensions info from browser

MEAS_NAME = data.browser.measurement.name;

MEAS_VIEW = data.browser.measurement.view;

MEAS_RECOMPUTE = data.browser.measurement.recompute;

%---------------------
% COMMAND SWITCH
%---------------------

switch str

%---------------------
% INITIALIZE
%---------------------

case 'Initialize'

	%--
	% check for existing menu
	%--
		
	tmp = get(findobj(gcf, 'type', 'uimenu', 'parent', gcf), 'label');
	
	tmp = find(strcmp(tmp, 'Measure'));
	
	if ~isempty(tmp)
		return;
	end
	
	%--
	% Measure
	%--
	
	L = strcat(MEAS_NAME, ' ...');
	
	L = { ...
		'Measure', ...
		'Display', ...
		'Recompute', ...
		L{:} ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n)); 
	S{4} = 'on';
	
	mg = menu_group(par, 'browser_measure_menu', L, S);
	
	data.browser.measure_menu.measure = mg;
	
	set(mg(1), 'position', 10);
	
	% NOTE: turn off measurements upon initialization, opening a log will activate these
	
	set(mg(4:end), 'enable', 'off');
	
	%--
	% Display
	%--
	
	L = { ...
		'No Display', ...
		MEAS_NAME{:}, ...
		'Display All' ...
	};
	
	n = length(L); 
	
	S = bin2str(zeros(1,n)); 
	S{2} = 'on'; 
	S{end} = 'on';
	
	tmp = menu_group(get_menu(mg, 'Display'), 'browser_measure_menu', L, S);
	
	data.browser.measure_menu.display = tmp;
	
	for k = 1:length(MEAS_VIEW)
		set(get_menu(tmp, MEAS_VIEW{k}), 'check', 'on');
	end
	
	%--
	% Recompute
	%--
	
	L = { ...
		'No Recompute', ...
		MEAS_NAME{:}, ...
		'Recompute All' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n)); 
	S{2} = 'on';
	S{end} = 'on';
	
	tmp = menu_group(get_menu(mg,'Recompute'), 'browser_measure_menu', L, S);
	
	data.browser.measure_menu.recompute = tmp;
	
	L{1} = ''; L{end} = '';
	
	for k = 1:length(MEAS_RECOMPUTE)
		set(get_menu(tmp, MEAS_RECOMPUTE{k}), 'check', 'on');
	end
	
	%--
	% save userdata
	%--
	
	set(par, 'userdata', data);

%---------------------
% DISPLAY
%---------------------

case ('No Display')
	
	%--
	% update measure display list
	%--
	
	data.browser.measurement.view = {};
	
	set(par, 'userdata', data);
	
	%--
	% update menu
	%--

	set(data.browser.measure_menu.display, 'check', 'off');	
	
	%--
	% update display
	%--
	
	browser_display(par, 'events', data);
	
case ('Display All')
	
	%--
	% update measurement display list
	%--
	
	data.browser.measurement.view = MEAS_NAME;
	
	set(par, 'userdata', data);
	
	%--
	% update display state menu
	%--
	
	tmp = data.browser.measure_menu.display;
	
	set(tmp(2:(end - 1)), 'check', 'on');	
	
	%--
	% update display
	%--
	
	browser_display(par, 'events', data);
	
%---------------------
% RECOMPUTE
%---------------------

case ('No Recompute')
	
	%--
	% update recompute list
	%--
	
	data.browser.measurement.recompute = {};
	
	set(par, 'userdata', data);
	
	%--
	% update menu
	%--
	
	set(data.browser.measure_menu.recompute, 'check', 'off');	

case 'Recompute All'
		
	%--
	% update measurement display list
	%--
	
	data.browser.measurement.recompute = MEAS_NAME;
	
	set(par, 'userdata', data);
	
	%--
	% update display state menu
	%--
	
	tmp = data.browser.measure_menu.recompute;
	
	set(tmp(2:(end - 1)), 'check', 'on');	
	
%---------------------
% TOGGLE
%---------------------

case MEAS_NAME

	%--
	% get update type from parent menu label
	%--
	
	type = get(gcbo, 'parent');
	
	if isempty(type)
		return;
	end
	
	type = lower(get(type, 'label'));
	
	%--
	% update according to type
	%--
	
	switch type
		
		case 'display'
	
			%--
			% update display state for measurement
			%--

			ixa = find(strcmp(MEAS_VIEW, str));

			if isempty(ixa)
				MEAS_VIEW = sort({MEAS_VIEW{:}, str}); state = 'on';
			else
				MEAS_VIEW(ixa) = []; state = 'off';
			end

			data.browser.measurement.view = MEAS_VIEW;

			set(par, 'userdata', data);

			%--
			% update display state menu
			%--

			set(get_menu(data.browser.measure_menu.display, str), 'check', state);

			%--
			% update display
			%--

			browser_display(par, 'events', data);
			
		case 'recompute'
			
			%--
			% update recompute state for measurement
			%--

			ixa = find(strcmp(MEAS_RECOMPUTE, str));

			if isempty(ixa)
				MEAS_RECOMPUTE = sort({MEAS_RECOMPUTE{:}, str}); state = 'on';
			else
				MEAS_RECOMPUTE(ixa) = []; state = 'off';
			end

			data.browser.measurement.recompute = MEAS_RECOMPUTE;

			set(par, 'userdata', data);
			
			%--
			% update display state menu
			%--

			set(get_menu(data.browser.measure_menu.recompute, str), 'check', state);
			
	end
	
%---------------------
% COMPUTE
%---------------------

% NOTE: this initiates compute, in the future it opens palette

case strcat(MEAS_NAME, ' ...')
	
	%---------------------
	% OLD INTERFACE
	%---------------------
	
	%--
	% select measure from available measures
	%--
	
	MEAS = data.browser.measurement.measurement;
	
	ixa = find(strcmp(MEAS_NAME, str(1:end - 4)));
	
	ext = MEAS(ixa);
	
	%--
	% compute measurement for all events in active log
	%--
	
	m = data.browser.log_active; 
	
	ix = 1:data.browser.log(m).length;
	
	process_browser_events(par, ext, m, ix);
	
	%---------------------
	% NEW INTERFACE
	%---------------------
	
	%--
	% update display
	%--
	
	browser_display(par, 'events')

end
