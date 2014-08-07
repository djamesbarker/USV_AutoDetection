function [repos, urls] = get_repositories

%--
% get repository addresses from file
%--

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

file = [fileparts(which('svn')), filesep, 'repositories.txt'];

if ~exist(file, 'file')
	repos = {};
else
	repos = file_readlines(file);
end

if nargout < 2
	return;
end 

%--
% build urls if needed
%--

types = {'http:', 'https:', 'svn:'}

urls = repos;

for k = 1:length(repos)
	
	start = repos{k}(1:4);
	
	if strcmp(start, 'http') || strcmp(start, 'svn:')
		continue;
	end
	
	urls{k} = strcat('file:///', strrep(repos{k}, filesep, '/'));
	
end

