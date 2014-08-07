function str = prepare_label(str)

% PREPARE_LABEL prepare string for display 
%
% str = prepare_label(str)

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

% TODO: consider known acronyms and special characters that need escape

if strmatch('api', str)
	str(1:3) = upper(str(1:3));
end 

if strmatch('svn', str)
	str(1:3) = upper(str(1:3));
end 

str = title_caps(str);
