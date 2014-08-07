function pal = update_log_palette(par, data)

% update_log_palette - update log palette when opening or closing logs
% --------------------------------------------------------------------
%
% g = update_log_palette(par, data)
%
% Input:
% ------
%  par - palette parent handle
%  data - parent userdata
%
% Output:
% -------
%  g - handle of updated palette figure

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
% $Revision: 6335 $
% $Date: 2006-08-28 18:03:45 -0400 (Mon, 28 Aug 2006) $
%--------------------------------

% TODO: replace use of 'control_update' with 'set' and 'get' control

%------------------------------------------------------
% HANDLE INPUT
%------------------------------------------------------

%--
% set figure if needed
%--

if (nargin < 1)
	par = gcf;
end

%--
% get userdata if needed
%--

if (nargin < 2) || isempty(data)
	data = get_browser(par);
end

%--
% check for palette to update
%--

pal = get_palette(par, 'Log', data);

if isempty(pal)
	return;
end

%------------------------------------------------------
% UPDATE LOG PALETTE
%------------------------------------------------------

%--
% get open log information
%--

if isempty(data.browser.log)
	
	L = {'(No Open Logs)'};
	
	ms = 1; % popupmenu value, cannot be empty
	
	v = []; % listbox value should be empty
	
else
	
	L = file_ext(struct_field(data.browser.log,'file'));
	
	m = data.browser.log_active;
	
	v = find(struct_field(data.browser.log,'visible'));
	
	%--
	% sort the results
	%--
	
	tmp = length(data.browser.log);
	
	if (tmp > 1)
		
		[L,ix] = sort(L);
		
		% map active log using permutation
		
		ms = find(ix == m);
		
		% map values using permutation
		
		tmp = zeros(1,tmp);
		tmp(v) = 1;
		v = find(tmp(ix));
		
	else
		
		ms = m;
		
	end

end

%--
% update active control
%--

g = control_update(par,'Log','Active',[],data);

g = findobj(g,'flat','style','popupmenu');

set(g, ...
	'string', L, 'value', ms ...
);

%--
% update display control
%--

g = control_update(par,'Log','Display',[],data);

g = findobj(g,'flat','style','listbox');

set(g, ...
	'string', L, 'value', v ...
);

%--
% update log control
%--

g = control_update(par,'Log','Log',[],data);

g = findobj(g,'flat','style','popupmenu');

set(g, ...
	'string', L, 'value', ms ...
);

%--
% update log option controls
%--

if ~isempty(data.browser.log)
	
	tmp = data.browser.log(ms); % this is the case when the logs are sorted
	
	control_update(par,'Log','Color',rgb_to_color(tmp.color),data);
	
	control_update(par,'Log','Line Style',lt_to_linestyle(tmp.linestyle),data);
	
	control_update(par,'Log','Line Width',tmp.linewidth,data);

	control_update(par,'Log','Opacity',tmp.patch,data);
	
else
	
	control_update(par,'Log','Color','Red',data);
	
	control_update(par,'Log','Line Style','Solid',data);
	
	control_update(par,'Log','Line Width',1,data);

	control_update(par,'Log','Opacity',0,data);
	
end

%--
% enable and disable controls
%--

if isempty(data.browser.log)
	state = '__DISABLE__';
else
	state = '__ENABLE__';
end

control = getfield(get(pal, 'userdata'), 'control');

for k = 1:length(control)
	
	if ~strcmp(control(k).style, 'separator') && ~strcmp(control(k).style, 'tabs')
		
		if ~iscell(control(k).name)
			control_update(par, 'Log', control(k).name, state, data);
		else
			for j = 1:prod(size(control(k).name))
				control_update(par, 'Log', control(k).name{j}, state, data);
			end
		end
	end
	
end

set_control(pal, 'New Log', 'enable', 1);

set_control(pal, 'Open Log', 'enable', 1);

% control_update(par, 'Log', 'New Log', '__ENABLE__', data);
% 
% control_update(par, 'Log', 'Open Log ...', '__ENABLE__', data);

if strcmp(state, '__ENABLE__')
	set(findobj(pal, 'tag', 'Display', 'style', 'pushbutton'), 'enable', 'off');
end
