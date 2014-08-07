function label = get_label(obj) 

% get_label - get tagged objects label
% ------------------------------------
%
% label = get_label(obj)
%
% Input:
% ------
%  obj - taggable object array
%
% Output:
% -------
%  label - object label array

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
% handle input
%--

if ~is_taggable(obj)
	error('Input must be taggable.'); return;
end

if length(obj) > 1
	
	label = cell(size(obj));
	
	for k = 1:length(obj)
		label{k} = get_label(obj(k));
	end
	
	return;
	
end

%--
% get tags and check for labels
%--

% NOTE: allow a single tag to be the label

tags = get_tags(obj); label = '';

if ischar(tags)
	tags = {tags};
end 

switch numel(tags)

	case 0

	case 1, label = tags{1};

	otherwise

		for j = 1:length(tags)
			if (tags{j}(1) == '*')
				label = tags{j}(2:end); return;
			end
		end
end
