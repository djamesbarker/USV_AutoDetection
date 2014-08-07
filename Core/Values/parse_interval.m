function [int,type] = parse_interval(str)

% parse_interval - parse interval string
% --------------------------------------
%
% [int,type] = parse_interval(str)
%
% Input:
% ------
%  str - interval strings
%
% Output:
% -------
%  int - interval endpoints
%  type - type of interval

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
% $Revision: 2086 $
% $Date: 2005-11-08 00:09:43 -0500 (Tue, 08 Nov 2005) $
%--------------------------------

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% handle multiple strings recursively
%--

if (iscellstr(str))
	
	for k = 1:length(str)
		[int(k,:),type(k)] = parse_interval(str{k});
	end
	
	return;
	
end

%---------------------------------------------
% PARSE STRING
%---------------------------------------------
	
% NOTE: this function can parse time intervals

%--
% split interval string
%--

[a,b] = strtok(str,',');

%--
% parse lower limit
%--

L = (a(1) == '['); 

a = a(2:end);

if (findstr(a,':'))
	a = clock_to_sec(a);
else
	a = str2num(a); 
end

if (isempty(a))
	int = [0,0]; type = -1; return;
end

%--
% parse upper limit
%--

U = (b(end) == ']'); 

b = b(2:end - 1);

if (findstr(b,':'))
	b = clock_to_sec(b);
else
	b = str2num(b); 
end

if (isempty(b))
	int = [0,0]; type = -1; return;
end

%--
% check interval order
%--

if (a > b)
	error('Improperly ordered interval.');
end

%--
% store endpoints and interval type
%--

int = [a, b]; 

type = (2 * L) + (1 * U);
	
