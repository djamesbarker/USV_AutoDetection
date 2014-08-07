function [sounds, logs] = library_folder_contents(lib_path)

%--
% recursive for multiple inputs
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

if iscell(lib_path)
	
	sounds = {}; logs = {};
	
	for k = 1:numel(lib_path)
		
		[newsounds, newlogs] = library_folder_contents(lib_path{k});
		
		sounds = {sounds{:}, newsounds{:}}; logs = {logs{:}, newlogs{:}};
		
	end
	
	return;
	
end

%--
% get sound names
%--

sounds = get_folder_names(lib_path);

logs = {};

for k = 1:length(sounds)
	
	log_path = fullfile(lib_path, sounds{k}, 'Logs');
	
	contents = what_ext(log_path, 'mat');
	
	logs = {logs{:}, contents.mat{:}};
	
end
	

