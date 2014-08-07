function state = palette_display(h, state)

% palette_display - set palette display state
% -------------------------------------------
%
% state = palette_display(h, state)
%
% Input:
% ------
%  h - handle to figure with palettes
%  state - 'on' or 'off'
%
% Output:
% -------
%  state - current palette display state

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
% $Revision: 1168 $
% $Date: 2005-07-08 16:56:50 -0400 (Fri, 08 Jul 2005) $
%--------------------------------

%---------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------

%--
% set empty state default
%--

if nargin < 2
	state = '';
end

%--
% set current figure as default parent
%--

if (nargin < 1) || isempty(h)
	h = gcf;
end

%---------------------------------------------------
% COMPUTE
%---------------------------------------------------

%--
% get parent palettes
%--

pal = get_xbat_figs('parent', h, 'type', 'palette');

% NOTE: return empty state when there are no palettes and state is undefined

if isempty(pal)
	state = ''; return;
end

%--
% get current state
%--

curr = get(pal(1), 'visible');

% NOTE: return if desired state is current state

if strcmpi(state, curr)
	return;
end

%--
% update state
%--

% NOTE: here the state toggles the current state

if isempty(state)
	
	if strcmpi(curr, 'on')
		state = 'off';
	else
		state = 'on';
	end
	
end

set(pal, 'visible', state);
