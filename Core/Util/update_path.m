function dirs = update_path(type, root, rec)

% update_path - update path with tree or path
% -------------------------------------------
%
% dirs = update_path('append', root, rec)
%
%      = update_path('remove', root, rec)
%
% Input:
% ------
%  root - tree root (def: pwd)
%  rec - follow tree (def: 1)
%
% Output:
% -------
%  dirs - directories appended or removed from path

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

% NOTE: default recursive append

if nargin < 3
	rec = 1;
end

% NOTE: default current directory starting point

if (nargin < 2) || isempty(root) 
	root = pwd;
end

% NOTE: check for proper type

if ~ismember(type, {'append', 'remove'})
	error('Path update type must be ''append'' or ''remove''.');
end

%--
% collect and filter directories to append
%--

if rec
	dirs = scan_dir(root);
else
	dirs = {root};
end

% NOTE: we filter paths that are 'private'

for k = length(dirs):-1:1
	
	[ignore, leaf] = fileparts(dirs{k});
	
	if strcmp(leaf, 'private')
		dirs(k) = []; continue;
	end 
	
	if strfind(dirs{k}, [filesep, 'private', filesep])
		dirs(k) = [];
	end
		
end

%--
% update path based on type
%--

switch type
	
	case 'append', addpath(dirs{:}, '-end');

	case 'remove', rmpath(dirs{:});
		
end
