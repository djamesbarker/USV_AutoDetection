function user = user_save(user)

% user_save - save user to file
% -----------------------------
%
% user = user_save(user)
%
% Input:
% ------
%  user - user structure
%
% Output:
% -------
%  user - saved user

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
% $Revision: 1631 $
% $Date: 2005-08-23 12:41:39 -0400 (Tue, 23 Aug 2005) $
%--------------------------------

% TODO: update to update active user if needed

%--
% update modified date
%--

user.modified = now;

file = get_user_file(user);

%--
% save to file
%--

% NOTE: it is not clear which is a better error message, consider truly handling exception

try
	save(file, 'user'); 
catch
	error(['Failed to save user ''', user.name, '''.']);
end

	
