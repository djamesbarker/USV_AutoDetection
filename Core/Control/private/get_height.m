function height = get_height(control)

% get_height - compute control height in tile units
% -------------------------------------------------
%
% height = get_height(control)
%
% Input:
% ------
%  control - control
%
% Output:
% -------
%  height - height in tile units

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
% $Revision: 3397 $
% $Date: 2006-02-03 19:55:30 -0500 (Fri, 03 Feb 2006) $
%--------------------------------

switch (control.layout)
	
	case ('compact')
		height = control.lines + control.space;
		
	otherwise
		height = control.label + control.lines + control.space;

end
