function [status, result] = sqlite_cli(file, command)

% sqlite - file-based database engine access
% ------------------------------------------
%
% [status, result] = sqlite(file, command)
%
% Input:
% ------
%  file - database file
%  command - command
%
% Output:
% -------
%  status - status
%  result - result

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

% TODO: move to the MEX interface 

%--
% get tool
%--

tool = get_tool('sqlite3.exe');

if nargin && isempty(tool)
	error('Unable to find tool.');
end

% NOTE: return tool if we are called with no input

if ~nargin
	status = tool; result = []; return;
end

%--
% use tool
%--

str = ['"', tool.file, '" "', file, '"'];

if (nargin > 1) && ~isempty(command)
	str = [str, ' "', command, '"'];
end

[status, result] = system(str);




