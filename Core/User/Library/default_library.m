function lib = default_library(user)

% default_library - defines default library location
% --------------------------------------------------
%
% lib = default_library(user)
%
% Output:
% -------
%  lib - default library

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
% return if xbat root is not defined
%--

root = xbat_root;

%--
% get or set user if needed
%--

if ((nargin < 1) || isempty(user))
	user = get_active_user;
end

%--
% get or create default library
%--

if (isempty(user.default))

	%--
	% set default default library
	%--
	
	fs = filesep;
	
	lib = library_create( ...
		'id',0, ...
		'name','Default', ...
		'path',[root 'Users' fs user.name fs 'Default' fs], ...
		'author',user.name ...
	);

else
	
	%--
	% user has a set default library
	%--
	
	lib = user.library(user.default);
	
end
