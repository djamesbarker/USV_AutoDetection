function flag = set_palette_state(pal, state, slow)

% set_palette_state - set position, toggle, and tab state
% -------------------------------------------------------
%
% flag = set_palette_state(pal, state)
%
% Input:
% ------
%  pal - palette to apply state to
%  state - state of palette (previously obtained using get_palette_state)
%
% Output:
% -------
%  flag - success flag

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

%-------------------------
% HANDLE INPUT
%-------------------------

if (nargin < 3) || isempty(slow)
	slow = 0;
end

%-------------------------
% SET TOGGLE STATES
%-------------------------

if ~isempty(state.toggle)
		
	%--
	% get current palette toggles
	%--
	
	% NOTE: use of the toggle handles appears in 'min_max_palette'
	
	toggle = findobj(pal, 'tag', 'header_toggle');
	
	par = get(toggle, 'parent');
	
	if iscell(par)
		par = cell2mat(par);
	end
	
	name = get(par, 'tag');
	
	if slow
		stop(timerfind);
	end

	for k = 1:length(state.toggle)

		ix = find(strcmp(state.toggle(k).name, name));

		if ~isempty(ix)

			palette_toggle(pal, toggle(ix), state.toggle(k).state);

			if slow
				drawnow; pause(0.025);
			end

		end

	end

	if slow
		start(timerfind);
	end
	
end

%----------------------------------------------------
% SET TAB STATES
%----------------------------------------------------

% NOTE: tab selection only works when palette tabs have unique names

if ~isempty(state.tabs)
	
	for k = 1:length(state.tabs)
		tab_select([], pal, state.tabs(k).tab);
	end
	
end

%----------------------------------------------------
% SET POSITION
%----------------------------------------------------

pos = get(pal, 'position');
	
pos(1:2) = state.position(1:2);

set(pal, 'position', pos);

% NOTE: this helps reduce display problems on multiple monitors

drawnow;


