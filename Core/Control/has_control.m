function [value, ix] = has_control(pal, name)

% has_control - check for named control in palette or control array
% -----------------------------------------------------------------
%
% [value, ix] = has_control(in, name)
%
% Input:
% ------
%  in - control palette or cotnrol array
%  name - control name
%
% Output:
% -------
%  value - result of test
%  ix - index of control in array

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
% control palette input
%--

if ishandle(pal)
	
	ix = []; value = ~isempty(get_control(pal, name, 'handles'));

	if value 
		data = get(pal, 'userdata'); control = data.control; ix = find(strcmp(name, {control.name}));
	end

%--
% control array input
%--

else
	
	control = pal; ix = find(strcmp(name, {control.name}));  value = ~isempty(ix);

end
