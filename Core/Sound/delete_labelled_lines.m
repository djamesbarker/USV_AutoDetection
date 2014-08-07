function delete_labelled_lines(ax,tag)

% delete_labelled_lines - what it says
% ------------------------------------
%
% delete_labelled_lines(ax,tag)
%
% Input:
% ------
%  ax - parent axes
%  tag - labelled lines tag

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

%--------------------
% HANDLE INPUT
%--------------------

%--
% normalize tag
%--

tag = upper(strtrim(tag));

%--
% handle multiple axes recursively
%--

if (numel(ax) > 1)
	
	for k = 1:numel(ax)
		delete_labelled_lines(ax(k),tag);
	end

	return;
	
end

%--------------------
% DELETE LINES
%--------------------

% TODO: consider making safer by using type of object in 'findobj'

tags = {[tag, '_LINE'], [tag, '_LABEL']};

for k = 1:length(tags)
	delete(findobj(ax,'tag',tags{k}))
end
