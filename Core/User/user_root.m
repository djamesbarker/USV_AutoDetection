function root = user_root(in, type, parent)

% user_root - get user root directory
% -----------------------------------
%
% root = user_root(user, type, parent)
%
%      = user_root(name, type, parent)
%
% Input:
% ------
%  user - user struct (def: active user)
%  name - user name
%  type - type of user directory (def: 'base')
%  parent - parent application root (def: xbat_root)
%
% Output:
% -------
%  root - user root directory

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

%----------------------------
% HANDLE INPUT
%----------------------------

if nargin < 3
	parent = xbat_root;
end

%--
% set and check root type
%--

if (nargin < 2) || isempty(type)
	type = 'base';
end

types = user_root_types;

type = select_type(type, types);

if isempty(type)
	error('Unrecognized or ambiguous user root type.');
end

%--
% set active user default
%--

if (nargin < 1) || isempty(in)
	in = get_active_user;
end

% NOTE: return quickly if there is no user

if isempty(in)
	root = ''; return;
end

%--
% handle multiple inputs recursively
%--

if ~ischar(in) && (numel(in) > 1)
	
	if iscellstr(in)
		
		for k = 1:numel(in)
			root{k} = user_root(in{k}, type);
		end
		
	elseif isstruct(in)
		
		for k = 1:numel(in)
			root{k} = user_root(in(k).name, type);
		end
		
	end

	return;
	
end

%----------------------------
% GET ROOT
%----------------------------

%--
% get name from input
%--

switch class(in)
		
	case 'char', name = in;
		
	case 'struct', name = in.name;
		
end

%--
% build user root directory
%--

root = [users_root(parent), filesep, name];

if strcmp(type, 'base')
	return;
end

%--
% build user root of a special type
%--

% NOTE: these are always children of base user root

root = [root, filesep, title_caps(type)];


%----------------------------
% SELECT_TYPE
%----------------------------

function type = select_type(type, types)

%--
% find and output single matching type
%--

ix = strmatch(type, types);

if isempty(ix) || (numel(ix) > 1)
	type = ''; return;
end
		
type = types{ix};
