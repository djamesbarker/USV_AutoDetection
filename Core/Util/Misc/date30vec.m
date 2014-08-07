function v = date30vec(str)

% date30vec - convert date string format 30 to date vector
% --------------------------------------------------------
%
% v = date30vec(str)
%
% Input:
% ------
%  str - input date 30 format strings
%
% Output:
% -------
%  V - date vectors

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

% this is meant as a low level function perhaps put in the private folder

%--
% handle cell arrays
%--

if (iscell(str))
	
	n = length(str);
	v = zeros(n,6);
	
	for k = 1:length(str)
		v(k,:) = date30vec(str{k});
	end
	
	return;
	
end

%--
% parse string into date vector
%--

v = zeros(1,6);

% date part

v(1) = eval(str(1:4));
v(2) = eval(str(5:6));
v(3) = eval(str(7:8));

% time part

v(4) = eval(str(10:11));
v(5) = eval(str(12:13));
v(6) = eval(str(14:15));
