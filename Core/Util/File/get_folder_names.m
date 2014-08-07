function names = get_folder_names(folder)

% get_folder_names - get child folders, excluding '.' and '__' prefixes
% ---------------------------------------------------------------------
%
% names = get_folder_names(folder)
%
% Input:
% ------
%  folder - folder
%
% Output:
% -------
%  names - names

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
% iterate
%--

if iscell(folder)
	
	names = {};
	
	for k = 1:length(folder)
		part = get_folder_names(folder{k}); names = {names{:}, part{:}};
	end
	
	return;
	
end

%--
% get folder names
%--

content = dir(folder); names = {};

for k = 1:length(content)
	
	if content(k).isdir && (content(k).name(1) ~= '.') && ~any(strmatch('__', content(k).name))
		names{end + 1} = content(k).name;	
	end
	
end
