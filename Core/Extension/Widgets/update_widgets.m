function [widgets, elapsed] = update_widgets(par, event, data)

% update_widgets - update parent widgets on event
% -----------------------------------------------
%
% widgets = update_widgets(par, event, data)
%
% Input:
% ------
%  par - widget parent
%  event - parent event
%  data - parent state
%
% Output:
% -------
%  widgets - widgets updated

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

% TODO: update the output of this function to be more informative

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% get parent event widgets
%--

widgets = get_widgets(par, event);
		
if isempty(widgets)
	return;
end

%--
% get parent data if needed
%--

if (nargin < 3) || isempty(data)
	data = get_browser(par);
end

%-----------------------
% UPDATE WIDGETS
%-----------------------

%--
% get widget data from parent data
%--

data = get_widget_data(par, event, data);

%--
% update widgets
%--

% TODO: time, time budget, and trace

% NOTE: data depends on parent and event, it is the same for all widgets

% disp(' '); disp(upper(event));

elapsed = zeros(size(widgets));

for k = length(widgets):-1:1
	
	%--
	% update widget and time
	%--
	
	start = clock;
	
	updated = widget_update(par, widgets(k), event, data);
	
	elapsed(k) = etime(clock, start);
	
% 	if updated
% 		disp(['  ', get(widgets(k), 'name'), '  (', sec_to_clock(elapsed), ')']);
% 	else
% 		disp(['  ', get(widgets(k), 'name'), '  (', sec_to_clock(elapsed), ', FAILED)']);
% 	end
	
	% NOTE: removed widget from from the updated list if update failed
	
	if ~updated
		widgets(k) = []; elapsed(k) = [];
	end
	
end
