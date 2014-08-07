function tok = string_split(str,p)

% string_split - split a string based on a pattern
% ------------------------------------------------
% 
% tok = string_split(str,p)
%
% Input:
% ------
%  str - input string
%  p - separator pattern
%
% Output:
% -------
%  tok - string tokens

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
% get pattern length and indexes
%--

m = length(p);
ix = findstr(str,p);

%--
% get tokens from string
%--

if (length(ix))
	tok{1} = str(1:(ix(1) - 1));
	for k = 2:length(ix)
		tok{k} = str((ix(k - 1) + m):ix(k) - 1);
	end
	tok{length(ix) + 1} = str((ix(end) + m):end);
else
	tok = str;
end



