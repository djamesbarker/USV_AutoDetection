function init = str_to_init(str)

% string_to_initials - convert string typically name to initials
% --------------------------------------------------------------
%
% init = str_to_init(str)
%
% Input:
% ------
%  str - input string
%
% Output:
% -------
%  init - initials string

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% remove leading and trailing blanks
%--

str = fliplr(deblank(fliplr(deblank(str))));

%--
% collapse multiple spaces to one
%--

len0 = length(str);
len1 = 0;

while (len0 ~= len1)
	len0 = length(str);
	str = strrep(str,'  ',' ');
	len1 = length(str);
end

%--
% find spaces and get initials
%--

ix = [0, findstr(str,' ')];

init = str(ix + 1);
