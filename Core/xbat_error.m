function [id,str] = xbat_error(id,str)

% xbat_error - create error message and identifier
% ------------------------------------------------
%
% [id,str] = xbat_error(id,str)
%
% Input:
% ------
%  id - simple message identifier
%  str - error message
%
% Output:
% ------
%  id - message identifier
%  str - error message

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

% NOTE: add error logging controlled by an environment variable

% NOTE: this can be used to hide errors from the users while tracking

%--
% set generic identifier
%--

% NOTE: identifier creation needs some documentation

if (isempty(id))
	id = 'XBAT:GENERIC';
else
	id = ['XBAT:' upper(strrep(id,' ','_'))];
end

%--
% append and indent message
%--

sep = char(double('-') * ones(1,length(id)));

str = ['\n' id '\n' sep '\n' str];

str = strrep(str,'\n','\n\t');

str = ['\n', str_line(72), str, '\n', str_line(72)];

% NOTE: should this be done here or outside, should we also display?

str = sprintf(str);
