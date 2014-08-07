function tags = str_to_tags(str)

% str_to_tags - convert string to tags
% ------------------------------------
%
% tags = str_to_tags(str)
%
% Input:
% ------
%  str - input string
%
% Output:
% -------
%  tags - tags in string

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
% check for string input
%--

if ~ischar(str)
	error('String input is required.');
end

%--
% parse string to cell array
%--

tags = strread(str, '%s', -1, 'delimiter', ' ');

% NOTE: return input string when parse to valid tags fails, does this ever happen?

if ~is_tags(tags)
	tags = str;
end

% NOTE: this is the way the tags will be stored, consider using 'update_tags'

if iscell(tags) 
	tags = unique(tags(:));
end
