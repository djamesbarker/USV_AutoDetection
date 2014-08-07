function target = get_action_target(type, callback)

% get_action_target - get targets for action from type and callback
% -----------------------------------------------------------------
%
% target = get_action_target(type, callback)
%
% Input:
% ------
%  type - type of action
%  callback - packed callback context
%
% Output:
% -------
%  target - action target array

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

%--
% get palette from callback context
%--

pal = callback.pal;

%--
% get targets from context
%--

switch type

	case 'sound'

		% NOTE: in this case we get sounds
		
		if strcmpi(pal.name, 'xbat')
			target = get_selected_sound(pal.handle);
		end
		
	case 'log'

		% NOTE: in this case we get log names not logs
		
		if strcmpi(pal.name, 'xbat')
			target = get_control(pal.handle, 'Logs', 'value');
		end
	
	case 'event'
	
		% NOTE: in this case we get event palette strings
		
		if strcmpi(pal.name, 'event')
			target = get_control(pal.handle, 'event_display', 'value');
		end
	
	otherwise

		error(['Unrecognized action type ''', type, '''.']);

end
