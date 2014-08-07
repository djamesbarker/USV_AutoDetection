function str = string_title(str,p)

% string_capitalize - create title string
% ---------------------------------------
%
% str = string_title(str,p)
%
% Input:
% ------
%  str - input string
%  p - separator pattern (def: ' ')
%
% Output:
% -------
%  str - output title string

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
% set default pattern
%--

if (nargin < 2)
	p = ' ';
end

%--
% split string capitalize and join
%--

tok = string_split(str,p);
str = '';

if (iscell(tok))
	for k = 1:length(tok)
		tmp = tok{k};
		tmp(1) = upper(tmp(1));
		str = [str, ' ', tmp];
	end
else
	str = tok;
	str(1) = upper(str(1));
end
