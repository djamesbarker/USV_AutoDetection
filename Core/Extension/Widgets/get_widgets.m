function [widgets, info] = get_widgets(par, event)

% get_widgets - get child widgets listening to all or a specific event
% --------------------------------------------------------------------
%
% [widgets, info] = get_widgets(par, event)
%
% Input:
% ------
%  par - parent browser
%  event - widget event name (def: '', all events)
%
% Output:
% -------
%  widgets - widget handles
%  info - widget info

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

%-----------------
% HANDLE INPUT
%-----------------

%--
% check event input
%--

% NOTE: consider all events as default

if nargin < 2
	event = ''; 
else
	if isempty(event)
		error('Provided widget event must be non-empty.');
	end
end

if ~isempty(event) && ~ismember(event, get_widget_events)
	error('Unrecognized widget event.');
end

%--
% check browser input and get info
%--

[proper, par_info] = is_browser(par);

if ~proper
	widgets = []; info = []; return; % error('Input handle is not browser handle.');
end

%-----------------
% GET WIDGETS
%-----------------

%--
% check widget cache
%--

% NOTE: it is not clear this is correct

% persistent LAST_PARENT WIDGET_HANDLES WIDGET_INFO;
% 
% if isempty(LAST_PARENT)
% 	
% 	LAST_PARENT = par;
% 	
% elseif par == LAST_PARENT
% 	
% 	ix = ishandle(WIDGET_HANDLES);
% 
% 	WIDGET_HANDLES = WIDGET_HANDLES(ix); WIDGET_INFO = WIDGET_INFO(ix);
% 
% 	widgets = WIDGET_HANDLES; info = WIDGET_INFO;
% 
% end
% 
% if ~isempty(widgets)
% 	return;
% end

%--
% get all widget figures
%--

% NOTE: widgets are not registered with the parent for now 

widgets = get_xbat_figs('type', 'widget');

if isempty(widgets)
	info = []; return;
end

%--
% parse widget tags to get widget info
%--

tags = get(widgets, 'tag');

if ischar(tags)
	tags = {tags};
end

for k = 1:length(tags)
	info(k) = parse_widget_tag(tags{k});
end

%--
% match widget and parent info
%--

widget_info = rmfield(info, {'header', 'type', 'name', 'listen'});

par_info = rmfield(par_info, 'type');

for k = length(info):-1:1
	
	if ~isequal(par_info, widget_info(k))
		info(k) = []; widgets(k) = [];
	end
	
end 

%--
% check if we listen
%--

if ~isempty(event)
	
	for k = length(info):-1:1

		listen = get_field(info(k).listen, event);
		
		if ~listen
			info(k) = []; widgets(k) = [];
		end

	end

end

%--
% set persistent stores
%--

% WIDGET_HANDLES = widgets; WIDGET_INFO = info;
