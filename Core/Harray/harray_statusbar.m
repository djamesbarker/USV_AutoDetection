function state = harray_statusbar(par, state)

% harray_statusbar - show and hide harray statusbar
% -------------------------------------------------
%
% state = harray_statusbar(par, state)
%
% Input:
% ------
%  par - parent figure
%  state - 'on' or 'off' (def: toggle state)
%
% Output:
% -------
%  state - current statusbar state

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

% TODO: make statusbar update available from this function

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
% UPDATE STATUSBAR STATE
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
	
	case 'on', data.base.status.on = 1;
		
	case 'off', data.base.status.on = 0;
		
	% NOTE: we are lenient on toggle action description
	
	otherwise
		
		data.base.status.on = double(~data.base.status.on);
		
		if data.base.status.on
			state = 'on';
		else
			state = 'off';
		end

end

% NOTE: we update harray data

harray_data(par, data);
