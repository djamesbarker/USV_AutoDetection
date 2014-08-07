function name = get_library_name(lib, user)

% get_library_name - get full library name, includes author
% ---------------------------------------------------------
%
% name = get_library_name(lib)
%
% Input:
% ------
%  lib - library
%  
% Output:
% -------
%  name - library name

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

name = lib.name; author = lib.author;

% NOTE: this is to suppress the author from the name if it matches the
% input user, consider using a 'short' mode or something like that

if nargin > 1 && ~isempty(user) && strcmp(author, user.name)
	return;	
end

name = [author, filesep, name];
