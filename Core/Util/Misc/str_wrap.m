function lines = str_wrap(str, width)

% str_wrap - wrap string into paragraph
% -------------------------------------
%
% lines = str_wrap(str, width)
%
% Input:
% ------
%  str - input string
%  width - line length (def: 72)
%
% Output:
% -------
%  lines - wrapped string lines

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
% set line length
%--

if nargin < 2
	width = 72;
end

%--
% get blanks
%--

ix = findstr(str, ' ');

%--
% compute linebreaks
%--

spill = mod(ix, width);

b = [1,  ix(spill(1:end - 1) > spill(2:end)),  length(str)];

%--
% add linebreaks
%--

lines{1} = str(b(1):b(2));

for k = 2:length(b) - 1
	lines{end + 1} = str(b(k) + 1:b(k + 1));
end




