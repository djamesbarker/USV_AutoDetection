function [ixs] = cell_find(a, b, not)

% [ixs] = cell_find(a, b, not)
%
% return the indexes of *a* whose entries are contained in *b*
%
% *a* and *b* are cell arrays.  if NOT is specified, then the search is
% negative.

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


if nargin < 3
	
	not = [];
	
end

ixs = zeros(1, length(a));

for ii = 1:length(a)
	
	for jj = 1:length(b)
		
		
		eq = strcmp(num2str(a{ii}), num2str(b{jj}));
		
		flag = ~any(not) && eq || any(not) && ~eq;
		
		if eq
			
			ixs(ii) = 1;
			
		end
		
	end
	
end

if any(not)
	
	ixs = ~ixs;
	
end

ixs = find(ixs);
	
	
