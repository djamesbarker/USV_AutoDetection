function state = harray_colorbar(par, state)

% harray_colorbar - show and hide harray colorbar
% -----------------------------------------------
%
% state = harray_colorbar(par, state)
%
% Input:
% ------
%  par - parent figure
%  state - 'on' or 'off' (def: toggle state)
%
% Output:
% -------
%  state - current colorbar state

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

% TODO: make colorbar update available from this function

%-------------------------------------
% HANDLE INPUT
%-------------------------------------

%--
% set default state action
%--

if (nargin < 2) || isempty(state)
	state = 'toggle';
end

%--
% set parent figure
%--

if (nargin < 1)
	par = gcf;
end

if isempty(par)
	state = []; return;
end

%-------------------------------------
% UPDATE COLORBAR STATE
%-------------------------------------

%--
% get harray data
%--

data = harray_data(par);

if isempty(data)
	state = []; return;
end

%--
% update state
%--

switch state
	
	case 'on'
		data.base.color.on = 1;
		
	case 'off'
		data.base.color.on = 0;
		
	% NOTE: we are lenient on toggle action description
	
	otherwise
		data.base.color.on = double(~data.base.color.on);

end

% NOTE: we update harray data

harray_data(par, data);

%-------------------------------------
% UPDATE COLORBAR DISPLAY
%-------------------------------------

%--
% update visibility
%--

% NOTE: here we also convert the current state to a state string

if data.base.color.on
	state = 'on';
else
	state = 'off';
end

%--
% update colorbar display
%--

update_colorbar_display(par, state);


%-------------------------------------
% UPDATE_COLORBAR_DISPLAY
%-------------------------------------

function flag = update_colorbar_display(par, state)

% update_colorbar_display - update colorbar display
% -------------------------------------------------
%
% flag = update_colorbar_display(par, state)
%
% Input:
% ------
%  par - parent figure
%  state - display state
%
% Output:
% -------
%  flag - success flag

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

flag = 1;

%--
% get colorbar axes
%--

cax = findobj(par, 'tag', 'HARRAY_COLORBAR');
	
set([cax, findall(cax)'], 'visible', state);

if strcmp(state, 'off')
	return;
end

%--
% get or create colorbar image
%--

cim = findobj(cax, 'tag', 'HARRAY_COLORBAR_IMAGE');

% BUG: there is a MATLAB bug here, where the axes tag gets overwritten

% BUG: another MATLAB bug concerns the grid display when creating empty images

if isempty(cim)
	
	axes(cax);
	
	cim = image( ...
		(1:size(get(par, 'colormap'), 1))', ...
		'tag', 'HARRAY_COLORBAR_IMAGE' ...
	);

	set(cax, 'tag', 'HARRAY_COLORBAR');
	
end 

%--
% set colorbar axes and image properties
%--

% TODO: we need a way of getting the correct Y limits

set(cax, ...
	'xlim', [0, 1], 'xtick', [], ...
	'ylim', [0, 1], 'ydir', 'normal', ...
	'yaxislocation','right' ...
);

set(cim, ...
	'cdata', (1:size(get(par, 'colormap'), 1))', ...
	'xdata', [0, 1], 'ydata', [0, 1] ...
);


