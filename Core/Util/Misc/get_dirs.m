function dirs = get_dirs(root, pat, fun)

% get_dirs - get directories starting from root matching a pattern
% ----------------------------------------------------------------
%
% dirs = get_dirs(root, pat)
%
% Input:
% ------
%  root - scan root
%  pat - name pattern
%  fun - pattern matching function (def: @strcmpi)
%
% Output:
% -------
%  dirs - matching dirs

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
% handle input
%--

if nargin < 3
	fun = @strcmpi;
end

% NOTE: no pattern means select all

if (nargin < 2)
	pat = '';
end

if ~nargin || isempty(root)
	root = pwd;
end

%--
% scan and select on match
%--

if isempty(pat)
	dirs = scan_dir(root);
else
	dirs = scan_dir(root, {@match, pat, fun});
end


%--------------------
% MATCH
%--------------------

function file = match(file, pat, fun)

%--
% get directory name
%--

[ignore, name] = fileparts(file);

%--
% match with pattern using fun
%--

if ~fun(name, pat)
	file = [];
end
