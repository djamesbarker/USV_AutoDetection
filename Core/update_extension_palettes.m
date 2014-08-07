function pals = update_extension_palettes(par, data)

% update_extension_palettes - update extension palettes when logs change
% ----------------------------------------------------------------------
%
% pals = update_extension_palettes(par, data)
%
% Input:
% ------
%  par - parent handle
%  data - parent state
%
% Output:
% -------
%  pals - updated palette handles

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

%----------------------
% HANDLE INPUT
%----------------------

%--
% check browser handle input
%--

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

%--
% get browser state
%--

if (nargin < 2) || isempty(data)
	data = get_browser(par);
end

%----------------------
% TEST CODE
%----------------------

%--
% get listener control values
%--

none = isempty(data.browser.log);

if none
	list = {'(No Open Logs)'}; ix = 1;
else
	list = file_ext(struct_field(data.browser.log, 'file')); ix = data.browser.log_active;
end
		
%--
% get listener names and palette handles
%--

% NOTE: not all of these listeners are currently in use

listener = {'output_log', 'noise_log', 'source_log', 'template_log'}; 

% NOTE: this is critical, 'get_palette' only gets registered palettes, is should use this function!

pal = get_xbat_figs('type', 'palette', 'parent', par);

%--
% look for listener controls in available palettes
%--

pals = [];

for k = 1:length(pal)
	
	for j = 1:length(listener)
		
		%--
		% look for listener in palette
		%--
		
		control = get_control(pal(k), listener{j});
		
		if isempty(control)
			continue;
		end
		
		%--
		% update listening control values and state
		%--
		
		old_value = get_control(pal(k), listener{j}, 'value');
		
		set(control.handles.obj, 'string', list, 'value', ix);
		
		%--
		% try to keep old value for noise log
		%--
		
		if strcmp(listener{j}, 'noise_log');
			set_control(pal(k), listener{j}, 'value', old_value);
		end
			
		set_control(pal(k), listener{j}, 'enable', ~none);
		
		% NOTE: these are ancillary listeners that are not well formalized
		
		set_control(pal(k), 'scan', 'enable', ~none);
		
		set_control(pal(k), 'use_log', 'enable', ~none);
		
		%--
		% add palette to list of updated palettes
		%--
		
		pals(end + 1) = pal(k); 
		
	end
	
end

