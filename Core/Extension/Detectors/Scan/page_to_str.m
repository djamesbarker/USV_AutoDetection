function str = page_to_str(page, fun)

% page_to_str - scan page string
% ------------------------------
%
% str = page_to_str(page, fun)
%
% Input:
% ------
%  page - scan page
%  fun - time string function (def: @sec_to_clock)
%
% Output:
% -------
%  str - page string

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
% set time conversion function
%--

if nargin < 2
	fun = @sec_to_clock;
end

%--
% create string
%--

% TODO: integrate full and interval display

str = ['[', fun(page.start), ', ', fun(page.start + page.duration)];

if page.full
	str = [str, ')'];
else
	str = [str, ']'];
end

switch page.interval
	
	case 0
		
	case 1, str = ['{', str];
		
	case 2, str = [str, '}'];
		
	case 3, str = ['{', str, '}'];
		
end
