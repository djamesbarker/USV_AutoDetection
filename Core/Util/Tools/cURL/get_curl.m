function tool = get_curl

% get_curl - get curl command-line tool
% -------------------------------------
%
% tool = get_curl
%
% Output:
% -------
%  tool - curl tool

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

% TODO: currently this is only available for PC, make it available on linux

if ispc
    file = 'curl.exe';
else
	file = 'curl';
end

%--
% get tool
%--

tool = get_tool(file);

%--
% install tool if needed
%--

% NOTE: this is used in 'nircmd' and here, factor

if isempty(tool) && install_tool('cURL');

	tool = get_tool(file);

end

