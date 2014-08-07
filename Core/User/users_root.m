function root = users_root(parent, opt)

% users_root - get all users root directory
% -----------------------------------------
%
% root = users_root(parent, create)
%
% Input:
% ------
%  parent - parent application root (def: xbat_root)
%  create - option to create root if it does not exist (def: 1)
%
% Output:
% -------
%  root - users root

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
% $Revision: 1869 $
% $Date: 2005-09-28 16:45:31 -0400 (Wed, 28 Sep 2005) $
%--------------------------------

%--
% handle input
%--

if nargin < 2 
	opt = 1;
end

if ~nargin || isempty(parent)
	parent = xbat_root;
end

if ~exist_dir(parent)
	error('Users parent does not seem to exist.');
end

%--
% get users root
%--

root = [parent, filesep, 'Users'];

if ~opt
	return;
end
	
% TODO: make this a set and get to allow other users roots

root = create_dir(root);

if ~exist_dir(root)
	error('Failed to create users root.');
end
	


