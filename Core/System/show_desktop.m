function value = show_desktop(value)

% show_desktop - set visibility of windows desktop
% ------------------------------------------------
% 
% state = show_desktop
%
% show_desktop(1) - show the desktop
%
% show_desktop(0) - hide the desktop

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

% NOTE: we share desktop display state through environment variable

%------------------------------------------------------------
% HANDLE INPUT
%------------------------------------------------------------

%--
% return value if no input
%--

if nargin < 1
	
	value = get_env('show_desktop'); 
	
	% NOTE: handle empty value here in case 'startup' fails to set it
	
	if ~isempty(value)
		return;
	else
		value = 1;
	end
	
end 

%------------------------------------------------------------
% BUILD AND EXECUTE COMMAND
%------------------------------------------------------------

%--
% get tool file
%--

tool = nircmd;

if isempty(tool)
    return;
end

% NOTE: this allows the command syntax

if ischar(value)
	value = eval(value);
end

if value
	
	[status, result] = system(['"', tool.file, '" win show class progman']);
	
	set_env('show_desktop', 1);
	
else
	
	[status, result] = system(['"', tool.file, '" win hide class progman']);
	
	set_env('show_desktop', 0);
	
end
