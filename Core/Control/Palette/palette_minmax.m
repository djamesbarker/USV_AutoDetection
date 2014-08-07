function palette_minmax(state, pal)

% palette_minmax - minimize or maximize palette
% ---------------------------------------------
%
% palette_minmax(state, pal)
%
% Input:
% ------
%  state - 'min' or 'max'
%  pal - palette figure handle

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
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

% TODO: problems stopping and starting timers

%-----------------------------
% HANDLE INPUT
%-----------------------------

%--
% set handle
%--

if (nargin < 2) || isempty(pal)
	pal = gcf;
end 

%--
% check handle
%--

if ~ishandle(pal) || ~strcmpi(get(pal, 'type'), 'figure')
	error('Input is not figure handle.');
end

%--
% check for properly tagged figure
%--

% NOTE: a palette figure has 'PALETTE', 'WAITBAR' or 'DIALOG' in the tag

% NOTE: a fully collapsed dialog is strange, action buttons are hidden 

tag = get(pal, 'tag');

if ( ...
	isempty(findstr(tag, 'PALETTE')) && ...
	isempty(findstr(tag, 'WAITBAR')) && ...
	isempty(findstr(tag, 'DIALOG')) ...
)

	disp('WARNING: Handle does not point to a palette.'); return;

end

%--
% check state
%--

switch lower(state)
	
	case 'min', state = 'close';
		
	case 'max', state = 'open';
		
	otherwise, error(['Unrecognized palette state ''', state, '''.']);
		
end

%-----------------------------
% HANDLE INPUT
%-----------------------------

%--
% get all palette toggles
%--

toggle = findobj(pal, 'tag', 'header_toggle');

%--
% apply state to toggles
%--

% NOTE: timers off and forced display queue flush seems to work

stop(timerfind);

for k = 1:length(toggle)
	
	palette_toggle(pal, toggle(k), state); 
	
	% NOTE: put this as optional in palette toggle

	drawnow; pause(0.025);
	
end

start(timerfind); 
