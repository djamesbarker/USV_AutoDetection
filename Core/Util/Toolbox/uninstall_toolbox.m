function uninstall_toolbox(name)

% uninstall_toolbox - remove toolbox from path and filesystem
% -----------------------------------------------------------
%
% uninstall_toolbox(name)
%
% Input:
% ------
%  name - toolbox name

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
% get toolbox root by name
%--

root = toolbox_root(name);

% NOTE: if the root does not exist we assume the toolbox is not installed

if ~exist_dir(root)
	return;
end

%--
% remove toolbox from path
%--

% TODO: update 'append_path.m' to also perform path removal

dirs = scan_dir(root); rmpath(dirs{:}); 

%--
% remove from filesystem
%--

% NOTE: we clear functions so that any MEX files are not held in memory

try
	clear functions; rmdir(root);
catch 
	disp(['Please remove ''', root, ''' manually.']);
end
