function log_measure_menu(h,str,flag)

% log_measure_menu - log browser measurement function menu
% --------------------------------------------------------
%
% flag = log_measure_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag (def: '')
%
% Output:
% -------
%  flag - command execution flag

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
% $Date: 2005-04-20 02:22:39 -0400 (Wed, 20 Apr 2005) $
% $Revision: 950 $
%--------------------------------

%--
% enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Measure'))
		set(get_menu(h,str),'enable',flag);
	end			
	return;			
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% perform command sequence
%--

if (iscell(str))
	for k = 1:length(str)
		try
			log_measure_menu(h,str{k}); 
		catch
			disp(' '); 
			warning(['Unable to execute command ''' str{k} '''.']);
		end
	end
	return;
end

%--
% set handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% get userdata
%--

data = get(gcf,'userdata');

%--
% get measurement information
%--

MEAS_NAME = data.browser.measurement.name;
MEAS_VIEW = data.browser.measurement.view;

%--
% main switch
%--

switch (str)

%--
% Initialize
%--

case ('Initialize')
	
	%--
	% check for existing menu
	%--
		
	tmp = get(findobj(gcf,'type','uimenu','parent',gcf),'label');
	
	tmp = find(strcmp(tmp,'Measure'));
	
	if (~isempty(tmp))
		return;
	end
	
	%--
	% Measure
	%--
	
	L = strcat(MEAS_NAME,' ...');
	
	L = { ...
		'Measure', ...
		'Display', ...
		L{:} ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	
	mg = menu_group(h,'log_measure_menu',L,S);
	data.browser.measure_menu.measure = mg;
	
% 	set(mg(1),'position',9);
	
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
	
	tmp = menu_group(get_menu(mg,'Display'),'log_measure_menu',L,S);
	data.browser.measure_menu.display = tmp;
	
	for k = 1:length(MEAS_VIEW)
		set(get_menu(tmp,MEAS_VIEW{k}),'check','on');
	end
	
	%--
	% save userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Active and Display
%--

%--
% No Display
%--

case ('No Display')
	
	%--
	% update measurement display list
	%--
	
	data.browser.measurement.view = cell(0);
	set(h,'userdata',data);
	
	%--
	% update display state menu
	%--
	
	tmp = data.browser.measure_menu.display;
	set(tmp,'check','off');	
	
	%--
	% update display
	%--
	
	log_browser_display('events');
	log_resizefcn;
	
%--
% Display All
%--

case ('Display All')
	
	%--
	% update measurement display list
	%--
	
	data.browser.measurement.view = MEAS_NAME;
	set(h,'userdata',data);
	
	%--
	% update display state menu
	%--
	
	tmp = data.browser.measure_menu.display;
	set(tmp(2:(end - 1)),'check','on');	
	
	%--
	% update display
	%--
	
	log_browser_display('events');
	log_resizefcn;
	
% %--
% % No Measurement
% %--
% 
% case ('No Measurement')
% 	
% 	%--
% 	% update active measurement
% 	%--
% 	
% 	data.browser.measurement.active = '';
% 	set(h,'userdata',data);
% 	
% 	%--
% 	% update active measurement menus
% 	%--
% 	
% 	set(data.browser.measure_menu.active,'check','off');
	
%--
% Measurement
%--

case (MEAS_NAME)

	%--
	% update display state for measurement
	%--
	
	ixa = find(strcmp(MEAS_VIEW,str));
	
	if (isempty(ixa))
		MEAS_VIEW = sort({MEAS_VIEW{:}, str});
		state = 'on';
	else
		MEAS_VIEW(ixa) = [];
		state = 'off';
	end
	
	data.browser.measurement.view = MEAS_VIEW;
	set(h,'userdata',data);
	
	%--
	% update display state menu
	%--
	
	set(get_menu(data.browser.measure_menu.display,str),'check',state);
	
	%--
	% update display
	%--
	
	log_browser_display('events');
	log_resizefcn;
		
%--
% Measurement ... (Batch measurement for whole log, eventually for selected set)
%--

case (strcat(MEAS_NAME,' ...'))

	%--
	% call measurement in interactive batch mode
	%--
	
	MEAS = data.browser.measurement.measurement;
	ixa = find(strcmp(MEAS_NAME,str(1:end - 4)));
	
	%--
	% get log index and event indices
	%--
	
	log = data.browser.log;
	
	h = data.browser.parent;
	data = get(h,'userdata');
	
	LOGS = file_ext(struct_field(data.browser.log,'file'));
	
	m = find(strcmp(LOGS,log));
	ix = 1:data.browser.log(m).length;
	
	%--
	% measure whole log or selected set uniformly
	%--
	
	feval(MEAS(ixa).fun,'events',h,m,ix);
	
	%--
	% update display
	%--
	
	log_browser_display('events');
	log_resizefcn;

end
