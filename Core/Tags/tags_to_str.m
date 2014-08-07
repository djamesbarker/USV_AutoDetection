function str = tags_to_str(tags)

% tags_to_str - convert tags to string
% ------------------------------------
%
% str = tags_to_str(tags)
%
% Input:
% ------
%  tags - tags
%
% Output:
% -------
%  str - tag string

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
% check input for tags
%--

if ~is_tags(tags)
	error('Input is not proper tags.');
end

%--
% return empty string for empty tags
%--

if isempty(tags)
	str = ''; return;
end

%--
% create string from cell if needed
%--

if ischar(tags)
	str = tags; return;
end 

str = tags{1};

for k = 2:length(tags)
	str = [str, ' ', tags{k}];
end
