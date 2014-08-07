function dirs = clean_mex(root)

% clean_mex - remove MEX files from their private locations
% ---------------------------------------------------------
%
% dirs = clean_mex(root)
%
% Input:
% ------
%  root - scan root
%
% Output:
% -------
%  dirs - directories cleaned

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

% NOTE: this function will actually clean all but a set of excluded extensions 

%--
% get MEX directories
%--

dirs = get_dirs(root, 'MEX');

%--
% clean corresponding 'private' directories
%--

for k = 1:length(dirs)
	
	target = fullfile(fileparts(dirs{k}), 'private');
	
% 	disp(' '); disp(['At ', target]);
	
	if exist(target, 'dir')
		clean(target);
	end
	
end


%----------------------
% CLEAN
%----------------------

function clean(root)

%--
% set extensions to exclude from cleaning
%--

exclude = {'.c', '.m', '.mat', '.txt'};

%--
% get directory contents and delete non-excluded files (not other directories)
%--

content = no_dot_dir(root);

for k = 1:length(content)
	
	%--
	% skip other directories and excluded files
	%--
	
	if content(k).isdir
		continue;
	end 
	
	[ignore, ext] = strtok(content(k).name, '.');
	
	if ismember(ext, exclude)
		continue;
	end
	
	%--
	% delete file
	%--
	
	file = fullfile(root, content(k).name);
	
	try
% 		disp(['  Deleting ''', content(k).name, ''' ...']); 
		delete(file);
	catch
		
	end
	
end
