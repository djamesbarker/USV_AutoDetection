function [value, info] = is_working_copy(root)

% is_working_copy - check whether a directory is a working copy
% -------------------------------------------------------------
%
% [value, info] = is_working_copy(root)
%
% Input:
% ------
%  root - root directory
%
% Output:
% -------
%  value - result of is working copy test
%  info - svn info

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

if ~nargin
	root = pwd;
end

[ignore, exported, info] = svn_version(root);

value = ~exported;
