function [b,t] = parse_interval(s)

% parse_interval - parse string with interval information
% -------------------------------------------------------
%
% [b,t] = parse_interval(s)
%
% Input:
% ------
%  s - interval string
%
% Output:
% -------
%  b - interval endpoints
%  t - type of interval
%    0 - open (,)
%    1 - closed above (,]
%    2 - closed below [,)
%    3 - closed [,]
%

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
% parse string
%--

[a,b] = strtok(s,', ');

l = (a(1) == '[');
a = str2num(a(2:end));

b = b(2:end);
u = (b(end) == ']');
b = str2num(b(1:end - 1));

%--
% get endpoints and type
%--

b = [a, b];
t = 2*l + 1*u;
