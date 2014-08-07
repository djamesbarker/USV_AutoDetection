function stats = get_code_stats(root, prune)

% get_code_stats - get lines of code and related for a directory
% --------------------------------------------------------------
% 
% stats = get_code_stats(root, prune)
%
% Input:
% ------
%  root - start of scan
%  prune - indicator
%
% Output:
% -------
%  stats - for code contained in root

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

%-----------------
% HANDLE INPUT
%-----------------

%--
% set default prune
%--

if nargin < 2
	prune = 1;
end

%--
% set core as default root
%--

if ~nargin
	root = [xbat_root, filesep, 'Core'];
end

%--
% get directories
%--

disp(' '); ix = 1;

stats.root = root;

stats.count = [0, 0];

dirs = scan_dir(root);

stats.lines = zeros(length(dirs), 2);

for j = 1:length(dirs)
	
	stats.dir(j).name = dirs{j};
	
	stats.dir(j).count = [0, 0];
	
	%--
	% get directory files
	%--
	
	files = get_field(what_ext(dirs{j}, 'm'), 'm');
	
	stats.dir(j).lines = zeros(length(files), 2);
	
	for k = 1:length(files)
		
		%--
		% get total lines and code lines
		%--
		
		% NOTE: we are not counting empty lines
		
		file = [dirs{j}, filesep, files{k}];
		
		[code, total] = lines_of_code(file);
		
		%--
		% pack file info
		%--
		
		stats.dir(j).file(k).name = files{k};
	
		lines = [code, total]; % NOTE: the comment lines are the 'diff'
		
		stats.dir(j).file(k).count = lines; 
		
		stats.dir(j).file(k).lines = lines; 
		
		disp([int2str(ix), '. ', file, ' ', int2str(lines(1))]); ix = ix + 1;
		
		%--
		% update directory lines
		%--
		
		stats.dir(j).count = stats.dir(j).count + lines;
		
		stats.dir(j).lines(k, :) = lines;
		
	end
	
	%--
	% prune empty files from stats
	%--
	
	if prune
		
		for k = length(files):-1:1

			if ~stats.dir(j).file(k).count(1)
				stats.dir(j).file(k) = [];
			end

		end
		
	end
	
	%--
	% update total lines
	%--
	
	stats.count = stats.count + stats.dir(j).count;
	
	stats.lines(j, :) = stats.dir(j).count;
	
end

%--
% prune empty directories from stats
%--

if prune

	for j = length(dirs):-1:1

		if ~stats.dir(j).count(1)
			stats.dir(j) = [];
		end

	end

end

