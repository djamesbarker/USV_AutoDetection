function path = get_windows_path(str, first)

% get_windows_path - get path elements in windows
% -----------------------------------------------
%
% path = get_windows_path(str, first)
%
%
% Input:
% ------
%  str - string to look for in path element
%  first - return first match
%
% Output: 
% -------
%  path - string cell array with elements of windows path

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

if nargin < 2
	first = 1;
end

if ~ispc
	error('This function is only available for Windows.');
end

%--
% get full path string
%--

% NOTE: we get path string and parse elements into cells

[status, result] = system('path'); 

[ignore, result] = strtok(result, '='); 

path = strread(result(2:end), '%s', -1, 'delimiter', ';');

%--
% filter if needed
%--

if nargin && ~isempty(str)
	
	ix = [];

	for k = 1:length(path)
		
		if isempty(strfind(lower(path{k}), str))
			continue;
		end
		
		ix(end + 1) = k; 
			
		if first
			break;
		end
		
	end
	
	path = path(ix);

end
