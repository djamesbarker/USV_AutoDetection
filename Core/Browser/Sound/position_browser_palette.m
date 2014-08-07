function position_browser_palette(par, pal, data, rel)

% position_browser_palette - position palette with respect to browser
% -------------------------------------------------------------------
%
% position_browser_palette(par, pal, data, rel)
%
% Input:
% ------
%  par - browser handle
%  pal - palette handle
%  data - browser state
%  rel - relative position (def: 'center')

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

% TODO: make default relative position an option

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% set relative position option
%--

if nargin < 4
	rel = 'center';
end

%--
% check handle input
%--

if ~is_browser(par)
	error('Input browser handle is not browser.');
end

if ~is_palette(pal)
	error('Input palette handle is not palette.');
end

%--
% get browser state if needed
%--

if nargin < 3
	data = get_browser(par);
end

%---------------------------
% SETUP
%---------------------------

%--
% get palette name
%--

name = get(pal, 'name');

%---------------------------
% POSITION PALETTE
%---------------------------

%--
% make palette invisible
%--

% set(pal, 'visible', 'off');

%--
% update state of palette if available
%--

% NOTE: perhaps we should check the field exists

if ~isempty(data.browser.palette_states)

	names = struct_field(data.browser.palette_states, 'name');

	ix = find(strcmp(names, name));

	if ~isempty(ix)
		set_palette_state(pal, data.browser.palette_states(ix), 1);
	else
		position_palette(pal, par, rel);
	end

else

	position_palette(pal, par, rel);

end

%--
% make sure palette is visible
%--

set(pal, 'visible', 'on');
