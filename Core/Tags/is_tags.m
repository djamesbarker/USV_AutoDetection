function value = is_tags(tags)

% is_tags - check that input is a valid set of tags
% -------------------------------------------------
%
% value = is_tags(tags)
%
% Input:
% ------
%  tags - candidate tags
%
% Output:
% -------
%  tags - valid tags test result

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

% TODO: this code can be refactored for conciseness and efficiency

%--
% check for empty cell
%--

% NOTE: an empty cell is the empty tags set

if iscell(tags) && isempty(tags)
	value = 1; return;
end 

%--
% check for a string or cell array of strings
%--

if ~ischar(tags) && ~iscellstr(tags)
	value = 0; return;
end

%--
% check string content
%--

if ischar(tags)
	value = valid_tag(tags); return;
end

%--
% check string cell array contents
%--

for k = 1:length(tags)
	
	% NOTE: we return quickly if we find a not valid tag
	
	if ~valid_tag(tags{k})
		value = 0; return;
	end 
	
end 

% NOTE: passed all tests

value = 1;
