function str = get_path_str(root, mode)

% get_path_str - add directories to path
% ----------------------------------
%
% str = get_path_str(root, 'flat')
%     = get_path_str(root, 'rec')
%
% Input:
% ------
%  root - initial directory
%
% Output:
% -------
%  str - string appended to path

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
% set default mode
%--

if nargin < 2
	mode = 'flat'; 
end 

% NOTE: we have some hard-coded directory names to skip

EXCLUDE_DIRS = { ...
	'private', ...
	'CVS' ...
};

%--
% build path string
%--

% NOTE: you can add to the path calling 'addpath(path, str)'

out = what_ext(root);
		
str = out.path;

for k = 1:length(out.dir)

	%--
	% skip dot, method, and excluded directories
	%--

	if (out.dir{k}(1) == '.') || (out.dir{k}(1) == '@')
		continue;
	end

	if ~isempty(find(strcmp(out.dir{k}, EXCLUDE_DIRS), 1))
		continue;
	end

	%--
	% handle add mode
	%--
	
	switch mode

		case 'flat'
			part = [root, filesep, out.dir{k}];

		case 'rec'
			part = get_path_str([root, filesep, out.dir{k}], 'rec');

	end
	
	%--
	% append partial path string to path string
	%--
	
	str = [str, pathsep, part];

end
