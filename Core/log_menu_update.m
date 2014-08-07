function log = log_menu_update(mode, data, m, ix)

% log_menu_update - update log information menu
% ---------------------------------------------
%
% flag = log_menu_update('meta', data, m, ix)
%
%      = log_menu_update('edit', data, m, ix)
%
%      = log_menu_update('event', data, m, ix)
%
% Input:
% ------
%  data - figure userdata
%  m - log index
%  ix - event index
%
% Output:
% -------
%  flag - update success flag

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

switch (mode)
	
	%--
	% modification date update
	%--
	
	case ('update')
		
		%--
		% get log info menu
		%--
		
		tmp = get_menu(data.browser.log_menu.log,file_ext(data.browser.log(m).file));
		tmp = get_menu(tmp,'Log');
		tmp = get_menu(tmp,'Log Info:');
		
		%--
		% recreate log info menu
		%--
		
		delete(get(tmp,'children'));
	
		L = { ...
			['Author:  ' data.browser.log(m).author], ...
			['Created:  ' datestr(data.browser.log(m).created)], ...
			['Modified:  ' datestr(data.browser.log(m).modified)] ...
		};
	
		menu_group(tmp,'',L);

	%--
	% full update
	%--
	
	case ('full')
		
		%--
		% get log menu
		%--
		
		tmp = get_menu(data.browser.log_menu.log,file_ext(data.browser.log(m).file));
		tmp = get_menu(tmp,'Log');
		
		g = get_menu(tmp,'Log Info:');
		tmp = get(g,'children');
		
		%--
		% recreate log menu
		%--
		

	
	%--
	% event addition and deletion update
	%--
	
	case ('event')
		
end
