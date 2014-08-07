function flag = palette_enable(pal,value)

% palette_enable - enable or disable all controls in palette
% ----------------------------------------------------------
%
% flag = palette_enable(pal,value)
%
% Input:
% ------
%  pal - palette handle
%  value - enable value
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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

flag = [];

%--
% convert value
%--

switch (lower(value))
	
	case ('on')
		value = '__ENABLE__';
		
	case ('off')
		value = '__DISABLE__';
		
	otherwise
		return;
		
end

%--
% get control names
%--

% NOTE: only controls that provide values need to be considered 

controls = fieldnames(get_control_values(pal));

%--
% enable or disable controls
%--

% use foreach construction

for k = 1:length(controls)
	control_update([],pal,controls{k},value);
end

flag = 1;
