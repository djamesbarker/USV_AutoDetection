function code = tophat_type_code(type)

% tophat_type_code - convert tophat type string to code
% -----------------------------------------------------
%
% code = tophat_type_code(type)
%
% Input:
% ------
%  type - type string
% 
% Output:
% -------
%  code - code corresponding to type

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

switch (type) 
	
	case ('Self-Complement')
		code = -1;
		
	case ('Black')
		code = 0;

	case ('White')
		code = 1;
    
	otherwise
		error(['Unrecognized Top-Hat type ''', type, '''.']);

end
