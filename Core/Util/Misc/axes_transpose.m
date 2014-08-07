function p = axes_transpose(h)

% axes_transpose - transpose axes
% -------------------------------
%
% p = axes_transpose(h)
%
% Input:
% ------
%  h - handle to axes
%
% Output:
% -------
%  p - properties changed in transposed axes

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
% $Revision: 1.0 $
% $Date: 2003-07-06 13:36:01-04 $
%--------------------------------

%--
% get axes properties
%--

q = get(h);

%--
% get names
%--

str = fieldnames(q);

%--
% get indexes to X and Y properties
%--

xix = strmatch('X',str);
xix = xix(6:end);

yix = strmatch('Y',str);
yix = yix(6:end);

%--
% exchange property values
%--

for k = 1:length(xix)

	eval(['p.' str{xix(k)} ' = q.' str{yix(k)} ';']);
	eval(['p.' str{yix(k)} ' = q.' str{xix(k)} ';']);

end
	
