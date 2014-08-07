function out = get_code_dirs(root,exclude)

% get_code_dirs - get relevant directories that contain code
% ----------------------------------------------------------
%
% out = get_code_dirs
%
% Output:
% -------
%  out - cell array of partial paths to directories

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

% NOTE: we remove root from output

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% set list of directories to exclude
%--

% NOTE: this is very specific to current state of code

if (nargin < 2)
	exclude = {'Users', 'Samples', 'Presets', 'Docs', 'Others', 'private', 'mex_source'};
end

%--
% set application root
%--

if (nargin < 1)
	root = xbat_root;
end

%------------------------------------------
% GET DIRECTORIES
%------------------------------------------

%--
% get directories under root and strip root string
%--

out = scan_dir(root);

out = strrep(out,root,'');

%--
% remove excluded directories
%--

for k = length(out):-1:1
	
	% NOTE: remove directory if it matches any of the excluded names
	
	for j = 1:length(exclude)
		if (findstr([filesep, exclude{j}],out{k}))
			out(k) = []; break;
		end
	end
	
	% NOTE: also remove empty directories
	
	if (isempty(out{k}))
		out(k) = [];
	end
	
end

%--
% sort output
%--

% NOTE: the directories come out in reverse alphabetical order, this helps sort

out = flipud(out);

out = sort(out);

% NOTE: consider further sort by depth
