function value = is_top(in)

% TODO: this function was extracted from 'get_play_axes' it is not yet general

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

value = 1;

%--
% get other visible objects 
%--

% TODO: add visible flag as input

others = get_others(in, 1);

if isempty(others)
	value = 1; return;
end

%--
% compare positions
%--

pos = get(in, 'position'); pos = pos(2) + pos(4);

for k = 1:length(others)
	
	pos2 = get(others(k), 'position');
	
	if pos < (pos2(2) + pos2(4))
		value = 0; return;
	end
	
end
