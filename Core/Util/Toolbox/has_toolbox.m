function [value, local, info] = has_toolbox(name)

% has_toolbox - check for toolbox availability
% --------------------------------------------
%
% [value, local, info] = has_toolbox(name)
%
% Input:
% ------
%  name - toolbox name
%
% Output:
% -------
%  value - result
%  local - not mathworks toolbox indicator
%  info - version info for mathworks toolboxes

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

%--
% consider local toolboxes
%--

% NOTE: value is the 'exists' output of 'toolbox_root'

[root, value] = toolbox_root(name);

% NOTE: for a local toolbox we do not have version info

if value && ~isempty(no_dot_dir(root))
	local = 1; info = []; return;
end

%--
% consider built-in toolboxes
%--

% NOTE: we do not use the toolbox root to make this determination

info = ver(name); value = ~isempty(info);

% NOTE: the local value is empty (undefined) if we don't have the toolbox

local = ternary(value, 0, []);

