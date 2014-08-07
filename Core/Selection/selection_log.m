function selection_log(par, log, data)

% selection_log - log selection to chosen or active log
% -----------------------------------------------------

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


if nargin < 3 || isempty(data)
	data = get_browser(par);
end

logs = get_browser(par, 'log', data);

if isempty(log)
	m = data.browser.log_active;
elseif ischar(log)	
	m = find(strcmp(logs, log));
else
	m = log;
end
	
%--
% return for empty selection
%--

if isempty(data.browser.selection.handle)
	return;
end

%--
% get annotation information
%--

ANNOT = data.browser.annotation.annotation;

ANNOT_NAME = data.browser.annotation.name;

%--
% add existing selection
%--

if isempty(data.browser.annotation.active)
	
	[flag, ix] = log_update(par, m); % this function modifies the userdata
	
else

	% add option in annotation interface to set default log in
	% annotation dialog

	ixa = find(strcmp(ANNOT_NAME,data.browser.annotation.active));
	
	flag = feval(ANNOT(ixa).fun, 'selection', par);
	
end

%--
% update display
%--

if flag

	browser_display(par, 'events'); % the available data is not current

	pal = get_palette(par, 'Event');
	
	if isempty(pal)
		return;
	end

	handles = get_control(pal, 'find_events', 'handles');

	browser_controls(par, 'find_events', handles.obj);	
	
	if exist('ix', 'var')
		event_bdfun(par, m, ix);
	end

end
