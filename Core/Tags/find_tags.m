function [ix, obj] = find_tags(obj, match, logic)

% find_tags - find objects based on tags
% --------------------------------------
%
% ix = find_tags(obj, match, logic)
%
% Input:
% ------
%  obj - tagged objects
%  match - tags to match
%  logic - logic to user for combining search
%
% Output:
% -------
%  ix - objects found indices

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
% set default logic ahd check logic
%--

if nargin < 3
	logic = 'and';
end

if ~ismember(logic, {'and', 'or'})
	error('Unrecognized logical operator.');
end

%--
% check tags to match input
%--

if ischar(match)
	match = {match};
end

if ~is_tags(match)
	error('Tags to match input must be tags.');
end

%--
% compute index array
%--

ix = true(size(obj)); tags = get_tags(obj); 

for k = length(tags):-1:1
	
	switch logic
		
		% NOTE: if any of the tags to match is missing remove object
		
		case 'and'
			if any(~ismember(match, tags{k}))
				ix(k) = 0; 
			end
		
		% NOTE: if none of the tags to match belongs to tags remove
		
		case 'or'
			if ~any(ismember(match, tags{k}))
				ix(k) = 0;
			end
			
	end
	
end

%--
% select objects if needed
%--

if nargout > 1
	obj = obj(ix);
end
