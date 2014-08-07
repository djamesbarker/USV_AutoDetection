function value = xbat_developer(value)

% xbat_developer - xbat developer state
% -------------------------------------
%
% value = xbat_developer(value)
%
% Input:
% ------
%  value - value to set
%
% Output:
% -------
%  value - value of environment variable

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
% $Revision: 1631 $
% $Date: 2005-08-23 12:41:39 -0400 (Tue, 23 Aug 2005) $
%--------------------------------

%--
% set name and default
%--

name = mfilename; % NOTE: filename is used as variable name

if (~nargin)
	default = 0;
end

%--
% get or set value
%--

switch (nargin)
	
	case (0)
		
		%--
		% get value if not set set default
		%--
		
		value = get_env(name);
		
		if (isempty(value))
			value = default; set_env(name,value);
		end

	case (1)
		
		% NOTE: this is to allow the command form of the function call
		
		if (ischar(value))
			value = eval(value);
		end
		
		set_env(name,value);

end
