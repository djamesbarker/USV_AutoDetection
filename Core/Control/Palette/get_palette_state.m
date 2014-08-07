function state = get_palette_state(pal, data)

% get_palette_state - get position, toggle, and tab state
% -------------------------------------------------------
%
% state = get_palette_state(pal, data)
%
% Input:
% ------
%  pal - palette figure handle
%  data - palette userdata
%
% Output:
% -------
%  state - palette state

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

%----------------------------------------------------
% HANDLE INPUT
%----------------------------------------------------

%--
% get palette userdata if needed
%--

if (nargin < 2) || isempty(data)
	data = get(pal, 'userdata');
end

%----------------------------------------------------
% GET NAME, TAG, AND POSITION
%----------------------------------------------------

% NOTE: use absolute position, relative position causes problems

state.name = get(pal, 'name');

state.tag = get(pal, 'tag');

state.position = get(pal, 'position');

%----------------------------------------------------
% GET TOGGLE STATES
%----------------------------------------------------

% NOTE: this code depends on the way toggles are created in 'control_group'

if isfield(data, 'toggle') && length(data.toggle)
	
	%--
	% loop over toggles
	%--
	
	for k = 1:length(data.toggle)
		
		tmp = data.toggle(k).toggle;
		
		%--
		% get toggle name
		%--
		
		state.toggle(k).name = get(get(tmp, 'parent'), 'tag');
		
		%--
		% get toggle state
		%--
		
		if strcmp(get(tmp, 'string'), '+')
			state.toggle(k).state = 'close';
		else
			state.toggle(k).state = 'open';
		end
		
	end
	
else
	
	%--
	% there are no toggles
	%--
	
	state.toggle = [];
	
end

%----------------------------------------------------
% GET TAB STATES
%----------------------------------------------------

% NOTE: this code depends on the way toggles are created in 'control_group'

if isfield(data, 'tabs') && length(data.tabs)
	
	%--
	% loop over tabs
	%--
	
	for k = 1:length(data.tabs)
		
		%--
		% get text children of tabs axes
		%--
				
		% NOTE: problems arise when we have elements with no name
		
		label = findobj(get(findobj(pal, 'tag', data.tabs(k).name), 'children'), 'type', 'text');
				
		%--
		% select darkest color label to be the active tab 
		%--
		
		% NOTE: get colors, convert to matrix, sum along columns, and get the minimum value index
		
		[ignore, ix] = min(sum(cell2mat(get(label, 'color')), 2));
				
		%--
		% store active tab name
		%--
		
		state.tabs(k).tab = get(label(ix), 'string');
		
	end
	
else
	
	%--
	% there are no tabs
	%--
	
	state.tabs = [];
	
end
