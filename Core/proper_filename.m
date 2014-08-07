function flag = proper_filename(str)

% proper_filename - determine whether a string may be a filename
% --------------------------------------------------------------
%
% flag = proper_filename(str)
%
% Input:
% ------
%  str - proposed filename
%
% Output:
% -------
%  flag - proper flag

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
% $Revision: 6184 $
% $Date: 2006-08-16 19:53:20 -0400 (Wed, 16 Aug 2006) $
%--------------------------------

% NOTE: this is a simple check for a proper filename

% NOTE: there is a better way of implementing this using regular expressions,

%--------------------------------------
% CHECK FOR EMPTY
%--------------------------------------

if isempty(str)
	flag = 0; return;
end

%--------------------------------------
% CHECK FOR CHARACTERS NOT ALLOWED
%--------------------------------------

%--
% improper characters
%--

not_allowed = double('\/:*"<>|');

%--
% convert string to double and check
%--

str = double(str);

for k = 1:length(not_allowed)
	
	if ~isempty(find(str == not_allowed(k)))
		flag = 0; return;
	end 
	
end

flag = 1;
